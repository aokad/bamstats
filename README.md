# Bamstat
Create BAM summary , using PCAP bam_stats, samtools.

## Dependency

 - Python (>= 2.7), pysam, xlrd, xlwt, ANNOVAR
 - samtools
 - PCAP-core

## Install & Run

Dounload all files in this repository

```
$ git clone https://github.com/aokad/bamstats.git
$ cd bamstat
```

Run.

```
$ ./bamstats.sh ${input bam file}.bam ${output txt file}.txt
```

Run multi files(use qsub).

```
$ qsub ./bamstats.sh ${input bam file 1}.bam ${output txt file 1}.txt
$ qsub ./bamstats.sh ${input bam file 2}.bam ${output txt file 2}.txt
$ qsub ./bamstats.sh ${input bam file 3}.bam ${output txt file 3}.txt
$ qsub ./bamstats.sh ${input bam file 4}.bam ${output txt file 4}.txt
$ qsub ./bamstats.sh ${input bam file 5}.bam ${output txt file 5}.txt
```


## Directory

```
{repository root}
 |- README.md           # this file
 |- bamstats.sh         # run script
 |- [DIR] python        # python scripts
 |- [DIR] log           # log files
```
