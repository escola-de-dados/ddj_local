/*Desafio Módulo 3

Faça uma query na base do Enem (enem2019) que te retorne o número de participantes concluintes do ensino médio e presentes nas quatro provas objetivas do exame, segundo a cor/raça declarada na inscrição, que tiveram nota acima de 800 na prova de matemática. Qual é o número de participantes de cada cor/raça com nota acima de 800 em matemática?*/

-- (Dica 1: use o dicionário de variáveis para descobrir a correspondência entre os códigos numéricos e a cor/raça.)

-- (Dica 2: se você está usando a base reduzida que baixou no drive, todos os participantes são concluintes do ensino médio e estiveram presentes nas quatro provas objetivas. Se você baixou a base completa diretamente do site do Inep, vai precisar aplicar filtros nessas variáveis!)

-- Abaixo seguem três alternativas para chegar ao mesmo resultado:

-- 1) Resposta simples:

SELECT
	TP_COR_RACA,
	count(*) NU_NOTA_MT
FROM enem2019
WHERE NU_NOTA_MT > 800
GROUP BY TP_COR_RACA



-- 2) Resposta com a correspondência da cor/raça:

SELECT 
CASE 
WHEN TP_COR_RACA = 0 THEN 'Nao declarado'
	WHEN TP_COR_RACA = 1 THEN 'Branca'
	WHEN TP_COR_RACA = 2 THEN 'Preta'
	WHEN TP_COR_RACA = 3 THEN 'Parda'
	WHEN TP_COR_RACA = 4 THEN 'Amarela'
	WHEN TP_COR_RACA = 5 THEN 'Indígena'
END AS COR, count(*)
FROM enem2019
WHERE NU_NOTA_MT > 800
GROUP BY 1



-- 3) Resposta para quem usou a base completa:

SELECT CASE WHEN TP_COR_RACA = 0 THEN 'Nao declarado'
	WHEN TP_COR_RACA = 1 THEN 'Branca'
	WHEN TP_COR_RACA = 2 THEN 'Preta'
	WHEN TP_COR_RACA = 3 THEN 'Parda'
	WHEN TP_COR_RACA = 4 THEN 'Amarela'
	WHEN TP_COR_RACA = 5 THEN 'Indígena'
END AS COR, count(*)
FROM enem2019
WHERE NU_NOTA_MT > 800
AND TP_ST_CONCLUSAO = 2 
AND TP_PRESENCA_CH = 1  
AND TP_PRESENCA_CN = 1 
AND TP_PRESENCA_LC = 1 
AND TP_PRESENCA_MT = 1  
GROUP BY 1
