
# PRA QUE SERVE ESSE CODIGO?
# Nesse exercicio, ele serve para criar uma versao reduzida dos microdados do Enem 2019.
# A base na integra tem mais de 5 milh?es de linhas, mas s? queremos uma parte delas:
# N?s queremos apenas quem se inscreveu no Enem, fez todas as provas e estava no terceiro ano do ensino medio.
# Esse universo representa 1,2 milhao das mais de 5 milh?es de linhas da planilha.
# Com esse filtro, vamos reduzir o arquivo de 3Gb para menos de 1Gb, e usa-lo com mais facilidade.

# COMO RODAR ESSE CODIGO?
# - Selecionar com o mouse as linhas necessarias em cada trecho
# - Clicar em "CTRL+ENTER"
# Esperar at? o programa terminar de rodar (alguns computadores levam mais tempo que outros)


# PASSO 1: Instalar os pacotes necessarios (selecione as DUAS linhas abaixo e clique em CTRL+ENTER)

install.packages("data.table")
install.packages("tidyverse")


# PASSO 2: Carregar os pacotes que acabm de ser instalados (selecione as DUAS linhas abaixo e clique em CTRL+ENTER)

library(data.table)
library(tidyverse)


# PASSO 3: Rodar o codigo que abrir apenas as linhas da tabela que queremos 
# (selecione as SETE linhas abaixo e clique em CTRL+ENTER)
# AGUARDE!!! Dependendo do seu computador, pode demorar poucos ou muitos minutos

enem2019_comfiltro <- 'MICRODADOS_ENEM_2019.csv' %>% 
  fread() %>% 
  filter(TP_PRESENCA_CN == 1,
         TP_PRESENCA_CH == 1,
         TP_PRESENCA_LC == 1,
         TP_PRESENCA_MT == 1,
         TP_ST_CONCLUSAO == 2)


# PASSO 4: Veja como na janela "Environment" um novo objeto foi criado, chamado "enem2019_comfiltro".


# PASSO 5: Grave esse novo objeto em um arquivo .CSV
# selecione a linha abaixo e clique em CTRL+ENTER
# AGUARDE NOVAMENTE!!! A planilha 

write.csv(com_filtro, "enem2019_comfiltro.csv")


# PASSO 6: Abra a pasta onde voce salvou o projeto e veja se encontra a planilha "enem2019_comfiltro.csv".
# Ela deve ter por volta de 900Mb.

# PRONTO! MISS?O CUMPRIDA! :)
# PS: Esse codigo serve para reduzir outras bases grandes. O que vai mudar? O nome do arquivo e os filtros.