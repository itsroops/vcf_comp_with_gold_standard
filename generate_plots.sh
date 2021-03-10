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
file_name=$out/$file_name

# Declaring array for storing submitted jobs
declare -a jobs

# Submitting the jobs
k=`sbatch vcf_comp.sh $python_path $happy_path $vcf_gold $var $bed $file_name $ref --cpus-per-task=$cpt --mem=$mem --time=$tot_time --account=$acc --partition=$par --mail-type=$mail_type --mail-user=$mail_id -x raptor10201`

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

echo -e "Please wait while the jobs are running.......Elapsed time is $h hour(s) : $m minute(s) : $s second(s)"

sleep 2m

done

echo -e "\nAll the jobs are complete......" `date` >> mainlog.txt
echo -e "\nAll the jobs are complete......"

# Plotting the vcf comparison values
$curr_path/temp/miniconda3/bin/python3 happy_plots.py $out

echo -e "\nThe bar charts of the comparison are generated in the path $out......" `date` >> mainlog.txt
echo -e "\nThe bar charts of the comparison are generated in the path $out......"

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
