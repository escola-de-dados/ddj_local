-- O COMANDO JOIN

/*
O comando JOIN (do verbo 'juntar') serve para o cruzamento de duas tabelas.
Exemplo: digamos que tenho uma tabela A com as colunas 'codigo_municipio', 'escola' e 'ideb' e 10 mil linhas com escolas brasileiras.
Mas quero acrescentar uma coluna com o nome do municipio.
Para isso, posso buscar outra tabela B com as colunas 'codigo_municipio', 'nome_municipio' e 'uf'.
O JOIN é o comando que me permite criar a minha tabela C juntando as colunas que me interessam das outras duas tabelas.
*/

/*
A SINTAXE DO JOIN:
ONDE COLOCAR NA QUERY?
O JOIN vai sempre depois do FROM e antes do WHERE (se for preciso usar o WHERE).
Pense nele como um complemento do FROM. 
Como o FROM pede sempre uma tabela, e agora queremos usar DUAS tabelas, o JOIN nos ajuda a completar a frase.
*/

/*
EXERCICIO: calculando 'um' Enem por Escola
Para praticar o JOIN, vamos usar as bases do Enem, do Censo Escolar e uma tabela de apoio do IBGE.
Juntando as 3 tabelas, vamos montar nossa propria tabela com as notas medias de cada escola.
Basta seguir o passo a passo com os codigos e comentarios abaixo.
*/

-- Mas antes, CINCO avisos importantes:

/*
AVISO IMPORTANTE 1: Nao existe uma lista oficial de notas do Enem por Escola.
O Inep deixou de fazer o calculo em 2015 alegando que dois motivos:
1- Que a imprensa e as escolas estavam criando 'rankings' indevidamente;
2- Que a Prova Brasil passou a ser censitaria para o ensino medio, ou seja, haveria outro indicador para avaliar as notas.
*/

/*
AVISO IMPORTANTE 2: O Enem nao e uma prova censitaria (que todos os alunos fazem).
Por isso, o publico que faz o Enem nao representa o universo de estudantes concluindo o ensino medio.
As escolas estaduais, por exemplo, possuem menos alunos que fazem o Enem ou tentam entrar na faculdade.
Por isso, elas costumam ser subrepresentadas na base do Enem.
*/

/*
AVISO IMPORTANTE 3: Essa nota em geral nao conta toda a historia do percuso de cada estudante.
Por isso, o Inep criou outros indicadores que podem e devem ser usados para dar mais contexto aos resultados.
Alguns indicadores do Inep:
NSE (Nivel Socioeconomico da escola): divide as escolas em sete niveis, segundo o perfil socioeconomico das familias dos estudantes matriculados.
Indicador de Formacao Adequada de Docentes: divide as escolas de acordo com a formacao de quem da as aulas nelas
Indicador Permanencia Escola: mostra se a escola ensinou aqueles alunos durante todo o ensino medio, ou se so entraram no ultimo ano.
Sao tentativas de dosar melhor a que se deve um resultado alto ou baixo, para evitar rankings distorcidos.
*/

/*
AVISO IMPORTANTE 4: Outro problema esta no fato de que nem todos os candidatos e candidatas preenchem a inscricao corretamente.
O Inep consegue resolver esse problema cruzando dados pessoais dessas pessoas (CPF) e consultando as proprias escolas.
Mas nas bases publicas nao temos como reduzir essa limitacao.
*/

/*
AVISO IMPORTANTE 5: Dito tudo isso, podemos avaliar a nota media das escolas no Enem seguindo alguns criterios.
No nosso exercicio, vamos seguir as regras aplicadas pelo Inep em 2015, ultimo ano em que foi feito o calculo.
Regras para a escola ter a nota do Enem calculada:
Regra 1: A escola precisa ter pelo menos 10 estudantes matriculados no ultimo ano do ensino medio.
Regra 2: Ela precisa que pelo menos 50% desses estudantes participem das provas.
Regra 3: Nao vamos calcular uma unica nota por escola, mas uma nota media para cada prova.
Isso vai dar mais insights pra ver qual escola vai melhor em humanas, em matematica, em redacao etc.
*/


