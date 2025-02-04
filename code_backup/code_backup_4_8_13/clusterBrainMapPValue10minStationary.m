

clear
clc
close all

session='session2';
dataLength='all_10min';
mapType='stationaryFCMap';


numSeed=4;
numROI=156;
numSub=22;
resultDir=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/',dataLength,filesep,session,'/'];
maskDir=['/home/data/Projects/microstate/DPARSF_preprocessed/mask/'];
figDir=['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/',dataLength, filesep,session, filesep, mapType, filesep];

tmp=load([resultDir,'/z_stationary_FC.mat']);
stationaryFC=tmp.z_stationary_FC;
disp ('Files loaded successfully.')

for i=1:numSeed
    stationaryFCAllSubOneSeed=zeros(numSub,numROI);
    for j=1:numSub
        for m=1:numROI
            stationaryFCAllSubOneSeed(j,m)=stationaryFC(i,m,j);
        end
    end
    meanFC=mean(stationaryFCAllSubOneSeed);
    [h,pValue]=ttest(stationaryFCAllSubOneSeed);
    [pID,pN] = FDR(pValue,0.05)
    
    for k=1:numROI
        p=pValue(k);
        if p<=pID
            if p==0
                p=1e-320;
                negLogPValue(k)=(-1)*log10(p);
                if meanFC(k)<0
                    negLogPValue(k) = -negLogPValue(k);
                else
                    negLogPValue(k)=negLogPValue(k);
                end
            else
                negLogPValue(k)=(-1)*log10(p);
                if meanFC(k)<0
                    negLogPValue(k) = -negLogPValue(k);
                else
                    negLogPValue(k)=negLogPValue(k);
                end
            end
        else
            negLogPValue(k)=0;
        end
    end
    [Outdata,VoxDim,Header]=rest_readfile([maskDir,'final_reduced.nii']);
    [nDim1 nDim2 nDim3]=size(Outdata);
    temp=unique(Outdata);
    ROIIndx=temp(find(temp~=0));
    numROI=length(ROIIndx);
    
    stationaryFCMap=Outdata;
    for m=1:numROI
        stationaryFCMap(find(Outdata==ROIIndx(m)))=negLogPValue(m);
    end
    
    Header.pinfo = [1;0;0];
    Header.dt    =[16,0];
    rest_WriteNiftiImage(stationaryFCMap,Header,[figDir,'thresholdedStationaryFCMap_seed',num2str(i),'_', session, '.nii']);
end



