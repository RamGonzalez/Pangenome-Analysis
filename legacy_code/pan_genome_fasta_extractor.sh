#!/bin/bash

##Hay que extraer la columna 15, y la 1, separadas por espacio " " y con un ">" al inicio de linea para construir el header tipo fasta.
##Solo para los que tiene "3" en la columna 4

INPUT_CSV="data/gene_presence_absence.csv"
INPUT_FASTA="data/pan_genome_reference.fa"

mkdir -p results/

awk 'BEGIN { FS="\",\""; OFS=" " }  $4=='3' { print ">"$15,$1 } ' $INPUT_CSV | tr -d '"' > results/fasta_ids.list

sed -e 's/\(^>.*$\)/#\1#/' $INPUT_FASTA \
| tr -d "\r" \
| tr -d "\n" \
| sed -e 's/$/#/' \
| tr "#" "\n" \
| sed -e '/^$/d' > results/simplfied_fasta.fa

> results/core_genome.fa

while read PALABRA
do
	grep -m1 -A1 "$PALABRA" results/simplfied_fasta.fa >> results/core_genome.fa
done < results/fasta_ids.list

rm results/fasta_ids.list results/simplfied_fasta.fa
