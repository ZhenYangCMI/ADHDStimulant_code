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

addpath(genpath('/home/data/Projects/Zhen/commonCode/spm8'))
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.3_130615
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.3_130615/Subfunctions/
addpath /home/data/Projects/Zhen/commonCode/REST_V1.8_130615


med='OffMed'
dataDir=['/home/data/Projects/Zhen/ADHDStimulant/results/CPAC_zy4_29_14_reorganized/compCor/', med, '/FunImg/'];
subListFile='/home/data/Projects/Zhen/ADHDStimulant/data/final16sub.txt';

subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})
numSub=length(subList)
effect='Med_condition'
MaskData='/home/data/Projects/Zhen/ADHDStimulant/masks/CWASMask_compCor/stdMask_16subOnAndOffMed_compCor_100prct.nii.gz'
mkdir (['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/', effect, '_followUp'])
outputDir= ['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/', effect, '_followUp/'];
for i=1:numSub
    sub=subList(i, 1:7); 
    AllVolume=[dataDir, 'normFunImg_', sub, '_fwhm6_masked.nii.gz'];
    
    ROIDef={['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/mdmr3mmFWHM6/cluster_mask_', effect, '.nii']}
    
    if strcmp(med, 'OnMed')
        OutputName=[outputDir, 'FC_', effect, '_', sub, 'V1'];
    else
        OutputName=[outputDir, 'FC_', effect, '_', sub, 'V2'];
    end
    IsMultipleLabel=1;
    [FCBrain, Header] = y_SCA(AllVolume, ROIDef, OutputName, MaskData, IsMultipleLabel);
end
