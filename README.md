# TCC_VictorJ
Trabalho de conclusão de especialização do discente Victor Jakitsch, intitulado (...)

Dados utilizados disponíveis em https://seelab.net.technion.ac.il/data/

#PACOTES NECESSÁRIOS
library(psych)
library(ggplot2)
library(tidyverse)
library(modelsummary)

#CONTRUÇÃO DO DATA FRAME

pasta <- "C:/Users/victo/OneDrive/UFMG/Especialização/Disciplinas/04Monografia/ProjetoR/TCC_VictorJ/AnonymousBank"

files <- list.files(path = pasta, pattern = "\\.txt$", full.names = TRUE)

lista <- lapply(files, function(f) {
  dat <- read.csv(f, header = TRUE, sep = "\t", na.strings = "",
                  colClasses = "character")
  dat$file <- tools::file_path_sans_ext(basename(f))
  dat
})

ANO_DF <- do.call(rbind, lista)

ANO_DF$date <- as.Date(ANO_DF$date, format = "%y%m%d")
ANO_DF$mes  <- format(ANO_DF$date, "%m")

## ETL

calls_day <- as.data.frame(table(ANO_DF$date), stringsAsFactors = FALSE)


#Refazendo a análise

datasummary_skim(ANO_DF)

table(ANO_DF$date)


colSums(is.na(ANO_DF))

ANO_DF_mes <- ANO_DF[is.na(ANO_DF$mes), ]
ANO_DF_mes


#PLOTS



ggplot(ANO_DF, aes(x = mes, group = 1)) +
  geom_line(stat = "count") +
  labs(x = "Mês", y = "# Chamadas", title = "Chamadas por mês") +
  theme_minimal()

