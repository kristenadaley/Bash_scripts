#! /bin/bash
#Run strelka2 against multiple files

#this list is for the /projects/rmorin_scratch/BC_ctDNA_cohort/dellingr_analysis_directory path
#lists all of the directories with names having BC in them (I did this to get rid of the other files in this directory, so that only the individual file sampleIDs were placed into the config fie below)
LIST=$(ls -d /projects/rmorin_scratch/BC_ctDNA_cohort/dellingr_analysis_directory/*[BC]* | cut -f 6 -d '/')

for SAMPLEID in $LIST
do
    /projects/rmorin_scratch/BC_ctDNA_cohort/strelka/strelka-2.9.10.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py \
        --normalBam /projects/NCI_Burkitts/data/genome_bams_grch38/BLGSP-71-06-00286-99A-01D.bam \
        --tumorBam /projects/rmorin_scratch/BC_ctDNA_cohort/dellingr_analysis_directory/$SAMPLEID/results/$SAMPLEID.collapse.sort.bam \
        --referenceFasta /home/krdaley/GRCh38_no_alt.fa \
        --runDir /projects/rmorin_scratch/BC_ctDNA_cohort/strelka/$SAMPLEID
        --exome
done

#this part runs each workflow script through stelka2
config=$(find /projects/rmorin_scratch/BC_ctDNA_cohort/strelka/ -type f -name 'runWorkflow.py')

#this part runs strelka, locally, with 24 jobs (-j 24),
for workflow in $config
do 
    $workflow -m local -j 24
#this was added by chris I think?, and says if there is already a sample with files in it then dont rerun it, exit that file.
    if [[ $? != 0 ]]
    then
        exit $?
    fi 
done
