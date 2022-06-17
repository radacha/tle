function genfig_mdata_fun_tlevariants(dataSet,ks)

n = 10000;
runs = 20; % No. of runs (20 used in SDM'19 paper)

id_mle = zeros(n,runs);
id_tle = zeros(n,runs);
id_tlec = zeros(n,runs);
id_tlen = zeros(n,runs);
id_tlecn = zeros(n,runs);

numks = length(ks);

id_mle_all = zeros(n*runs,numks);
id_tle_all = zeros(n*runs,numks);
id_tlec_all = zeros(n*runs,numks);
id_tlen_all = zeros(n*runs,numks);
id_tlecn_all = zeros(n*runs,numks);

for i = 1:numks
    k = ks(i);
    for r = 1:runs
        rstr = num2str(r-1);
        if r-1 < 10, rstr = ['0' rstr]; end %#ok<AGROW>
        namePrefix = ['data/m10000/id/' dataSet '-' rstr '-k' num2str(k)];
        id_mle(:,r) = csvread([namePrefix '-id_mle.csv']);
        id_tle(:,r) = csvread([namePrefix '-id_tle.csv']);
        id_tlec(:,r) = csvread([namePrefix '-id_tlec.csv']);
        id_tlen(:,r) = csvread([namePrefix '-id_tlen.csv']);
        id_tlecn(:,r) = csvread([namePrefix '-id_tlecn.csv']);
    end
    id_mle_all(:,i) = id_mle(:);
    id_tle_all(:,i) = id_tle(:);
    id_tlec_all(:,i) = id_tlec(:);
    id_tlen_all(:,i) = id_tlen(:);
    id_tlecn_all(:,i) = id_tlecn(:);
end

for i = 1:numks
    k = ks(i);
    h = figure('DefaultAxesFontSize',18);
    boxplot([id_mle_all(:,i) id_tle_all(:,i) id_tlec_all(:,i) id_tlen_all(:,i) id_tlecn_all(:,i)],'Labels',{'MLE','$\mathrm{TLE}$','$\mathrm{TLE_c}$','$\mathrm{TLE^n}$','$\mathrm{TLE_c^n}$'},'Whisker',1.5);
    bp = gca;
    bp.XAxis.TickLabelInterpreter = 'latex';
    ylabel('ID');
    title([dataSet ', k = ' num2str(k)]);
    saveas(h,['data/m10000/figtle/' 'boxplot-' dataSet '-k' num2str(k) '.fig']);
    saveas(h,['data/m10000/figtle/' 'boxplot-' dataSet '-k' num2str(k) '.png']);
    saveas(h,['data/m10000/figtle/' 'boxplot-' dataSet '-k' num2str(k) '.eps'],'epsc');
    close(h);
end
