#!/bin/bash

find -L . -type f -name "*.gbk" -o -name "*.gbff" | sed "s#.gbk#.gff#" | sed "s#.gbff#.gff#" | xargs mk 
