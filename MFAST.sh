#!/bin/sh
#PBS -N MFAST
#PBS -M r.avinash@ufl.edu
#PBS -m abe
#PBS -l walltime=480:01:00
#PBS -l nodes=1:ppn=1
#PBS -l pmem=1000mb

time bash allReps.sh $1


