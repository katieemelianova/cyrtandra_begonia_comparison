#!/bin/bash

#SBATCH --partition=short
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G

orthofinder -d -f fastas
