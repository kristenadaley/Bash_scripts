#!/bin/bash

#Created by Christopher Rushton on June 29, 2017
# Runs VCF2MAF on the SUDY samples

vcfFiles=$(ls /projects/rmorin_scratch/BC_ctDNA_cohort/2merged_strelkaVCFs/*.vcf)
outDir="/projects/rmorin_scratch/BC_ctDNA_cohort/3unfiltered_strelkaMAFs/"

for vcfFile in ${vcfFiles[*]}; do

        baseName=${vcfFile##*/}
        rootName=${baseName%%.*}
        normalName=${rootName%%_*}-Normal
        #normalName=${normalName/Relapse/Normal}

        outName=${outDir}${baseName/.vcf/.maf}
        vcf2maf.pl --input-vcf $vcfFile --output-maf $outName --vep-path /home/krdaley/anaconda3/envs/vcf2maf/share/ensembl-vep-100.3-0 --ref-fasta /home/krdaley/GRCh38_no_alt.fa --ncbi-build GRCh38 --vep-data /projects/rmorin/reference/ensembl_vep_cache/ --vcf-normal-id NORMAL --vcf-tumor-id TUMOR --tumor-id $rootName --normal-id $normalName
done

# this script was modified from Chris, from: /projects/rmorin/projects/DLBCL_Epizyme/Analysis/Plasmas/Strelka2/00-HelperFiles
