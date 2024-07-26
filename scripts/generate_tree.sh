#!/bin/bash
#SBATCH --job-name=phylo_tree            # Job name
#SBATCH --output=phylo_tree.out          # Standard output log
#SBATCH --error=phylo_tree.err           # Standard error log
#SBATCH --account=jkim6                  # Group providing CPU and memory resources
#SBATCH --qos=jkim6                      # QOS to run job on (investment or burst)
#SBATCH --time=400:00:00                 # Time limit hrs:min:sec
#SBATCH --ntasks=2                       # Number of tasks
#SBATCH --mem=15gb                       # Job memory request
#SBATCH --mail-type=END,FAIL             # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=dshin1@ufl.edu       # Where to send mail	

# Load the MEGA module
module load mega/11.0.13

# Define input and output files
input_aln="/blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/aligned_sequences.meg"
output_tree="/blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/phylo_tree.nwk"

# Run MEGA to generate the phylogenetic tree using the specified MAO file
megacc -a /blue/jkim6/dshin1/Phylogenetic_tree/tomato_CYP450_tree/infer_ML_amino_acid.mao -d $input_aln -o $output_tree
