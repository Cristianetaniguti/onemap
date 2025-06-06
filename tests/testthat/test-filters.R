context("Filters function")

library(vcfR)

test_that("number of distorted markers",{
  check_dist <- function(example_data, table.h0){
    eval(bquote(data(.(example_data))))
    segre <- eval(bquote(test_segregation(get(.(example_data)), simulate.p.value = T)))
    segre_tab <- print(segre)
    eval(bquote(expect_equal(as.vector(table(segre_tab$H0)), .(table.h0))))
    expect_equal(length(select_segreg(segre, distorted = T, numbers = T)), sum(segre_tab$`p-value` < 0.05/length(segre_tab$Marker)))
    expect_equal(length(select_segreg(segre, distorted = T, threshold = 0.01, numbers = T)), sum(segre_tab$`p-value` < 0.01/length(segre_tab$Marker)))
  }
  
  check_dist("onemap_example_out", c(12,8,8,2))
  check_dist("onemap_example_f2", c(36,30))
  check_dist("onemap_example_bc", c(67))
  check_dist("onemap_example_riself", c(68))
})

test_that("number of bins",{
  check_bins <- function(example_data, n.mar){
    eval(bquote(data(.(example_data))))
    bins <- eval(bquote(find_bins(get(.(example_data)))))
    onemap_bins <- eval(bquote(create_data_bins(input.obj = get(.(example_data)), bins)))
    eval(bquote(expect_equal(check_data(onemap_bins),0)))
    eval(bquote(expect_equal(onemap_bins$n.mar, .(n.mar))))
  }
  check_bins("vcf_example_f2", 24)
  check_bins("vcf_example_out", 23)
  check_bins("vcf_example_bc", 25)
  check_bins("vcf_example_riself",25)
  
  data("vcf_example_out")
  bins <- find_bins(vcf_example_out)
  
  onemap_bins <- create_data_bins(vcf_example_out, bins)
  twopts <- rf_2pts(onemap_bins)
  
  lgs <- group(make_seq(twopts, "all"))
  
  lg1 <- make_seq(lgs,1)
  
  # Test edit_order_onemap - interactive
  # input.obj <- edit_order_onemap(input.seq = lg1)
  # seq_edit <- make_seq(input.obj)
  
  map1 <- map(lg1)
  map2 <- map(make_seq(lgs,4))
  
  # Test save sequences
  maps.list <- list(map1, map2)

  save_onemap_sequences(sequences.list = maps.list, filename = "test.RData")
  save(maps.list, file = "test2.RData")
  
  # Test load sequences
  maps.list.load <- load_onemap_sequences(filename = "test.RData")
  
  # Test plot_genome_vs_cm
  p <- plot_genome_vs_cm(map.list = map1, group.names = "LG2")
  
  # Test summary_maps_onemap
  df <- summary_maps_onemap(map.list = list(map1, map2))
  
  expect_equal(df$map_length[3], 159.7943, 0.1)
  
  ord1 <- ord_by_geno(make_seq(twopts, "all"))
  ord2 <- ord_by_geno(map2)
  
  expect_equal(ord1$seq.num, 1:23)
  expect_equal(ord2$seq.num, 15:23)
  
  # Test add_redundants
  map_red <- add_redundants(sequence = map1, 
                            onemap.obj = vcf_example_out, bins)
  
  expect_equal(length(map_red$seq.num) - length(map1$seq.num), 1) 
})

test_that("number of missing data",{
  check_missing <- function(example_data, n.mar,n.ind){
    eval(bquote(data(.(example_data))))
    onemap_mis <- eval(bquote(filter_missing(get(.(example_data)), 0.5)))
    eval(bquote(expect_equal(check_data(onemap_mis), 0)))
    eval(bquote(expect_equal(onemap_mis$n.mar, .(n.mar))))
    onemap_mis <- eval(bquote(filter_missing(get(.(example_data)), 0.5, by = "individuals")))
    eval(bquote(expect_equal(check_data(onemap_mis), 0)))
    eval(bquote(expect_equal(onemap_mis$n.ind, .(n.ind))))
  }
  check_missing(example_data = "vcf_example_f2", n.mar = 25, n.ind = 191)
  check_missing("onemap_example_riself", 64, 100)
  check_missing("onemap_example_out", 30, 100)
  check_missing("onemap_example_bc", 67,150)
})

test_that("number of repeated ID markers",{
  check_dupli <- function(example_data, n.mar){
    eval(bquote(data(.(example_data))))
    onemap_dupli <- eval(bquote(rm_dupli_mks(get(.(example_data)))))
    eval(bquote(expect_equal(check_data(onemap_dupli), 0)))
    eval(bquote(expect_equal(onemap_dupli$n.mar, .(n.mar))))
  }
  
  check_dupli("vcf_example_f2", 25)
  check_dupli("onemap_example_riself", 68)
  check_dupli("onemap_example_out", 30)
  check_dupli("onemap_example_bc", 67)
  
})

test_that("filter probs",{
  onemap.obj <- onemap_read_vcfR(system.file("extdata/vcf_example_out.vcf.gz", package = "onemap"),
                                 parent1 = "P1", parent2 = "P2", cross = "outcross")
  vcfR.object <- read.vcfR(system.file("extdata/vcf_example_out.vcf.gz", package = "onemap"))
  gq <- extract_depth(vcfR.object = vcfR.object,
                      onemap.object = onemap.obj,
                      vcf.par = "GQ", 
                      parent1 = "P1", 
                      parent2 = "P2")
  onemap.prob <- create_probs(onemap.obj, genotypes_errors = gq)
  onemap.filt <- filter_prob(onemap.prob, threshold = 0.999999999)
  onemap.mis <- filter_missing(onemap.filt, threshold = 0.10)
  expect_equal(onemap.mis$n.mar, 22)
  
  pl <- extract_depth(vcfR.object = vcfR.object,
                      onemap.object = onemap.obj,
                      vcf.par = "PL", 
                      parent1 = "P1", 
                      parent2 = "P2")
  
  onemap.prob <- create_probs(onemap.obj, genotypes_probs = pl)
  onemap.filt <- filter_prob(onemap.prob, threshold = 0.9)
  onemap.mis <- filter_missing(onemap.filt, threshold = 0.10)
  expect_equal(onemap.mis$n.mar, 22)
  
})

