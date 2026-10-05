# MFAST: Maximal Frequent Agreement SubTrees

A heuristic for finding **evolutionary relationships that are shared by most
trees in a large collection of phylogenetic trees**.

> Ramu A, Kahveci T, Burleigh JG. *A scalable method for identifying frequent
> subtrees in sets of large phylogenetic trees.* BMC Bioinformatics 13, 256
> (2012). [doi:10.1186/1471-2105-13-256](https://doi.org/10.1186/1471-2105-13-256)

*Avinash Ramu and Sriram, University of Florida.*

## Background

Phylogenetic analyses rarely produce a single tree. Bootstrap replicates,
Bayesian posterior samples and gene trees from different loci can number in
the thousands, often with hundreds of taxa each. Consensus methods summarise
them into one tree but collapse any group that conflicts between trees, which
can hide well-supported relationships.

A **frequent agreement subtree** is a subtree on a subset of taxa whose
topology appears in at least a given fraction of the input trees. MFAST finds
large frequent agreement subtrees efficiently, so it scales to big sets of
large trees where exact methods are too slow.

## How it works

1. **Find seeds.** Enumerate small subtrees (k taxa, k = 3 to 5) in each tree
   and keep those that occur in at least the frequency cutoff of trees
   (`findPotSeeds.cpp`, `filterFreqSeeds.pl`).
2. **Combine seeds.** Greedily merge compatible frequent seeds into larger
   subtrees, using either in-order or minimum-overlap combination
   (`io_combine`, `min_combine`, built on the
   [Newick Utilities](https://github.com/tjunier/newick_utils) in `src/`).
3. **Post-process.** Keep the maximal subtrees that still meet the frequency
   cutoff (`post_process.pl`).

## Usage

Input is a file of trees in Newick format, one per line, each ending in `;`.

```bash
perl pipeline.pl trees.nwk 70 0
```

| Argument | Meaning |
| --- | --- |
| `trees.nwk` | File of input trees |
| `70` | Frequency cutoff: percentage of trees a subtree must appear in |
| `0` | Combination method: `0` for in-order combine, any other value for minimum-overlap combine |

The maximal frequent agreement subtrees are printed to standard output, and
intermediate files (`*_s`, `*_fs`, `*pp`) are written next to the input.
`allReps.sh` runs the pipeline over replicate tree sets, and `MFAST.sh` is a
PBS job script for running it on a cluster.

## Status

Research code written as a proof of principle of the heuristic; it has not been
refactored since publication. Precompiled Linux binaries (`findPotSeeds`,
`io_combine`, `min_combine`, `nw_*`) are included.

## License

MIT. See [COPYING](COPYING).
