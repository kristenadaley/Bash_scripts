#!/bin/bash

#moified from chris's script

vcfFiles=$(ls /projects/rmorin_scratch/BC_ctDNA_cohort/1strelka/*/results/variants/somatic.snvs.vcf.gz)
outDir="/projects/rmorin_scratch/BC_ctDNA_cohort/2merged_strelkaVCFs/"

for vcfFile in ${vcfFiles[*]}; do

        # Parse the sample ID for this vcf file
        sampleName=${vcfFile%/results*}
        sampleName=${sampleName##*/}

        # Output VCF file
        outName=${outDir}/${sampleName}.strelka.vcf

        #if the file already exists, go to the next one
        if [[ -e $outName ]]; then
            continue
        fi

        # Parse the indel VCF file
        indelFile=${vcfFile/somatic.snvs/somatic.indels}

        # Merge VCFs
        bcftools concat -a $vcfFile $indelFile -O v | bcftools view -f PASS -o $outName
done

#/projects/rmorin/projects/DLBCL_Epizyme/Analysis/Plasmas/Strelka2/00-HelperFiles/MergeStrelka2VCFs.sh --> chris's original script location
