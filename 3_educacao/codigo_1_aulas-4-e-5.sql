-- SELECT FROM WHERE: aprendendo o basico de SQL com a base do Enem 2019

-- e possivel escrever comentarios entre as linhas de codigo.

-- Sequencia de DOIS HIFENS: para escrever um comentario de uma linha.

/*
 BARRA+ASTERISCO Serve para escrever
 um comentario de varias linhas.
 Mas para isso e preciso "fechar" o comando.
 Ao final, use a sequencia ASTERISCO+BARRA.
*/


/* ### SELECT ### */

/*
Uma das funcoes do SQL e a consulta a uma base de dados. 
Em geral, e essa a funcao mais útil para jornalistas.
O comando SELECT e o que da inicio a sua consulta.
Para entender o codigo, pense que voce esta escrevendo uma frase em uma nova lingua.
Uma das tarefas e aprender a ordem em que os elementos da frase devem ser usados, como verbos, substantivos e ate a virgula.
*/

-- Frase 1: "Selecionar tudo da tabela ideb2017"

-- Traducao para o SQL:

SELECT * FROM ideb2017;

/* 
SELECT: Comando para selecionar alguma coisa de algum lugar.
O asterisco * e "a coisa". No caso, ele seleciona todas as colunas (ou variaveis) da sua tabela.
FROM: Comando que vai indicar o lugar de onde voce quer selecionar o seu dado. Nesse caso, nossa tabela ideb2017.
*/

-- Frase 2: "Selecionar apenas as colunas do municipio e do estado das escolas da tabela ideb2017"

-- Nesse caso, preciso saber o nome delas, e lista-las depois do comando, separadas por VIRGULA.

-- Por isso e importante ter sempre o dicionario de variaveis por perto!

-- Traducao para o SQL:

SELECT nome_munic, uf FROM ideb2017;

-- Note que a ordem da sua frase influencia a ordem das colunas na sua tabela nova.

-- Note no exemplo abaixo como o ENTER e a BARRA DE ESPACO nao afetam o codigo (voce so precisa selecionar todas as linhas antes de executar a consulta).

SELECT nome_munic ,
 uf     FROM 
 ideb2017;
 

 
 /*
Note que, se voce digitou tudo direitinho, cada elemento aparece com uma cor diferente:
AZUL: comandos
ROXO: variaveis
VERDE: tabelas
VERMELHO: valores
*/ 

 
 /* ### SELECT DISTINCT ### */

-- O comando SELECT DISTINCT serve para selecionar apenas os valores unicos de uma coluna, sem todas as linhas repetidas.

-- Frase 3: "Selecionar so os valores unicos que aparecem na coluna do estado da tabela ideb2017"

-- Traducao para o SQL:

SELECT DISTINCT uf FROM ideb2017;

-- Se selecionarmos uma segunda coluna, o número de linhas sera o numero de valores possiveis da coluna com mais valores unicos.

-- IMPORTANTE: sempre separar as colunas selecionadas entre virgulas:

SELECT DISTINCT uf, nome_munic FROM ideb2017;


 /* ### CASE ... WHEN ... THEN ... ELSE ... END ### */

/* 
Como os microdados costumam ter valores em codigos (por exemplo, 0 para "Sim" e 1 para "Nao"),
o comando "CASE-WHEN-ELSE" serve para substituir os valores codificados por termos mais faceis de analisar.
*/

/* 
Frase 4: "Selecionar os valores unicos da coluna estado na tabela ideb2017, mas, 
CASO o valor seja RO, ENTAO substitua-o por 'Rondonia';
NOS OUTROS CASOS, substitua os valores por 'nao e Rondonia'."
*/

SELECT  
	CASE
		WHEN uf = 'RO' THEN 'Rondônia'
		ELSE 'nao e Rondônia'
	END 
FROM ideb2017;

-- O END serve para indicar o fim da minha lista de condicoes referentes a essa coluna especifica.

