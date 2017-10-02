setwd("C:\\Users\\8516201\\Desktop\\ANPOCS")


library(readr)
library(dplyr)
install.packages("data.table")
library(data.table)
install.packages("tidyverse")
install.packages("modelr")
library(tidyverse)
library(stringr)
install.packages("plyr")
library(plyr)
install.packages("rowr")
library(rowr)

receitas2002 <- fread("2002_Receitas_Cand_DepFed.txt")
receitas2006 <- fread("2006_Receitas_Cand_DepFed.txt")
dados <- fread("anpocs_receitas_2002_2006.csv")
capital <- fread("capitalfamiliar.csv")
votos2002 <- fread("votoscandmun_2002.csv")
votos2006 <- fread("votoscandmun_2006.csv")
votos2010 <- fread("votoscandmun_2010.csv")
receitas2010 <- fread("2010_Receitas_Cand_DepFed.txt")

capital <- capital %>%
  filter(CAPITAL_FAMILIAR ==1 & SEXO == 1) %>%
  select(ELEICAO, NOME, CAPITAL_FAMILIAR)%>%
  rename(NOME_CAND = NOME)

write.table(carreira_politica_2002_2010, "capitalfamiliar.csv", sep = ";", fileEncoding ="latin1", row.names = F)

votos2002 <- votos2002 %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (DESC_SIT_CAND_TOT == "ELEITO"| DESC_SIT_CAND_TOT == "MÉDIA"))

votos2006 <- votos2006 %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (DESC_SIT_CAND_TOT == "ELEITO"| DESC_SIT_CAND_TOT == "MÉDIA"))

votos2010 <- votos2010 %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (DESC_SIT_CAND_TOT == "ELEITO"| DESC_SIT_CAND_TOT == "MÉDIA"))

votos <- rbind(votos2002, votos2006, votos2010)


dados_receitas2002 <- capital %>%
  filter(ELEICAO == 1) %>%
  inner_join(receitas2002, by="NOME_CAND") %>%
  select(-UNIDADE_FEDERACAO_DOADOR)

dados_receitas2006 <- capital %>%
  filter(ELEICAO == 2) %>%
  inner_join(receitas2006, by="NOME_CAND") %>%
  select(-COD_TIPO_RECEITA, -COD_TIPO_RECURSO, -UNIDADE_ELEITORAL_DOADOR, -SITUACAO_CADASTRAL,-CNPJ_CAND, -NUM_PART, -COD_CARGO)


dados_receitas2010 <- capital %>%
  filter(ELEICAO == 3) %>%
  inner_join(receitas2010, by="NOME_CAND") %>%
  mutate(DESC_TIPO_RECURSO = ESPECIE_RECURSO,
         NUM_CPF_CGC_DOADOR = CPF_CNPJ_DOADOR) %>%
  select(-ESPECIE_RECURSO,-CPF_CNPJ_DOADOR) %>%
  select(-CPF_CAND, -DATA_HORA, -ENTREGA_CONJ, -FONTE_RECURSO,-DESC_RECEITA, -NUM_RECIBO_ELEITORAL, -NUM_DOC)

receitas_2002_2006_2010 <- rbind.fill(dados_receitas2002, dados_receitas2006, dados_receitas2010)
write.table(receitas_2002_2006_2010, "receitas.csv", sep = ";", fileEncoding ="latin1", row.names = F)


candidatas <- receitas_2002_2006_2010 %>%
  select(NOME_CAND, SEQ_CAND, SIGLA_UF, NUM_CAND) %>%
  distinct() %>%
  mutate(NOME_)

full <- full_join(candidatas, capital, by = "NOME_CAND") %>%
  distinct()

nomes <- receitas_2002_2006_2010 %>%
  select(NOME_CAND)%>%
  distinct()%>%
  arrange(desc(NOME_CAND))

nomes2 <- capital %>%
  select(NOME_CAND)%>%
  distinct()%>%
  arrange(desc(NOME_CAND))

nomes3 <-cbind.fill(nomes, nomes2)

