# Phylogenetic-analysis-with-Hipergator

This repository contains scripts and documentation for generating a phylogenetic tree using protein sequences with MEGA-CC on UF HiPerGator.

## Directory Structure

- `scripts/`: Contains SLURM job scripts and other automation scripts.
- `mao/`: Contains MAO files for assigning detailed job parameters.
- `results/`: Contains analysis results.

## Access to UF HiPerGator

1. Open terminal.
2. SSH into HiPerGator:
   ```bash
   ssh <GatorLink Username>@hpg.rc.ufl.edu
3. Enter your password (same as your GatorID password).
4. Press 1 to get a DUO Push.
5. Allow it in the DUO app.

## Access to UF HiPerGator Data Directory

1. Go to UF HiPerGator Open OnDemand (https://ood.rc.ufl.edu).
2. Log in with your UF ID.
3. Click the "Files" tab on the top, and navigate to the desired directory.

Here you can check the files, upload, download, delete, etc., within the directory.

## Workflow

1. Original File Format Change
Sequence alignment with MEGA11 requires FASTA format to run. Prepare protein sequences in the following format in a .fasta file. (The file format can be changed by typing .fasta at the end of the file name)

**Example** 
```
>Solyc08g005610.3.1
MEFVSMLCLFTFISLTLLLIHSIFKFLAFASKKLPLPPGTLGLPYIGETFQLYSQNPNVFFASKVKKYGSIFKTYILGCPCVMISSPEAAKQVLVTKANLFKPTFPASKERMLGKQAIFFHQGDYHAKLRKLVLQAFKPDSIRNIIPDIESIAITSLESFQGRLINTYQEMKTYTFNVALISIFGKDEFLYREELKKCYYILEKGYNSMPINLPGTLFNKAMKARKELAKIVAKIISTRREMKIDHGDLLGSFMGDKEGLTDEQIADNVIGVIFAARDTTASVLTWILKYLGENPSVLQAVTEEQENIMRKKEVNGEEKVLNWQDTRQMPMTTRVIQETLRVASILSFTFREAVEDVEFEGYLIPKGWKVLPLFRNIHHSPDNFPEPEKFDPSRFEVSPKPNTFMPFGNGVHSCPGNDLAKLEILILVHHLTTKYRWSMVGPQNGIQYGPFALPQNGLPIKLSLKTSST
>Solyc10g007960.1.1
MANTKDSYHIITMDTKESSIPSLPMKEIPGDYGVPFFGAIKDRYDFHYNQGADEFFRSRMKKYDSTVFRTNVPPGPFNARNSKVVVLVDAVSYPILFDNSQVDKENYFEGTFMSSPSFNGGYKVCGFLGTSDPKHTTLKGLFLSTLTRLHDKFIPIFTTSITSMFTSLEKELSEKGTSYFNPIGDNLSFEFLFRLFCEGKNPIDTSVGPNGPKIVDKWVFLQLAPLISLGLKFVPNFLEDLVLHTFPLPYILVKRDHQKLYNAFYNSMKDILDEAEKLGVKRDEACHNFVFLAGFNSYGGLKVFFPSLIKWIGTSGPSLHARLVKEIRTAVKEAGGVTLSAIDKMPLVKSVVYETLRMDPPVPFQTVKARKNIIITNHESSFLIKKDELIFGYQPLATKDSKVFKNAEEFNPDRFVGGGEKLLKYVYWSNGKEIDNPSVNDKQCPGKDLIVLMGRLLVVEFFMRYDTFEVEFGKLLLGSKVTFKSLTKATS
```
2. Sequence Alignment
Align protein sequences using the MUSCLE algorithm.

For alignment, you need a FASTA sequence file, a MAO file, and a SLURM script to submit the job. 
To get the MAO file, the instructions are located in the [mao directory](./mao) in this repository.

**SLURM Script: `muscle_align.sh`**
```
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
```

3. Model Selection for Phylogenetic Tree
   
Use MEGA-CC to find the best model for the phylogenetic tree.

**SLURM Script: `mega_model_selection.sh`**
```
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
```