-- PASSO 1. Preparando a base do Censo Escolar 2019.

-- 1.1. TABELA ESCOLAS: Na base das ESCOLAS, nossa query vai pedir o codigo, o nome e o estado da escola, alem da rede administrativa.

-- Alem disso, ela vai filtrar apenas as escolas ATIVAS em 2019:

SELECT 
	CO_ENTIDADE AS CO_ESCOLA, 
	NO_ENTIDADE, 
	CO_UF, 
	TP_DEPENDENCIA
FROM ESCOLAS
WHERE TP_SITUACAO_FUNCIONAMENTO = 1;

-- O resultado deve ter 182.468 linhas.

-- Vamos SALVAR o resultado dessa query como uma VISTA, que serve como se fosse uma nova tabela dentro do nosso banco de dados.

-- O nome da vista vai ser "escolas_ativas".

-- 1.2. TABELA TURMAS: Agora, vamos descobrir, na base das TURMAS, a quantidade de matriculas das escolas.

-- Porem, vamos filtrar apenas pelas turmas do terceiro ou quarto ano do ensino medio regular (incluindo o tecnico).

SELECT 
	CO_ENTIDADE AS CO_ESCOLA, 
	QT_MATRICULAS
FROM TURMAS
WHERE
	(TP_ETAPA_ENSINO BETWEEN 27 AND 28) OR
	(TP_ETAPA_ENSINO BETWEEN 32 AND 33) OR
	(TP_ETAPA_ENSINO BETWEEN 37 AND 38);

-- O resultado da query acima deve ter 75.561 linhas.

-- Vamos SALVAR uma vista com o nome "matriculas".

-- 1.3. Vamos entao JUNTAR essas duas tabelas/vistas em uma terceira tabela.

/*
JOIN - COMO COMEÇAR:
A primeira coisa a saber e que precisamos de pelo menos uma CHAVE por onde fazer essa uniao.
A chave nada mais e do que uma ou mais colunas em comum nas duas tabelas.
Elas nao precisam ter o mesmo numero de linhas, o que importa e ter uma coluna com os mesmos valores.
No nosso caso, essa coluna se chama "CO_ESCOLA" em ambas as tabelas.
*/

/*
TIPOS DE JOIN:
Esse e um bom momento para entender as varias maneiras de juntar duas tabelas.
Lembra da teoria dos conjuntos aprendida na escola? Trata-se da mesma coisa:
INNER JOIN: Pra ser usado quando eu quero que minha tabela C contenha apenas as linhas que existem nas duas tabelas.
LEFT JOIN: Quando eu quero manter toda a minha tabela A, e pegar da tabela B apenas os elementos de uma coluna que coincidam.
RIGHT JOIN: Quando eu quero manter toda a minha tabela B, e pegar da tabela A apenas os elementos de uma coluna que coincidam.
FULL OUTER JOIN: Quando eu quero juntar a integra das duas tabelas.

/*
QUAL JOIN ESCOLHER?
No nosso caso, temos duas tabelas:
A tabela "escolas_ativas" tem 182.468 linhas com todas as escolas com o codigo e o nome, estado e rede, independentemente do nivel de ensino.
A tabela "matriculas" tem 75.561 linhas com o codigo e a quantidade de matriculas das escolas, mas so das escolas que entram no nosso criterio.
Como as demais escolas nao me interessam, vou escolher o INNER JOIN.
Isso porque ele descarta as linhas que nao coincidem em ambas as tabelas.
*/

-- Exemplo com INNER JOIN: 
	
SELECT
	A.CO_ESCOLA,
	A.NO_ENTIDADE,
	A.CO_UF,
	A.TP_DEPENDENCIA,
	B.CO_ESCOLA,
	B.QT_MATRICULAS
