SELECT 
'Article - désignation'=ISNULL(AR.LIB_30, ''),
'Article - famille'=ISNULL(PR.LIB_30, ISNULL(AR.FAM_PROD, '')),

'#IDArticle'=LF.CDE_PROD

FROM AGSFR.CTRLFACT FA

INNER JOIN AGSFR.LCTRLFACT LF ON FA.NUM_FACT=LF.NUM_FACT
INNER JOIN AGSFR.FOURNIS F ON F.CDE_FRS=FA.CDE_FRS
INNER JOIN AGSFR.ARTICLE AR ON LF.CDE_PROD=AR.CDE_PROD
LEFT OUTER JOIN AGSFR.PRODUIT PR ON AR.FAM_PROD =PR.CDE_FAM

WHERE FA.TYPE IN ('AV','FA')
AND ISNULL(F.STAT,0)=0
AND AR.STAT<>1
AND FA.TRANSPORT =0

GROUP BY AR.LIB_30, PR.LIB_30, AR.FAM_PROD, LF.CDE_PROD