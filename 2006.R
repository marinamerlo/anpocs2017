setwd("D:\\Dropbox\\Mestrado\\ANPOCS 2017\\2006")
#criando uma lista de todos os arquivos contidos na pasta
lista.arquivos <-list.files(file.path(getwd()))
print(lista.arquivos)
#criando uma lista para pegar somente os documentos de votação
lista.resultados <- grep(pattern="votacao_candidato_munzona_2006_", lista.arquivos, value=TRUE)
print(lista.resultados)

#criando o dataframe vazio que receberá os dados
resultados <- data.frame()

#Loop para coletar os dados que queremos:
#vai abrir cada uma das listas, renomear as colunas de acordo com o indicado no arquivo LEIAME.
#incluir no dataframe vazio
for(arquivo in lista.resultados){
  d <- fread(file.path(getwd(), arquivo), stringsAsFactors = F, encoding = "Latin-1", header = F)
  resultados <-bind_rows(resultados, d)
}

names(resultados) <- c("DATA_GERACAO",
                       "HORA_GERACAO",
                       "ANO_ELEICAO",
                       "NUM_TURNO",
                       "DESCRICAO_ELEICAO",
                       "SIGLA_UF",
                       "SIGLA_UE",
                       "CODIGO_MUNICIPIO",
                       "NOME_MUNICIPIO",
                       "NUMERO_ZONA",
                       "CODIGO_CARGO",
                       "NUMERO_CAND",
                       "SQ_CANDIDATO",
                       "NOME_CANDIDATO",
                       "NOME_URNA_CANDIDATO",
                       "DESCRICAO_CARGO",
                       "COD_SIT_CAND_SUPERIOR",
                       "DESC_SIT_CAND_SUPERIOR",
                       "CODIGO_SIT_CANDIDATO",
                       "DESC_SIT_CANDIDATO",
                       "CODIGO_SIT_CAND_TOT",
                       "DESC_SIT_CAND_TOT",
                       "NUMERO_PARTIDO",
                       "IGLA_PARTIDO",
                       "NOME_PARTIDO",
                       "SEQUENCIAL_LEGENDA",
                       "NOME_COLIGACAO",
                       "COMPOSICAO_LEGENDA",
                       "TOTAL_VOTOS")
resultados %>%
  filter(SIGLA_UF == "PB") %>%
  filter(str_detect(NOME_CANDIDATO,"ANTONIO"))


cand2006 <- c("JOAQUIM DOMINGOS RORIZ",
              "VALDIR RAUPP DE MATOS",
              "JOSÉ CAMILO ZITO DOS SANTOS FILHO",
              "WILSON LEITE BRAGA",
              "ERONILDO BRAGA BEZERRA",
              "VITAL DO REGO FILHO",
              "ANTONIO VITAL DO RÊGO",
              "SÉRGIO IVAN MORAES",
              "NEUDO RIBEIRO CAMPOS",
              "NEWTON CARDOSO",
              "ANTONIO SERGIO ALVES VIDIGAL")

votos2006 <- resultados %>%
  filter(str_detect(NOME_CANDIDATO,paste(cand2006, collapse="|")))

table(votos2006$NOME_CANDIDATO)

write.table(votos2006, "padrinho_votos2006.csv", sep = ";", fileEncoding ="latin1", row.names = F)
