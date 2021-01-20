#! /bin/bash
#Run strelka2 against multiple files

#this list is for the /projects/rmorinscratch/BC_ctDNA_cohort/dellingr_analysis_directory/ path
#lists BC directory
LIST=$(ls -d *[BC]*)

for SAMPLEID in $LIST
do
    /projects/rmorin_scratch/BC_ctDNA_cohort/strelka/strelka-2.9.10.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py \
        --normalBam /projects/rmorin/projects/DLBCL_OZM/Data/NormalBAMsDup/OZM073-013-014_Normal.markDupl.bam \
        --tumorBam /projects/rmorin_scratch/BC_ctDNA_cohort/dellingr_analysis_directory/$SAMPLEID/results/$SAMPLEID.collapse.sort.bam \
        --referenceFasta /home/krdaley/GRCh38_no_alt.fa \
        --runDir /projects/rmorin_scratch/BC_ctDNA_cohort/strelka/$SAMPLEID \
       --exome
done

config=$(find /projects/rmorin_scratch/BC_ctDNA_cohort/strelka/ -type f -name 'runWorkflow.py')

parallel -j 10 {1} -m local -j 10 ::: $config

for workflow in $config
do
    $workflow -m local -j 24
done