FROM escolas_ativas A INNER JOIN matriculas B
	ON A.CO_ESCOLA = B.CO_ESCOLA
GROUP BY A.CO_ESCOLA;

-- Nosso resultado vai ser uma tabela com 27.347 linhas, já afunilando para pegarmos as escolas que preencham nossos requisitos.

-- Salve esse resultado como uma VISTA de nome "escolas_ensinomedio".

/*
Notou a COMPOSIÇÃO DO JOIN? Ela aparecem em tres momentos:
1) No nivel do SELECT
Como sempre, no SELECT eu escolho quais colunas eu quero.
Mas, nesse caso, como tenho duas colunas, eu renomeio os nomes das colunas indicando a referencia que vou usar para cada tabela.
Assim, o sistema vai buscar a coluna que quero na tabela que quero.
No nosso exemplo, seguimos nomenando a primeira tabela como A, e a segunda como B.
2) No nivel do FROM
Apos o SELECT, eu determino as tabelas a serem usadas com FROM [tabela1] A INNER JOIN] [tabela2] B.
Nesse caso, as letras A e B ja indicam 
3) Chave de uniao
Alem de determinar o tipo de uniao a ser feita, com o complemento ON eu indico qual COLUNA usarei como CHAVE.
*/

-- Vamos testar agora outro exemplo, mudando apenas do INNER JOIN para o LEFT JOIN:

SELECT
	A.CO_ESCOLA,
	A.NO_ENTIDADE,
	A.CO_UF,
	A.TP_DEPENDENCIA,
	B.CO_ESCOLA,
	B.QT_MATRICULAS
FROM escolas_ativas A LEFT JOIN matriculas B
	ON A.CO_ESCOLA = B.CO_ESCOLA
GROUP BY A.CO_ESCOLA;

-- O resultado da query acima é uma tabela com 182.468 (mesmo numero de linhas da tabela com mais linhas que usei).

-- Na consulta acima, alem das escolas de que preciso, tenho dezenas de milhares de outras que nao servem pra minha analise.

-- Por isso, nao vou salvar vista desse resultado, porque ele tem pouca utilidade.

-- PASSO 2: Preparando a base do IBGE: 

/*
Agora tenho outro problema para resolver: as duas bases do Censo Escolar apenas trazem o CODIGO do estado.
Mas eu quero o NOME de cada estado.
Para isso, vou usar uma terceira tabela, do IBGE, que tem a chave que eu quero (codigo do estado) e o nome correspondente.
Com a query abaixo eu pego apenas os valores unicos de cada codigo do estado, com o respectivo nome do estado:
*/

SELECT DISTINCT
	UF,
	Nome_UF
FROM IBGE_ESTADOS;

-- O resultado tem as 27 linhas esperadas, entao basta salva-lo em uma VISTA chamada "nomes_estados".

-- PASSO 3: Hora de unir a tabela "escolas_ensinomedio" (A) com a tabela "nomes_estados" (B).

-- Novamente, vamos de INNER JOIN:

SELECT
	A.CO_ESCOLA,
	A.NO_ENTIDADE,
	A.CO_UF,
	A.TP_DEPENDENCIA,
	A.QT_MATRICULAS,
	B.UF,
	B.Nome_UF
FROM escolas_ensinomedio A INNER JOIN nomes_estados B
	ON A.CO_UF = B.UF;

-- Salve a VISTA como "escolas2019".

-- Note que nosso resultado segue com 27.347. Isso quer dizer que todas as linhas da tabela A tinha correspondencia na tabela B.

-- Podemos testar qual seria o resultado caso queiramos fazer um LEFT JOIN:

SELECT
	A.CO_ESCOLA,
	A.NO_ENTIDADE,
	A.CO_UF,
	A.TP_DEPENDENCIA,
	A.QT_MATRICULAS,
	B.UF,
	B.Nome_UF
FROM escolas_ensinomedio A INNER JOIN nomes_estados B
	ON A.CO_UF = B.UF;

