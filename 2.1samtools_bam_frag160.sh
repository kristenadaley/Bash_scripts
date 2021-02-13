#!/bin/bash
INPUT=$1
OUTPUT=$2
samtools view -h $INPUT | awk '$1 ~ /^@/ || ($9 < 160 && $9 > -160)' | samtools view -b > $OUTPUT
