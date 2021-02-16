#!/bin/sh -l

# Calling the hap.py tool for comaparisons between gold standard file and other vcf files
$1/python $2/hap.py $3 $4 -f $5 -o $6 -r $7
