clear
clc
close all
session='session1';
subList=load('/home/data/Projects/microstate/NKITRT_SubID.mat');
subList=subList.SubID;
covType='GSR'

numSeed=4;
winWidth=69; % in TR
step=3; % in TR
numVol=884;
numWin=floor((numVol-winWidth)/step)+1;
numSub=length(subList);
numWinAllSub=numWin*numSub;
analyDir=['/home/data/Projects/microstate/DPARSF_preprocessed/'];
resultDir=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/all_10min/', covType, '/', session,'/'];
figDir=['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/all_10min/', covType, '/', session,'/'];

a=load([resultDir,'winFullCorLassoSeed_OptimalLambdaPerSub_645_',session,'win', num2str(winWidth), '_',covType,'.mat'])
tmp=a.winFullCorLassoSeed;

indx=load([resultDir, 'clustIndxNormWinAllSeeds_FullCorLasso_',session,'_10min.txt']);
numClust=length(unique(indx));

newIndx=[2,3,6,1,5,4];
indxRecode=indx;
if strcmp(session, 'session1')
indxRecode(find(indx==2))=1;
indxRecode(find(indx==1))=2;
else
indxRecode(find(indx==2))=1;
indxRecode(find(indx==3))=2;
indxRecode(find(indx==6))=3;
indxRecode(find(indx==1))=4;
indxRecode(find(indx==5))=5;
indxRecode(find(indx==4))=6;
end

indx2D=reshape(indxRecode,[], 4);
seed1=tmp(1+5984*(1-1):5984*1, :);
seed2=tmp(1+5984*(2-1):5984*2, :);
seed3=tmp(1+5984*(3-1):5984*3, :);
seed4=tmp(1+5984*(4-1):5984*4, :);

t=0;
cmap=[0.200000002980232 1 1;0.257142871618271 1 1;0.314285725355148 1 1;0.371428579092026 1 1;0.428571432828903 1 1;0.485714286565781 1 1;0.54285717010498 1 1;0.600000023841858 1 1;0.657142877578735 1 1;0.714285731315613 1 1;0.77142858505249 1 1;0.828571438789368 1 1;0.885714292526245 1 1;0.942857146263123 1 1;1 1 1;1 1 0.9375;1 1 0.875;1 1 0.8125;1 1 0.75;1 1 0.6875;1 1 0.625;1 1 0.5625;1 1 0.5;1 1 0.4375;1 1 0.375;1 1 0.3125;1 1 0.25;1 1 0.1875;1 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.964705884456635 0 0;0.929411768913269 0 0;0.894117653369904 0 0;0.858823537826538 0 0;0.823529422283173 0 0;0.788235306739807 0 0;0.752941191196442 0 0;0.717647075653076 0 0;0.682352960109711 0 0;0.647058844566345 0 0;0.61176472902298 0 0;0.576470613479614 0 0;0.541176497936249 0 0;0.505882382392883 0 0;0.470588237047195 0 0;0.43529412150383 0 0;0.400000005960464 0 0];

% plot the meanFC for each seed
figure(1)

for i=1:numSeed
    if i==1
        seed=seed1;
    elseif i==2
        seed=seed2;
    elseif i==3
        seed=seed3;
    else
        seed=seed4;
    end
    
    for j=1:numClust
        t=t+1;
if strcmp(session, 'session1')
        subplot(5,5,t)
else
subplot(5,6,t)
end
        indxList=find(indx2D(:,i)==j);
        numWinInClust=length(indxList)
        numWinPerClust(i,j)=numWinInClust;
        seedCor=seed(indxList, :);
        meanCor=mean(seedCor)
        imagesc(meanCor)
        set(gca, 'YTick', [], 'XTick', [])
        colormap(cmap)
caxis([-0.1 0.4])
    end
end

% plot the mean FC for all seeds
a=tmp;
a(1:5984,1)=0;
a(1+5984:5984*2,2)=0;
a(1+5984*2:5984*3,3)=0;
a(1+5984*3:5984*4,4)=0;

clustMean=[];
for k=1:numClust
clustCor=a(find(indxRecode==k),:);
for m=1:numSeed
b=clustCor(:,m);
b(find(b==0))=[];
clustMean(k,m)=mean(b);
end
end

for k=1:numClust
if strcmp(session, 'session1')
subplot(5,5,t+k)
else
subplot(5,6, t+k)
end
imagesc(clustMean(k,:))
        set(gca, 'YTick', [], 'XTick', [])
        colormap(cmap)
caxis([-0.1 0.4])
end
%saveas(figure(1), sprintf('/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/all_10min/GSR/%s/clustMeanBtwSeed_seedSep_%s.png', session, session))

figure
imagesc(clustMean)
colormap(cmap)
caxis([-0.1 0.4])
set(gca, 'YTick', [], 'XTick', [])
colorbar
%saveas(figure(1), sprintf('/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/all_10min/GSR/%s/clustMeanBtwSeed_allSeeds_%s.png', session, session))