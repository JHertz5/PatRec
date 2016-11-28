%%
%Q2A Something is fucked

addpath /Users/jakubszypicyn/Documents/Year_4_EEE/Pattern_Recognition/NotPatRecCW/data

% clean up
clc
close all
clear all
load Separated_Data.mat
load Q1A_Eigen
V = fliplr(V);

showPlots = true;

numEigs = 2576;

%% Calculate wn = [an1 an2 ... anM]', ani = normFace_n'*ui

for n = 1:size(trainingNorm,2)
        w(:,n) = [trainingNorm(:,n)'*V(:,1:numEigs)]';
end
% wn has now dimensions numEigs by size(trainigNorm,2) -> decresed
% dimensionality to save on space, memory, computation time but to preserve
% maximum feature variance

%%

% Reconstruction

TrainFaceIdx = 1; %index of a face from training set to be reconstructed

reconstructedFace = zeros(1,2576);

for n = 1:numEigs
     reconstructedFace = reconstructedFace + w(n,TrainFaceIdx)*V(:,TrainFaceIdx);
end
reconstructedFace = 6*reconstructedFace+ meanFace;

%% Plot for comparison

faceW = 46; faceH = 56;
OrigFace = zeros(faceH, faceW, 'double');
RecoFace = zeros(faceH, faceW, 'double');

if showPlots == true
    figure(1)
    for i = 1:faceW %extract image one line at a time
        lineStart = (i-1)*faceH + 1;
        lineEnd = i*faceH;
        OrigFace(1:faceH,i) = rot90(training(lineStart:lineEnd,TrainFaceIdx), 2);
        RecoFace(1:faceH,i) = rot90(reconstructedFace(lineStart:lineEnd), 2);
    end
    subplot(1,2,1)
    h = pcolor(OrigFace);
    set(h,'edgecolor','none');
    colormap gray
    shading interp
    title('Original Face','fontsize',20)
    
    subplot(1,2,2)
    h = pcolor(RecoFace);
    set(h,'edgecolor','none');
    colormap gray
    shading interp
    title(['Reconstructed Face with ' num2str(numEigs) ' eigenfaces'],'fontsize',20)
    
end
