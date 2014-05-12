clear
clc


dataDir=['/home/data/Projects/Zhen/ADHDStimulant/data/organized/'];
subListFile='/home/data/Projects/Zhen/ADHDStimulant/data/final16subMedOnOffCmb.txt';
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})
numSub=length(subList)
effect='Med_condition' 
MaskData='/home/data/Projects/Zhen/ADHDStimulant/masks/CWASMask_compCor/stdMask_16subOnAndOffMed_compCor_100prct.nii.gz'
mkdir (['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/', effect, '_followUp'])
outputDir= ['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/', effect, '_followUp/'];
for i=1:numSub
    sub=subList(i, 1:9);
    AllVolume=[dataDir, 'normFunImg_', sub, '_3mm_fwhm6_masked.nii'];
    
    ROIDef={['/home/data/Projects/BIRD/results/CPAC_zy1_24_14_reorganized/compCor/CWAS_110sub/mdmr3mmFWHM6/cluster_mask_', effect, '.nii.gz']}
    OutputName=[outputDir, 'FC_', effect, '_', sub];
    IsMultipleLabel=1;
    [FCBrain, Header] = y_SCA(AllVolume, ROIDef, OutputName, MaskData, IsMultipleLabel);
end
