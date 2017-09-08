#!/bin/bash

INPUT1=01-input/genotypic_matrix_chunks.out
INPUT2=01-input/genotypic_matrix_chunks.mcmc.xml
INPUT3=01-input/genotypic_matrix_chunks.mcmcTree.xml

Rscript ./00-scripts/rscript/fineRADstructurePlot.R $INPUT1 $INPUT2 $INPUT3
