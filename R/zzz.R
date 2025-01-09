#######################################################################
#                                                                     #
# Package: onemap                                                     #
#                                                                     #
# zzz.R                                                               #
# Contains: .onemapEnv                                                #
#                                                                     #
# Written by Gabriel Rodrigues Alves Margarido and Marcelo Mollinari  #
# copyright (c) 2007, Gabriel R A Margarido                           #
#                                                                     #
# First version: 11/07/2007                                           #
# Last update: 03/12/2012                                             #
# License: GNU General Public License version 2 (June, 1991) or later #
#                                                                     #
#######################################################################

.onemapEnv <- new.env()
assign(".map.fun",  "kosambi", envir = .onemapEnv)
# end of file

.onLoad <- function(libname, pkgname){
  msg <- paste(
    "\n\nAfter version 3.0.0 OneMap updates has been solely for maintaining accessibility and functionality. 
    New feature development and optimization efforts are now being directed toward the 
    MAPpoly (https://github.com/mmollina/MAPpoly) and MAPpoly2 (https://github.com/mmollina/mappoly2) packages.\n\n",
    
    "MAPpoly is a more robust package designed for constructing linkage maps in polyploid species. ",
    "Its optimized algorithms also provide improved efficiency for diploid species compared to OneMap. ",
    "Therefore, we recommend using MAPpoly instead of OneMap in the following scenarios for diploid species:\n\n",
    
    "- When working with only biallelic markers (e.g., SNPs).\n",
    "- For outcrossing full-sib (F1), F2, or backcross populations.\n",
    "- For datasets with a large number of markers (>5,000).\n",
    "- For multi-population datasets (e.g., progeny from multiple parents; see MAPpoly2).\n\n",
    
    "However, OneMap remains the best choice if you have:\n\n",
    "- Populations derived from recombinant inbred lines (RILs).\n",
    "- Datasets with multiallelic or dominant markers.\n\n",
    
    "For guidance on best practices in building linkage maps while accounting for genotyping errors, ",
    "please refer to this publication: \n
    C. H. Taniguti, L. M. Taniguti, R. R. Amadeu, J. Lau, G. de S. Gesteira, T. de P. Oliveira, G. C. Ferreira, 
    G. da S. Pereira, D. Byrne, M. Mollinari, O. Riera-Lizarazu, A. A. F. Garcia, 
    Developing best practices for genotyping-by-sequencing analysis in the construction of linkage maps, 
    GigaScience, Volume 12, 2023, giad092, https://doi.org/10.1093/gigascience/giad092",
    sep = ""
  )
  
  packageStartupMessage(msg)
}

