#!/bin/bash 
find -L . -type d -name "*_aggregated"  | sed "s#_aggregated#_roary#" | xargs mk

