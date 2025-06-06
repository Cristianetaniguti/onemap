#######################################################################
#                                                                     #
# Package: onemap                                                     #
#                                                                     #
# File: find_bins.R                                                   #
# Contains: find_bins, print.onemap_bin                               #
#                                                                     #
# Written by Marcelo Mollinari                                        #
# copyright (c) 2015, Marcelo Mollinari                               #
#                                                                     #
# First version: 08/27/2015                                           #
# License: GNU General Public License version 3                       #
#                                                                     #
#######################################################################

##'  Allocate markers into bins
##'
##' Function to allocate markers with redundant information into bins.
##' Within each bin, the pairwise recombination fraction between markers is zero.
##'
##' @aliases find_bins
##' @param input.obj an object of class \code{onemap}.
##' @param exact logical. If \code{TRUE}, it only allocates markers with
##' the exact same information into bins, including missing data; if
##' \code{FALSE}, missing data are not considered when allocating markers.
##' In the latter case, the marker with the lowest amount of missing data is
##' taken as the representative marker on that bin.
##' @return An object of class \code{onemap_bin}, which is a list containing the
##' following components: \item{bins}{a list containing the bins. Each element of
##' the list is a table whose lines indicate the name of the marker, the bin in
##' which that particular marker was allocated and the percentage of missing data.
##' The name of each element of the list corresponds to the marker with the lower
##' amount of missing data among those on the bin}\item{n.mar}{total number of markers.}
##' \item{n.ind}{number individuals} \item{exact.search}{logical; indicates if
##' the search was performed with the argument \code{exact=TRUE} or \code{exact=FALSE}}
##' @author Marcelo Mollinari, \email{mmollina@@usp.br}
##' @seealso \code{\link[onemap]{create_data_bins}}
##' @keywords bins dimension reduction
##' @examples
##' \donttest{
##'   data("vcf_example_out")
##'   (bins<-find_bins(vcf_example_out, exact=FALSE))
##' }
##' 
##' 
##' @import dplyr
##' @import tidyr
##' 
##'@export
find_bins <- function(input.obj, exact=TRUE)
{
  ## checking for correct object
  if(!inherits(input.obj,"onemap"))
    stop(deparse(substitute(input.obj))," is not an object of class 'onemap'")
  
  if (input.obj$n.mar<2) stop("there must be at least two markers to proceed with analysis")
  
  if(exact){
    temp_geno <- as.data.frame(t(input.obj$geno))
    temp <- temp_geno %>% group_by_all() %>% dplyr::mutate(label = cur_group_id())
    bin <- temp$label
    mis<-apply(input.obj$geno,2, function(x) 100*sum(x==0)/length(x))
    dtf<-data.frame(bin, mis)
    # Recover initial ordering
    dtf_temp <- split.data.frame(dtf, dtf$bin)
    dtf_temp <- dtf_temp[match(unique(bin), names(dtf_temp))]
    for(i in 1:length(dtf_temp))
      dtf_temp[[i]]$bin <- i
    names(dtf_temp) <- NULL
    dtf <- do.call(rbind, dtf_temp)
  } else {
    bin<-get_bins(input.obj$geno, exact)
    mis<-apply(input.obj$geno,2, function(x) 100*sum(x==0)/length(x))
    dtf<-data.frame(bin, mis)
  }

  w<-by(dtf, dtf$bin, function(x) x)
  names(w)<-sapply(w, function(x) rownames(x)[which.min(x$mis)])
  structure(list(bins=w,info=list(n.ind=input.obj$n.ind, n.mar=input.obj$n.mar, exact.search=exact)), class="onemap_bin")
}

##' print method for object class 'onemap_bin'
##' 
##' @param x object of class \code{onemap_bin}
##' @param ... currently ignored
##' 
##' @return No return value, called for side effects
##' 
##' @export
##' @method print onemap_bin
print.onemap_bin<-function (x, ...) {
  ##printing brief summary of the data
  cat("This is an object of class 'onemap_bin'\n")
  cat("    No. individuals:                        ", x$info$n.ind, "\n")
  cat("    No. markers in original dataset:        ", x$info$n.mar, "\n")
  cat("    No. of bins found:                      ", length(x$bins), "\n")
  cat("    Average of markers per bin:             ", mean(sapply(x$bins, nrow)), "\n")
  if(x$info$exact.search)
  {
    cat("    Type of search performed:                exact\n")
  }
  else
    cat("    Type of search performed:                non exact\n\n")
}
## end of file


