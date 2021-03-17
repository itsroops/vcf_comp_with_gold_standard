#! /bin/sh

# Navigating to the vcf files
files=`ls $vcf_folder/*.vcf`

echo -e "Submitting jobs for all the vcf files:\n"

job_time=$(date +"%s")

# Submitting jobs for all the vcf files
for var in $files

do

# Reading the filename
file_name=`echo $var | rev | cut -d'/' -f 1 | rev`
file_name=$out/$out_name/$file_name

# Declaring array for storing submitted jobs
declare -a jobs

# The case when the account, partition and mail_id parameters are null
if [[ -z $acc && -z $par && -z $mail_id ]] ; then
   k=`sbatch --cpus-per-task=$cpt --mem=$mem --time=$tot_time --mail-type=$mail_type vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref`

# The case when the account and  partition are null whereas mail_id parameters is not null
elif [[ -z $acc && -z $par && ! -z $mail_id ]] ; then
     k=`sbatch --cpus-per-task=$cpt --mem=$mem --time=$tot_time --mail-type=$mail_type --mail-user=$mail_id vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref`

# The case when the account and mail_id are null whereas the partition is not null
elif [[	-z $acc	&& ! -z $par && -z $mail_id ]] ; then
     k=`sbatch --cpus-per-task=$cpt --mem=$mem --time=$tot_time  --partition=$par --mail-type=$mail_type vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref`

# The case when the account is null whereas partition and mail_id parameters are not null
elif [[ -z $acc && ! -z $par && ! -z $mail_id ]] ; then
     k=`sbatch --cpus-per-task=$cpt --mem=$mem --time=$tot_time  --partition=$par --mail-type=$mail_type --mail-user=$mail_id vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref`

# The case when the partition and mail id are null whereas the account is not null
elif [[ ! -z $acc && -z $par && -z $mail_id ]] ; then
     k=`sbatch --cpus-per-task=$cpt --mem=$mem --time=$tot_time --account=$acc --mail-type=$mail_type vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref`

# The case when the partition is null whereas the account and mail_id are not null
elif [[ ! -z $acc && -z $par && ! -z $mail_id ]] ; then
     k=`sbatch --cpus-per-task=$cpt --mem=$mem --time=$tot_time --account=$acc --mail-type=$mail_type --mail-user=$mail_id vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref`

# The case when the account and partition parameters are not null and mail id is null
elif [[ ! -z $acc && ! -z $par && -z $mail_id ]] ; then
     k=`sbatch --cpus-per-task=$cpt --mem=$mem --time=$tot_time --account=$acc --partition=$par --mail-type=$mail_type vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref`

# The case when the account, partition and mail id are not null
else
  k=`sbatch --cpus-per-task=$cpt --mem=$mem --time=$tot_time --account=$acc --partition=$par --mail-type=$mail_type --mail-user=$mail_id vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref`

fi


echo $k
echo $k......`date` >> mainlog.txt

# Extracting the job ids
j=$(echo $k | cut -d ' ' -f4)
jobs+=($j)
done


echo -e "\nThe 'squeue' command can be used to check the status of the jobs submitted" >> mainlog.txt
echo -e "\nMoreover, the running status of individual jobs can be found here $curr_path/slurm-jobid.out" >> mainlog.txt

echo -e "\nThe 'squeue' command can be used to check the status of the jobs submitted"
echo -e "\nMoreover, the running status of individual jobs can be found here $curr_path/slurm-jobid.out\n"

# Running the infinite loop  till all the queued jobs terminate
l=0
while [ $l -lt 10 ]
do

flag=0
for i in "${jobs[@]}"
do
k=`squeue | grep $i`
len=${#k}
if [[ $len = 0 ]]; then
flag=$((flag+1))
fi
done

if [[ $flag = ${#jobs[@]} ]]; then
break
fi

# Checking the status of the jobs completion every after 2 minutes

run_time=$(date +"%s")

# Computing the elapsed seconds
secs=$((run_time-job_time))

# Dividing seconds into hours, minutes and seconds
h=$((secs/3600))
m=$((secs%3600/60))
s=$((secs%60))

echo -e "Please wait while the jobs are running.......Elapsed time for jobs is $h hour(s) : $m minute(s) : $s second(s)"

sleep 2m

done

# Checking if the jobs that are queued have run successfully or not
count=`ls -1 $out/$out_name/*.summary.csv 2>/dev/null | wc -l`

if [[ $count == 0 ]] ; then
   echo -e "\nNone of the jobs have run successfully. Please check the slurm log files for details.\n"
   echo -e "\nNone of the jobs have run successfully. Please check the slurm log files for details......." `date` >> mainlog.txt
   exit 1
fi

echo -e "\nAll the jobs are complete......" `date` >> mainlog.txt
echo -e "\nAll the jobs are complete......"

# Plotting the vcf comparison values
$curr_path/temp/miniconda3/bin/python3 happy_plots.py $out/$out_name

# Checking if the plots are generated successfully or not
count=`ls -1 $out/$out_name/*.pdf 2>/dev/null | wc -l`

if [[ $count == 0 ]] ; then
   echo -e "\nThere is(are) some error(s) in the generation of plot files.\n"
   echo -e "\nThere is(are) some error(s) in the generation of plot files......" `date` >> mainlog.txt
   exit	1
fi


echo -e "\nThe bar charts of the comparison are generated in the path $out/$out_name......" `date` >> mainlog.txt
echo -e "\nThe bar charts of the comparison are generated in the path $out/$out_name......"

end_time=$(date +"%s")

# Computing the elapsed seconds
secs=$((end_time-start_time))

# Dividing seconds into hours, minutes and seconds
h=$((secs/3600))
m=$((secs%3600/60))
s=$((secs%60))

echo -e "\nThe total running time of the program is $h hour(s) $m minute(s) and $s second(s)" >> mainlog.txt
echo -e "\nThe total running time of the program is $h hour(s) $m minute(s) and $s second(s)"

echo -e "\nThe log file is generated in the following path: $curr_path/mainlog.txt"
