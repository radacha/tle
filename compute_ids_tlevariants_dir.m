function compute_ids_tlevariants_dir(dataPath,outputPath,ks)

tic;

rng(42, 'twister');

dataExt = '.data';
dataDlm = ' ';

maxk = 200;

listing = dir([dataPath '*' dataExt]);

for f = 1:length(listing)

    dataSet = listing(f).name(1:end-length(dataExt));
    fprintf('\nloading data set: %s',dataSet);
    X = dlmread([dataPath dataSet dataExt],dataDlm);
    
    n = size(X,1);
    
    id_mle = ones(n,1);
    id_tle = zeros(n,1);
    id_tlec = zeros(n,1);
    id_tlen = zeros(n,1);
    id_tlecn = zeros(n,1);

    % Load or compute kNN distances
    nnFilePrefix = [dataPath 'knn/' dataSet '-k' num2str(maxk)];
    nnidxFileNameMAT = [nnFilePrefix '-nnidx.mat'];
    nndistsFileNameMAT = [nnFilePrefix '-nndists.mat'];
    nnidxFileNameCSV = [nnFilePrefix '-nnidx.csv'];
    nndistsFileNameCSV = [nnFilePrefix '-nndists.csv'];
    if exist(nnidxFileNameMAT,'file') && exist(nndistsFileNameMAT,'file')
        % STRONGLY prefer .mat format since some methods are sensitive to rounding of distances
        fprintf('\nloading %d-nearest neighbors from .mat file...',maxk);
        load(nnidxFileNameMAT,'idx');
        load(nndistsFileNameMAT,'dists');
        idxmax = idx; 
        distsmax = dists; 
    elseif exist(nnidxFileNameCSV,'file') && exist(nndistsFileNameCSV,'file')
        fprintf('\nloading %d-nearest neighbors from .csv file...',maxk);
        idxmax = csvread(nnidxFileNameCSV);
        distsmax = csvread(nndistsFileNameCSV);
    else
        fprintf('\ncomputing %d-nearest neighbors...',max(ks));
        [idxmax,distsmax] = knnsearch(X,X,'K',max(ks)+1);
        idxmax = idxmax(:,2:end); % 2:end skips first neighbor - the point itself
        distsmax = distsmax(:,2:end);
    end
        
    for k = ks
        
        idx = idxmax(:,1:k);
        dists = distsmax(:,1:k);
        
        fprintf('\n\nk = %d\nquery point:',k);
        for i = 1:n
            if mod(i,1000)==0, fprintf('\n%d',i); end
            KNN = X(idx(i,:),:);
            id_mle(i) = idmle(dists(i,:)');
            id_tle(i) = idtle(KNN,dists(i,:));
            id_tlec(i) = idtlec(KNN,dists(i,:));
            id_tlen(i) = idtlen(KNN,dists(i,:));
            id_tlecn(i) = idtlecn(KNN,dists(i,:));
        end
        
        csvwrite([outputPath 'id/' dataSet '-k' num2str(k) '-id_mle.csv'],id_mle);
        csvwrite([outputPath 'id/' dataSet '-k' num2str(k) '-id_tle.csv'],id_tle);
        csvwrite([outputPath 'id/' dataSet '-k' num2str(k) '-id_tlec.csv'],id_tlec);
        csvwrite([outputPath 'id/' dataSet '-k' num2str(k) '-id_tlen.csv'],id_tlen);
        csvwrite([outputPath 'id/' dataSet '-k' num2str(k) '-id_tlecn.csv'],id_tlecn);
        
    end
    
    fprintf('\n');

end

toc;