-- Veja que, nesse caso, a query resultou nas mesmas 27.437 linhas, justamente por 100% das linhas coincidem nas duas tabelas.

-- Nao precisa salvar essa vista.

-- PASSO 4: Preparando a base do Enem 2019.

-- Já temos a tabela "escolas2019" pronta pra indicar a quantidade de matriculas de alunos concluintes do ensino medio de cada escola.

-- Agora precisamos de uma tabela onde cada linha representa uma escola, e as colunas contenham a nota media da escola em cada prova.

-- 4.1. Filtrar só por candidatos e candidatas que sao concluintes do ensino medio e que fizeram todas as provas.

-- OBS: No caso da nossa base, ela ja foi reduzida para conter exatamente esses alunos, mas faremos a query mesmo assim.

-- OBS 2: Quem estiver usando a base "completa" precisa NECESSARIAMENTE fazer a mesma query:

SELECT
	*
FROM enem2019
WHERE 
TP_ST_CONCLUSAO = 2 AND
TP_PRESENCA_CH = 1 AND 
TP_PRESENCA_CN = 1 AND
TP_PRESENCA_LC = 1 AND
TP_PRESENCA_MT = 1 AND 
TP_STATUS_REDACAO = 1;

-- O resultado deve ter 1.217.156 linhas (estudantes). Salve essa VISTA como "concluintes2019".

/*
4.2. Nesta etapa cumpriremos uma tarefa dupla:
1) Transformar as linhas de estudantes em linhas de escola usando o GROUP BY;
2) Calcular a MEDIA da nota de cada escola em cada prova.
*/

-- Como vimos na aula passada, podemos fazer calculos usando operadores logicos.

-- Isso e possivel mesmo dentro do SELECT.

-- Rode o codigo abaixo e, em seguida, vejas as explicacoes detalhadas sobre ele:

SELECT
	CO_ESCOLA,
	COUNT(*) AS QT_PARTICIPANTES,
	CAST(AVG(NU_NOTA_CH) AS INTEGER) AS MEDIA_HUMANAS,
	CAST(AVG(NU_NOTA_CN) AS INTEGER) AS MEDIA_NATUREZA,
	CAST(AVG(NU_NOTA_LC) AS INTEGER) AS MEDIA_LINGUAGENS,
	CAST(AVG(NU_NOTA_MT) AS INTEGER) AS MEDIA_MATEMATICA,
	CAST(AVG(NU_NOTA_REDACAO) AS INTEGER) AS MEDIA_REDACAO
FROM concluintes2019
GROUP BY CO_ESCOLA;

-- Essa query (ou consulta) retornou 29.613 linhas. Salve a VISTA como "medias2019".

/*
OPERADORES LOGICOS NO SELECT:
No codigo acima, vemos que nao apenas selecionamos colunas, mas tambem determinamos calculos sobre elas.
A primeira linha e simples, pede apenas a variavel "CO_ESCOLA": em cada linha, vai aparecer uma vez o nome da escola.
Na segunda linha, queremos criar uma coluna no nosso resultado chamada "QT_PARTICIPANTES".
Nela, cada linha vai representar o seguinte valor: a soma de participantes do Enem que estudam em cada escola.
Ja nas colunas seguintes, teremos a nota média dos participantes do Enem de cada escola, e em cada prova.
Pra que a visualizacao seja por escola, preciso incluir no fim o comando GROUP_BY, escolhendo a variavel/coluna que quero agrupar ("CO_ESCOLA").
*/


-- PASSO 5: Juntando as duas bases.

/*
Agora temos duas tabelas:
Uma tabela com a media de cada escola e a quantidade de participantes no Enem 2019 (medias2019, ou tabela "A");
Uma tabela com a quantidade de matriculas da escola no Censo Escolar 2019 (escolas2019, ou tabela "B").
Vamos entao unir as duas e ver o resultado.
*/


