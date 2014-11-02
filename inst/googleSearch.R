# TODO: Add comment
# 
# Author: mario
###############################################################################

library(tm.plugin.webmining)
library(RSelenium)
library(XML)

RSelenium::checkForServer()
RSelenium::startServer() # if needed
remDr <- remoteDriver(browserName = "safari")


remDr$open()
url.name = feedquery("https://www.google.com/search", params = list(q = "test"))
remDr$navigate(url.name)

pagesource <- remDr$getPageSource()[[1]]

tree <- htmlTreeParse(pagesource, asText = TRUE, useInternalNodes = TRUE, trim=TRUE)
elem <- xpathSApply(tree, path = "//div[contains(@class,'rc')]")[-1]

headers <- unlist(sapply(elem, getNodeSet, ".//h3/a", fun = xmlValue))
link <- sapply(sapply(elem, getNodeSet, ".//h3/a", fun = xmlAttrs), function(x) x["href"])
names(link) <- NULL
link <- gsub("[\\/\"]+", "", link)
description <- unlist(sapply(elem, getNodeSet, ".//span[contains(@class,'st')]", fun = xmlValue))