-- Se eu quiser apenas os valores unicos, basta adicionar o "DISTINCT" (sempre imediatamente depois do "SELECT", e sempre sem virgula):

SELECT  DISTINCT
	CASE
		WHEN uf = 'RO' THEN 'Rondônia'
		ELSE 'nao e Rondônia'
	END 
FROM ideb2017;

-- Note que o nome da coluna nao e mais "uf". Mas existe um comando simples para renomear essa e qualquer outra coluna:

 /* ### AS (o "alias") ### */
 
/*
"Alias": termo em ingles que indica uma forma mais usual de se referir a uma mesma pessoa.
Assim como o "CASE-WHEN-ELSE", ele serve como limpeza da base, para facilitar a analise.
No SQL, o comando a ser usado se chama AS.
Ele vai no fim de uma coluna na sua lista de selecoes.
No nosso caso, a unica coluna selecionada termina no END, portanto, colocamos o AS depois disso:
*/

SELECT DISTINCT
	CASE
		WHEN uf = 'RO' THEN 'Rondônia'
		ELSE 'nao e Rondônia'
	END AS Estado
FROM ideb2017;

-- Mas podemos nomear mais colunas se quisermos, apenas devemos lembrar de separar cada uma por virgula...

-- ...mas sem separar com virgula a ultima delas e o FROM!

SELECT DISTINCT
	CASE
		WHEN uf = 'RO' THEN 'Rondônia'
		ELSE 'não é Rondônia'
	END AS Estado,
	nome_munic AS Municipio
FROM ideb2017;

-- DICA! Evite colocar acentos nos nomes das colunas.

-- O nome das colunas nunca pode ter espaco!!

/*
Os comandos acima servem para estabelecer condicoes de:
- selecao de colunas (as variaveis da tabela);
- tratamento dos nomes das colunas ou valores contidos nelas.
*/

/* ### WHERE ### 

A seguir, veremos como funciona o WHERE, um comando importante para FILTRAR de quais linhas estamos falando.
Para isso, vamos agora mexer um pouco na tabela do enem2019.
*/ 

-- Frase 5: "Selecionar as colunas de estado, idade e sexo, mas apenas os dados de candidatos e candidatas do estado do ACRE na tabela enem2019."

-- Traducao para o SQL:

SELECT
	*
FROM enem2019
WHERE SG_UF_NASCIMENTO = 'AC';

/* IMPORTANTE: o WHERE sempre vai apos o FROM, que sempre vai apos o SELECT! 
Pense nos tres como oracoes diferentes numa mesma frase.
Quando voce passa de uma oracao para outra, nunca pode separa-las por virgula.
*/

-- Notou que acrescentamos um elemento novo, o sinal de "igual"? Trata-se de dos chamados "operadores logicos", que usamos para criar nossos filtros:

/*
LISTA DE OPERADORES LOGICOS:
- De comparacao:
	= (igual a)
	<> (diferente de)
	!= (diferente de)
	< (menor que)
	> (maior que)
	<= (menor ou igual a)
	>= (maior ou igual a)
- Logicos:
	AND (uma condicao E outra condicao)
	OR (uma OU outra condicao)
- Intervalo de valores:
	BETWEEN (valores ENTRE x E y)
- Pertencimento a conjuntos:
	IN (contido em tal conjunto)
	NOT IN (nao contido em tal conjunto)
- Buscar em parte do texto:
	LIKE (texto inclui tal trecho)
	NOT LIKE (texto nao inclui tal trecho)
- Nulabilidade:
	IS NULL (celula daquela coluna, naquela linha, nao foi preenchido)
	IS NOT NULL (exclui as linhas com celulas sem preenchimento em uma coluna especifica)
	*/
	
-- Frase 6: "Selecionar as mesmas colunas do Acre que a frase 5, mas filtrando apenas pelos candidatos homens com mais de 50 anos."

-- Traducao para o SQL:

SELECT
	SG_UF_NASCIMENTO,
	NU_IDADE,
	TP_SEXO
