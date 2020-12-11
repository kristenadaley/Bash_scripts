#!/bin/bash

#depth filter of 4ZZ

mafFiles=$(ls /projects/rmorin_scratch/BC_ctDNA_cohort/4filtered_strelkaMAFs/*.maf)
outDir="/projects/rmorin_scratch/BC_ctDNA_cohort/5depthfiltered_strelkaMAFs/"

for mafFile in ${mafFiles[*]}; do

        baseName=${mafFile##*/}
        rootName=${baseName%%.*}
        outName=${outDir}/${rootName}.depthFilt.maf

        awk -F '\t' '$40>=10' $mafFile > $outName
done
