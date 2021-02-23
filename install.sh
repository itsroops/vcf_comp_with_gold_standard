#! /bin/sh

start_time=$(date +"%s")

# Recording the current path
k=`pwd`

# Making a temporary directory
mkdir temp

echo -e "\nThe temp install folder created......" `date` > $k/install_log.txt

# Navigating to the temporary directory
cd temp

echo -e "\nNavigating to the temporary directory......" `date` >> $k/install_log.txt

echo -e "\nDownloading the latest miniconda3 installer......" `date` >> $k/install_log.txt

# Downloading the miniconda installer
wget --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 2>/dev/null

echo -e "\nStarting miniconda3 installation......" `date` >> $k/install_log.txt
echo -e "\n" >> $k/install_log.txt

# Installing the Miniconda3 in the current path
sh Miniconda3-latest-Linux-x86_64.sh -b -p $k/temp/miniconda3 >> $k/install_log.txt

# Removing the miniconda installer
rm Miniconda3-latest-Linux-x86_64.sh

# Setting the conda path
conda_path=$k/temp/miniconda3/condabin
echo -e "\nSetting the conda path......" `date` >> $k/install_log.txt

# Setting the python3 path
python_path=$k/temp/miniconda3/bin
echo -e "\nSetting the python3 path......" `date` >> $k/install_log.txt

echo -e "\nminiconda3 installation completed and it is installed in the minconda3 folder......" `date` >> $k/install_log.txt

echo -e "\nStarting installation of cmake......" `date` >> $k/install_log.txt

# Installing the cmake
wget https://cmake.org/files/v3.2/cmake-3.2.3-Linux-x86_64.tar.gz 2>/dev/null
tar xf cmake-3.2.3-Linux-x86_64.tar.gz
rm cmake-3.2.3-Linux-x86_64.tar.gz

echo -e "\nCompleting the cmake installation......" `date` >> $k/install_log.txt

echo -e "\nSetting the cmake path......" `date` >> $k/install_log.txt

# Setting the cmake path
cmake_path=$k/temp/cmake-3.2.3-Linux-x86_64/bin

echo -e "\nInstalling the python2 conda environment named as happy......" `date` >> $k/install_log.txt
echo -e "\n" >> $k/install_log.txt

# Installing the python2 environment
$conda_path/conda create -n happy -y python=2 >> $k/install_log.txt

echo -e "\nInstalling the required packages for the python2 conda environment......" `date` >> $k/install_log.txt
echo -e "\n" >> $k/install_log.txt

# Installing the required packages for the python 2 environment
$conda_path/conda install -n happy -y boost pandas scipy pysam bx-python >> $k/install_log.txt

echo -e "\nInstalling the required packages for the python3 default conda environment......" `date` >> $k/install_log.txt 
echo -e "\n" >> $k/install_log.txt

# Installing the required packages for the python 3 environment
$conda_path/conda install -y pandas matplotlib >> $k/install_log.txt

echo -e "\nDownloading the hap.py tool from the github......" `date` >> $k/install_log.txt
echo -e "\n" >> $k/install_log.txt

# Downloading the hap.py tool
git clone https://github.com/sequencing/hap.py 2>/dev/null

echo -e "\nMaking the build folder for installation named as hap.py-build......" `date` >> $k/install_log.txt

# Making the build folder
mkdir hap.py-build
cd hap.py-build

echo -e "\nRunning cmake......" `date` >> $k/install_log.txt

# Running cmake
$cmake_path/cmake ../hap.py >> $k/install_log.txt

echo -e "\nBuilding the hap.py tool....." `date` >> $k/install_log.txt

# Building the tool
make >> $k/install_log.txt

echo -e "\nAll required softwares are installed in the path: $k/temp....." `date` >> $k/install_log.txt

end_time=$(date +"%s")

# Computing the elapsed seconds
secs=$((end_time-start_time))

# Dividing seconds into hours, minutes and seconds
h=$((secs/3600))
m=$((secs%3600/60))
s=$((secs%60))

echo -e "\nThe total running time of the installation process is $h hour(s) $m minute(s) and $s second(s)" >> $k/install_log.txt
