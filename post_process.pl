#!/usr/bin/perl

#Avinash Ramu, University of Florida
#Post Processing step for MFAST heuristic
#Usage perl post_process.pl MFAST TREES cutoffFrequency(in %)


if($#ARGV != 3) {
  print"\nIncorrect Arguments exiting!";
  print "\n\tUsage perl post_process.pl MFAST_file tree_file\n";
  die;
}


#MFAST file
$MFASTS = $ARGV[0];


#Input Trees file
$TREES = $ARGV[1];

#frequency
$freq = $ARGV[2];

#op file
$op_file = $ARGV[3];

#file for processed op
#$op_file = "pp_$TREES";
open(OUT, ">$op_file") or die("Unable to open output file !");

#Labels of Input Trees
$LABELS = "labels_".$TREES;
$first_tree = $TREES."_1";

#Write first tree labels to file and sort
`head -n 1 $TREES > $first_tree`;
`./nw_labels_old $first_tree > $LABELS`;
`sort $LABELS > "stree"$LABELS`;

#Remove first tree and unsorted labels
`rm $first_tree`;
`rm $LABELS`;


#Find labels of MFASTs
$uMFASTS = "u".$MFASTS;
$MLABELS = "labels_".$uMFASTS;

#Remove duplicate MFASTs
`sort -u $MFASTS > $uMFASTS`;

#Sort MFASTs according to leafsize
`perl leafcount3.pl $uMFASTS`;
`./sortlc $uMFASTS`;

open(MASTS,$uMFASTS );
@MFASTS_ARRAY = <MASTS>;
#print "\nMFAST ".$MFASTS_ARRAY[0];

#Get the labels of Largest MFAST and sort them
`head -n 1 $uMFASTS > $uMFASTS"_1"`;
`./nw_labels $uMFASTS"_1" > $MLABELS`;
`sort $MLABELS > "smfast"$MLABELS`;

#Find the labels in the input trees not in MFAST.
`comm -23 "stree"$LABELS "smfast"$MLABELS > difflabels`;
`sort -n difflabels > difflabels2`;


open(DLABELS,"difflabels2") or die("\nUnable to open temp file !"); 
@DLABELS_ARRAY = <DLABELS>;
#print "\nDLABELS ".$DLABELS_ARRAY[0];

open(LABELS_h,"stree".$LABELS )or die("\nUnable to open temp file !"); 
@LABELS_ARRAY = <LABELS_h>;
#print "\nLABELS ".$LABELS_ARRAY[0];

open(TREE,$TREES)or die("\nUnable to open trees file !"); 
@trees_array = <TREE>;
#print "\nTREE ".$trees_array[0];

$cutoff = int(($freq * ($#trees_array+1))/100);
#print "\nThe cutoff is ".$cutoff;

$false_cutoff = $#trees_array + 1 - $cutoff; 
#print "\nThe false cutoff is ".$false_cutoff;

$MFAST = $MFASTS_ARRAY[0];
for($i=0; $i<=$#DLABELS_ARRAY; $i++) {
    
    #print"\nMFAST is $MFAST";  
    
    #print "\nLeaves left: ";
    #print $#DLABELS_ARRAY-$i;
    $MAST_LABELS = `./nw_labels_noio '$MFAST'`;
    #print"\nMFAST Label ".$MAST_LABELS;
    chomp ($MAST_LABELS);
    
    $new_label = $DLABELS_ARRAY[$i];
    #print"\nNew Label to be added ".$DLABELS_ARRAY[$i];
    
    
    for($j =0; $j<=$#trees_array; $j++) {
	
	$current_tree	= $trees_array[$j];
	
	$check_current = `./nw_match_noio '$current_tree' '$MFAST'| wc -l`;	
	
	if($check_current == 1) {
	
	    $combined_labels = $MAST_LABELS." ".$new_label;
	    #print "\nCombined Labels is ".$combined_labels;
	    
	    $pruned = `./nw_prune -v '$current_tree' $combined_labels`;
	    #print "\nPruned is ".$pruned;
	    
	    $pruned_freq = `./nw_match_416 $TREES '$pruned' $false_cutoff | wc -l`;
	    #print"\n pruned frequency is $pruned_freq";
	    
	    if($pruned_freq >= $cutoff) {
		#print"\nCutoff satisfied !!\n";
		#print" Added";
		#print OUT$pruned;
		$MFAST = $pruned;
	    }
	    
	    last;
	}
	
    }
}

#Write postprocessed MFAST to file
print OUT$MFAST;


`rm "stree$LABELS"`;
`rm difflabels`;
`rm difflabels2`;
`rm "smfast$MLABELS"`;
#print"\n $uMFASTS  $MLABELS";
`rm $uMFASTS`;
`rm $uMFASTS"_lc"`;
`rm $uMFASTS"_1"`;

`rm $MLABELS`;


print"\n";
