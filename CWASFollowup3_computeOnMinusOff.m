clear
clc

rmpath /home/milham/matlab/REST_V1.7
rmpath /home/milham/matlab/REST_V1.7/Template
rmpath /home/milham/matlab/REST_V1.7/man
rmpath /home/milham/matlab/REST_V1.7/mask
rmpath /home/milham/matlab/REST_V1.7/rest_spm5_files

restoredefaultpath

% addpath(genpath('/home/data/HeadMotion_YCG/YAN_Program/spm8'))
% addpath /home/data/HeadMotion_YCG/YAN_Program/DPARSF_V2.3_130615
% addpath /home/data/HeadMotion_YCG/YAN_Program/DPARSF_V2.3_130615/Subfunctions/
% addpath /home/data/HeadMotion_YCG/YAN_Program/REST_V1.8_130615

addpath(genpath('/home/data/Projects/Zhen/BIRD/BIRD_code/spm8'))
addpath /home/data/Projects/Zhen/BIRD/BIRD_code/DPARSF_V2.3_130615
addpath /home/data/Projects/Zhen/BIRD/BIRD_code/DPARSF_V2.3_130615/Subfunctions/
addpath /home/data/Projects/Zhen/BIRD/BIRD_code/REST_V1.8_130615


project='ADHDStimulant';
covType='compCor' % covType can be noGSR or compCor
effect='Med_condition';  % 'DT_group_name', or 'age_demeanByDT_group'

BrainMaskFile=['/home/data/Projects/Zhen/ADHDStimulant/masks/CWASMask_compCor/stdMask_16subOnAndOffMed_compCor_100prct.nii.gz'];

numSub=16;
numClust=3;

for k=1:numClust
    
    dataOutDir=['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/meanRegress/CWASME_ROI', num2str(k), '/'];
    fileName=['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/meanRegress/CWASME_ROI', num2str(k), '/CWASME_ROI', num2str(k), '_AllVolume_meanRegress.nii']
    
    [AllVolume,vsize,theImgFileList, Header,nVolumn] =rest_to4d(fileName);
    
    
    [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
    
    
    %Set Mask
    
    if ~isempty(BrainMaskFile)
        
        [MaskData,MaskVox,MaskHead]=rest_readfile(BrainMaskFile);
        
    else
        
        MaskData=ones(nDim1,nDim2,nDim3);
        
    end
    
    
    % Convert into 2D. NOTE: here the first dimension is voxels,
    
    % and the second dimension is subjects. This is different from
    
    % the way used in y_bandpass.
    
    %AllVolume=reshape(AllVolume,[],nDimTimePoints)';
    
    AllVolume=reshape(AllVolume,[],nDimTimePoints);
    
    
    MaskDataOneDim=reshape(MaskData,[],1);
    
    MaskIndex = find(MaskDataOneDim);
    
    nVoxels = length(MaskIndex);
    
    %AllVolume=AllVolume(:,MaskIndex);
    
    AllVolume=AllVolume(MaskIndex,:);
    
    AllVolumeOn=AllVolume(:, 1:16);
    AllVolumeOff=AllVolume(:, 17:32);
    AllVolumeDif=AllVolumeOn-AllVolumeOff;
    
    
    % write the data as a 4D volume
    AllVolumeBrain = (zeros(nDim1*nDim2*nDim3, nDimTimePoints/2));
    
    AllVolumeBrain(MaskIndex,:) = AllVolumeDif;
    
    
    
    AllVolumeBrain=reshape(AllVolumeBrain,[nDim1, nDim2, nDim3, nDimTimePoints/2]);
    
    Header_Out = Header;
    
    Header_Out.pinfo = [1;0;0];
    
    Header_Out.dt    =[16,0];
    
    %write 4D file as a nift file
    
    outName=[dataOutDir, 'CWASME_ROI', num2str(k), '_AllVolume_meanRegress_Dif.nii'];
    
    
    rest_Write4DNIfTI(AllVolumeBrain,Header_Out,outName)
    
end
