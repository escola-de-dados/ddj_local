###################################################################################################################
///////////////////Criar tabela com codigo de RS/////////////////////

COMENTÁRIO: "Função "CREATE TABLE  - > é o comando para criação da tabela e deve ser seguida 
pelo nome que daremos à tabela", nesse caso a nova tabela se charamá "curso"
No código abixo estamos criando uma nova tabela a partir das tabelas caso_full, mun_regiao através do comando "FROM" 
As colunas selecionadas consideram o nome_da_tabela"."nome_da_coluna
O comando "WHERE" faz a junção das duas tabelas considerando as colunas caso_full.city_ibge_code = mun_regiao.Cod_IBGE
Esta coluna e o "=" fará o relacionamento entre as duas tabelas"

CREATE TABLE curso as
SELECT
caso_full.city_ibge_code,
caso_full.new_deaths, caso_full.last_available_deaths, 
caso_full.last_available_death_rate, 
caso_full.new_confirmed, caso_full.last_available_confirmed_per_100k_inhabitants,
caso_full.estimated_population_2019,
caso_full.date, caso_full.epidemiological_week,
caso_full.state, caso_full.city,
mun_regiao.Cod_IBGE, mun_regiao.cod_RS, mun_regiao.nome_RS, mun_regiao.pop_regiao
FROM caso_full, mun_regiao
WHERE caso_full.city_ibge_code = mun_regiao.Cod_IBGE;



#################################################################################################################
COMENTÁRIO: "No codigo acima estamos criando três tabelas distintas txmunc, txregc, txufc 
é selecionado a coluna "date" que fará o relacionamento entre as tabelas posteriormente.
A função "sum" soma os casos de covid segundo unidade de análise e divide( / ) essa some pela população
da população na unidade de analise correspondente. A função "CAST" converte o dado de população em "FLOAT"
formato de numero que permite o cálulo.
Na função "WHERE" e apontada a unidade de análise correspondente. Nesse caso:
Cod_IBGE = 3304557 esse código corresponde ao municipio do Rio de Janeiro
cod_RS = 33005 esse codigo corresponde a Regiõ de Saúde onde o municipio se encontra
Cod_IBGE = 33 esse codigo corresponde ao estado do RJ"


//////////////////////////////////COMPARAÇÃO DAS TAXAS DE CASOS/////////////////////////////////////////////////

CREATE TABLE txmunc as
select date, 
sum(new_confirmed)/CAST(estimated_population_2019 as FLOAT)*1000000 as taxa_por_municipio
from curso 
WHERE Cod_IBGE = 3304557 group by date;

CREATE TABLE txregc as
select date, 
sum(new_confirmed)/CAST(pop_regiao as FLOAT)*1000000 as taxa_por_região
from curso 
WHERE cod_RS = 33005 group by date;

CREATE TABLE txufc as
select date, 
sum(new_confirmed)/CAST(estimated_population_2019 as FLOAT)*1000000 as taxa_por_estado
from curso 
WHERE Cod_IBGE = 33 group by date;

##################################################################################################################

COMENTÁRIO: "A função "INNER JOIN" permite usar um operador de comparação para comparar os valores 
de colunas provenientes de tabelas associadas. Por meio desta cláusula, os registros de duas tabelas 
são usados para que sejam gerados os dados relacionados de ambas.
Na nossa função o "INNER JOIN" está unificando as tres tabelas criadas: txmunc, txregc, txufc considerando a coluna "date"
e a função "ORDER by" organiza os resultados de acordo com uma ou mais colunas da tabela. No nosso caso a data"


CREATE TABLE txmmcasos as
SELECT * FROM txufc
INNER JOIN txregc ON txregc.date = txufc.date
INNER JOIN txmunc ON txmunc.date = txufc.date
ORDER by date;


########################################################################################################
//////////////////////////////COMPARAÇÃO DAS TAXAS DE ÓBITOS////////////////////////////////////////////


COMENTÁRIO: "O mesmo procedimento será realizado abaixo para os óbitos por covid"

