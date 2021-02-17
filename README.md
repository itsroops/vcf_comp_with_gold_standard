# Automated comparison of VCF files with gold standard file using hap.py tool
This tool would use the **hap.py** comparison tool for comparing the generated VCF files with the gold standard file. 

## Prerequisites
1. Please be sure to have **make** program installed in your system. It can easily be checked using `which make`. This is required for building source codes.
2. Please install **git** in the system. 

## Installation
The installation process is pretty strightforward and can be achieved easily by the following steps.
1. Execute the command `git clone https://github.com/itsroops/vcf_comp_with_gold_standard`
2. Run the script `sh start_install.sh`. This will take care of all the dependencies and will download them.

## Running the tool
The usage is pretty simple and the interactive dialogs would guide in accepting all the relevant inputs.
Please execute the script `sh main.sh`

## Outputs
The outputs from the tool can be categorized into two forms, namely, *log files* and *plot files*.

1. There are three types of *log files* which are generated.
   * *install_log.txt*: This is an installation log file which is generated during installation of the dependencies and it records all the installation processesas   
      it occur in the system.
      
   * *mainlog.txt*: This file is generated during the actual execution of the tool and it records all the steps in details.
   * *slurm-jobid.out*: There are several of these files which log the events of the slurm jobs which have been submitted to the scheduler. 
  
2.  The *plot files* 

