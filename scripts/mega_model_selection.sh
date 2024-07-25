#!/bin/bash
#SBATCH --job-name=phylo_model               # Job name
#SBATCH --output=phylo_model.out             # Standard output log
#SBATCH --error=phylo_model.err              # Standard error log
#SBATCH --account=jkim6                      # Group providing CPU and memory resources
#SBATCH --qos=jkim6                          # QOS to run job on (investment or burst)
#SBATCH --partition=hpg-default              # Partition to use
#SBATCH --time=48:00:00                      # Time limit hrs:min:sec
#SBATCH --ntasks=2                           # Number of tasks
#SBATCH --mem=15gb                           # Job memory request
#SBATCH --mail-type=END,FAIL                 # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=dshin1@ufl.edu           # Where to send mail    

# Load the MEGA module
module load mega/11.0.13

# Define input and output files
input_aln="/blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/aligned_sequences.meg"
output_tree_model="/blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/tree_model.xlsx"

# Run MEGA to find the best model using the specified MAO file
megacc -a /blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/model_sel_ml_amino_acid.mao -d $input_aln -o $output_tree_model
