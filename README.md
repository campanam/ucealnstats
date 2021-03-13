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
The ucealnstats.rb expects the UCE alignments to be contained within a single directory. UCE alignments should be in NEXUS format.  

## Execution  
Execute the script using the command `ruby ucealnstats.rb <directory of UCE alignments>`. Output can be redirected from standard output to a file using `>`, e.g. the command `ruby ucealnstats.rb test_dir > test_results.tsv` will collect alignment statistics from UCE alignments within the directory 'test_dir' and print them to the file 'test_results.tsv'.  

### Output  
The script will output results in tab-separated values (TSV) format.

## ucealnstats Citations  
Campana, M.G. 2020. ucealnstats. https://github.com/campanam/ucealnstats.  
