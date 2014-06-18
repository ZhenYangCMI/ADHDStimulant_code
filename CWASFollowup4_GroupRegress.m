% This script perform the group analysis for full model
% check whether the standardized or non-standardized data were used

clear
clc


% Initiate the settings.
% 1. define Dir
% for numerical ID
%subList=load('/home/data/Projects/Colibazzi/data/subClean_step2_98sub.txt');
% for text ID
subListFile=['/home/data/Projects/Zhen/ADHDStimulant/data/final16sub.txt'];
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})

numSub=size(subList, 1)

measureList={'CWASME_ROI1', 'CWASME_ROI2', 'CWASME_ROI3' };

numMeasure=length(measureList)

mask=['/home/data/Projects/Zhen/ADHDStimulant/masks/CWASMask_compCor/stdMask_16subOnAndOffMed_compCor_100prct.nii.gz'];

GroupAnalysis=['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/CWASfollowup_groupAnalysis/'];

% 2. set path
addpath /home/data/HeadMotion_YCG/YAN_Program/mdmp
addpath /home/data/HeadMotion_YCG/YAN_Program
addpath /home/data/HeadMotion_YCG/YAN_Program/TRT
addpath /home/data/HeadMotion_YCG/YAN_Program/DPARSF_V2.2_130309
addpath /home/data/HeadMotion_YCG/YAN_Program/spm8
addpath /home/data/Projects/Zhen/commonCode
[ProgramPath, fileN, extn] = fileparts(which('DPARSFA_run.m'));
Error=[];
addpath([ProgramPath,filesep,'Subfunctions']);
[SPMversion,c]=spm('Ver');
SPMversion=str2double(SPMversion(end));

% 3. Model Creation
[NUM,TXT,RAW]=xlsread(['/home/data/Projects/Zhen/ADHDStimulant/data/CWASregressorsFollowup.xls']);

for j=1:numMeasure
    measure=char(measureList{j})
    
    % Model creation
    
    labels=[TXT(1,2), TXT(1,3)];
    %labels{1, 3}='constant';
    cov=[NUM(:,1), NUM(:,2)];
    model=cov;
    disp(labels)
    
    
    % 5. group analysis
    
    FileName = {['/home/data/Projects/Zhen/ADHDStimulant/results/CWAS/OnAndOffMed/meanRegress/', measure, '/', measure, '_AllVolume_meanRegress_Dif.nii']};
    % perform group analysis
    mkdir([GroupAnalysis,measure]);
    outDir=[GroupAnalysis,measure];
    
    OutputName=[outDir,filesep, measure]
    y_GroupAnalysis_Image(FileName,model,OutputName,mask);
    
    % 6. convert t to Z
    
    effectList={'T1'};
    
    
    Df1=numSub-size(model,2) % N-k-1: N:number of subjects; k=num of covariates (constant excluded)
    
    for k=1:length(effectList)
        effect=char(effectList{k})
        
        ImgFile=[outDir, filesep, measure, '_', effect, '.nii'];
        OutputName=[outDir, filesep,  measure, '_', effect, '_Z.nii'];
        Flag='T';
        [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
    end
    
end
