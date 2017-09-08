#!/bin/bash

#INPUT FILE
INPUT=01-input/genotypic_matrix.txt

#Running RAD painter - calculate co-ancestry matrix
./00-scripts/fineRADstructure/RADpainter paint "$INPUT"

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss) 

#Running fine_structure
m="-m T"         #Method to use: MCMCwithTree, oMCMC (MCMC without tree), SplitMerge, Tree, admixture.
I="-I 1"         #Initial number of populations.  <x> is either a number or "n" for the number of individuals, or   
                 #"l" for label detected populations.  Default is 1.
s="-s 123"       #<s>"		Sets the RNG seed to s (>0)
i="-i "          #Ignores the first i lines of the input file
x="-x 100000"    #Number of burn in iterations for MCMC method.
y="-y 100000"    #Number of sample iterations for MCMC method.
z="-z 1000"      #<num> Thin interval in the output file, for MCMC method.
t="-t"           #<num>		Maximum number of tree comparisons for splitting/merging.
K="-K"           #Fix the number of populations to whatever you started with.
                 #This would be set by '-I' or by an initial state file.
a="-a 1.0"       #Set alpha, the prior of the number of parameters (default: 1.0).
c="-c 1.0"       #Set the likelihood correction factor: L_{used}=L^{1/<corfactor>}. (default: 1.0)
B="-B 4/o/O"     #Choose a model for beta: 1/e/E:	Equipartition model of Pella and Masuda.
                 #2/c/C:	Constant model.
                 #4/o/O:  F model of Falush et al 2003 with a single parameter for all populations (default).
#b="-b "          #Hyperparameters for ALL models, in the order COUNTS,LENGTHS,MEANS.  
                 #COUNTS: *must* be included, even if count matrix not used!
                 #For model 1, there are no parameters.
                 #For model 2, set the prior of the distribution of population sizes (each population has beta_i=<num>). (default: 1.0).
                 #For model 4, set the hyperprior of the distribution of delta and F. Parameters are 
                 #(k_f,k_delta,theta_f,theta_delta) for the parameters of the gamma distribution F~Gamma(k_f,theta_f), 
                 #and delta~Gamma(k_delta,theta_delta) (default: -b 2,2,0.01,0.01).
                 #LENGTHS: 8 parameters: (k_alpha0,k_beta0,k_alpha,k_beta,beta_alpha0,beta_beta0,beta_alpha,beta_beta)
                 #MEANS: 6 parameters: (k_betamu, k_alphamu, k_kappa, beta_alphamu,beta_betamu,beta_kappa)
                 #Set K parameters negative for fixed =|k| e.g. when finding a tree given the mean parameters.
#M="-M"           #modeltype: Specify the type of inference model for chunk counts. accept contractions and lower case, and can be:
                 #1 or Finestructure: standard finestructure model (default).
                 #2 or Normalised: Normalise data row and columns within a population.
                 #3 or MergeOnly: As 2, but only compare populations being merged or split.
                 #4 or Individual: Prior is placed on individual rows instead of population rows. (slowest model).
#e="-e"           #Extract details from a state; can be (a unique contraction of): beta: the parameter matrix
                 #X: the copying data matrix for populations
                 #X2: the normalised copying matrix
                 #maxstate: maximum observed posterior probability state
                 #meancoincidence: the mean coincidence matrix
                 #merge<:value><:split>: create a merge(or split) population from the mean coincidence.
                 #admixture: gets the population as an admixture matrix.
                 #Pmatrix: gets the P matrix for the admixture.
                 #range:<from>:<to> gets the iterations in the specified range.
                 #thin:<step>: thins the output by step.
                 #probability: get the posterior probability of the data given the conditions of the outputfile.
                 #likelihood: samples the likelihood of the data given the conditions	in the outputfile.
                 #tree: extract the tree in newick format and print it to a FOURTH file
#F="-F"           #Fix the populations specified in the file.  They should be specified as
                 #population format, i.e. PopA(ind1,ind2) would fix the data rows ind1 and ind2 to always be in the same population (they form a 'super individual')
                 #called PopA. Continents are specified with a * before the name, and are treated specially in the tree building phase,  i.e. *ContA(ind1,ind2).  Continents are not merged with the rest of the tree.
#T="-T"           #When using a merge tree, initialisation can be set to the following:
                 #1:	Use the initial state "as is".
                 #2:	Perform merging to get to best posterior state.
                 #3:	Perform full range of moves to to get to best posterior state. This is the default.  Set number of attempts with -x <num>.
                 #4:	As 1, but dont flatten maximum copy rates for the main tree.
                 #5:	As 2, but dont flatten maximum copy rates for the main tree.
                 #6:	As 3, but dont flatten maximum copy rates for the main tree.
                 #7:	As 1, but maximise hyperparameters between merges.
                 #8:	As 2, but maximise hyperparameters between merges.
                 #9:	As 3, but maximise hyperparameters between merges.
#k="-k"           #Change the tree building algorithm.
                 #0:	Discard all ordering and likelihood information (default).
                 #1:	Maintain ordering.
                 #2:	Maintain ordering and likelihood.
                 #-X	Specifies that there are row names in the data (not necessary for  ChromoPainter or ChromoCombine style files.)
                 #-Y	Specifies that there are column names in the data file (as -X, not necessary.)
#v="-v"           #Verbose mode
#V="-V"           #Print Version info
#h="-h"           #This help message
#./finestructure -x 100000 -y 100000 -z 1000 "$INPUT".out "$INPUT"_chunks.mcmc.xml
#./finestructure -m T -x 10000 "$INPUT"_chunks.out "$INPUT"_chunks.mcmc.xml "$INPUT"_chunks.mcmcTree.xml

#RUN finestructure
#all options:
#./00-script/src/finestructure $m $I $s $i $x $y $z $t $K $a $c $B $b $M $e $F $T $k $v $V $h "$INPUT".out "$INPUT"_chunks.mcmc.xml 2>&1 | tee log.files/finestrcture."$TIMESTAMP".log
#subset of option

#Assign individuals to pop
./00-scripts/fineRADstructure/finestructure $x $y $z "${INPUT%.txt}"_chunks.out "${INPUT%.txt}"_chunks.mcmc.xml 2>&1 | tee log.files/finestrcture."$TIMESTAMP".log

#Tree building
./00-scripts/fineRADstructure/finestructure $m $x  "${INPUT%.txt}"_chunks.out "${INPUT%.txt}"_chunks.mcmc.xml  "${INPUT%.txt}"_chunks.mcmcTree.xml  2>&1 | tee log.files/finestrcture."$TIMESTAMP".log
