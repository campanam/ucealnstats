#!/bin/env/ruby

#----------------------------------------------------------------------------------------
# ucealnstats
UCEALNSTATSVER = "0.2.0"
# Michael G. Campana, 2020
# Smithsonian Conservation Biology Institute
#----------------------------------------------------------------------------------------

$samples = {} # Hash of samples and alignment statistics
$totaluces = 0 # Number of UCEs in complete dataset
$totallength = 0 # Length of complete alignment

#----------------------------------------------------------------------------------------
class TaxonUce # Object holding taxon-specific information 
	# ucecount: total number of UCEs covered
	# gappedlength: total alignment length including gaps
	# ungappedlength: total aligned length excluding gaps
	# sampleucelength: total length of UCE alignments for which this sample has data
	attr_accessor	:ucecount, :gappedlength, :ungappedlength, :sampleucelength
	def initialize(ucecount, gappedlength, ungappedlength, sampleucelength)
		@ucecount, @gappedlength, @ungappedlength, @sampleucelength = ucecount, gappedlength, ungappedlength, sampleucelength
	end
end
#----------------------------------------------------------------------------------------
def get_tag_value(line,tag)
	tag_value = line.split.find { |form| /#{tag}/ =~ form }
	tag_value = tag_value[tag.length + 1..-1].delete(";")
	return tag_value
end
#----------------------------------------------------------------------------------------
def get_files
	Dir.foreach(File.expand_path(ARGV[0])) do |file|
		unless File.directory?(file)
			if file[-4..-1] == ".nex" or file[-6..-1] == ".nexus"
				$totaluces += 1
				# While PhylUCE nexus format is standardized, coding this to be compatible with any nexus file
				dataflag = false # Flag that alignment is within data block
				collectsamples = false # Flag to start collecting individual sample data
				missing = "?" # Default missing character
				gap = "-" # Default gap character
				ucelength = 0 # Default alignment length
				File.open(File.expand_path(ARGV[0]) + "/" + file) do |f1|
					while line = f1.gets
						if line.upcase.strip == "BEGIN DATA;"
							dataflag = true
						elsif dataflag 
							if line.upcase.strip == "END;"
								# Tally included samples
								for sample in @current_samples.keys
									gappedlength = @current_samples[sample].delete(missing).length # Using delete! returns empty string if no matches
									ungappedlength = @current_samples[sample].delete(missing).delete(gap).length
									if !$samples.keys.include?(sample)
										taxuce = TaxonUce.new(1, gappedlength, ungappedlength, ucelength)
										$samples[sample] = taxuce
									else
										$samples[sample].ucecount += 1
										$samples[sample].gappedlength += gappedlength
										$samples[sample].ungappedlength += ungappedlength
										$samples[sample].sampleucelength += ucelength
									end
								end
								break # Skip rest of nexus file
							elsif line.upcase.strip == "MATRIX"
								collectsamples = true
								@current_samples = {} # Hash of current samples and extended sequences for interleaved format
							elsif collectsamples
								next if line.strip == ";" or line.strip == "" # Skip any lines just ending the matrix or blank
								sample_arr = line.strip.split
								sample = sample_arr[0]
								if @current_samples.keys.include?(sample)
									@current_samples[sample] << sample_arr[1]
								else
									@current_samples[sample] = sample_arr[1]
								end
							else
								# Adjust nexus defaults if format different
								if line.downcase.include?("nchar")
									ucelength = get_tag_value(line, "nchar").to_i 
									$totallength += ucelength
								end
								missing = get_tag_value(line, "missing") if line.downcase.include?("missing")	
								gap = get_tag_value(line, "gap") if line.downcase.include?("gap")	
							end
						end
					end
				end
			end
		end
	end
end
#----------------------------------------------------------------------------------------
def print_results
	puts "Results for " + ARGV[0]
	puts "Total No. of Loci: " + $totaluces.to_s
	puts "Total UCE Alignment Length: " + $totallength.to_s
	puts ""
	puts "Sample Statistics"
	puts "Sample\tCapturedUCEs\tMissingUCEs\tGappedAlignmentLength\tUngappedAlignmentLength\tTotalLengthCapturedUCEs\tMeanGapped(Missing)\tMeanUngapped(Missing)\tMeanGapped(NoMissing)\tMeanUngapped(NoMissing)\tCoverage(Missing)\tCoverage(NoMissing)"
	# MeanGapped(Missing) & MeanUngapped(Missing) are mean UCE lengths including missing loci
	# MeanGapped(NoMissing) & MeanUngapped(NoMissing) are mean UCE lengths excluding missing loci
	# Coverage(Missing) is Gapped Length/Total UCE alignment length
	# Coverage(NoMissing) is Gapped Length/Covered UCE alignment length
	for sample in $samples.keys
		sam = $samples[sample]
		puts [sample, sam.ucecount, $totaluces - sam.ucecount, sam.gappedlength, sam.ungappedlength, sam.sampleucelength, sam.gappedlength.to_f/$totaluces.to_f, sam.ungappedlength.to_f/$totaluces.to_f, sam.gappedlength.to_f/sam.ucecount.to_f, sam.ungappedlength.to_f/sam.ucecount.to_f, sam.gappedlength.to_f/$totallength.to_f, sam.gappedlength.to_f/sam.sampleucelength.to_f].join("\t")
	end
end
#----------------------------------------------------------------------------------------
if ARGV[0].nil?
	puts "ucealnstats " + UCEALNSTATSVER
	puts "Michael G. Campana, 2020"
	puts "Smithsonian Conservation Biology Institute"
	puts ""
	puts "Usage: ruby ucealnstats.rb <directory> > <output.tsv>"
else
	get_files
	print_results
end