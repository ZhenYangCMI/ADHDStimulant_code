
smooth=6

subList="/home/data/Projects/Zhen/ADHDStimulant/data/final16sub.txt"

maskDir="/home/data/Projects/Zhen/ADHDStimulant/masks/CWASMask_compCor"
preprocessDate='4_29_14'

## 1. spatial normalize the derivatives
standard_template=/home2/data/Projects/Zhen/workingMemory/mask/MNI152_T1_brain.nii.gz
anatDir=/home/data/Projects/Zhen/ADHDStimulant/results/CPAC_zy${preprocessDate}_reorganized/compCor/T1Img


for med in OnMed OffMed; do

dataDir="/home/data/Projects/Zhen/ADHDStimulant/results/CPAC_zy4_29_14_reorganized/compCor/${med}/FunImg"
	
	for sub in `cat $subList`; do
		echo ${sub}
		echo --------------------------
		echo "running subject ${sub}"
		echo --------------------------

		# Applywarp
		cd ${dataDir}

		# mask the grey matter
		3dcalc -a ${dataDir}/normFunImg_${sub}.nii.gz -b /home2/data/Projects/Zhen/workingMemory/mask/MNI152_T1_GREY_3mm_25pc_mask.nii.gz -expr 'a*b' -prefix ${dataDir}/normFunImg_${sub}_masked.nii.gz
		# smooth the data and apply a grey matter mask
		3dmerge -1blur_fwhm 6.0 -doall -prefix ${dataDir}/normFunImg_${sub}_fwhm${smooth}.nii.gz ${dataDir}/normFunImg_${sub}.nii.gz 
		3dcalc -a ${dataDir}/normFunImg_${sub}_fwhm${smooth}.nii.gz -b /home2/data/Projects/Zhen/workingMemory/mask/MNI152_T1_GREY_3mm_25pc_mask.nii.gz -expr 'a*b' -prefix ${dataDir}/normFunImg_${sub}_fwhm${smooth}_masked.nii.gz
		# use the std to create the mask	
		cmd1="fslmaths ${dataDir}/normFunImg_${sub}_masked.nii.gz -Tstd -bin ${maskDir}/stdMask_${sub}${med}"
		echo $cmd1
		eval $cmd1

	done
done


## 2. create the group mask

subList=/home/data/Projects/Zhen/ADHDStimulant/data/final16subMedOnOffCmb.txt
subIncludedList="subIncludedList.txt"
for sub in `cat $subList`; do
echo "${maskDir}/stdMask_${sub}.nii.gz" >> $subIncludedList
done

a=$(cat $subIncludedList)

cmd1="3dMean -prefix ${maskDir}/stdMask_16subOnAndOffMed_compCor.nii.gz $a"
echo $cmd1
eval $cmd1

3dcalc -a ${maskDir}/stdMask_16subOnAndOffMed_compCor.nii.gz -expr 'step(a-0.99999)' -prefix ${maskDir}/stdMask_16subOnAndOffMed_compCor_100prct.nii.gz

#rm -rf $subIncludedList

## 3. create filepath for all subject
subList="/home/data/Projects/Zhen/ADHDStimulant/data/final16sub.txt"
for med in OnMed OffMed; do
sublistFile="/home/data/Projects/Zhen/ADHDStimulant/data/FilePath_16sub_${med}.txt"
rm -rf $sublistFile
	for sub in `cat $subList`; do
	echo "${dataDir}/normFunImg_${sub}_fwhm${smooth}_masked.nii.gz" >> $sublistFile
	done 
done
