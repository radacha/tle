rng(42, 'twister'); % Random seed (42 used in SDM'19 paper)

dataDist = 'Torus'; % Data distribution: 'Gaussian', 'Uniform' or 'Torus'

% Ratios of outliers/inliers to consider in chart
% (works only with 'Gaussian' and 'Uniform' data)
outlierRatio = 0.1; % (0.1 used in SDM'19 paper)
inlierRatio = 0.1;  % (0.1 used in SDM'19 paper)

n = 10000; % No. of points in data set (10000 used in SDM'19 paper)
q = 1000;  % No. of points in query set (1000 used in SDM'19 paper)
k = 20;    % No. of neighbors (20 used in SDM'19 paper)

ds = 2:1:20; % Dimensionalities (2:1:20 used in SDM'19 paper)

runs = 20; % No. of runs (20 used in SDM'19 paper)

numds = length(ds);
numout = floor(q*outlierRatio);
numin = floor(q*inlierRatio);

mlemean = zeros(1,numds);
mlevar = zeros(1,numds);
tlemean = zeros(1,numds);
tlevar = zeros(1,numds);
tlecmean = zeros(1,numds);
tlecvar = zeros(1,numds);
tlenmean = zeros(1,numds);
tlenvar = zeros(1,numds);
tlecnmean = zeros(1,numds);
tlecnvar = zeros(1,numds);

omlemean = zeros(1,numds);
omlevar = zeros(1,numds);
otlemean = zeros(1,numds);
otlevar = zeros(1,numds);
otlecmean = zeros(1,numds);
otlecvar = zeros(1,numds);
otlenmean = zeros(1,numds);
otlenvar = zeros(1,numds);
otlecnmean = zeros(1,numds);
otlecnvar = zeros(1,numds);

% For inliers
imind_ml1_val = zeros(1,numds); % one value for whole query set
imind_mli_val = zeros(1,numds); % one value for whole query set

imlemean = zeros(1,numds);
imlevar = zeros(1,numds);
itlemean = zeros(1,numds);
itlevar = zeros(1,numds);
itlecmean = zeros(1,numds);
itlecvar = zeros(1,numds);
itlenmean = zeros(1,numds);
itlenvar = zeros(1,numds);
itlecnmean = zeros(1,numds);
itlecnvar = zeros(1,numds);

for r = 1:runs

    fprintf('\nrun = %d, d =',r);
    
    for j = 1:numds
        
        d = ds(j);
        fprintf(' %d',d);
        
        if strcmp(dataDist,'Gaussian')
            X = randn(n,d);
            Q = randn(q,d);
        elseif strcmp(dataDist,'Uniform')
            X = rand(n,d)-0.5;
            Q = rand(q,d)-0.5; % centering so that norm is outlier score
        elseif strcmp(dataDist,'Torus')
            X = rand(n,d);
            Q = rand(q,d);
        else
            error(['Unsupported data distribution: ' dataDist]);
        end
        
        if strcmp(dataDist,'Torus')
            [idx,dists] = knnsearch(X,Q,'K',k,'Distance',@torusL2DistForKNNSearch);
        else
            [idx,dists] = knnsearch(X,Q,'K',k);
        end
        
        normsQ = sum(Q.^2,2);
        [~,idxQ] = sort(normsQ,'descend');
        idxQout = idxQ(1:numout);
        idxQin = idxQ(end-numin+1:end);
        
        id_mle = zeros(q,1);
        id_tle = zeros(q,1);
        id_tlec = zeros(q,1);
        id_tlen = zeros(q,1);
        id_tlecn = zeros(q,1);
        for i = 1:q
            KNN = X(idx(i,:),:);
            if strcmp(dataDist,'Torus')
                for l = 1:k
                    for m = 1:d
                        diff = abs(Q(i,m)-KNN(l,m));
                        if 1-diff < diff
                            if Q(i,m) < 0.5
                                KNN(l,m) = KNN(l,m)-1;
                            else
                                KNN(l,m) = KNN(l,m)+1;
                            end
                        end
                    end
                end
            end
            id_mle(i) = idmle(dists(i,:)');
            id_tle(i) = idtle(KNN,dists(i,:));
            id_tlec(i) = idtlec(KNN,dists(i,:));
            id_tlen(i) = idtlen(KNN,dists(i,:));
            id_tlecn(i) = idtlecn(KNN,dists(i,:));
       end
       
       mlemean(j) = mlemean(j) + mean(id_mle);
       mlevar(j) = mlevar(j) + std(id_mle);
       tlemean(j) = tlemean(j) + mean(id_tle);
       tlevar(j) = tlevar(j) + std(id_tle);
       tlecmean(j) = tlecmean(j) + mean(id_tlec);
       tlecvar(j) = tlecvar(j) + std(id_tlec);
       tlenmean(j) = tlenmean(j) + mean(id_tlen);
       tlenvar(j) = tlenvar(j) + std(id_tlen);
       tlecnmean(j) = tlecnmean(j) + mean(id_tlecn);
       tlecnvar(j) = tlecnvar(j) + std(id_tlecn);
       
       omlemean(j) = omlemean(j) + mean(id_mle(idxQout));
       omlevar(j) = omlevar(j) + std(id_mle(idxQout));
       otlemean(j) = otlemean(j) + mean(id_tle(idxQout));
       otlevar(j) = otlevar(j) + std(id_tle(idxQout));
       otlecmean(j) = otlecmean(j) + mean(id_tlec(idxQout));
       otlecvar(j) = otlecvar(j) + std(id_tlec(idxQout));
       otlenmean(j) = otlenmean(j) + mean(id_tlen(idxQout));
       otlenvar(j) = otlenvar(j) + std(id_tlen(idxQout));
       otlecnmean(j) = otlecnmean(j) + mean(id_tlecn(idxQout));
       otlecnvar(j) = otlecnvar(j) + std(id_tlecn(idxQout));
       
       imlemean(j) = imlemean(j) + mean(id_mle(idxQin));
       imlevar(j) = imlevar(j) + std(id_mle(idxQin));
       itlemean(j) = itlemean(j) + mean(id_tle(idxQin));
       itlevar(j) = itlevar(j) + std(id_tle(idxQin));
       itlecmean(j) = itlecmean(j) + mean(id_tlec(idxQin));
       itlecvar(j) = itlecvar(j) + std(id_tlec(idxQin));
       itlenmean(j) = itlenmean(j) + mean(id_tlen(idxQin));
       itlenvar(j) = itlenvar(j) + std(id_tlen(idxQin));
       itlecnmean(j) = itlecnmean(j) + mean(id_tlecn(idxQin));
       itlecnvar(j) = itlecnvar(j) + std(id_tlecn(idxQin));

    end
end
fprintf('\n\n');

mlemean = mlemean / runs;
mlevar = mlevar / runs;
tlemean = tlemean / runs;
tlevar = tlevar / runs;
tlecmean = tlecmean / runs;
tlecvar = tlecvar / runs;
tlenmean = tlenmean / runs;
tlenvar = tlenvar / runs;
tlecnmean = tlecnmean / runs;
tlecnvar = tlecnvar / runs;

omlemean = omlemean / runs;
omlevar = omlevar / runs;
otlemean = otlemean / runs;
otlevar = otlevar / runs;
otlecmean = otlecmean / runs;
otlecvar = otlecvar / runs;
otlenmean = otlenmean / runs;
otlenvar = otlenvar / runs;
otlecnmean = otlecnmean / runs;
otlecnvar = otlecnvar / runs;

imlemean = imlemean / runs;
imlevar = imlevar / runs;
itlemean = itlemean / runs;
itlevar = itlevar / runs;
itlecmean = itlecmean / runs;
itlecvar = itlecvar / runs;
itlenmean = itlenmean / runs;
itlenvar = itlenvar / runs;
itlecnmean = itlecnmean / runs;
itlecnvar = itlecnvar / runs;

h = figure('Renderer','painters','Position',[50 50 900 512],'DefaultAxesFontSize',14);
hold on;
plot(ds,mlemean+mlevar,'b-.');
plot(ds,mlemean,'bo-');
plot(ds,mlemean-mlevar,'b-.');
plot(ds,tlemean+tlevar,'r-.');
plot(ds,tlemean,'r+-');
plot(ds,tlemean-tlevar,'r-.');
plot(ds,tlecmean+tlecvar,'m-.');
plot(ds,tlecmean,'mo-');
plot(ds,tlecmean-tlecvar,'m-.');
plot(ds,tlenmean+tlenvar,'g-.');
plot(ds,tlenmean,'g*-');
plot(ds,tlenmean-tlenvar,'g-.');
plot(ds,tlecnmean+tlecnvar,'k-.');
plot(ds,tlecnmean,'k*-');
plot(ds,tlecnmean-tlecnvar,'k-.');
plot(ds,ds,'k-');
xlim([ds(1) ds(end)]);
hold off;
xlabel('Dimensionality');
ylabel('ID');
title(['i.i.d. ' dataDist ', n = ' int2str(n) ', q = ' int2str(q) ', k = ' int2str(k) ', runs = ' int2str(runs)]);
legend('MLE: \mu+\sigma','MLE: \mu','MLE: \mu-\sigma',...
       'TLE: \mu+\sigma','TLE: \mu','TLE: \mu-\sigma',...
       'TLE_c: \mu+\sigma','TLE_c: \mu','TLE_c: \mu-\sigma',...
       'TLE^n: \mu+\sigma','TLE^n: \mu','TLE^n: \mu-\sigma',...
       'TLE_c^n: \mu+\sigma','TLE_c^n: \mu','TLE_c^n: \mu-\sigma',...
       'The Truth','Location','WestOutside');
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-all_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.fig']);
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-all_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.png']);
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-all_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.eps'],'epsc');

h = figure('Renderer','painters','Position',[50 50 900 512],'DefaultAxesFontSize',14);
hold on;
plot(ds,omlemean+omlevar,'b-.');
plot(ds,omlemean,'bo-');
plot(ds,omlemean-omlevar,'b-.');
plot(ds,otlemean+otlevar,'r-.');
plot(ds,otlemean,'r+-');
plot(ds,otlemean-otlevar,'r-.');
plot(ds,otlecmean+otlecvar,'m-.');
plot(ds,otlecmean,'mo-');
plot(ds,otlecmean-otlecvar,'m-.');
plot(ds,otlenmean+otlenvar,'g-.');
plot(ds,otlenmean,'g*-');
plot(ds,otlenmean-otlenvar,'g-.');
plot(ds,otlecnmean+otlecnvar,'k-.');
plot(ds,otlecnmean,'k*-');
plot(ds,otlecnmean-otlecnvar,'k-.');
plot(ds,ds,'k-');
xlim([ds(1) ds(end)]);
hold off;
xlabel('Dimensionality');
ylabel('ID of outliers');
title(['i.i.d. ' dataDist ', n = ' int2str(n) ', q = ' int2str(q) ', k = ' int2str(k) ', runs = ' int2str(runs)]);
legend('MLE: \mu+\sigma','MLE: \mu','MLE: \mu-\sigma',...
       'TLE: \mu+\sigma','TLE: \mu','TLE: \mu-\sigma',...
       'TLE_c: \mu+\sigma','TLE_c: \mu','TLE_c: \mu-\sigma',...
       'TLE^n: \mu+\sigma','TLE^n: \mu','TLE^n: \mu-\sigma',...
       'TLE_c^n: \mu+\sigma','TLE_c^n: \mu','TLE_c^n: \mu-\sigma',...
       'The Truth','Location','WestOutside');
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-outliers_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.fig']);
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-outliers_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.png']);
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-outliers_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.eps'],'epsc');

h = figure('Renderer','painters','Position',[50 50 900 512],'DefaultAxesFontSize',14);
hold on;
plot(ds,imlemean+imlevar,'b-.');
plot(ds,imlemean,'bo-');
plot(ds,imlemean-imlevar,'b-.');
plot(ds,itlemean+itlevar,'r-.');
plot(ds,itlemean,'r+-');
plot(ds,itlemean-itlevar,'r-.');
plot(ds,itlecmean+itlecvar,'m-.');
plot(ds,itlecmean,'mo-');
plot(ds,itlecmean-itlecvar,'m-.');
plot(ds,itlenmean+itlenvar,'g-.');
plot(ds,itlenmean,'g*-');
plot(ds,itlenmean-itlenvar,'g-.');
plot(ds,itlecnmean+itlecnvar,'k-.');
plot(ds,itlecnmean,'k*-');
plot(ds,itlecnmean-itlecnvar,'k-.');
plot(ds,ds,'k-');
xlim([ds(1) ds(end)]);
hold off;
xlabel('Dimensionality');
ylabel('ID of inliers');
title(['i.i.d. ' dataDist ', n = ' int2str(n) ', q = ' int2str(q) ', k = ' int2str(k) ', runs = ' int2str(runs)]);
legend('MLE: \mu+\sigma','MLE: \mu','MLE: \mu-\sigma',...
       'TLE: \mu+\sigma','TLE: \mu','TLE: \mu-\sigma',...
       'TLE_c: \mu+\sigma','TLE_c: \mu','TLE_c: \mu-\sigma',...
       'TLE^n: \mu+\sigma','TLE^n: \mu','TLE^n: \mu-\sigma',...
       'TLE_c^n: \mu+\sigma','TLE_c^n: \mu','TLE_c^n: \mu-\sigma',...
       'The Truth','Location','WestOutside');
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-inliers_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.fig']);
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-inliers_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.png']);
saveas(h,['data/synth-1/figtle/' 'meanvar5AllDim_' dataDist '-inliers_d' num2str(min(ds)) '-' num2str(max(ds)) '_n' num2str(n) '_q' num2str(q) '_k' num2str(k) '_runs' num2str(r) '.eps'],'epsc');
