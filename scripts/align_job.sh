#!/bin/bash
#SBATCH --job-name=muscle_align
#SBATCH --output=muscle_align.out
#SBATCH --error=muscle_align.err
#SBATCH --account=jkim6
#SBATCH --qos=jkim6
#SBATCH --time=100:00:00
#SBATCH --ntasks=2
#SBATCH --mem=15gb
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=dshin1@ufl.edu

# Load the MEGA module
module load mega/11.0.13

# Set up Xvfb
DISPLAY_ID=$RANDOM
export DISPLAY=:${DISPLAY_ID}
Xvfb :${DISPLAY_ID} -screen 0 1024x768x16 &

# Run MUSCLE alignment
megacc -a "/blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/muscle_align_protein.mao" -d "/blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/Tomato_P450_with_ref.fasta" -o "/blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/aligned_sequences.meg"

