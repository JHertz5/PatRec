%%
%Q2A using Q1B

% clean up
clc
close all
clear all
if contains(pwd, 'NotPatRecCW')
    dataPath = strcat( extractBefore(pwd, 'NotPatRecCW'), 'NotPatRecCW/data');
    addpath(char(dataPath));
else
    printf('Move to NotPatRecCW directory\n');
end
showPlots = true;
load Separated_Data.mat
load Q1B_Eigen
V = fliplr(V);

numEigs = 150;
testingIdx = 20;
trainFaceIdx = 2;
%% Calculate wn = [an1 an2 ... anM]', ani = normFace_n'*ui

w_n = zeros(numEigs, 416, 'double');
for n = 1:size(trainingNorm,2)
        w_n(:,n) = (trainingNorm(:,n)'*eigVecs_best(:,1:numEigs))';
end
% wn has now dimensions numEigs by size(trainigNorm,2) -> decresed
% dimensionality to save on space, memory, computation time but to preserve
% maximum feature variance

%%

% Reconstruction

 %index of a face from training set to be reconstructed

reconstructedFace = meanFace;

for n = 1:numEigs
     reconstructedFace = reconstructedFace + w_n(n,trainFaceIdx)*eigVecs_best(:,n);
end
%reconstructedFace = reconstructedFace + meanFace;

%% Plot for comparison

faceW = 46; faceH = 56;
OrigFace = zeros(faceH, faceW, 'double');
RecoFace = zeros(faceH, faceW, 'double');

if (exist('showPlots', 'var') && showPlots == true)
    figure(1)
    for i = 1:faceW %extract image one line at a time
        lineStart = (i-1)*faceH + 1;
        lineEnd = i*faceH;
        OrigFace(1:faceH,i) = rot90(training(lineStart:lineEnd,trainFaceIdx), 2);
        RecoFace(1:faceH,i) = rot90(reconstructedFace(lineStart:lineEnd), 2);
    end
   subplot(1,4,1)
    h = pcolor(OrigFace);
    set(h,'edgecolor','none');
    colormap gray
    shading interp
    title('Original Face','fontsize',20)
%     
    subplot(1,4,2)
    h = pcolor(RecoFace);
    set(h,'edgecolor','none');
    colormap gray
    shading interp
    title(['Reconstructed Face with ' num2str(numEigs) ' eigenfaces'],'fontsize',20)
    set(findobj(gcf, 'type','axes'), 'Visible','off')
    %saveas(h,'Q2A_Reco_Train3_3.jpg')
else
    fprintf('No plots because showPlots != true\n')
end

ReconstructionError = norm(training(:,trainFaceIdx)-reconstructedFace)

%% Enter testing face for reconstruction


testFace = testing(:,testingIdx);

% subtract the mean
testFace = testFace - meanFace;

% project it onto eigenfaces
 w_test = (testFace'*eigVecs_best(:,1:numEigs))';
% 
 reconstructedFace2 = meanFace;
% 
 for n = 1:numEigs
      reconstructedFace2 = reconstructedFace2 + w_test(n,:)*eigVecs_best(:,n);
 end

if (exist('showPlots', 'var') && showPlots == true)
    figure(2)
    for i = 1:faceW %extract image one line at a time
        lineStart = (i-1)*faceH + 1;
        lineEnd = i*faceH;
        OrigFace2(1:faceH,i) = rot90(testing(lineStart:lineEnd,testingIdx), 2);
        RecoFace2(1:faceH,i) = rot90(reconstructedFace2(lineStart:lineEnd), 2);
    end
    subplot(1,4,1)
    h = pcolor(OrigFace2);
    set(h,'edgecolor','none');
    colormap gray
    shading interp
    title('Original Face','fontsize',20)
    
    subplot(1,4,2)
    h = pcolor(RecoFace2);
    set(h,'edgecolor','none');
    colormap gray
    shading interp
    title(['Reconstructed Face with ' num2str(numEigs) ' eigenfaces'],'fontsize',20)
    set(findobj(gcf, 'type','axes'), 'Visible','off')
    %saveas(h,'Q2A_Reco_Test1_3.jpg')
else
    fprintf('No plots because showPlots != true\n')
end


ReconstructionError = norm(testing(:,testingIdx)-reconstructedFace2)