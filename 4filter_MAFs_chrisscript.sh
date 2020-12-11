#!/bin/bash

bamFiles=$(ls /projects/rmorin_scratch/BC_ctDNA_cohort/dellingr_analysis_directory/*/results/*.bam)
mafDir="/projects/rmorin_scratch/BC_ctDNA_cohort/3unfiltered_strelkaMAFs"
outDir="/projects/rmorin_scratch/BC_ctDNA_cohort/4filtered_strelkaMAFs"
script="/projects/rmorin/projects/DLBCL_Epizyme/Analysis/Plasmas/Strelka2/00-HelperFiles/PostFilterMAF.py"

for bamFile in ${bamFiles[*]}; do

        baseName=${bamFile##*/}
        rootName=${baseName%%.*}

        outName=${outDir}/${rootName}.postFilt.maf

        # Added by the coolest person(meh)
        if [[ -e $outName ]]; then
                continue
        fi

        mafFile=$(ls ${mafDir}/${rootName}.*)

        if [[ $? != 0 ]]; then
                continue
        fi
        echo "$rootName"
        $script -m ${mafFile} -b ${bamFile} -o $outName
done




#location of chris's original script
#/projects/rmorin/projects/DLBCL_Epizyme/Analysis/Plasmas/Strelka2/00-HelperFiles/FilterMAFs.sh
