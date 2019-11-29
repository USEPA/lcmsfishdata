library(RSQLite)
library(LUMA)

if(!file.exists("data-raw/Peaklist_Neg")) {
  download.file(
    "https://raw.githubusercontent.com/jmosl01/lcmsfishdata/master/data-raw/Peaklist_Neg",
    "data-raw/Peaklist_Neg"
  )
}

peak_db <- connect_peakdb(file.base = "Peaklist_Neg",
                          db.dir = "data-raw")

mynames <- RSQLite::dbListTables(peak_db)
mynames <- mynames[-grep("sqlite",mynames)]


Peaklist_Neg <- lapply(mynames, function(x) read_tbl(x, peak.db = peak_db))
temp <- gsub(" ", "_", mynames)
names(Peaklist_Neg) <- temp
devtools::use_data(Peaklist_Neg, compress = "xz", overwrite = T)

dbDisconnect(peak_db)