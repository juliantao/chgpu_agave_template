#!/bin/bash

#SBATCH -N 1                        	# number of compute nodes
#SBATCH -n 4                        	# number of tasks your job will spawn
#SBATCH --mem=16G                   	# amount of RAM requested in GiB (2^40)
#SBATCH -p gpu                     	# Use gpu partition
#SBATCH -C V100                     	# Specify GPU type
#SBATCH -q wildfire                 	# Run job under wildfire QOS queue
#SBATCH --gres=gpu:4                	# Request 4 GPUs
#SBATCH -t 2-00:00                  	# wall time (D-HH:MM)
#SBATCH -o slurm.%j.out             	# STDOUT (%j = JobId)
#SBATCH -e slurm.%j.err             	# STDERR (%j = JobId)
#SBATCH --mail-type=ALL             	# Send a notification when a job starts, stops, or fails
#SBATCH --mail-user=jtao25@asu.edu 	# send-to address
module purge
module load eigen/3.3.7-openmpi-3.0.3-gcc-7x cuda/11.2.0 blaze/3.7 cmake/3.20.3 chrono/6.0.0 anaconda/py3 rclone/1.43
nvidia-smi 				# Useful for seeing GPU status and activity 
mkdir build 				# Make a new directory to host all cmake files 
cd build				# Go to the new build directory
cmake ..				# Generate Makefiles
make					# Build the project
./repose repose.json			# Run the executive
cd ..					# Return to the project directory
tar czvf repose_output.tgz ./OUT	# Make a tarball of the output files with compression
rclone copy ./repose_output.tgz BiGdata:repose
rm -r ./OUT repose_output.tgz