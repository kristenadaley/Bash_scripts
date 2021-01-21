v1
#! /bin/bash
#Run strelka1 against multiple files

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


v1.1
#! /bin/bash
chrisis script edited for my data:

BASE_PATH=/projects/rmorin_scratch/BC_ctDNA_cohort
bamFiles=$(ls -d $BASE_PATH/dellingr_analysis_directory/[BC]*/results/*.bam)
configFile="$BASE_PATH/1.1strelka1/strelka1_config.ini"
#Chris had corresponding normals for his samples, I dont so I took this part out
normalbam="/projects/rmorin/projects/DLBCL_OZM/Data/NormalBAMsDup/OZM073-013-014_Normal.markDupl.bam"
refGenome="/home/krdaley/GRCh38_no_alt.fa"
outDir="$BASE_PATH/1.1strelka1/"
strelkaScript="$BASE_PATH/1.1strelka1/strelka_workflow-1.0.15/bin/configureStrelkaWorkflow.pl"

for bamFile in ${bamFiles[*]}; do

    baseName=${bamFile##*/}
    rootName=${baseName%%.*}
    sampleOutDir=${outDir}/${rootName}/
    if [[ -e $sampleOutDir ]]; then
        continue
    fi

    # Generate an index for this file, if one does not exist already
    if [[ ! -e "${bamFile}.bai" ]]; then
        samtools index $bamFile
    fi
    
    # not doing this because I dont have matched normals
    # Find the coresponding normal for this sample
    #matchedNorm=$(ls ${normalDir}/${rootName%_plasma}*.bam)

    #if [[ "$matchedNorm" == "" ]]; then
    #    echo "WARNING: Unable to find normal BAM file for $rootName. Skipping"
    #    continue
    #fi
    
    # Run ClipOverlap
    /projects/rmorin_scratch/BC_ctDNA_cohort/Dellingr/Dellingr/ClipOverlap.py -i $bamFile -o - | samtools sort > tmpFile
.bam  && samtools index tmpFile.bam
    #produse clip -i $bamFile -o - | samtools sort > tmpFile.bam  && samtools index tmpFile.bam
    #produse clip -i $matchedNorm -o - | samtools sort > tmpFile.normal.bam && samtools index tmpFile.normal.bam
    
    
    echo "$strelkaScript --tumor ./tmpFile.bam --normal $normalbam --ref $refGenome --config $configFile --output-dir $sampleOutDir"
    eval "$strelkaScript --tumor ./tmpFile.bam --normal $normalbam --ref $refGenome --config $configFile --output-dir $sampleOutDir"
    nice make -C $sampleOutDir -j 8
    rm tmpFile.bam
done