CREATE TABLE txmuno as
select date, 
sum(new_deaths)/CAST(estimated_population_2019 as FLOAT)*1000000 as taxa_por_municipio
from curso 
WHERE Cod_IBGE = 3304557 group by date;

CREATE TABLE txrego as
select date, 
sum(new_deaths)/CAST(pop_regiao as FLOAT)*1000000 as taxa_por_região
from curso 
WHERE cod_RS = 33005 group by date;

CREATE TABLE txufo as
select date, 
sum(new_deaths)/CAST(estimated_population_2019 as FLOAT)*1000000 as taxa_por_estado
from curso 
WHERE Cod_IBGE = 33 group by date;

CREATE TABLE txmmobito as
SELECT * FROM txufo
INNER JOIN txrego ON txrego.date = txufo.date
INNER JOIN txmuno ON txmuno.date = txufo.date
ORDER by date;

##############################################################################################################
/////////////////////////////////////Média móvel taxa casos///////////////////////////////////////////////////

COMENTÁRIO: "Com base na tabela anterior será criada a média movel para taxa que permite a comparação entre áreas.
Para isso, vamos criar uma nova tabela para taxa de casos desta vez suavizada pela média móvel de 7 dias.
A tabela criada se chamará  "MMtxcasom" para municipio, "MMtxcasor" para região e "MMtxcasoe" para estado.
A função "AVG" retorna a média dos valores de uma coluna numérica, a função "OVER" determina o particionamento 
e a ordenação de um conjunto de linhas antes que a função associada seja aplicada, nesse caso "AVG". O conjunto de 
linhas utilizados considera a "ORDER BY date" (ou seja, ordenando por data), segundo o valor observado e as 
6 linhas anteriores."

CREATE TABLE MMtxcasom as
select date, 
AVG(taxa_por_municipio) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND 0 FOLLOWING) AS "7-Day Moving Average municipio"
from txmmcasos 
group by date;

CREATE TABLE MMtxcasor as
select date, 
AVG(taxa_por_região) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND 0 FOLLOWING) AS "7-Day Moving Average região"
from txmmcasos 
group by date;

CREATE TABLE MMtxcasoe as
select date, 
AVG(taxa_por_estado) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND 0 FOLLOWING) AS "7-Day Moving Average estado"
from txmmcasos 
group by date;


###################################################################################################################
COMENTÁRIO: "Novamente utilizamos a função "INNER JOIN" para unificar as tabelas criadas: MMtxcasom, MMtxcasor, MMtxcasoe
considerando a coluna "date" e a função "ORDER by" organiza os resultados de acordo com uma ou mais colunas da tabela.
Todas as tres tabelas são adicionadas a tabela "MMtxcaso3""

CREATE TABLE MMtxcaso3 as
SELECT * FROM MMtxcasoe
INNER JOIN MMtxcasor ON MMtxcasor.date = MMtxcasoe.date
INNER JOIN MMtxcasom ON MMtxcasom.date = MMtxcasoe.date
ORDER by date;


##################################################################################################################
/////////////////////////////////////Média móvel taxa município óbitos////////////////////////////////////////////

COMENTÁRIO: "O mesmo procedimento será realizado abaixo para os óbitos por covid"

CREATE TABLE MMtxobtm as
select date, 
AVG(taxa_por_municipio) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND 0 FOLLOWING) AS "7-Day Moving Average municipio"
from txmmobito 
group by date;

CREATE TABLE MMtxobtr as
select date, 
AVG(taxa_por_região) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND 0 FOLLOWING) AS "7-Day Moving Average região"
from txmmobito 
group by date;

CREATE TABLE MMtxobte as
select date, 
AVG(taxa_por_estado) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND 0 FOLLOWING) AS "7-Day Moving Average estado"
from txmmobito 
group by date;


CREATE TABLE MMtxobt3 as
SELECT * FROM MMtxobte
INNER JOIN MMtxobtr ON MMtxobtr.date = MMtxobte.date
INNER JOIN MMtxobtm ON MMtxobtm.date = MMtxobte.date
ORDER by date;





