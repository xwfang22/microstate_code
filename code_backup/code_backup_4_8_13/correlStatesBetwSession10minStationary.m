clear
clc
close all

clear
clc

dataLength='all_10min';

resultDir1=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/', dataLength, filesep, 'session1'];
resultDir2=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/', dataLength, filesep, 'session2'];
figDir=['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/', dataLength, '/correlTwoSessions/'];

    
    tmp1=load([resultDir1,'/avg_z_stationary_FC.mat']);
    tmp2=load([resultDir2,'/avg_z_stationary_FC.mat']);
    stationaryFC1=tmp1.avg_z_stationary_FC;
    stationaryFC1Transp=stationaryFC1';
    stationaryFC2=tmp2.avg_z_stationary_FC;
    stationaryFC2Transp=stationaryFC2';
    stationaryFCTransp=[stationaryFC1Transp,stationaryFC2Transp];
    [corStationaryFC,pValue]=corrcoef( stationaryFCTransp);
    
    figure(1)
    imagesc(corStationaryFC)
    colorbar
    title('Correlations between Stationalry FC Estimated with Full Correlation ')
    xlabel('Stationary FC Session 1 (4 Seeds) and Session 2 (4 Seeds)')
    ylabel('Stationary FC Session 1 (4 Seeds) and Session 2 (4 Seeds)')
    caxis([-1 1])
    saveas(figure(1),[figDir,'CorrelBetwTwoSessions_stationaryFCFullCorrel.png'])