-- 5.1. INNER JOIN: Juntar as duas tabelas mostrando APENAS as escolas que aparecem em ambas:

SELECT
	A.CO_ESCOLA,
	A.QT_PARTICIPANTES,
	A.MEDIA_HUMANAS,
	A.MEDIA_NATUREZA,
	A.MEDIA_LINGUAGENS,
	A.MEDIA_MATEMATICA,
	A.MEDIA_REDACAO,
	B.CO_ESCOLA,
	B.NO_ENTIDADE AS NOME_ESCOLA,
	B.Nome_UF AS ESTADO,
	B.TP_DEPENDENCIA AS REDE_ESCOLA,
	B.QT_MATRICULAS
FROM medias2019 A INNER JOIN escolas2019 B
	ON A.CO_ESCOLA = B.CO_ESCOLA;

-- Notem acima que separei as colunas de cada tabela.

-- Mas agora quero fazer uma nova ordem na minha tabela final.

-- 5.2. Fazer o mesmo comando acima, mas reordenando as colunas pela ordem em que quero que sejam vistas:

SELECT
	B.Nome_UF AS ESTADO,
	B.NO_ENTIDADE AS NOME_ESCOLA,
	A.CO_ESCOLA,
	B.TP_DEPENDENCIA AS REDE_ESCOLA,
	A.QT_PARTICIPANTES,
	B.QT_MATRICULAS,
	A.MEDIA_HUMANAS,
	A.MEDIA_NATUREZA,
	A.MEDIA_LINGUAGENS,
	A.MEDIA_MATEMATICA,
	A.MEDIA_REDACAO
FROM medias2019 A INNER JOIN escolas2019 B
	ON A.CO_ESCOLA = B.CO_ESCOLA;

-- 5.3. A regra do Inep recomenda deixar de fora do calculo todas as escolas em que poucos estudantes fizeram o Enem.

-- Por isso vou rodar o mesmo comando, mas criar uma coluna calculando a porcentagem de estudantes que fizeram o Enem.

-- Notem abaixo que, para isso, usamos o comando CASE-WHEN-ELSE e, dentro dos valores, incluimos uma regra de tres simples.

/*
POSSIBILIDADES DE RESULTADO:
1- Se o resultado for menos de 50% (ou seja, menos da metade),
eu concluo que a escola nao teve participacao suficiente pra ter a nota calculada ("Baixa participacao").
2- Se o resultado for acima de 100%, vou considerar que os dados da escola nas duas bases sao discrepantes,
por isso tambem as deixarei de fora, ja que nao tenho acesso ao CPF dos alunos para desvendar o problema ("Dados discrepantes").
3- Se tivermos qualquer outro resultado (ou seja, nem abaixo de 50% nem acima de 100%),
eu considero que a escola teve mais da metade dos alunos matriculados realizando o Enem ("Alta participacao").
Por isso, no fim do codigo incluo um filtro (WHERE) para mostrar so as escolas com "Alta participacao".
*/
	
SELECT
	B.Nome_UF AS ESTADO,
	B.NO_ENTIDADE AS NOME_ESCOLA,
	A.CO_ESCOLA,
	B.TP_DEPENDENCIA AS REDE_ESCOLA,
	A.QT_PARTICIPANTES,
	B.QT_MATRICULAS,
	CASE
		WHEN (QT_PARTICIPANTES * 100) / QT_MATRICULAS < 50 THEN 'Baixa participação'
		WHEN (QT_PARTICIPANTES * 100) / QT_MATRICULAS > 100 THEN 'Dados discrepantes'
		ELSE 'Alta participação'
	END AS PARTICIPACAO,
	A.MEDIA_HUMANAS,
	A.MEDIA_NATUREZA,
	A.MEDIA_LINGUAGENS,
	A.MEDIA_MATEMATICA,
	A.MEDIA_REDACAO
FROM medias2019 A INNER JOIN escolas2019 B
	ON A.CO_ESCOLA = B.CO_ESCOLA
