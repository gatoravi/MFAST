#!/usr/bin/bash

#usage bash allReps.sh 0/1 { 0 = Inorder combine 1 = min overlap combine}
for r in {1..10}
do
  for file in *rep$r
  do
    perl pipeline.pl $file 70 $1 > opRep$r
  done
done
