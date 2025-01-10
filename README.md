<!-- badges: start -->
[![R-CMD-check](https://github.com/Cristianetaniguti/onemap/workflows/R-CMD-check/badge.svg)](https://github.com/Cristianetaniguti/onemap/actions)
[![Development](https://img.shields.io/badge/development-inactive-darkblue.svg)](https://img.shields.io/badge/development-inactive-darkblue.svg)
[![codecov](https://codecov.io/gh/Cristianetaniguti/onemap/branch/master/graph/badge.svg)](https://codecov.io/gh/Cristianetaniguti/onemap)
[![CRAN_monthly_downloads](https://cranlogs.r-pkg.org/badges/onemap)](https://cranlogs.r-pkg.org/badges/onemap)
  <!-- badges: end -->
  
# OneMap <img src="https://user-images.githubusercontent.com/7572527/119237022-0b19a400-bb11-11eb-9d45-228a59f22a1a.png" align="right" width="200"/>

**OneMap** is a software tool designed for constructing genetic maps in experimental crosses, including full-sib, recombinant inbred lines (RILs), F2, and backcross populations. It was initially developed by Gabriel R. A. Margarido, Marcelo Mollinari, and A. Augusto F. Garcia, with later contributions from Rodrigo R. Amadeu, Cristiane H. Taniguti, and Getúlio C. Ferreira.  

The software has been available on CRAN since 2007 ([OneMap on CRAN](https://cran.r-project.org/package=onemap)) and has undergone several updates, adding new features and optimization up to version 3.2.0 in 2024. Future updates will focus solely on maintaining accessibility and functionality. **New feature development and optimization efforts are now being directed toward the [MAPpoly](https://github.com/mmollina/MAPpoly) and [MAPpoly2](https://github.com/mmollina/mappoly2) packages**.  

**MAPpoly** is a more robust package designed for constructing linkage maps in polyploid species. Its optimized algorithms also provide improved efficiency for diploid species compared to OneMap. Therefore, we recommend using MAPpoly instead of OneMap in the following scenarios for diploid species:  

- When working with only biallelic markers (e.g., SNPs).  
- For outcrossing full-sib (F1), F2, or backcross populations.  
- For datasets with a large number of markers (>5,000).  
- For multi-population datasets (e.g., progeny from multiple parents; see MAPpoly2).  

However, **OneMap** remains the best choice if you have:  

- Populations derived from recombinant inbred lines (RILs).  
- Datasets with multiallelic or dominant markers.  

For guidance on best practices in building linkage maps while accounting for genotyping errors, please refer to [this publication](https://academic.oup.com/gigascience/article/doi/10.1093/gigascience/giad092/7330892).  

# How to install

## From CRAN (stable version)

It is easy, just type (within R):

```R
setRepositories(ind = 1:2)
install.packages("onemap", dependencies=TRUE)
```

You also can use the console menus: _Packages -> Install
package(s)_. After clicking, a box will pop-up asking you to choose
the CRAN mirror. Choose the location nearest to you. Then, another box
will pop-up asking you to choose the package you want to install.
Select _onemap_ then click _OK_. The package will be
automatically installed on your computer.

`OneMap` can also be installed by downloading the appropriate files
directly at the CRAN website and following the instructions given in section `6.3 Installing Packages` of the
[R Installation and Administration](https://cran.r-project.org/doc/manuals/R-admin.pdf)
manual.

## From github (version under development)

Within R, you need to install and load the package `devtools`:

```R
install.packages("devtools")
library(devtools)
```

This will allow you to automatically build and install packages from
GitHub. If you use Windows, first install
[Rtools](https://cran.r-project.org/bin/windows/Rtools/). If you are facing problems with Rtools installation, try to do it by selecting the *Run as Administrator* option with the right mouse button. On a Mac,
you will need Xcode (available on the App Store).

Then, to install `OneMap` from GitHub (this very repo):

```R
install_github("Cristianetaniguti/onemap")
```

# Tutorials

You can read _OneMap_ tutorials going to the vignettes of the
installed package, or clicking below. Please, start with the overview,
that will guide you through other chapters.

1. [Overview](https://cristianetaniguti.github.io/onemap/Overview.html)

2. [Introduction to R](https://cristianetaniguti.github.io/onemap/Introduction_R.html)

3. [How to build a linkage map for inbred-bases populations (F2, RIL and BC)](https://cristianetaniguti.github.io/onemap/Inbred_Based_Populations.html)

4. [How to build a linkage map for outcrossing populations](https://cristianetaniguti.github.io/onemap/Outcrossing_Populations.html)

# How to cite

Margarido, G. R. A., Souza, A. P., &38; Garcia, A. A. F. (2007). OneMap: software for genetic mapping in outcrossing species. Hereditas, 144(3), 78–79. https://doi.org/10.1111/j.2007.0018-0661.02000.x

* If you are using OneMap versions > 2.0, please cite also:

Taniguti, C. H.; Taniguti, L. M.; Amadeu, R. R.; Lau, J.; de Siqueira Gesteira, G.; Oliveira, T. de P.; Ferreira, G. C.; Pereira, G. da S.;  Byrne, D.;  Mollinari, M.; Riera-Lizarazu, O.; Garcia, A. A. F. Developing best practices for genotyping-by-sequencing analysis in the construction of linkage maps. GigaScience, 12, giad092. https://doi.org/10.1093/gigascience/giad092

* If you used the HMM parallelization, please cite [BatchMap](https://github.com/bschiffthaler/BatchMap) paper too:

Schiffthaler, B., Bernhardsson, C., Ingvarsson, P. K., &; Street, N. R. (2017). BatchMap: A parallel implementation of the OneMap R package for fast computation of F1 linkage maps in outcrossing species. PLoS ONE, 12(12), 1–12. https://doi.org/10.1371/journal.pone.0189256