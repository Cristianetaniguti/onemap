% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_haplotypes.R
\name{progeny_haplotypes}
\alias{progeny_haplotypes}
\title{Generate data.frame with genotypes estimated by HMM and its probabilities}
\usage{
progeny_haplotypes(..., ind = 1, group_names = NULL, most_likely = FALSE)
}
\arguments{
\item{...}{Map(s) or list(s) of maps. Object(s) of class sequence.}

\item{ind}{vector with individual index to be evaluated or "all" to include all individuals}

\item{group_names}{Names of the groups.}

\item{most_likely}{logical; if  \code{TRUE}, the most likely genotype receive 1 and all the rest 0. 
If there are more than one most likely both receive 0.5.
if FALSE (default) the genotype probability is plotted.}
}
\value{
a data.frame information: individual (ind) and group (grp) ID, position in centimorgan (pos), 
group (grp), genotypes probabilities (prob), parent (homologs), and the parents homologs (homologs) 
in that homolog and position.
}
\description{
Generate data.frame with genotypes estimated by HMM and its probabilities
}
\author{
Getulio Caixeta Ferreira, \email{getulio.caifer@gmail.com}

Cristiane Taniguti, \email{chtaniguti@usp.br}
}
