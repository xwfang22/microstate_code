clear
clc
close all


dataLength='all_10min';

resultDir=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/', dataLength, filesep, 'session1/clustMean/'];

figDir=['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/', dataLength, '/session1/corrWithinSession/'];


    load('MyColormapsCorrel','mycmap')
    
    numClust=5;
   
    tmp=load([resultDir,'/clusterMean_',num2str(numClust),'clusters_session1_normWin.mat']);
    
    clustMean=tmp.finalMeanWinOfClust;
    clustMeanTransp=clustMean';
    
    % recode clust 1 and 2 to corresponding to the cluster order of 2
    % session concatenated data.
    a=clustMeanTransp(:,1)
    b=clustMeanTransp(:,2)
    clustMeanTransp(:,1)=b
    clustMeanTransp(:,2)=a
    [corClusters,pValue]=corrcoef(clustMeanTransp);
    
    for i=1:numClust
                corClusters(i,i:end)=0;
    end
    
%    ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;1,0.4,0;1,0.3,0;1,0.1,0;1,1,1;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1];
% first use this colormap which is the same as the one used to plot state
% map and stationary map to generate the plot; then editor the color map in
% the editor by adding 2 white nodes in the middle; then used
% mycmap=get(figure(1), 'Colormap') and save('MyColormapsCorrel.mat',
% 'mycmap') to save the color map. later to use, just load the colormap
% ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
% ColorMap=flipdim(ColorMap,1);
% cmap1 = colorRamp(ColorMap(1:6,:), 32);
% cmap2= colorRamp(ColorMap(7:end,:), 32);
% ColorMap=vertcat(cmap1,cmap2)


    figure(1)
    imagesc(corClusters)
    h=figure(1);
    %colorbar
    caxis([-0.8 0.8])
    set(gca,'xTick',0.5:5.5, 'yTick', 0.5:5.5,'XTickLabel',[],'YTickLabel',[]);
    set(gca,'LineWidth',2)
    set(figure(1),'Colormap',mycmap)
    %set(figure(1),'Colormap',ColorMap)  % this is used to generate the
    %first graph for eiditing the colormap
    grid on
    set(gca, 'GridLineStyle', '-' )
    
    set(h,'Position',[1,1,800,665])
    saveas(figure(1),[figDir,'CorrelSession1_zWinFullCorLasso.png'])
    
    
%     figure(1)
%     imagesc(corClusters)
%     colorbar
%     title('Correlations between clusters')
%     xlabel('Clusters')
%     ylabel('clusters')
%     caxis([-1 1])
%     saveas(figure(1),[figDir,'CorrelBetwTwoSessions_zWinFullCorLasso.png'])



