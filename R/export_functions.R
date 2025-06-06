#' Export OneMap maps to be visualized in VIEWpoly
#' 
#' @param seqs.list a list with `sequence` objects
#' 
#' @return object of class viewmap
#' 
#' @export
export_viewpoly <- function(seqs.list){
  if(!(inherits(seqs.list,c("list", "sequence")))) stop(deparse(substitute(seqs.list))," is not an object of class 'list' or 'sequence'")
  
  ph.p1 <- ph.p2 <- maps <- d.p1 <- d.p2 <- list()
  for(i in 1:length(seqs.list)){
    
    # only for biallelic markers
    types <- seqs.list[[i]]$data.name$segr.type[seqs.list[[i]]$seq.num]
    if(inherits(seqs.list[[i]]$data.name, "outcross")){
      labs.out <- c("A.1" = 1,
                    "A.2" = 2,
                    "A.3" = 3,
                    "A.4" = 4,
                    "B1.5" = 5,
                    "B1.6" = 6,
                    "B3.7"=7,
                    "C.8" = 8,
                    "D1.9" = 9,
                    "D1.10" = 10,
                    "D1.11" = 11,
                    "D1.12" = 12,
                    "D1.13" = 13,
                    "D2.14" = 14,
                    "D2.15" = 15,
                    "D2.16" = 16,
                    "D2.17" = 17,
                    "D2.18" = 18)
      d.p1[[i]] <- labs.out[match(types, names(labs.out))]
      d.p2[[i]] <- labs.out[match(types, names(labs.out))]
    } else if(inherits(seqs.list[[i]]$data.name, "intercross")){
      labs <- c("A.H.B" = 1,
                "C.A" = 2,
                "D.B" = 3)
      d.p1[[i]] <- labs[match(types, names(labs))]
      d.p2[[i]] <- labs[match(types, names(labs))]
    } else if(inherits(seqs.list[[i]]$data.name, "backcross")){
      labs <- c("A.H" = 1)
      d.p1[[i]] <- labs[match(types, names(labs))]
      labs <- c("A.H" = 0)
      d.p2[[i]] <- labs[match(types, names(labs))]
    } else if(inherits(seqs.list[[i]]$data.name, "ri")){
      labs <- c("A.B" = 1)
      d.p1[[i]] <- labs[match(types, names(labs))]
      labs <- c("A.B" = 2)
      d.p2[[i]] <- labs[match(types, names(labs))]
    }
    
    parents <- parents_haplotypes(seqs.list[[i]])
    ph.p1[[i]] <- parents[,c(5,6)]
    ph.p2[[i]] <- parents[,c(7,8)]
    rownames(ph.p1[[i]]) <- rownames(ph.p2[[i]]) <- colnames(seqs.list[[i]]$data.name$geno)[seqs.list[[i]]$seq.num]
    names(ph.p1[[i]]) <- c("a", "b")
    names(ph.p2[[i]]) <- c("c", "d")
    
    chr <- seqs.list[[i]]$data.name$CHROM[seqs.list[[i]]$seq.num]
    pos <- seqs.list[[i]]$data.name$POS[seqs.list[[i]]$seq.num]
    
    maps[[i]] <- data.frame(mk.names = colnames(seqs.list[[i]]$data.name$geno)[seqs.list[[i]]$seq.num],
                            l.dist = c(0,cumsum(kosambi(seqs.list[[i]]$seq.rf))),
                            g.chr = if(is.null(chr)) rep(NA, length(seqs.list[[i]]$seq.num)) else chr,
                            g.dist = if(is.null(pos)) rep(NA, length(seqs.list[[i]]$seq.num)) else pos,
                            alt = rep(NA, length(seqs.list[[i]]$seq.num)),
                            ref = rep(NA, length(seqs.list[[i]]$seq.num)))  
  }
  
  structure(list(d.p1 = d.p1,
                 d.p2 = d.p2,
                 ph.p1 = ph.p1,
                 ph.p2= ph.p2,
                 maps = maps,
                 software = "onemap"),
            class = "viewmap")
}

