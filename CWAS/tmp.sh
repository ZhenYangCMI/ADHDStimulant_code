
smooth=6



## 3. create filepath for all subject
subList="/home/data/Projects/Zhen/ADHDStimulant/data/final16sub.txt"
for med in OnMed OffMed; do
sublistFile="/home/data/Projects/Zhen/ADHDStimulant/data/FilePath_16sub_${med}.txt"
dataDir="/home/data/Projects/Zhen/ADHDStimulant/results/CPAC_zy4_29_14_reorganized/compCor/${med}/FunImg"
rm -rf $sublistFile
	for sub in `cat $subList`; do
	echo "${dataDir}/normFunImg_${sub}_fwhm${smooth}_masked.nii.gz" >> $sublistFile
	done 
done
