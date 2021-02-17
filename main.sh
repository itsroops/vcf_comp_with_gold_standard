#! /bin/sh

# Writing the log file
echo -e "\nProgram Started......" `date` > mainlog.txt

# Writing the program description for users's convenience
clear
echo "************************************************************************************************************"
echo -e "\n                             VCF files Comparison tool with gold standard                     \n"
echo -e "                                       Author: Avirup Guha Neogi                                  "
echo -e "************************************************************************************************************"
echo -e "\nThis is an interactive tool which will guide you to perform VCF comparisons"
echo -e "\n*This tool will automatically install the hap.py tool for comparisons"
echo -e "\n*Please keep all the VCF files to be compared (with the gold standard file) into a folder"
echo -e "\n*The extension of the VCF must end with '.vcf'. If you use any compressor please decompress and place the normal '.vcf' files"
echo -e "\n*Other required files are bed file and a reference file"
echo -e "\n*At any point of entering input, if you want to keep the default value, then press ENTER"
echo -e "\n"
read -p "Press ENTER to continue or CTRL+z to abort...."

start_time=$(date +"%s")

# Storing the current path
curr_path=`pwd`

# Setting the python path
python_path=$curr_path/temp/miniconda3/envs/happy/bin

# Setting the hap.py path
happy_path=$curr_path/temp/hap.py-build/bin

# Reading the full path of the vcf files
echo -e "\nPlease enter the folder path of the VCF files which need to be compared. Default:current directory"
read vcf_folder
vcf_folder=${vcf_folder:-$curr_path} 
echo -e "\nFolder of the VCF files read......" `date` >> mainlog.txt

# Reading the full path of the gold standard files 
echo -e "\nPlease enter the filename along with the full path for the gold standard file"
read vcf_gold
echo -e	"\nPath of the gold standard file read......" `date` >> mainlog.txt

# Reading the path of the bed file
echo -e "\nPlease enter the filename along with the full path for the bed file"
read bed
echo -e	"\nPath of the bed file read......" `date` >> mainlog.txt

# Reading the full path of the reference file
echo -e "\nPlease enter the filename along with the full path for the reference file"
read ref
echo -e "\nPath of the reference file read......" `date` >> mainlog.txt

# Reading the output folder path
echo -e "\nPlease enter the output folder path. Default:current directory"
read out
out=${out:-$curr_path}
echo -e "\nPath of the output folder read......" `date` >> mainlog.txt

echo -e "\nPlease mention whether the gold standard file contains the word 'chr' after the chromosome numbers"
echo -e "\nEnter (Y/y) if 'chr' word is present. Default value is N"
read ch
ch=${ch:-N}
f=0

if [[ $ch = [yY] ]] ; then
f=1
echo -e "\nDo you want to keep the original file and make a new file or replace the original file?"
echo -e "\nPlease enter (Y/y) if you want to replace the original file. Default value is N"
read ch2
ch2=${ch2:-N}

# Removing the "chr" from the chromosome numbers present in the gold standard file in order to make it compatible for comparison
f_name=`python3 remove_chr.py $vcf_gold $ch2`
echo -e "\nchr removed from the chromosome numbers......" `date` >> mainlog.txt

fi

clear

echo -e "\nAccepting slurm scheduling options from the user"
sleep 1

# Reading the cpu(s) per task
echo -e "\nPlease enter the cpus-per-task. Default:1. Press ENTER to keep default"
read cpt
cpt=${cpt:-1}
echo -e "\nNumber of CPUs-per-task read......" `date` >> mainlog.txt

# Reading the memory required per node
echo -e "\nPlease enter the memory required per node.Default units are in MB"
echo -e "\nDifferent units can be specified using the suffix [K|M|G|T]. Default value set is 15G"
read mem
mem=${mem:-15G}
echo -e "\nMemory required per node read......" `date` >> mainlog.txt

# Setting a time limit on the total runtime of the job allocation
echo -e "\nPlease enter the total time allocation for the job"
echo -e "\nAcceptable time formats include 'minutes', 'minutes:seconds', 'hours:minutes:seconds', 'days-hours', 'days-hours:minutes' and 'days-hours:minutes:seconds"
echo -e "\nDefault time limit set is 48:00:00"
read tot_time
tot_time=${tot_time:-48:00:00}
echo -e "\nTotal time allocation for the job read......" `date` >> mainlog.txt

# Reading the account name for the job
echo -e "\nPlease enter the account name"
read acc
echo -e "\nAccount name read......" `date` >> mainlog.txt

# Reading the partition name
echo -e "\nPlease enter the partition name"
read par
echo -e "\nPartition name read......" `date` >> mainlog.txt

# Reading the mail type to notify users
echo -e "\nPlease enter mail type to notify users when certain event occurs. Default is ALL"
read mail_type
mail_type=${mail_type:-ALL}    
echo -e "\nMail type read......" `date` >> mainlog.txt

# Reading the user mail id to notify users
echo -e "\nPlease enter the user mail id to get notified"
read mail_id
echo -e "\nMail id read......" `date` >> mainlog.txt
echo -e "\n" >> mainlog.txt

# Proving executable permissions to the file for all
chmod a+x generate_plots.sh

# Executing the generation of plots script in the background by taking the variables from the current shell
source ./generate_plots.sh &

echo -e "\nYou can monitor the log in the following path:$curr_path/mainlog.txt"
echo -e "\nThe final plots would be available in the following path:$out"
