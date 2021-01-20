#! /bin/bash
#Run strelka2 against multiple files

#this list is for the /projects/rmorin_scratch/BC_ctDNA_cohort/dellingr_analysis_directory/ path
#lists BC directories (there are other files in here)
LIST=$(ls -d *[BC]*)
BASE_PATH=/projects/rmorin_scratch/BC_ctDNA_cohort

for SAMPLEID in $LIST
do
    $BASE_PATH/1.1strelka1/strelka_workflow-1.0.15/bin/configureStrelkaWorkflow.pl \
        --normal=/projects/rmorin/projects/DLBCL_OZM/Data/NormalBAMsDup/OZM073-013-014_Normal.markDupl.bam \
        --tumor=$BASE_PATH/dellingr_analysis_directory/$SAMPLEID/results/$SAMPLEID.collapse.sort.bam \
        --ref=/home/krdaley/GRCh38_no_alt.fa \
        --config=$BASE_PATH/1.1strelka1/strelka1_config.ini
        --output-dir=$BASE_PATH/1.1strelka1/
done

for output in $output-dir
do
    cd $BASE_PATH/1.1strelka1/
    make -j 24
done
