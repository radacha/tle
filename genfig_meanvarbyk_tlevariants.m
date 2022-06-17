rng(42, 'twister'); % Random seed (42 used in SDM'19 paper)

dataDist = 'Torus'; % Data distribution: 'Gaussian', 'Uniform' or 'Torus'

n = 10000; % No. of points in data set (10000 used in SDM'19 paper)
q = 1000;  % No. of points in query set (1000 used in SDM'19 paper)
d = 10;    % Dimensionality (10 used in SDM'19 paper)

ks = 10:10:100; % Values of k (10:10:100 used in SDM'19 paper)

runs = 20; % No. of runs (20 used in SDM'19 paper)

numks = length(ks);

mlemean = zeros(1,numks);
mlevar = zeros(1,numks);
tlemean = zeros(1,numks);
tlevar = zeros(1,numks);
tlecmean = zeros(1,numks);
tlecvar = zeros(1,numks);
tlenmean = zeros(1,numks);
tlenvar = zeros(1,numks);
tlecnmean = zeros(1,numks);
tlecnvar = zeros(1,numks);

for r = 1:runs

    fprintf('\nrun = %d, k =',r);
    
    if strcmp(dataDist,'Gaussian')
        X = randn(n,d);
        Q = randn(q,d);
    elseif strcmp(dataDist,'Uniform')
        X = rand(n,d)-0.5;
        Q = rand(q,d)-0.5;
    elseif strcmp(dataDist,'Torus')
        X = rand(n,d);
        Q = rand(q,d);
    else
        error(['Unsupported data distribution: ' dataDist]);
    end
        
    if strcmp(dataDist,'Torus')
        [idxmax,distsmax] = knnsearch(X,Q,'K',max(ks),'Distance',@torusL2DistForKNNSearch);
    else
        [idxmax,distsmax] = knnsearch(X,Q,'K',max(ks));
    end
    
    for j = 1:numks
        
        k = ks(j);
        fprintf(' %d',k);
        
        id_mle = zeros(q,1);
        id_tle = zeros(q,1);
        id_tlec = zeros(q,1);
        id_tlen = zeros(q,1);
        id_tlecn = zeros(q,1);
        
        idx = idxmax(:,1:k);
        dists = distsmax(:,1:k);
        
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

h = figure('Renderer','painters','Position',[50 50 900 512],'DefaultAxesFontSize',14);
hold on;
plot(ks,mlemean+mlevar,'b-.');
plot(ks,mlemean,'bo-');
plot(ks,mlemean-mlevar,'b-.');
plot(ks,tlemean+tlevar,'r-.');
plot(ks,tlemean,'r+-');
plot(ks,tlemean-tlevar,'r-.');
plot(ks,tlecmean+tlecvar,'m-.');
plot(ks,tlecmean,'mo-');
plot(ks,tlecmean-tlecvar,'m-.');
plot(ks,tlenmean+tlenvar,'g-.');
plot(ks,tlenmean,'g*-');
plot(ks,tlenmean-tlenvar,'g-.');
plot(ks,tlecnmean+tlecnvar,'k-.');
plot(ks,tlecnmean,'k*-');
plot(ks,tlecnmean-tlecnvar,'k-.');
plot(ks,repmat(d,1,numks),'k-');
xlim([ks(1) ks(end)]);
hold off;
xlabel('k');
ylabel('ID');
title(['i.i.d. ' dataDist ', n = ' int2str(n) ', q = ' int2str(q) ', d = ' int2str(d) ', runs = ' int2str(runs)]);
legend('MLE: \mu+\sigma','MLE: \mu','MLE: \mu-\sigma',...
       'TLE: \mu+\sigma','TLE: \mu','TLE: \mu-\sigma',...
       'TLE_c: \mu+\sigma','TLE_c: \mu','TLE_c: \mu-\sigma',...
       'TLE^n: \mu+\sigma','TLE^n: \mu','TLE^n: \mu-\sigma',...
       'TLE_c^n: \mu+\sigma','TLE_c^n: \mu','TLE_c^n: \mu-\sigma',...
       'The Truth','Location','WestOutside');
saveas(h,['data/synth-1/figtle/' 'meanvarbyk_' dataDist '-tlevariants_d' num2str(d) '_n' num2str(n) '_q' num2str(q) '_k' num2str(ks(1)) '-' num2str(ks(end)) '_runs' num2str(r) '.fig']);
saveas(h,['data/synth-1/figtle/' 'meanvarbyk_' dataDist '-tlevariants_d' num2str(d) '_n' num2str(n) '_q' num2str(q) '_k' num2str(ks(1)) '-' num2str(ks(end)) '_runs' num2str(r) '.png']);
saveas(h,['data/synth-1/figtle/' 'meanvarbyk_' dataDist '-tlevariants_d' num2str(d) '_n' num2str(n) '_q' num2str(q) '_k' num2str(ks(1)) '-' num2str(ks(end)) '_runs' num2str(r) '.eps'],'epsc');
