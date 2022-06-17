# Tight Local ID Estimator (TLE)

Welcome to the collection of Matlab scripts implementing intrinsic dimensionality (ID) estimators and experiments described in the paper:

Laurent Amsaleg, Oussama Chelly, Michael E. Houle, Ken-ichi Kawarabayashi, Miloš Radovanović and Weeris Treeratanajaru. Intrinsic dimensionality estimation within tight localities. Submitted, 2022.

An older version of the collection associated with the conference version of the paper is available [here](https://perun.pmf.uns.ac.rs/radovanovic/tle/).

## Quick description of the scripts

__id*.m:__
Implementations of various ID estimators.

__genfig_meanvarbyd_outlierness_tlevariants.m:__
Generate synthetic-data plots with varying dimensionality featuring MLE and TLE variants (Figures 6 and 7 in the paper).

__genfig_meanvarbyd_outlierness_all.m:__
Generate synthetic-data plots with varying dimensionality featuring multiple ID estimators (Figures 8, 9 and 10 in the paper).

__genfig_meanvarbyk_tlevariants.m:__
Generate synthetic-data plots with varying neighborhood size featuring MLE and TLE variants (figures not included in the paper).

__genfig_meanvarbyk_all.m:__
Generate synthetic-data plots with varying neighborhood size featuring multiple ID estimators (Figures 11 and 12 in the paper).

__genfig_mdata_all_tlevariants.m, genfig_mdata_fun_tlevariants.m:__
Generate m-family synthetic-data plots featuring MLE and TLE variants (figures not included in the paper).

__genfig_mdata_all_all.m, genfig_mdata_fun_all.m:__
Generate m-family synthetic-data plots featuring multiple ID estimators (Figures 13 and 14 in the paper).

__genfig_boxplot_all2multik_tlevariants.m, genfig_boxplot_fun2multik_tlevariants.m:__
Generate real-data box plots featuring MLE and TLE variants (figures not included in the paper).

__genfig_boxplot_all2multik_all.m, genfig_boxplot_fun2multik_all.m:__
Generate real-data box plots featuring multiple ID estimators (Figures 15 and 16 in the paper).

__compute_ids_tlevariants_dir_all.m, compute_ids_tlevariants_dir.m:__
Compute ID estimates of MLE and TLE variants for all data sets in given directories.

__compute_ids_dir_all.m, compute_ids_dir.m:__
Compute ID estimates of multiple ID estimators for all data sets in given directories.

__compute_knn_dir_all.m, compute_knn_dir.m:__
Compute k-NN distances and indexes for all data sets in given directories.

__torusL2DistForKNNSearch.m:__
Modified Euclidean distance to enable k-NN search in the multidimensional torus setting.

__GetDim.mexw64:__
Matlab executable compiled for 64-bit Windows from matlab\GetDim.cpp by Matthias Hein and Jean-Yves Audibert. We use it to compute (local) correlation dimension. See https://www.ml.uni-saarland.de/code/IntDim/IntDim.htm

All Matlab code written by Miloš Radovanović, with the help of (pseudo) code by Oussama Chelly and Michael E. Houle.

## Data sets

Real data sets are available [here](https://perun.pmf.uns.ac.rs/radovanovic/tle/id-tle-real-data.zip) (~490MB).

Synthetic data sets from the "m-family" are available [here](https://perun.pmf.uns.ac.rs/radovanovic/tle/id-tle-synth-m10000-data.zip) (~120MB).

## Contact

Questions? Comments? Please write to Miloš Radovanović: <radacha@dmi.uns.ac.rs>

## Licensing information

This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License: http://creativecommons.org/licenses/by-sa/4.0/

For attribution, please cite the above paper.
