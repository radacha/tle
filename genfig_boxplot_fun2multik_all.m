function genfig_boxplot_fun2multik_all(dataSet,ks)

figName = dataSet;
if strcmp(figName,'ann_sift1b') 
    figName = 'ann\_sift1m';
end

for k = ks

    id_mle  = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_mle.csv']);
    id_tle  = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_tle.csv']);
    id_lcd  = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_lcd.csv']);
    id_mom  = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_mom.csv']);
    id_ed   = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_ed.csv']);
    id_ged  = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_ged.csv']);
    id_lpca = csvread(['data/real/id/' dataSet '-k' num2str(k) '-id_lpca.csv']);
    
    h = figure('DefaultAxesFontSize',18);
    boxplot([id_mle id_tle id_lcd id_mom id_ed id_ged id_lpca],'Labels',{'MLE','TLE','LCD','MoM','ED','GED','LPCA'},'Whisker',1.5);
    ylabel('ID');
    title([figName ', k = ' num2str(k)]);
    saveas(h,['data/real/figall/' 'boxplot-' dataSet '-k' num2str(k) '.fig']);
    saveas(h,['data/real/figall/' 'boxplot-' dataSet '-k' num2str(k) '.png']);
    saveas(h,['data/real/figall/' 'boxplot-' dataSet '-k' num2str(k) '.eps'],'epsc');
    close(h);

end
