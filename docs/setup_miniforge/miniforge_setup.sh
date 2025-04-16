
# navigate to work directory
cd $WORK

# download the file
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh

# change permissions ot user execute
chmod u+x Miniforge3-Linux-x86_64.sh

# install miniforge3, but specify the installation path to work scratch rather than home dir
./Miniforge3-Linux-x86_64.sh -p $WORK/miniforge3
 
echo 'This will edit your bashrc file if you run conda init. Consider changing this to be manually activated' 