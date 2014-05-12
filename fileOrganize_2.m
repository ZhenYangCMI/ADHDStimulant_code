clear
clc
group='OnMed'
if strcmp(group, 'OffMed')
    fileName={'subList9subOffMedV1.txt', 'subList10subOffMedV2.txt'};
    
elseif strcmp(group, 'OnMed')
    fileName={'subList10subOnMedV1.txt', 'subList9subOnMedV2.txt'};
end

destinationDir='/home/data/Projects/Zhen/ADHDStimulant/data/organized/'

for j=1:length(fileName)
    file=char(fileName{j})
    
    subListFile=['/home/data/Projects/Zhen/ADHDStimulant/data/', file];
    
    subList1=fopen(subListFile);
    subList=textscan(subList1, '%s', 'delimiter', '\n')
    subList=cell2mat(subList{1});
    numSub=length(subList)
    
       
    for i=1:length(subList)
        
        if strcmp(file(end-5:end-4), 'V1')
            sub=cellstr(subList(i, 1:7));
        else
            sub=cellstr(subList(i, 1:8));
        end
        
        originalDir=['/home/data/Projects/Zhen/ADHDStimulant/data/fromKrishna/', char(sub)]
        anatFolder=[originalDir, '/anat_1'];
        restFolder=[originalDir, '/lfo_1'];
        
        
        if length(char(sub))==7
            mkdir ([destinationDir, char(sub), group, '/anat' ])
            mkdir ([destinationDir, char(sub), group, '/rest' ])
            subAnatDestination=[destinationDir, char(sub), group, '/anat/' ];
            subRestDestination=[destinationDir, char(sub), group, '/rest/' ];
            
            copyfile(anatFolder, subAnatDestination)
            copyfile(restFolder, subRestDestination)
            
            
        elseif length(char(sub))==8
            tmp=char(sub);
            mkdir ([destinationDir, tmp(1:7), group, '/anat'])
            mkdir ([destinationDir, tmp(1:7), group, '/rest'])
            subAnatDestination=[destinationDir, tmp(1:7), group, '/anat/' ];
            subRestDestination=[destinationDir, tmp(1:7), group, '/rest/' ];
            copyfile(restFolder, subRestDestination)
            
            anatFolder=['/home/data/Projects/Zhen/ADHDStimulant/data/fromKrishna/', tmp(1:7), '/anat_1'];
            copyfile(anatFolder, subAnatDestination)
            
        end
    end
    
end    
