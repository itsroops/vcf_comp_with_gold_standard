#!/bin/sh

if [[ $# -eq 0 ]] ; then

# Running the program in interactive mode

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

# Checking the validity of the argument
if [[ $vcf_folder != /* ]] ; then
   echo -e "\nInvalid argument for the vcf files path"
   echo -e "\nInvalid argument for the vcf files path......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1

else
echo -e "\nFolder of the VCF files read......" `date` >> mainlog.txt

fi

# Reading the full path of the gold standard files 
echo -e "\nPlease enter the filename along with the full path for the gold standard file"
read vcf_gold

# Checking the validity of the argument
if [[ $vcf_gold != /*.vcf ]] ; then
   echo -e "\nInvalid argument for the gold standard file"
   echo -e "\nInvalid argument for the gold standard file......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1

else
echo -e	"\nPath of the gold standard file read......" `date` >> mainlog.txt

fi

# Reading the path of the bed file
echo -e "\nPlease enter the filename along with the full path for the bed file"
read bed

# Checking the validity of the argument
if [[ $bed != /*.bed ]] ; then
   echo -e "\nInvalid argument for the bed file"
   echo -e "\nInvalid argument for the bed file......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1

else
echo -e	"\nPath of the bed file read......" `date` >> mainlog.txt

fi

# Reading the full path of the reference file
echo -e "\nPlease enter the filename along with the full path for the reference file"
read ref

# Checking the validity of the argument
if [[ $ref != /*.* ]] ; then
   echo -e "\nInvalid argument for the reference file"
   echo -e "\nInvalid argument for the reference file......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1
   
else
echo -e "\nPath of the reference file read......" `date` >> mainlog.txt

fi

# Reading the output folder path
echo -e "\nPlease enter the output folder path. Default:current directory"
read out
out=${out:-$curr_path}

# Checking the validity of the argument
if [[ $out != /* ]] ; then
   echo -e "\nInvalid argument for the output path"
   echo -e "\nInvalid argument for the output path......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1

else
echo -e "\nPath of the output folder read......" `date` >> mainlog.txt

fi

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
echo -e "\nPlease wait......"
f_name=$($curr_path/temp/miniconda3/bin/python3 remove_chr.py $vcf_gold $ch2 2>&1)
echo -e "\nchr removed from the chromosome numbers......" `date` >> mainlog.txt
vcf_gold=$f_name

fi

clear

echo -e "\nAccepting slurm scheduling options from the user"
sleep 1

# Reading the cpu(s) per task
echo -e "\nPlease enter the cpus-per-task. Default:1. Press ENTER to keep default"
read cpt
cpt=${cpt:-1}

# Checking the validity of the argument
if [[ $cpt != [1-9]* || $cpt == *[aA-zZ]* ]] ; then
   echo -e "\nInvalid argument for number of cpu(s) per task"
   echo -e "\nInvalid argument for number of cpu(s) per task......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1

else
echo -e "\nNumber of CPU(s)-per-task read......" `date` >> mainlog.txt

fi

# Reading the memory required per node
echo -e "\nPlease enter the memory required per node.Default units are in MB"
echo -e "\nDifferent units can be specified using the suffix [K|M|G|T]. Default value set is 15G"
read mem
mem=${mem:-15G}

# Checking the validity of the argument
if [[ $mem != [0-9]* ]] ; then
   echo -e "\nInvalid argument for the size of the memory required per node"
   echo -e "\nInvalid argument for the size of the memory required per node......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1

else
echo -e "\nMemory required per node read......" `date` >> mainlog.txt

fi

# Setting a time limit on the total runtime of the job allocation
echo -e "\nPlease enter the total time allocation for the job"
echo -e "\nAcceptable time formats include 'minutes', 'minutes:seconds', 'hours:minutes:seconds', 'days-hours', 'days-hours:minutes' and 'days-hours:minutes:seconds"
echo -e "\nDefault time limit set is 48:00:00"
read tot_time
tot_time=${tot_time:-48:00:00}

# Checking the validity of the input
if [[ $tot_time != [0-9]* ]] ; then
   echo -e "\nInvalid argument for total time of the slurm execution"
   echo -e "\nInvalid argument for total time of the slurm execution......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1

else
echo -e "\nTotal time allocation for the job read......" `date` >> mainlog.txt

fi 

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

# Checking the validity of the argument
if [[ -z $mail_id ]] ; then
   echo -e "\nMail id read......" `date` >> mainlog.txt


elif [[ $mail_id != *@*.* ]] ; then
   echo -e "\nInvalid Mail id"
   echo -e "\nInvalid Mail id......" `date` >> mainlog.txt
   echo -e "\nExiting the program......" `date` >> mainlog.txt
   exit 1

else
echo -e "\nMail id read......" `date` >> mainlog.txt

fi

echo -e "\n" >> mainlog.txt


else

# Running the program in comman-line mode

echo -e "\nProgram Started......" `date` > mainlog.txt

# Defining th version function
function version() {
echo "************************************************************************************************************"
echo -e "\n                             VCF files Comparison tool with gold standard                     \n"
echo -e "                                       Author: Avirup Guha Neogi                                  "
echo -e "                                              VERSION: 1.0                                        "
echo -e "************************************************************************************************************"
}

# Defining the help function
function help() {
clear
echo -e "This is a tool to perform VCF comparisons"
echo -e "Please keep all the VCF files to be compared (with the gold standard file) into a folder"
echo -e "The extension of the VCF must end with '.vcf'. If you use any compressor please decompress and place the normal '.vcf' files"
echo -e "Other required files are bed file and a reference file"
echo -e "\nYou can either use long or short options or a combination of both"
echo -e "Format for using it is as follows:"
echo -e "\n\033[1msh main.sh [option 1] [argument 1] [option 2] [argument 2]....[option n] [argument n]\033[0m"
echo -e "\nThe compulsory options are the gold standard file, bed file and the reference files. Among the slurm options are account and partition names"
echo -e "\nIf you have to enter both --rem_chr=Y|y and --rem_chr_newfile=Y|y, then make sure to use the --rem_chr_newfile flag before --rem_chr"
echo -e "\nFollowing are the options for running in command line"
echo -e "\n\033[1m--help\033[0m | \033[1m-help\033[0m | \033[1m-h\033[0m: Help"
echo -e "\033[1m--version\033[0m | \033[1m-version\033[0m | \033[1m-v\033[0m: Version" 
echo -e "\033[1m--vcf\033[0m | \033[1m-f\033[0m: The folder path of the VCF files which need to be compared. Default:current directory"
echo -e "\033[1m--gold\033[0m | \033[1m-g\033[0m: The filename along with the full path for the gold standard file"
echo -e "\033[1m--bed\033[0m | \033[1m-b\033[0m: The filename along with the full path for the bed file"
echo -e "\033[1m--ref\033[0m | \033[1m-r\033[0m: The filename along with the full path for the reference file"
echo -e "\033[1m--out\033[0m | \033[1m-o\033[0m: The output folder path. Default:current directory"
echo -e "\n\033[1m--rem_chr\033[0m | \033[1m-c\033[0m: The option indicates whether the gold standard file contains the chromosomes as chr1, chr2, etc. Acceptable values are Y|y|other.Default value: N. Other values are automatically treated as N"
echo -e "\n\033[1m--rem_chr_newfile\033[0m | \033[1m-k\033[0m: The option indicates whether one would like to replace the original gold standard file with the file after removing the characters 'chr' or whether one would like to create a new file with the removed characters. Acceptable values are Y|y|other. Default value: N. Any other value is automatically treated as N"
echo -e "\n\033[1m--cpt\033[0m | \033[1m-n\033[0m: The number of CPUs-per-task"
echo -e "\n\033[1m--mem\033[0m | \033[1m-s\033[0m: The memory required per node.Default units are in MB. Different units can be specified using the suffix [K|M|G|T]. Default value set is 15G"
echo -e "\n\033[1m--tot_time\033[0m | \033[1m\033[1m-t\033[0m: The total time allocation for the job. Acceptable time formats include 'minutes', 'minutes:seconds', 'hours:minutes:seconds', 'days-hours', 'days-hours:minutes' and 'days-hours:minutes:seconds'. Default time limit set is 48:00:00"
echo -e "\n\033[1m--acc\033[0m | \033[1m-a\033[0m: The account name"
echo -e "\033[1m--par\033[0m | \033[1m-p\033[0m: The partition name"
echo -e "\033[1m--mail_type\033[0m | \033[1m-m\033[0m: The mail type to notify users when certain event occurs. Default is ALL"
echo -e "\033[1m--mail_id\033[0m | \033[1m-e\033[0m: The user mail id to get notified"
}

# Recording the start time of the process
start_time=$(date +"%s")

# Storing the current path
curr_path=`pwd`

# Setting the python path
python_path=$curr_path/temp/miniconda3/envs/happy/bin

# Setting the hap.py path
happy_path=$curr_path/temp/hap.py-build/bin

# Setting the default value of the vcf folder
vcf_folder=$curr_path

# Setting the default value of the output folder
out=$curr_path

# Setting the default number of CPUs-per-task
cpt=1

# Setting the default memory required per node
mem=15G

# Setting the default total time allocation for the job
tot_time=48:00:00

# Setting the deafult mail type to notify users when certain event occurs
mail_type=ALL

# Setting the dafault value of remove chromosome
ch=N

# Setting the default for the option that asks whether the new file formed after removing chromosome has to be replaced with the old file or not
ch2=N

# Accepting the long options from the  user and converting it to short form
for arg in "$@"; do
 shift
  case "$arg" in
   "--help") set -- "$@" "-h" ;;
   "--version") set -- "$@" "-v" ;;
   "--vcf") set -- "$@" "-f" ;;
   "--gold") set -- "$@" "-g" ;;
   "--ref") set -- "$@" "-r" ;;
   "--bed") set -- "$@" "-b" ;;
   "--rem_chr") set -- "$@" "-c" ;;
   "--rem_chr_newfile") set -- "$@" "-k" ;;
   "--out") set -- "$@" "-o" ;;
   "--cpt") set -- "$@" "-n" ;;
   "--mem") set -- "$@" "-s" ;;
   "--par") set -- "$@" "-p" ;;
   "--acc") set -- "$@" "-a" ;;
   "--tot_time")  set -- "$@" "-t" ;;
   "--mail_type") set -- "$@" "-m" ;;
   "--mail_id")   set -- "$@" "-e" ;;
    *) set -- "$@" "$arg" ;;

  esac
done


OPTIND=1

# Executing the short options that have been accepted from the user
while getopts "f:g:r:b:o:c:k:n:s:p:t:m:a:e:hv" opt; do
  case $opt in
    f)
      vcf_folder=$OPTARG 

      # Checking the validity of the argument
      if [[ $vcf_folder != /* ]] ; then
        echo -e "\nInvalid argument for the vcf files path"
        echo -e "\nInvalid argument for the vcf files path......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt
        exit 1
      fi
      ;;
    g)
      vcf_gold=$OPTARG

      # Checking the validity of the argument
      if [[ $vcf_gold != /*.vcf ]] ; then
        echo -e "\nInvalid argument for the gold standard file"
        echo -e "\nInvalid argument for the gold standard file......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt
        exit 1
      fi
      ;;
    r)
      ref=$OPTARG
    
      #	Checking the validity of the argument
      if [[ $ref != /*.* ]] ; then
        echo -e "\nInvalid argument for the reference file"
        echo -e "\nInvalid argument for the reference file......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt
        exit 1
      fi
      ;;
    b)
      bed=$OPTARG

      # Checking the validity of the argument
      if [[ $bed != /*.bed ]] ; then
        echo -e "\nInvalid argument for the bed file"
        echo -e "\nInvalid argument for the bed file......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt
        exit 1
      fi
      ;;
    o)
      out=$OPTARG

      # Checking the validity of the argument
      if [[ $out != /* ]] ; then
        echo -e "\nInvalid argument for the output path"
        echo -e "\nInvalid argument for the output path......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt
        exit 1
      fi
      ;;
    c)
      ch=$OPTARG
      if [[ $ch = [yY] ]] ; then
        echo -e "\nPlease wait............"
        f_name=$($curr_path/temp/miniconda3/bin/python3 remove_chr.py $vcf_gold $ch2 2>&1)
        vcf_gold=$f_name
      fi
      ;;
    k)
      ch2=$OPTARG
      ;;
    n)
      cpt=$OPTARG

      # Checking the validity of the argument
      if [[ $cpt != [1-9]* || $cpt == *[aA-zZ]* ]] ; then
        echo -e "\nInvalid argument for number of cpu(s) per task"
        echo -e "\nInvalid argument for number of cpu(s) per task......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt
        exit 1
      fi
      ;;
    s)
      mem=$OPTARG
     
      # Checking the validity of the argument
      if [[ $mem != [0-9]* ]] ; then
        echo -e "\nInvalid argument for the size of the memory required per node"
        echo -e "\nInvalid argument for the size of the memory required per node......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt
        exit 1
      fi
      ;;
    p)
      par=$OPTARG
      ;;
    t)
      tot_time=$OPTARG

      # Checking the validity of the input
      if [[ $tot_time != [0-9]* ]] ; then
        echo -e "\nInvalid argument for total time of the slurm execution"
        echo -e "\nInvalid argument for total time of the slurm execution......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt
        exit 1
      fi
      ;;
    m)
      mail_type=$OPTARG
      ;;
    a)
      acc=$OPTARG
      ;;
    e)
      mail_id=$OPTARG

      # Checking the validity of the argument
      if [[ $mail_id != *@*.* ]] ; then
        echo -e "\nInvalid Mail id"
        echo -e "\nInvalid Mail id......" `date` >> mainlog.txt
        echo -e "\nExiting the program......" `date` >> mainlog.txt    
        exit 1
      fi
      ;;
    h)
      help
      echo -e "\nExiting the program......" `date` >> mainlog.txt
      exit 0;;
    v)
      version
      echo -e "\nExiting the program......" `date` >> mainlog.txt
      exit 0;;  
    *)
      echo -e "\ntype 'sh main.sh -h' for help"
      echo -e "\nExiting the program......" `date` >> mainlog.txt
      exit 1
      ;;
  esac
done

# Checking if all the mandatory arguments have been entered
if [[ -z "$ref" || -z "$bed" || -z "$vcf_gold" || -z "$acc" || -z "$par" ]] ; then
  echo -e "\nNot all the mandatory arguments are entered..."
  echo -e "\nNot all mandatory arguments are entered......" `date` >> mainlog.txt
  echo -e "\ntype 'sh main.sh -h' for help\n"
  echo -e "\nExiting the program......" `date` >> mainlog.txt
  exit 1
fi

echo -e "\nAll commannd line arguments have been accepted......" `date` >> mainlog.txt

fi

# Creating a parameter file to record all the parameters that have been entered

echo "Execution Parameters:" > parameters.txt
echo -e "----------------------------------------------------------------------------" >> parameters.txt
echo -e "\nCurrent path: $curr_path" >> parameters.txt
echo "VCF folder path: $vcf_folder" >> parameters.txt
echo "Gold standard file: $vcf_gold" >> parameters.txt
echo "Reference file: $ref" >> parameters.txt
echo "Bed file: $bed" >> parameters.txt
echo "Output path: $out" >> parameters.txt
echo "Does the gold standard file contain 'chr' in the chromosome number?: $ch" >> parameters.txt
echo "For gold standard file containing 'chr' in the chromosome number, does the user want to create a new file with the removed 'chr' word?: $ch2" >> parameters.txt
echo -e "\nSlurm Options:\n" >> parameters.txt
echo "Number of cpu(s) per task: $cpt" >> parameters.txt
echo "Amount of memory required per node: $mem" >> parameters.txt
echo "The time limit on the total runtime of the job allocation: $tot_time" >> parameters.txt
echo "The account name for the job: $acc" >> parameters.txt
echo "The partition name: $par" >> parameters.txt
echo "The mail type to notify users: $mail_type" >> parameters.txt
echo "The user mail id to notify users: $mail_id" >> parameters.txt 

echo -e "\nParameter file generated......" `date` >> mainlog.txt
echo -e "\n" >> mainlog.txt

# Proving executable permissions to the file for all
chmod a+x generate_plots.sh

# Executing the generation of plots script in the background by taking the variables from the current shell
source ./generate_plots.sh &

echo -e "\nYou can monitor the log in the following path: $curr_path/mainlog.txt"
echo -e "\nThe parameter file is available in the following path: $curr_path/parameters.txt"
echo -e "\nThe final plots would be available in the following path: $out\n"
