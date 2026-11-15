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
  mutate(dt = as.POSIXct(paste(format(date, "%Y-%m-%d"), vru_exit),
                         format = "%Y-%m-%d %H:%M:%S", tz = "UTC")) %>%
  arrange(dt) %>%
  mutate(
    arrival_time = as.numeric(difftime(dt, lag(dt), units = "secs")),
    arrival_time = if_else(date != lag(date), NA_real_, arrival_time)
  )

## Fazer uma estratificação dos tempos





## Contruir o tempo de fila com base no dado padrão.

