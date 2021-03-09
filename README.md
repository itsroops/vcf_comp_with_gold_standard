# Automated benchmarking of a set of VCF files with a gold standard file using hap.py tool

## About
This tool would use the **hap.py** comparison tool for comparing the generated VCF files with the gold standard file. This can be used to automate the process of comparing several vcf files with the gold standard file and specifically used for the SNPs and INDELs. It can be used either in an interactive way or by using  the command line interface by providing the parameters as options. The interactive method would aid a novice user to make the comparisons without much technical knowledge of the software requirements and other usages. However, for the initegration of this tool into any existing bioinformatics pipleline, the command line interface needs to be used. This interface is for users having basic knowledge of linux commands and for those who know how to run such interfaces.

## Prerequisites

1. This works in typical linux clusters having **slurm workload manager**. 
2. Please be sure to have **make** program installed in your system. It can easily be checked using `which make`. This is required for building source codes.
3. Please install **git** in the system.
4. GCC/G++ 4.9.2+ for compiling

## Installation
The installation process is pretty straightforward and can be achieved easily by the following steps.
1. Execute the command `git clone https://github.com/itsroops/vcf_comp_with_gold_standard`
2. Navigate to the directory by running `cd vcf_comp_with_gold_standard`
3. Run the script by executing `sh start_install.sh`. This will take care of all the dependencies and will download them.

*In case of installation failure: If you have to restart the installation process, please delete the **temp** folder that has been created by `rm -rf temp` and then begin fresh installation.*

## Running the tool
The tool can be run either in 
The usage is pretty simple and the interactive dialogs would guide in accepting all the relevant inputs.
Please execute the script `sh main.sh`

## Outputs
The outputs from the tool can be categorized into three forms, namely, *log files* and *plot files* and *other result files*.

1. There are two types of *log files* which are generated in the $installation_path/vcf_comp_with_gold_standard folder.
       
   * *mainlog.txt*: This file is generated during the actual execution of the tool and it records all the steps in details.
   * *slurm-jobid.out*: There are several of these files which log the events of the slurm jobs which have been submitted to the scheduler. 

2. The *parameters.txt* file is also generated which cotains the list of parameters which have been accepted by the user for running the program. It can be   
   investigated in case of any discrepancy in the values of the parameters. This is also found in the $installation_path/vcf_comp_with_gold_standard folder.
  
3.  The *plot files* include the combined bar plots comparing the values for different metrices like recall, precision and  f1 scores for all the vcf files. 
    They are generated in the *pdf* format. These are generated in the output path which is specified by the user.

4.  The *other result files* contain outputs from the *hap.py* tool run. These are generated in the output path which is specified by the user.

## References
1. For the **hap.py** tool: https://github.com/Illumina/hap.py

2. For installing **git**: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

3. For **Slurm Workload Manager**: https://slurm.schedmd.com/quickstart.html

## Contact
For any queries/issues, please mail to *avirupgn@gmail.com*

