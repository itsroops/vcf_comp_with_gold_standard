#! /bin/sh

start_time=$(date +"%s")

# Recording the current path
k=`pwd`

# Making a temporary directory
mkdir temp

echo -e "\nThe temp install folder created......"

# Navigating to the temporary directory
cd temp

echo -e "\nNavigating to the temporary directory......"

echo -e "\nDownloading the latest miniconda3 installer......"

# Downloading the miniconda installer
wget --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

echo -e "\nStarting miniconda3 installation......"
echo -e "\n"

# Installing the Miniconda3 in the current path
sh Miniconda3-latest-Linux-x86_64.sh -b -p $k/temp/miniconda3

# Removing the miniconda installer
rm Miniconda3-latest-Linux-x86_64.sh

# Setting the conda path
conda_path=$k/temp/miniconda3/condabin
echo -e "\nSetting the conda path......"

# Setting the python3 path
python_path=$k/temp/miniconda3/bin
echo -e "\nSetting the python3 path......"

echo -e "\nminiconda3 installation completed and it is installed in the minconda3 folder......"

echo -e "\nStarting installation of cmake......"

# Installing the cmake
wget --no-check-certificate https://cmake.org/files/v3.2/cmake-3.2.3-Linux-x86_64.tar.gz
tar xf cmake-3.2.3-Linux-x86_64.tar.gz
rm cmake-3.2.3-Linux-x86_64.tar.gz

echo -e "\nCompleting the cmake installation......"

echo -e "\nSetting the cmake path......"

# Setting the cmake path
cmake_path=$k/temp/cmake-3.2.3-Linux-x86_64/bin

echo -e "\nInstalling the python2 conda environment named as happy......"
echo -e "\n"

# Installing the python2 environment
$conda_path/conda create -n happy -y python=2

echo -e "\nInstalling the required packages for the python2 conda environment......"
echo -e "\n"

# Adding channels for installing packages
$conda_path/conda config --add channels bioconda
$conda_path/conda config --add channels conda-forge

# Installing the required packages for the python 2 environment
$conda_path/conda install -n happy -y boost pandas scipy pysam bx-python

echo -e "\nInstalling the required packages for the python3 default conda environment......" 
echo -e "\n"

# Installing the required packages for the python 3 environment
$conda_path/conda install -y pandas matplotlib

echo -e "\nDownloading the hap.py tool from the github......"
echo -e "\n"

# Downloading the hap.py tool
git clone https://github.com/sequencing/hap.py

echo -e "\nMaking the build folder for installation named as hap.py-build......"

# Making the build folder
mkdir hap.py-build
cd hap.py-build

echo -e "\nRunning cmake......"

# Running cmake
$cmake_path/cmake ../hap.py

echo -e "\nBuilding the hap.py tool....."

# Building the tool
make

echo -e "\nAll required softwares are installed in the path: $k/temp....."

end_time=$(date +"%s")

# Computing the elapsed seconds
secs=$((end_time-start_time))

# Dividing seconds into hours, minutes and seconds
h=$((secs/3600))
m=$((secs%3600/60))
s=$((secs%60))

echo -e "\nThe total running time of the installation process is $h hour(s) $m minute(s) and $s second(s)\n"
