
% permutation test

clear
clc
close all


dataLength='all_10min';

resultDir1=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/', dataLength, filesep, 'GSR/session1/clustMean/'];
resultDir2=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/', dataLength, filesep, 'GSR/session2/clustMean/'];
figDir=['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/', dataLength, '/correlTwoSessions/'];

numClust1=5;
numClust2=6;
tmp1=load([resultDir1,'/clusterMean_',num2str(numClust1),'clusters_session1_normWin.mat']);
tmp2=load([resultDir2,'/clusterMean_',num2str(numClust2),'clusters_session2_normWin.mat']);
clustMean1=tmp1.finalMeanWinOfClust;
tmp3=clustMean1';
clustMean2=tmp2.finalMeanWinOfClust;
tmp4=clustMean2';

% recoder the cluster in session 2 to make them match with session
% according to correlation value
clustMeanTransp1=horzcat(tmp3(:,2), tmp3(:,1), tmp3(:,3), tmp3(:, 4),tmp3(:,5));
clustMeanTransp2=horzcat(tmp4(:,2), tmp4(:,6), tmp4(:,4), tmp4(:, 1), tmp4(:,5), tmp4(:,3));

numPerm=10000;
corrPermutation=zeros(numClust2, numPerm, numClust1);
permutation=zeros(size(clustMeanTransp1, 1), numPerm);
for i=1:numClust1
    disp(['session 1 clust', num2str(i)])
    a=clustMeanTransp1(:,i);
    for j=1:numClust2
         disp(['session 2 clust', num2str(j)])
        b=clustMeanTransp2(:,j);
        for k=1:numPerm
            x=b(randperm(length(b)));
            permutation(:,k)=x;
        end
        corrPermutation(j, :, i)=corr(a,permutation);
    end
end

pValPerm=zeros(numClust2, numClust1);
for i=1:numClust1
    a=clustMeanTransp1(:,i);
    for j=1:numClust2
        b=clustMeanTransp2(:,j);
        [tureCor, pCor]=corr(a,b)
        if tureCor>0
            p=length(find(corrPermutation(j,:,i)>tureCor))/numPerm;
        elseif tureCor==0
            p=1;
        elseif tureCor<0
            p=length(find(corrPermutation(j,:,i)<tureCor))/numPerm;
        end
        pValPerm(j,i)=p;
        pValCor(j,i)=pCor;
    end
end