# ucealnstats

Michael G. Campana, 2020
Smithsonian Conservation Biology Institute

Script to calculate taxon-specific alignment statistics from a collection of UCE alignments  

## License  
The software is made available under the [Apache-2 license](http://www.apache.org/licenses/LICENSE-2.0).  

## Installation  
Clone the repository: `git clone https://github.com/campanam/ucealnstats`  
Make the ucealnstats.rb script executable: `chmod +x ucealnstats/ucealnstats.rb`  
Move the ucealnstats.rb script to a target destination: `mv ucealnstats/ucealnstats.rb <destination>`  

## Usage  
### Input  
The ucealnstats.rb expects the UCE alignments to be contained within a single directory. UCE alignments should be in NEXUS format with '.nex' or '.nexus' extensions.  

## Execution  
Execute the script using the command `ruby ucealnstats.rb <directory of UCE alignments>`. Output can be redirected from standard output to a file using `>`, e.g. the command `ruby ucealnstats.rb test_dir > test_results.tsv` will collect alignment statistics from UCE alignments within the directory 'test_dir' and print them to the file 'test_results.tsv'.  

### Output  
The script will output results in tab-separated values (TSV) format.

The script will print the following overall statistics:
1. Results for <Directory>: Name of target directory analyzed by the script.  
2. Total No. of Loci: Total number of UCE alignments with the target directory.  
3. Total UCE Alignment Length: Total concatenated length (in bp) of UCE alignments.  

The script will then print per-sample alignment statistics:
1. Sample: Name of the sample.  
2. CapturedUCEs: Number of UCE alignments that included the sample.  
3. MissingUCEs: Number of UCE alignments that excluded the sample (i.e. 100% missing data for a sample at that locus).  
4. GappedAlignmentLength: Total concatenated UCE alignment length for the sample including gaps due to indels, but excluding missing data.  
5. UngappedAlignmentLength: Total concatenated UCE alignment length for the sample excluding both gaps due to indels and missing data.  
6. TotalLengthCapturedUCEs: Total length of UCE alignments for which some data for the sample was generated (including gaps and missing data).  
7. MeanGapped(Missing): Sample mean gapped UCE lengths including missing loci.  
8. MeanUngapped(Missing): Sample mean ungapped UCE lengths including missing loci.  
9. MeanGapped(NoMissing): Sample mean gapped UCE lengths excluding missing loci.  
10. MeanUngapped(NoMissing): Sample mean ungapped UCE lengths excluding missing loci.  
11. Coverage(Missing): Sample coverage including missing loci defined as GappedAlignmentLength/Total UCE alignment length.  
12. Coverage(NoMissing): Sample coverage excluding missing loci defined as GappedAlignmentLength/TotalLengthCapturedUCEs.  

## ucealnstats Citations  
Campana, M.G. 2020. ucealnstats. https://github.com/campanam/ucealnstats.  
