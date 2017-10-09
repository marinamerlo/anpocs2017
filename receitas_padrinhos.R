padrinho <- c("IRIS REZENDE MACHADO",
              "ELOI ALFREDO PIETA",
              "FRANCISCO GARCIA RODRIGUES",
              "ERONILDO BRAGA BEZERRA",
              "FRANCISCO FLAMARION PORTELA",
              "EDISON LOBAO",
              "SERGIO IVAN MORAES",
              "CIRO NOGUEIRA LIMA FILHO",
              "JOAO ALBERTO RODRIGUES CAPIBERIBE",
              "NEUDO RIBEIRO CAMPOS",
              "ROMERO JUCA FILHO",
              "DANTE MARTINS DE OLIVEIRA",
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
              "ESPERIDIÃO AMIN HELOU FILHO",
              "REGINALDO DE ALMEIDA",
              "TARSO FERNANDO HERZ GENRO",
              "LAIRE ROSADO FILHO",
              "JOAQUIM DOMINGOS RORIZ",
              "RICARDO JOSÉ MAGALHÃES BARROS",
              "MIGUEL ARRAES DE ALENCAR",
              "VALDIR RAUPP DE MATOS",
              "JADER FONTENELLE BARBALHO",
              "GERSON CAMATA",
              "ERONILDO BRAGA BEZERRA",
              "VITAL DO REGO FILHO",
              "ANTONIO VITAL DO REGO",
              "VENEZIANO VITAL DO REGO SEGUNDO NETO",
              "NEUDO RIBEIRO CAMPOS",
              "EDVALDO SOARES DE MAGALHAES",
              "NEWTON CARDOSO",
              "JOAQUIM DOMINGOS RORIZ",
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

padrinho <- unique(tolower(stri_trans_general(padrinho, "Latin-ASCII")))

receitas2002 <- fread("C:/Users/d841255/Desktop/ANPOCS/2002_Receitas_Cand_Brasil.txt")
receitas2006 <- fread("C:/Users/d841255/Desktop/ANPOCS/2006_Receitas_Cand_Brasil.txt")
receitas2010 <- fread("C:/Users/d841255/Desktop/ANPOCS/2010_Receitas_Candidatos_Brasil.txt")


receitas2002pad <- receitas2002 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CAND, "Latin-ASCII"))) %>% 
  filter(str_detect(NOME_CAND,paste(padrinho, collapse="|")))%>%
  select(-UNIDADE_FEDERACAO_DOADOR)

receitas2006pad <- receitas2006 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CAND, "Latin-ASCII"))) %>% 
  filter(str_detect(NOME_CAND,paste(padrinho, collapse="|"))) %>%
  select(-COD_TIPO_RECEITA, -COD_TIPO_RECURSO, -UNIDADE_ELEITORAL_DOADOR, -SITUACAO_CADASTRAL,-CNPJ_CAND, -NUM_PART, -COD_CARGO)

receitas2010pad <- receitas2010 %>%
  mutate(NOME_CAND = tolower(stri_trans_general(NOME_CAND, "Latin-ASCII"))) %>% 
  filter(str_detect(NOME_CAND,paste(padrinho, collapse="|"))) %>%
  mutate(DESC_TIPO_RECURSO = ESPECIE_RECURSO,
         NUM_CPF_CGC_DOADOR = CPF_CNPJ_DOADOR) %>%
  select(-ESPECIE_RECURSO,-CPF_CNPJ_DOADOR) %>%
  select(-CPF_CAND, -DATA_HORA, -ENTREGA_CONJ, -FONTE_RECURSO,-DESC_RECEITA, -NUM_RECIBO_ELEITORAL, -NUM_DOC)

receitas_2002_2006_2010 <- rbind.fill(receitas2002pad, receitas2006pad, receitas2010pad)
write.table(receitas_2002_2006_2010, "receitas_pad.csv", sep = ";", fileEncoding ="latin1", row.names = F)
