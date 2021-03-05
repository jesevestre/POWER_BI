SELECT 
'Achats'=SUM((CASE FA.TYPE WHEN 'FA' THEN 1 ELSE -1 END)*(LF.BRUT_FACT
-LF.MREM_FACT-LF.ESC_FACT)/(CASE FA.TX_DEVISE WHEN 0 THEN 1 ELSE FA.TX_DEVISE END)),
'Quantit�'=SUM(CASE WHEN ISNULL(FA.FAMILLE,'')='RC' THEN 0 ELSE CASE FA.TYPE WHEN 'FA' THEN
(ISNULL(QTE_FACT,0)) ELSE -(ISNULL(QTE_FACT,0)) END END),

'Date'=CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3),
'#IDFournisseur'=F.CDE_FRS,
'#IDArticle'=LF.CDE_PROD

FROM POLYTECH.CTRLFACT FA
INNER JOIN POLYTECH.LCTRLFACT LF ON FA.NUM_FACT=LF.NUM_FACT
INNER JOIN POLYTECH.CTRLFACTHISTO FH ON LF.NUM_FACT=FH.NUM_FACT AND LF.LIG_FACT=FH.LIG_FACT
INNER JOIN POLYTECH.FOURNIS F ON F.CDE_FRS=FA.CDE_FRS 
INNER JOIN POLYTECH.VARTICLEPRODMULTI AR ON LF.CDE_PROD=AR.CDE_PROD AND FH.SITE_EXECUTION=SITE_CONSULT
LEFT OUTER JOIN POLYTECH.PRODUIT PR ON AR.FAM_PROD =PR.CDE_FAM

WHERE FA.TYPE IN ('AV','FA')
AND ISNULL(F.STAT,0)=0
AND AR.STAT<>1
AND FA.TRANSPORT =0 

GROUP BY F.CDE_FRS, LF.CDE_PROD, FA.DTE_CREAT, F.CDE_FRS, LF.CDE_PROD,
DATEPART(YEAR,CONVERT(DATETIME,DATEADD(DD,FA.DTE_FACT,'30/12/1899'),3))

/*
INNER JOIN POLYTECH.LIGFACT LF ON FA.NUM_FACT=LF.NUM_FACT
INNER JOIN POLYTECH.CTRLFACTHISTO FH ON LF.NUM_FACT=FH.NUM_FACT AND LF.LIG_FACT=FH.LIG_FACT
INNER JOIN POLYTECH.CLIENTS F ON F.CDE_FRS=FA.CDE_FRS 
INNER JOIN POLYTECH.ARTICLE AR ON LF.CDE_PROD=AR.CDE_PROD AND FH.SITE_EXECUTION=SITE_CONSULT*/