clear
clc

%subList=load('/Users/zhenyang/Documents/Zhen_CMI_projects/ADHDstimulant/subListInitial32sub.txt')

subListFile='/Users/zhenyang/Documents/Zhen_CMI_projects/ADHDstimulant/subListInitial32subV2.txt';
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})

fileTypeList={'anat_1', 'anat_2', 'lfo_1', 'rest_1'};
%fileTypeList={'anat_2'};


subMissing={};
numSubHasFile=[];
for j=1:length(fileTypeList)
    a=0;
    b=0;
    fileType=char(fileTypeList{j})
    
    for i=1:length(subList)
        %sub=cellstr(subList(i, 1:7)); % for visit1
        sub=cellstr(subList(i, 1:8)); % for visit2
        
        if strcmp(fileType, 'anat_1') || strcmp(fileType, 'anat_2')
            file=['/Users/zhenyang/Documents/Zhen_CMI_projects/ADHDstimulant/originalFile/', char(sub), '/', fileType, '/mprage.nii.gz'];
        elseif strcmp(fileType, 'lfo_1') || strcmp(fileType, 'rest_1')
            file=['/Users/zhenyang/Documents/Zhen_CMI_projects/ADHDstimulant/originalFile/', char(sub), '/', fileType, '/lfo.nii.gz'];
        end
        
        if exist(file, 'file')
            a=a+1;
            numSubHasFile(j, 1)=a;
            subHasFile(a,j)=sub;
        else
            b=b+1;
            subMissing(b,j)=sub;
        end
    end
end
