#!/bin/bash

set -e
outdir="/projects/rmorin_scratch/mcl_ichorcna/gambl/data/genome_bams"

while read line; do
    cols=($line)
    #link the BAM
    source_bam=$(ls ${cols[2]}/${cols[1]}_1_lane_dupsFlagged.bam)
    out_bam="${outdir}/${cols[0]}.genome.bam"

    if [[ -e $out_bam ]]; then
            continue
    fi

    ln -s $source_bam $out_bam

    #link the bam.bai
    source_bai=$(ls ${cols[2]}/${cols[1]}_1_lane_dupsFlagged.bam.bai)
    out_bai="${outdir}/${cols[0]}.genome.bam.bai"

    if [[ -e $out_bai ]]; then
            continue
    fi

    ln -s $source_bai $out_bai

done < <(tail -n+2 /projects/rmorin_scratch/mcl_ichorcna/gambl/data/metadata/id_and_bam_path.tsv)

id_and_bam_path=$(ls /projects/rmorin_scratch/mcl_ichorcna/gambl/data/metadata/id_and_bam_path.tsv)
sample_table=$(ls /projects/rmorin_scratch/mcl_ichorcna/gambl/data/metadata/demo_samples.tsv)
