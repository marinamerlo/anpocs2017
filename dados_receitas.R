setwd("C:\\Users\\d841255\\Desktop\\ANPOCS")

library(readr)
library(dplyr)
library(data.table)
library(tidyverse)
library(stringr)
library(plyr)

receitas2002 <- fread("2002_Receitas_Cand_DepFed.txt")
receitas2006 <- fread("2006_Receitas_Cand_DepFed.txt")

carreira_politica_2002_2010 <- carreira_politica_2002_2010 %>%
  filter(CAPITAL_FAMILIAR ==1 & SEXO == 1) %>%
  select(ELEICAO, NOME, CAPITAL_FAMILIAR)%>%
  rename(NOME_CAND = NOME)
         
write.table(carreira_politica_2002_2010, "capitalfamiliar.csv", sep = ";", fileEncoding ="latin1", row.names = F)


dados2002 <- carreira_politica_2002_2010 %>%
  filter(ELEICAO == 1) %>%
  inner_join(receitas2002, by="NOME_CAND")

dados2006 <- carreira_politica_2002_2010 %>%
  filter(ELEICAO == 2) %>%
  inner_join(receitas2006, by="NOME_CAND")

dados <- rbind.fill(dados2002, dados2006)