#' Export genotype probabilities in MAPpoly format (input for QTLpoly)
#' 
#' @param input.map object of class `sequence`
#' 
#' @return object of class `mappoly.genoprob`
#' 
#' @export
export_mappoly_genoprob <- function(input.map){
  if(!(inherits(input.map,c("sequence")))) stop(deparse(substitute(seqs.list))," is not an object of class 'sequence'")
  
  probs <- cbind(ind = rep(1:input.map$data.name$n.ind, each = length(input.map$seq.num)),
                 marker = rep(colnames(input.map$data.name$geno)[input.map$seq.num], input.map$data.name$n.ind),
                 pos = c(0,cumsum(kosambi(input.map$seq.rf))),
                 as.data.frame(t(input.map$probs)))
  
  if(inherits(input.map$data.name, "outcross") | inherits(input.map$data.name, "f2")){
    phase <- list('1' = c(1,2,3,4),
                  '2' = c(2,1,4,3),
                  '3' = c(3,4,1,2),
                  "4" = c(4,3,2,1))
    
    seq.phase <- rep(c(1,input.map$seq.phases), input.map$data.name$n.ind)
    
    # Adjusting phases
    for(i in 1:length(seq.phase))
      probs[i,4:7] <- probs[i,phase[[seq.phase[i]]]+3]
  }
  
  colnames(probs)[4:7] <- c("a:c", "a:d", "b:c", "b:d")
  
  genoprob <- array(unlist(t(probs[,4:7])), 
                    dim = c(4, length(input.map$seq.num), input.map$data.name$n.ind),
                    dimnames = list(c("a:c", "a:d", "b:c", "b:d"),
                                    colnames(input.map$data.name$geno)[input.map$seq.num],
                                    rownames(input.map$data.name$geno)))
  
  map <- cumsum(c(0,kosambi(input.map$seq.rf)))
  names(map) <- colnames(input.map$data.name$geno)[input.map$seq.num]
  structure(list(probs = genoprob,
                 map = map), 
            class = "mappoly.genoprob")
}

#' Save a list of onemap sequence objects
#' 
#' The onemap sequence object contains everything users need to reproduce the complete analysis:
#' the input onemap object, the rf_2pts result, and the sequence genetic distance and marker order.
#' Therefore, a list of sequences is the only object users need to save to be able to recover all analysis.
#' But simple saving the list of sequences will save many redundant objects. This redundancy is only considered by R
#' when saving the object. For example, one input object and the rf_2pts result will be saved for every sequence. 
#' 
#'@param sequences.list list of \code{sequence} objects
#'
#'@param filename name of the output file (Ex: my_beautiful_map.RData)
#'
#'@export 
save_onemap_sequences <- function(sequences.list, filename){
  if(!(inherits(sequences.list,c("list", "sequence")))) stop(deparse(substitute(sequences.list))," is not an object of class 'list' or 'sequence'")
  
  ## if sequences.list is just a single chormosome, convert it  into a list
  if(inherits(sequences.list,"sequence")) sequences.list<-list(sequences.list)
  
  onemap.obj <- sequences.list[[1]]$data.name
  twopts <- sequences.list[[1]]$twopt
  
  sequences.list[[1]]$data.name <- NULL
  sequences.list[[1]]$twopt <- NULL
  
  for(i in 2:length(sequences.list)){
    if(!all(onemap.obj$segr.type == sequences.list[[i]]$data.name$segr.type)) stop("Not all sequences come from the same onemap object.")
    if(!all(twopts$n.mar == sequences.list[[i]]$twopt$n.mar)) stop("Not all sequences come from the same twopts object.")
    sequences.list[[i]]$data.name <- NULL
    sequences.list[[i]]$twopt <- NULL
  }
  
  new.list<- list(onemap.obj =onemap.obj, twopts = twopts, sequences.list = sequences.list)
  
  save(new.list, file = filename)
}

#' Load list of sequences saved by save_onemap_sequences
#' 
#' @param filename name of the file to be loaded
#'
#'@export
load_onemap_sequences <- function(filename){
  temp <- load(filename)
  map.list <- get(temp)
  
  if(is.null(names(map.list)) | !all(names(map.list) == c("onemap.obj", "twopts", "sequences.list"))) 
    stop("This file was not saved with save_onemap_sequences.")
  
  sequences.list <- map.list$sequences.list
  for(i in 1:length(sequences.list)){
    sequences.list[[i]]$data.name <- map.list$onemap.obj
    sequences.list[[i]]$twopt <- map.list$twopts
  }
  return(sequences.list)
}


