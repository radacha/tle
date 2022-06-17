function genfig_boxplot_fun2multik_tlevariants(dataSet,ks)

figName = dataSet;
if strcmp(figName,'ann_sift1b') 
    figName = 'ann\_sift1m';
end

for k = ks

    id_mle              = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_mle.csv']);
    id_tle              = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_tle.csv']);
    id_tleminus         = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_tlec.csv']);
    id_tlenomirror      = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_tlen.csv']);
    id_tleminusnomirror = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_tlecn.csv']);
        
    h = figure('DefaultAxesFontSize',18);
    boxplot([id_mle id_tle id_tleminus id_tlenomirror id_tleminusnomirror],'Labels',{'$\mathrm{MLE}$','$\mathrm{TLE}$','$\mathrm{TLE_c}$','$\mathrm{TLE^n}$','$\mathrm{TLE_c^n}$'},'Whisker',1.5);
    bp = gca;
    bp.XAxis.TickLabelInterpreter = 'latex';
    ylabel('ID');
    title([figName ', k = ' num2str(k)]);
    saveas(h,['data/real/figtle/' 'boxplot-' dataSet '-k' num2str(k) '.fig']);
    saveas(h,['data/real/figtle/' 'boxplot-' dataSet '-k' num2str(k) '.png']);
    saveas(h,['data/real/figtle/' 'boxplot-' dataSet '-k' num2str(k) '.eps'],'epsc');
    close(h);

end
