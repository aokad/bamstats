#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -e ./log
#$ -o ./log

BAM=${1}
OUT=${2}

##### configure
# PCAP
export PERL5LIB=/home/w3varann/.local/lib/perl/lib/perl5/:/home/w3varann/.local/lib/perl/lib/
PCAP=/home/w3varann/tools/PCAP-core-dev.20150511

# python
SCRIPT=./python
export PYTHONPATH=$PYTHONPATH:${SCRIPT}:/home/w3varann/.local/lib/python2.7/site-packages
export PYTHONHOME=/usr/local/package/python2.7/current
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PYTHONHOME}/lib

# samtools
export SAMTOOLS=/home/w3varann/tools/samtools-1.2/samtools

##### bam_stats_calc

## bam_stats
${PCAP}/bin/bam_stats.pl -i ${BAM} -o ${OUT}.1

## samtools depth
${SAMTOOLS} depth ${BAM} | awk '{{sum+=$3; sumsq+=$3*$3}} END {{ print "Average:\t",sum/NR; print "Stdev:\t",sqrt(sumsq/NR - (sum/NR)**2)}}' > ${OUT}.2

## grep -A1 LIBRARY
MET_FILE=`echo ${BAM} | sed 's/\.bam/.metrics/'`
grep -A1 LIBRARY $MET_FILE > ${OUT}.3

## samtools flagstat
echo "samtools_flagstat" > ${OUT}.4
${SAMTOOLS} flagstat ${BAM} >> ${OUT}.4

## coverage.py
ref_fa=/home/w3varann/database/hg19/hg19.fa
genome_size=/home/w3varann/database/hg19/hg19.chrom.sizes
bed_file=/home/w3varann/database/hg19.fa/hg19_minus_gap.bed
chr_str_in_fa=
coverage='2,10,20,30,40,50,100'
samtools=/home/w3varann/tools/samtools-1.2/samtools

for I in {5..14}
do
	/usr/local/package/python2.7/current/bin/python ${SCRIPT}/python/coverage.py -i ${BAM} -t ${OUT}.${I}.tmp -f ${ref_fa} -g ${genome_size} -e ${bed_file} -b "1000" -n "1000" -p "10" ${chr_str_in_fa} -c ${coverage} -s ${samtools} -r > ${OUT}.tmp.${I}
done

awk '/ratio/ {{ print }}' ${OUT}.tmp.5 > ${OUT}.5-1
for TMP_FILE in `ls ${OUT}.tmp.*`
do
    tail -n1 $TMP_FILE >> ${OUT}.5-1
    rm -f $TMP_FILE
done

/usr/local/package/python2.7/current/bin/python ${SCRIPT}/merge_cov.py -i ${OUT}.5-1 -o ${OUT}.5


##### bam_stats_merge

OUT_TSV=`echo ${OUT} | sed 's/\.txt/.tsv/'`
OUT_XLS=`echo ${OUT} | sed 's/\.txt/.xls/'`
cat ${OUT}.1 ${OUT}.2 ${OUT}.3 ${OUT}.4 ${OUT}.5 > ${OUT}
/usr/local/package/python2.7/current/bin/python ${SCRIPT}/mkxls.py -i ${OUT} -x $OUT_XLS
/usr/local/package/python2.7/current/bin/python ${SCRIPT}/xl2tsv.py -t $OUT_TSV -x $OUT_XLS




