SELECT
'Client - groupe'=ISNULL(GRP.DESIGNATION, ISNULL(C.GROUPE, '')),
'Client - nom'=ISNULL(C.NOM_CLI, ''),
'Client - cat�gorie'=ISNULL(CATT.DESIGNATION, ISNULL(C.CATEGORIE, '')),

'#Client'=ISNULL(C.CDE_CLI, '')

FROM AGS.FACTURE FA 
INNER JOIN AGS.LIGFACT LF ON FA.NUM_FACT=LF.NUM_FACT
INNER JOIN AGS.CLIENTS C ON FA.CDE_CLI=C.CDE_CLI
INNER JOIN AGS.ARTICLE AR ON LF.CDE_PROD=AR.CDE_PROD
INNER JOIN AGS.COUTS_STATS CS ON AR.CDE_PROD=CS.CDE_PROD

LEFT OUTER JOIN AGS.CATEGORIETIERS CATT ON C.CATEGORIE=CATT.CDE_CATEGORIE
LEFT OUTER JOIN AGS.CATEGORIE CAT ON AR.CDE_CATEGORIE=CAT.CDE_CATEGORIE AND AR.CDE_MARQUE=CAT.CDE_MARQUE
LEFT OUTER JOIN AGS.SEGMENT SEG ON AR.CDE_CATEGORIE=SEG.CDE_CATEGORIE
AND AR.CDE_SEGMENT=SEG.CDE_SEGMENT AND AR.CDE_MARQUE=SEG.CDE_MARQUE
LEFT OUTER JOIN AGS.GROUPETIERS GRP ON GRP.CDE_GROUPETIERS = C.GROUPE
LEFT OUTER JOIN AGS.SGROUPETIERS SGR ON C.GROUPE=SGR.CDE_GROUPETIERS
AND C.SOUS_GROUPE=SGR.CDE_SGROUPETIERS
LEFT OUTER JOIN AGS.CENTRALETIERS CEN ON CEN.CDE_CENTRALETIERS = C.CDE_CENTRALE
AND C.SOUS_GROUPE=CEN.CDE_SGROUPETIERS

WHERE (FA.TYPE IN ('AV','FA')) AND (ISNULL(AR.STAT,0)<>1) AND YEAR(FA.DTE_CREAT)>=YEAR(GETDATE())-5 AND ISNULL(C.STAT,0)<7

GROUP BY FA.VENDEUR, C.VENDEUR, C.GROUPE, GRP.DESIGNATION, SGR.DESIGNATION, C.CDE_CENTRALE, CEN.DESIGNATION, 
C.SECTEUR_COMMERCIAL, C.ACTIVITE, C.CDE_CLI, C.NOM_CLI, AR.LIG_PROD, AR.FAM_PROD, LF.CDE_PROD, AR.LIB_30, AR.ORGANE, 
C.PAYS_PAIE, C.CATEGORIE, CATT.DESIGNATION, C.MARCHE, AR.CDE_MARQUE, AR.CDE_CATEGORIE, CAT.DESIGNATION,
AR.CDE_SEGMENT, SEG.DESIGNATION, FA.DTE_CREAT, AR.VALORISATION, CS.PRX_ACT, CS.PRX_STD, CS.COUT_PUMP, CS.PRX_FAACT