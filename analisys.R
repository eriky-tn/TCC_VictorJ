#PACOTES NECESSÁRIOS
library(psych)
library(ggplot2)
library(tidyverse)
library(modelsummary)
library(hms)

#CONSTRUÇÃO DO DATA FRAME

pasta <- "C:/Users/victo/OneDrive/UFMG/Especialização/Disciplinas/04Monografia/ProjetoR/TCC_VictorJ/AnonymousBank"

files <- list.files(path = pasta, pattern = "\\.txt$", full.names = TRUE)

lista <- lapply(files, function(f) {
  dat <- read.csv(f, header = TRUE, sep = "\t", na.strings = "")
  #dat$file <- tools::file_path_sans_ext(basename(f))
  dat
})

ANO_DF <- do.call(rbind, lista)

## Remover as colunas sem relevancia

ANO_DF_filter <- subset(ANO_DF, select = -c(vru.line, priority, customer_id, priority, type, vru_entry, vru_time, q_start, q_exit, ser_start, ser_exit))


## 1. Arrumar as datas

ANO_DF_filter$date <- as.Date(as.character(ANO_DF_filter$date), format = "%y%m%d")

ANO_DF_filter$vru_exit <- as_hms(ANO_DF_filter$vru_exit)

## Remover os HANGUP e demandas fora do horário de tabalho (verificar documentação)

ANO_DF_filter <- ANO_DF_filter %>% filter(outcome != "HANG" & outcome != "PHANTOM")

## Calcular o tempo entre chegadas.

ANO_DF_filter <- ANO_DF_filter %>%
  group_by(date) %>%
  mutate(arrival_time = vru_exit - lag(vru_exit, default = first(vru_exit)))

## Fazer uma estratificação dos tempos


## Contruir o tempo de fila com base no dado padrão.

