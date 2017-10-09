chave <- fread("chave.csv")

chave <- chave %>%
  mutate(NOME_CANDIDATO = tolower(stri_trans_general(NOME_CANDIDATO, "Latin-ASCII")))

cand_votos_mun_1994_2006 <- rbind(votos1994, votos1998, votos2002, votos2006)

cand_votos_mun_1994_2006 <- cand_votos_mun_1994_2006 %>%
  mutate(NOME_CANDIDATO = tolower(stri_trans_general(NOME_CANDIDATO, "Latin-ASCII"))) %>%
  dplyr::rename(NOME_PAD = NOME_CANDIDATO)

dados_pad <- cand_votos_mun_1994_2006 %>%
  select(NOME_CANDIDATO, DESCRICAO_ELEICAO) %>%
  distinct() %>%
  dplyr::rename(ELEICAO_PAD = DESCRICAO_ELEICAO)

chave2 <- left_join(chave, dados_pad)


dados <- fread("cand_votos_mun_2002-2010_anpocs2017.csv")

dados <- dados %>%
  select(NOME_CAND, DESCRICAO_ELEICAO) %>%
  distinct() %>%
  dplyr::rename(NOME_APAD = NOME_CAND,
                ELEICAO_APAD = DESCRICAO_ELEICAO)

chave3 <- left_join(chave2,dados)

chave3 <- chave3 %>%
  select(NOME_APAD, NOME_CANDIDATO, ELEICAO_PAD, ELEICAO_APAD) %>%
  distinct() %>%
  dplyr::rename(NOME_PAD = NOME_CANDIDATO)

write.table(cand_votos_mun_1994_2006, "cand_votos_mun_1994_2006_pad.csv", sep = ";", fileEncoding ="latin1", row.names = F)
write.table(chave3, "chave_pad_apad.csv", sep = ";", fileEncoding ="latin1", row.names = F)


pares <- chave3 %>%
  select(NOME_APAD, NOME_PAD) %>%
  distinct()
