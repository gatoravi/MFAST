#! /usr/bin/perl
#Pipeline script for the MFAST heuristic.
#k =3, 4 and 5 a =5 fixed.
#usage - "perl pipeline.pl treeFile fc combineMethod"
#combineMethod = 0 for Inorder combine, anyother number = min overlap

if($#ARGV != 2) {
  print"Incorrect Arguments\n\t usage - perl pipeline.pl treeFile fc combineMethod\n\t combineMethod = 0 for Inorder combine, anyother number = min overlap\n Exiting!\n";
  die;
}

$seed_limit = 700;
$trees_file = $ARGV[0];
$seeds_file = $ARGV[0]."_s";
$fc = $ARGV[1];
$min = $ARGV[2];


print"\nTree file = $trees_file";
print"\nSeeds file = $seeds_file";

#Find potential seeds
`./findPotSeeds $trees_file $fc $seeds_file`;

$frequent_seeds = $ARGV[0]."_fs";

#Find frequent seeds
`perl filterFreqSeeds.pl $seeds_file $trees_file $frequent_seeds`;

#Get most frequent seeds
`head -n $seed_limit $frequent_seeds > $frequent_seeds"p"`;
`head -n $seed_limit $frequent_seeds"_frequencies" > $frequent_seeds"p_frequencies"`;
$frequent_seeds = $frequent_seeds."p";

#Combine using one of the combination approaches
if($min == 0) {
  $opMFASTS = $ARGV[0]."_mMFASTs";
  `./io_combine $frequent_seeds $trees_file 70 $opMFASTS`;
}

else {
  $opMFASTS = $ARGV[0]."_ioMFASTs";
  `./min_combine $frequent_seeds $trees_file 70 $opMFASTS`;
}

$post = $ARGV[0]."pp";
#Post process the combined MFASTs
`perl post_process.pl $opMFASTS $trees_file $fc $post`;

#print the post processed MFAST
open(pp, $post) or die("Unable to open post processed file !");

while(<pp>) {
  print;
}

print"Done !\n";