WHERE PARTICIPACAO = 'Alta participação';

-- 5.4. A regra do Inep ainda diz que apenas as escolas com mais de DEZ matriculas devem ser consideradas.

-- Isso impede distorcoes para incluir escolas pequenas e que selecionam os melhores estudantes: uma comparacao injusta.

/*
Para fazer isso, vamos usar o mesmo codigo acima, mas acrescentar mais uma condicao no filtro:
Agora, quero que aparecam as escolas que cumprem todas essas condicoes E
que tambem tenham PELO MENOS 10 matriculas no Censo Escolar 2019.
*/

-- Para isso, acrescento mais um filtro na linha do WHERE.

-- Tambem vou aproveitar e, com uma linha extra, incluir o comando ORDER BY (...) DESC para ver a escola com media mais alta na redacao:

SELECT
	B.Nome_UF AS ESTADO,
	B.NO_ENTIDADE AS NOME_ESCOLA,
	A.CO_ESCOLA,
	B.TP_DEPENDENCIA AS REDE_ESCOLA,
	A.QT_PARTICIPANTES,
	B.QT_MATRICULAS,
	CASE
		WHEN (QT_PARTICIPANTES * 100) / QT_MATRICULAS < 50 THEN 'Baixa participação'
		WHEN (QT_PARTICIPANTES * 100) / QT_MATRICULAS > 100 THEN 'Dados discrepantes'
		ELSE 'Alta participação'
	END AS PARTICIPACAO,
	A.MEDIA_HUMANAS,
	A.MEDIA_NATUREZA,
	A.MEDIA_LINGUAGENS,
	A.MEDIA_MATEMATICA,
	A.MEDIA_REDACAO
FROM medias2019 A INNER JOIN escolas2019 B
	ON A.CO_ESCOLA = B.CO_ESCOLA
WHERE PARTICIPACAO = 'Alta participação' AND QT_MATRICULAS >= 10
ORDER BY MEDIA_REDACAO;

/*
5.5. Antes de exportar a tabela final, quero facilitar o trabalho de ver
se a escola é federal, estadual, municipal ou privada.
Dentro do SELECT, vou usar mais uma vez o CASE-WHEN-ELSE:
*/


SELECT
	B.Nome_UF AS ESTADO,
	B.NO_ENTIDADE AS NOME_ESCOLA,
	A.CO_ESCOLA,
	CASE
		WHEN B.TP_DEPENDENCIA = 1 THEN 'Federal'
		WHEN B.TP_DEPENDENCIA = 2 THEN 'Estadual'
		WHEN B.TP_DEPENDENCIA = 3 THEN 'Municipal'
		WHEN B.TP_DEPENDENCIA = 4 THEN 'Privada'
		ELSE 'Não especificada'
	END AS REDE_ESCOLA,
	A.QT_PARTICIPANTES,
	B.QT_MATRICULAS
	CASE
		WHEN (QT_PARTICIPANTES * 100) / QT_MATRICULAS < 50 THEN 'Baixa participação'
		WHEN (QT_PARTICIPANTES * 100) / QT_MATRICULAS > 100 THEN 'Dados discrepantes'
		ELSE 'Alta participação'
	END AS PARTICIPACAO,
	A.MEDIA_HUMANAS,
	A.MEDIA_NATUREZA,
	A.MEDIA_LINGUAGENS,
	A.MEDIA_MATEMATICA,
	A.MEDIA_REDACAO
FROM medias2019 A INNER JOIN escolas2019 B
	ON A.CO_ESCOLA = B.CO_ESCOLA
WHERE PARTICIPACAO = 'Alta participação'
ORDER BY MEDIA_REDACAO DESC;

-- Salve a VISTA como enem_por_escola_2019.

-- Pronto! Temos a media em cada prova do Enem 2019 das escolas que se encaixam nos nosso criterios de analise.

-- Agora basta exportar a tabela para um arquivo .CSV

-- e escolher como produzir uma reportagem a partir desses dados.