#load libraries
library("dplyr")
#Usar pipes
library("reshape2")
#formatos columnares de datos a formato largo


#starting args object to recieve arguments from command line
#solution taken from https://www.r-bloggers.com/passing-arguments-to-an-r-script-from-command-lines/
args = commandArgs(trailingOnly=TRUE)

#for debugging purposes only
#comment this block before moving code to production 
#args [1] is the path to a csv file from roary
args[1]= "data/gene_presence_absence.csv"
#args[2] is the output file for this script
args[2]="core_genome_gene_ids.tsv"

#asign arguments to readable variable names 
input_file= args[1]

output_file=args[2]

#load data
roary_results.df=read.csv(file=input_file, header=TRUE, stringsAsFactors = FALSE )

#define number of subjects
#la ultima columna de info de roary no referente a objetos es la col 14
#total de columnas del data frame - 14 = number of subjects 
number_of_subjects=ncol(roary_results.df)-14

#create a dataframe with coregenomeids
#core genes are present in all subjects
core_genome.df= roary_results.df %>% filter(No..isolates==number_of_subjects) 

#create a dataframe with shellgenomeids 
#shell genes are present in >1 genome but not in all genomes
shell_genome.df= roary_results.df %>% filter(No..isolates>1 & No..isolates<number_of_subjects) 

#create a dataframe with accesorygenomeids
#accesory genes are those present in one subject
accesory_genome.df= roary_results.df %>% filter(No..isolates==1)  

#transform subject data from wide to long format. For each gene group (core, shell, accesory)
core_genome_long.df= core_genome.df[ , c(1,15:ncol(core_genome.df))] %>% melt(id.vars=1, variable.name="Subject_File", value.name="ContigID")
shell_genome_long.df= shell_genome.df[ , c(1,15:ncol(shell_genome.df))] %>% melt(id.vars=1, variable.name="Subject_File", value.name="ContigID")
accesory_genome_long.df= accesory_genome.df[ , c(1,15:ncol(accesory_genome.df))] %>% melt(id.vars=1, variable.name="Subject_File", value.name="ContigID")

#agregando la etiqueta de type of gene group
core_genome_long.df$TAG="core_genome"
shell_genome_long.df$TAG="shell_genome"
accesory_genome_long.df$TAG="accesory_genome"

#merging the 3 DF using rbind
concatenated.df=rbind(core_genome_long.df, shell_genome_long.df, accesory_genome_long.df)

#send concatenated.df to a table
write.table(x=concatenated.df, file=output_file, sep="\t", quote = FALSE, col.names = TRUE, row.names = FALSE) 
