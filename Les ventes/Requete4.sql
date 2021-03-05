SELECT
'Article - cat�gorie'=ISNULL(CAT.LIB_50, ''),
'Article - d�signation'=ISNULL(AR.LIB_30, ''),
'Chiffre d''affaires'=ROUND(SUM((CASE FA.TYPE WHEN 'FA' THEN 1 ELSE -1 END)*
(LF.MT_BRUT-LF.MT_REM-LF.MT_ESC)/(CASE FA.TX_DEVISE WHEN 0 THEN 1 ELSE FA.TX_DEVISE END)),3),

'#Date'=CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3),
'#Article'=ISNULL(LF.CDE_PROD, '')

FROM AGSFR.FACTURE FA
INNER JOIN AGSFR.CLIENTS C ON C.CDE_CLI=FA.CDE_CLI
INNER JOIN AGSFR.LIGFACT LF ON FA.NUM_FACT=LF.NUM_FACT 
INNER JOIN AGSFR.ARTICLE AR ON LF.CDE_PROD=AR.CDE_PROD
LEFT OUTER JOIN AGSFR.TABLES CAT ON FA.CATEGORIE=CAT.CDE_TABLE AND CAT.NUM_TABLE=132

WHERE (FA.TYPE IN ('AV','FA')) AND (ISNULL(AR.STAT,0)<>1) AND YEAR(FA.DTE_CREAT)>=YEAR(GETDATE())-5 AND ISNULL(C.STAT,0)<7

GROUP BY CAT.LIB_50, LF.CDE_PROD, AR.LIB_30, FA.DTE_CREAT