FROM enem2019
WHERE 
	SG_UF_NASCIMENTO = 'AC' AND
	TP_SEXO = 'M' AND
	NU_IDADE > 50;

	
-- Frase 7: "Selecionar as mesmas colunas do Acre que a frase 6, mas agora filtrando apenas pelas mulheres com idade entre 18 e 24 anos."

SELECT
	SG_UF_NASCIMENTO,
	NU_IDADE,
	TP_SEXO
FROM enem2019
WHERE 
	SG_UF_NASCIMENTO = 'AC' AND
	TP_SEXO = 'F' AND
	(NU_IDADE BETWEEN 18 AND 24);

	
/* Notou que usamos parenteses no exemplo acima?
Eles serve para evitar que o "AND" do intervalo selecionado pelo comando BETWEEN seja interpretado como uma mudanca de comando.
Para que o programa consiga entender exatamente o que voce quer, e preciso prestar atencao nos detalhes.
Veja em mais um exemplo abaixo:
*/

-- Frase 8: "Selecionar apenas candidatas mulheres no Acre que (tiveram nota de redacao entre 800 e 1000) OU (tiveram nota 0 na redacao)."

-- Traducao para o SQL:

SELECT
	SG_UF_NASCIMENTO,
	NU_IDADE,
	TP_SEXO,
	NU_NOTA_REDACAO
FROM enem2019
WHERE 
	SG_UF_NASCIMENTO = 'AC' AND
	TP_SEXO = 'F' AND
	((NU_NOTA_REDACAO BETWEEN 800 AND 1000) OR
	NU_NOTA_REDACAO = 0);
	
-- Frase 9: "Selecionar apenas candidatas mulheres no Acre que (tiveram nota 1000 na redacao) OU (tiveram nota 0 na redacao)."

-- Traducao para o SQL:
	
SELECT
	SG_UF_NASCIMENTO,
	TP_SEXO,
	NU_NOTA_REDACAO
FROM enem2019
WHERE 
	SG_UF_NASCIMENTO = 'AC' AND
	TP_SEXO = 'F' AND
	(NU_NOTA_REDACAO = 1000 OR
	NU_NOTA_REDACAO = 0);
	
/* Notou que alguns valores sao colocados entre aspas e ficam vermelhos, enquanto outros vao sem aspas e ficam na cor preta?
O motivo e que sao TIPOS DE DADOS diferentes: uns sao TEXT (texto), outros sao INTEGER (números inteiros).
O texto sempre vai entre aspas simples. Os números nao precisam de aspas.
Mas se voce usar texto sem aspas, o codigo da errado, porque o programa espera que valores foram de aspas tenham apenas números, nao letras.
Ja qualquer digito pode ser lido como texto.
*/

-- Teste na query abaixo para enxergar a mensagem de erro:

SELECT
	SG_UF_NASCIMENTO,
	NU_IDADE,
	TP_SEXO
FROM enem2019
WHERE 
	SG_UF_NASCIMENTO = 'AC' AND
	TP_SEXO = 'F' AND
	(NU_IDADE BETWEEN 18 AND 24);

/*ALGUNS TIPOS DE DADOS:
- TEXT: texto (aceita qualquer digito)
- CHAR(n): um campo de texto, mas tem definido um número fixo de caracterers (por exemplo: campo UF, com n = 2)
- VARCHAR(n): um campo de texto com tamanho variavel e que aceita ate um número maximo de caracteres (por exemplo: campo para nome completo)
- INTEGER: número inteiro
- DECIMAL: número com casas decimais
- REAL: tambem representa valores numericos, mas com valores aproximados
- BOOLEAN: traz os valores TRUE (verdadeiro) ou FALSE (falso)
- DATE, TIMESTAMP: dados referentes a data e/ou hora
*/

-- DICA: O DB-Browser costuma ler o tipo de dado de cada coluna, mas e possivel altera-lo manualmente.

/* ### GROUP BY ###*/

