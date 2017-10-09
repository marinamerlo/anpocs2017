setwd("D:\\Dropbox\\Mestrado\\ANPOCS 2017\\1998")
#criando uma lista de todos os arquivos contidos na pasta
lista.arquivos <-list.files(file.path(getwd()))
print(lista.arquivos)
#criando uma lista para pegar somente os documentos de votação
lista.resultados <- grep(pattern="votacao_candidato_munzona_1998_", lista.arquivos, value=TRUE)
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

cand1998 <- c("DANTE MARTINS DE OLIVEIRA",
              "LAIRE ROSADO FILHO",
              "FAISAL FARIS MAHMOUD SALMEN HUSSAIN",
              "RUBENS FURLAN",
              "GEORGE MORAIS FERREIRA",
              "JOMAR FERNANDES PEREIRA FILHO",
              "JOAQUIM DOMINGOS RORIZ",
              "RICARDO JOSÉ MAGALHÃES BARROS",
              "ERONILDO BRAGA BEZERRA",
              "VITAL DO REGO FILHO",
              "ANTONIO VITAL DO REGO",
              "VENEZIANO VITAL DO REGO SEGUNDO NETO",
              "NEUDO RIBEIRO CAMPOS",
              "EDVALDO SOARES DE MAGALHAES",
              "ESPERIDIÃO AMIN HELOU FILHO")


votos1998 <- resultados %>%
  filter(str_detect(NOME_CANDIDATO,paste(cand1998, collapse="|")))

write.table(votos1998, "padrinho_votos1998.csv", sep = ";", fileEncoding ="latin1", row.names = F)



