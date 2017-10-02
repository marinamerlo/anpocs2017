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
library(stringr)
library(stringi)
library(readxl)

capital <- fread("capitalfamiliar.csv")
receitas2002 <- fread("2002_Receitas_Cand_DepFed.txt")
receitas2006 <- fread("2006_Receitas_Cand_DepFed.txt")
receitas2010 <- fread("2010_Receitas_Cand_DepFed.txt")
votos2002 <- fread("votoscandmun_2002.csv")
votos2006 <- fread("votoscandmun_2006.csv")
votos2010 <- fread("votoscandmun_2010.csv")
cand2002 <- read_excel("2002_cand.xlsx")
cand2006 <- read_excel("2006_cand.xlsx")
cand2010 <- read_excel("2010_cand.xlsx")

capital <- capital %>%
  filter(CAPITAL_FAMILIAR ==1 & SEXO == 1) %>%
  select(ELEICAO, NOME, CAPITAL_FAMILIAR)

write.table(carreira_politica_2002_2010, "capitalfamiliar.csv", sep = ";", fileEncoding ="latin1", row.names = F)

votos2002 <- votos2002 %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (DESC_SIT_CAND_TOT == "ELEITO"| DESC_SIT_CAND_TOT == "MÉDIA")) %>%
  mutate(NUM_CAND = NUMERO_CAND) %>%
  select(-NUMERO_CAND)

votos2006 <- votos2006 %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (DESC_SIT_CAND_TOT == "ELEITO"| DESC_SIT_CAND_TOT == "MÉDIA")) %>%
  mutate(NUM_CAND = NUMERO_CAND) %>%
  select(-NUMERO_CAND)

votos2010 <- votos2010 %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (DESC_SIT_CAND_TOT == "ELEITO"| DESC_SIT_CAND_TOT == "MÉDIA")) %>%
  mutate(NUM_CAND = NUMERO_CAND) %>%
  select(-NUMERO_CAND)

votos <- rbind(votos2002, votos2006, votos2010)
write.table(votos, "votos.csv", sep = ";", fileEncoding ="latin1", row.names = F)


receitas2002 <- receitas2002 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CAND, "Latin-ASCII")))


receitas2006 <- receitas2006 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CAND, "Latin-ASCII")))

receitas2010 <- receitas2010 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CAND, "Latin-ASCII")))

table(cand2002$DESC_SIT_TOT_TURNO, cand2002$COD_SIT_TOT_TURNO)

cand2002 <- cand2002 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CANDIDATO, "Latin-ASCII"))) %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (COD_SIT_TOT_TURNO == "1"| COD_SIT_TOT_TURNO == "5") & DESCRICAO_SEXO == "FEMININO") %>%
  mutate(NUM_CAND = NUMERO_CANDIDATO) %>%
  select(-NUMERO_CANDIDATO)

cand2006 <- cand2006 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CANDIDATO, "Latin-ASCII"))) %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (COD_SIT_TOT_TURNO == "1"| COD_SIT_TOT_TURNO == "5") & DESCRICAO_SEXO == "FEMININO") %>%
mutate(NUM_CAND = NUMERO_CANDIDATO) %>%
  select(-NUMERO_CANDIDATO)

cand2010 <- cand2010 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CANDIDATO, "Latin-ASCII"))) %>%
  filter(DESCRICAO_CARGO == "DEPUTADO FEDERAL" & (COD_SIT_TOT_TURNO == "1"| COD_SIT_TOT_TURNO == "5") & DESCRICAO_SEXO == "FEMININO") %>%
  mutate(NUM_CAND = NUMERO_CANDIDATO) %>%
  select(-NUMERO_CANDIDATO)

capital <- capital %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CAND, "Latin-ASCII")))

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


nome_numer <- receitas_2002_2006_2010 %>%
  select(NOME_CAND, NUM_CAND, SIGLA_UF, ELEICAO) %>%
  distinct()


dados_cand2002 <- nome_numer %>%
  filter(ELEICAO == 1) %>%
  inner_join(cand2002, by="NOME_CAND")

dados_cand2002 <- dados_cand2002 %>%
  mutate(NUM_CAND = NUM_CAND.x,
         SIGLA_UF = SIGLA_UF.x) %>%
  select(-SIGLA_UF.x, - SIGLA_UF.y, -NUM_CAND.x, - NUM_CAND.y) %>%
  inner_join(votos2002, by= "NUM_CAND", "SIGLA_UF")


dados_cand2006 <- nome_numer %>%
  filter(ELEICAO == 2) %>%
  inner_join(cand2006, by="NOME_CAND")

dados_cand2006 <- dados_cand2006 %>%
  mutate(NUM_CAND = NUM_CAND.x,
         SIGLA_UF = SIGLA_UF.x) %>%
  select(-SIGLA_UF.x, - SIGLA_UF.y, -NUM_CAND.x, - NUM_CAND.y) %>%
  inner_join(votos2006, by= "NUM_CAND", "SIGLA_UF")

dados_cand2010 <- nome_numer %>%
  filter(ELEICAO == 3) %>%
  inner_join(cand2010, by="NOME_CAND")

dados_cand2010 <- dados_cand2010 %>%
  mutate(NUM_CAND = NUM_CAND.x,
         SIGLA_UF = SIGLA_UF.x) %>%
  select(-SIGLA_UF.x, - SIGLA_UF.y, -NUM_CAND.x, - NUM_CAND.y) %>%
  inner_join(votos2010, by= "NUM_CAND", "SIGLA_UF")

cand_votos_2002_2006_2010 <- rbind.fill(dados_cand2002, dados_cand2006, dados_cand2010)

glimpse(cand_votos_2002_2006_2010)

cand_votos_2002_2006_2010 <- cand_votos_2002_2006_2010 %>%
  select(-ANO_ELEICAO.x, -NUM_TURNO.x, -SIGLA_UE.x, -DESCRICAO_CARGO.x, -COMPOSICAO_LEGENDA.x,
         -SIGLA_UF.x, -V1, -HORA_GERACAO, -DATA_GERACAO) %>%
  dplyr::rename(ANO_ELEICAO = ANO_ELEICAO.y,
                NUM_TURNO = NUM_TURNO.y,
                SIGLA_UF = SIGLA_UF.y,
                SIGLA_UE = SIGLA_UE.y,
                DESCRICAO_CARGO = DESCRICAO_CARGO.y,
                COMPOSICAO_LEGENDA = COMPOSICAO_LEGENDA.y)

write.table(cand_votos_2002_2006_2010, "votos.csv", sep = ";", fileEncoding ="latin1", row.names = F) 