/*O comando GROUP BY serve para que voce consiga agrupar os resultados de uma certa coluna para poder observar melhor seus dados.
Para entender a sintaxe dele, e preciso enxergar as variavies que voce lista dentro do comando SELECT pela ordem em que estao dispostas (posicao 1, 2 etc.).*/

/*FUNCOES DE AGRUPAMENTO: sao usadas para contagem ou calculos que consolidam todas as suas linhas em resumos.
- COUNT: e usada para somar a quantidade de linhas em uma tabela ou para contar a soma de valores distintos de uma mesma coluna
- SUM: soma de valores em uma coluna numerica
- MAX: mostra o valor maximo existente em uma coluna numerica
- MIN: mostra o valor minimo existente em uma coluna numerica
- AVG: vem de "average" ("media", em ingles) e calcula a media de todos os valores em uma coluna numerica
*/

-- Frase 10: "Contar quantas linhas tem a base enem2019."

-- Traducao para o SQL:

SELECT count(*) FROM enem2019;

-- Frase 11: "Contar quantos candidatos da base enem2019 sao homens e quantos sao mulheres."

-- Traducao para o SQL:

SELECT
	TP_SEXO, 
	count(*) AS QTDE_PORSEXO
FROM enem2019
GROUP BY TP_SEXO;

-- Frase 12: "Selecionar apenas candidatos e candidatas com nota mil na redacao, e contar quantos sao homens e quantos sao mulheres."

-- Traducao para o SQL:

SELECT TP_SEXO, 
	count(*) AS QTDE_NOTAMIL
FROM enem2019
WHERE NU_NOTA_REDACAO = 1000
GROUP BY TP_SEXO;

/* ### ORDER BY ###*/

/*O comando ORDER BY ordena seus resultados a partir dos valores de uma das colunas.
A ordem crescente (ASC) vem com padrao. Mas podemos alterar para a ordem decrescente ao final do comando a palavra DESC.
*/

-- Frase 13: "Selecionar quem fez o Enem no Acre por idade e sexo e ordena-los da maior pra menor nota na redacao."

-- Traducao para o SQL:

SELECT 
	SG_UF_NASCIMENTO,
	NU_IDADE,
	TP_SEXO,
	NU_NOTA_REDACAO
FROM enem2019
WHERE 
	SG_UF_NASCIMENTO = 'AC'
ORDER BY
	NU_NOTA_REDACAO DESC;

-- Frase 14: "Selecionar quem fez o Enem no Acre por idade e sexo e ordena-los da maior pra menor idade."

-- Traducao para o SQL:

SELECT 
	SG_UF_NASCIMENTO,
	NU_IDADE,
	TP_SEXO,
	NU_NOTA_REDACAO
FROM enem2019
WHERE 
	SG_UF_NASCIMENTO = 'AC'
ORDER BY
	NU_IDADE DESC;

-- Frase 15: "Selecionar quem tirou nota mil na redacao por UF e ordenar pela ordem alfabetica do estado de tras para frente."

-- Traducao para o SQL:

SELECT 
	SG_UF_NASCIMENTO,
	NU_NOTA_REDACAO
FROM enem2019
WHERE NU_NOTA_REDACAO = 1000
ORDER BY SG_UF_NASCIMENTO DESC;

-- Frase 16: "Contar quantas notas mil cada UF teve e ordenar pela UF com o maior número de notas mil."

-- Traducao para o SQL:

SELECT 
	SG_UF_NASCIMENTO,
	COUNT(*) NU_NOTA_REDACAO
FROM enem2019
WHERE NU_NOTA_REDACAO = 1000
GROUP BY SG_UF_NASCIMENTO
ORDER BY NU_NOTA_REDACAO DESC;

-- Por fim, aplicamos o "Alias" para deixar a tabela ainda mais legivel.

SELECT 
	SG_UF_NASCIMENTO AS Estado,
	COUNT(*) AS Notas_mil
FROM enem2019
WHERE NU_NOTA_REDACAO = 1000
GROUP BY 1
ORDER BY 2 DESC;