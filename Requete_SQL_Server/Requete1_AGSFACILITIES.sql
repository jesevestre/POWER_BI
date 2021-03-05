SELECT 
'Pays'=ISNULL(PP.LIB_50, ISNULL(C.PAYS_PAIE, '')), 
'Cat�gorie'=ISNULL(CA.LIB_50,FA.FAMILLE),
'March�'=ISNULL(TYP.DESIGNATION, ISNULL(C.MARCHE, '')), 
'Activit�'=ISNULL(AC.DESIGNATION, ISNULL(C.ACTIVITE, '')),
'Secteur'=ISNULL(SEC.LIB_50, ISNULL(C.SECTEUR_COMMERCIAL, '')),
'Vendeur'=ISNULL(V.NOM,ISNULL(FA.VENDEUR, ISNULL(C.VENDEUR, ''))), 
'Groupe'=ISNULL(GRP.DESIGNATION, ISNULL(C.GROUPE, '')),
'Sous groupe'=ISNULL(SGR.DESIGNATION, ISNULL(C.SOUS_GROUPE, '')), 
'Centrale'=ISNULL(CEN.DESIGNATION, ISNULL(C.CDE_CENTRALE, '')),
'Client - code'=ISNULL(C.CDE_CLI, ''),
'Client - nom'=ISNULL(C.NOM_CLI, ''),
'Ligne de produits'=ISNULL(LP.LIB_30, ISNULL(AR.LIG_PROD, '')),
'Famille d''articles'=ISNULL(PR.LIB_30, ISNULL(AR.FAM_PROD, '')), 
'Article - d�signation'=ISNULL(AR.LIB_30, ''), 
'Article - nature'=ISNULL(NA.LIB_50, ISNULL(AR.ORGANE, '')),
'Date'=CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3),
'Mois'=DATEPART(MONTH,CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3)),
'Trimestre'=DATEPART(QQ,CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3)), 
'Ann�e'=DATEPART(YEAR,CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3)), 
'Quantit�'=ISNULL(ROUND(SUM(CASE WHEN ISNULL(FAMILLE,'')='RC' THEN 0 ELSE CASE FA.TYPE WHEN 'FA' THEN  
(ISNULL(QTE_FACT*ISNULL(LF.RAPPORTFA,1),0)) ELSE -(ISNULL(QTE_FACT*ISNULL(LF.RAPPORTFA,1),0)) END END),3), ''), 
'Chiffre d''affaires'=ROUND(SUM((CASE FA.TYPE WHEN 'FA' THEN 1 ELSE -1 END)*
(LF.MT_BRUT-LF.MT_REM-LF.MT_ESC)/(CASE FA.TX_DEVISE WHEN 0 THEN 1 ELSE FA.TX_DEVISE END)),3),
'Co�t'=(CASE AR.VALORISATION WHEN 1 THEN ISNULL(CS.PRX_ACT,0) WHEN 2 THEN ISNULL(CS.PRX_STD,0) 
WHEN 3 THEN ISNULL(CS.COUT_PUMP,0) WHEN 4 THEN ISNULL(CS.PRX_FAACT,0) ELSE 0 END) *
(ROUND(SUM(CASE WHEN ISNULL(FAMILLE,'')='RC' THEN 0 ELSE CASE FA.TYPE WHEN 'FA' THEN  
(ISNULL(QTE_FACT*ISNULL(LF.RAPPORTFA,1),0)) ELSE -(ISNULL(QTE_FACT*ISNULL(LF.RAPPORTFA,1),0)) END END),3))
/*'Cat�gorieClient'=ISNULL(CATT.DESIGNATION, ISNULL(C.CATEGORIE, '')),
'Marque'=ISNULL(MAR.DESIGNATION, ISNULL(AR.CDE_MARQUE, '')),
'Cat�gorie'=ISNULL(CAT.DESIGNATION, ISNULL(AR.CDE_CATEGORIE, '')), 
'Segment'=ISNULL(SEG.DESIGNATION, ISNULL(AR.CDE_SEGMENT, '')),
'Article - code'=ISNULL(LF.CDE_PROD, ''),
'Article - unit�'=ISNULL(AR.UNITE,''), */

FROM AGEMASRV.FACTURE FA 
INNER JOIN AGEMASRV.LIGFACT LF ON FA.NUM_FACT=LF.NUM_FACT
INNER JOIN AGEMASRV.CLIENTS C ON FA.CDE_CLI=C.CDE_CLI 
INNER JOIN AGEMASRV.ARTICLE AR ON LF.CDE_PROD=AR.CDE_PROD 
INNER JOIN AGEMASRV.COUTS_STATS CS ON AR.CDE_PROD=CS.CDE_PROD
LEFT OUTER JOIN AGEMASRV.VENDEUR V ON ISNULL(FA.VENDEUR,C.VENDEUR)=V.VENDEUR 
LEFT OUTER JOIN AGEMASRV.MARCHE TYP ON C.MARCHE=TYP.CDE_MARCHE 
LEFT OUTER JOIN AGEMASRV.ACTIVITETIERS AC ON C.ACTIVITE=AC.CDE_ACTIVITE AND C.MARCHE=AC.CDE_MARCHE 
LEFT OUTER JOIN AGEMASRV.CATEGORIETIERS CATT ON C.CATEGORIE=CATT.CDE_CATEGORIE 
AND C.ACTIVITE=CATT.CDE_ACTIVITE AND C.MARCHE=CATT.CDE_MARCHE 
LEFT OUTER JOIN AGEMASRV.TABLES SEC ON C.SECTEUR_COMMERCIAL=SEC.CDE_TABLE AND SEC.NUM_TABLE=53 
LEFT OUTER JOIN AGEMASRV.TABLES PP ON C.PAYS_PAIE=PP.CDE_TABLE AND PP.NUM_TABLE=35 
LEFT OUTER JOIN AGEMASRV.TABLES NA ON AR.ORGANE=NA.CDE_TABLE AND NA.NUM_TABLE=178
LEFT OUTER JOIN AGEMASRV.TABLES TPS ON AR.TYPE_STOCKAGE=TPS.CDE_TABLE AND TPS.NUM_TABLE=218
LEFT OUTER JOIN AGEMASRV.GROUPETIERS GRP ON GRP.CDE_GROUPETIERS = C.GROUPE 
LEFT OUTER JOIN AGEMASRV.SGROUPETIERS SGR ON C.GROUPE=SGR.CDE_GROUPETIERS 
AND C.SOUS_GROUPE=SGR.CDE_SGROUPETIERS 
LEFT OUTER JOIN AGEMASRV.CENTRALETIERS CEN ON CEN.CDE_CENTRALETIERS = C.CDE_CENTRALE 
AND C.SOUS_GROUPE=CEN.CDE_SGROUPETIERS 
LEFT OUTER JOIN AGEMASRV.LIGPROD LP ON AR.LIG_PROD =LP.LIG_PROD 
LEFT OUTER JOIN AGEMASRV.PRODUIT PR ON AR.FAM_PROD =PR.CDE_FAM
LEFT OUTER JOIN AGEMASRV.TABLES CA ON CA.CDE_TABLE=FA.FAMILLE AND CA.NUM_TABLE=132
/*LEFT OUTER JOIN AGEMASRV.MARQUE MAR ON AR.CDE_MARQUE=MAR.CDE_MARQUE 
LEFT OUTER JOIN AGEMASRV.CATEGORIE CAT ON AR.CDE_CATEGORIE=CAT.CDE_CATEGORIE AND AR.CDE_MARQUE=CAT.CDE_MARQUE 
LEFT OUTER JOIN AGEMASRV.SEGMENT SEG ON AR.CDE_CATEGORIE=SEG.CDE_CATEGORIE
AND AR.CDE_SEGMENT=SEG.CDE_SEGMENT AND AR.CDE_MARQUE=SEG.CDE_MARQUE */

WHERE (FA.TYPE IN ('AV','FA')) AND (ISNULL(AR.STAT,0)<>1) AND YEAR(FA.DTE_CREAT)>=YEAR(GETDATE())-3 AND ISNULL(C.STAT,0)<7
GROUP BY FA.FAMILLE, CA.LIB_50, FA.VENDEUR, C.VENDEUR, V.NOM, C.GROUPE, GRP.DESIGNATION, C.SOUS_GROUPE, SGR.DESIGNATION, C.CDE_CENTRALE, CEN.DESIGNATION,
C.SECTEUR_COMMERCIAL, SEC.LIB_50, C.ACTIVITE, AC.DESIGNATION, C.CDE_CLI, C.NOM_CLI, AR.LIG_PROD, LP.LIB_30, AR.FAM_PROD, PR.LIB_30,
LF.CDE_PROD, AR.LIB_30, AR.UNITE, AR.ORGANE, NA.LIB_50, C.PAYS_PAIE, PP.LIB_50, CATT.DESIGNATION, C.MARCHE, TYP.DESIGNATION,
/*C.CATEGORIE, AR.CDE_MARQUE, MAR.DESIGNATION, AR.CDE_CATEGORIE, CAT.DESIGNATION, AR.CDE_SEGMENT, SEG.DESIGNATION,*/
FA.DTE_CREAT, DATEPART(MONTH,CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3)), DATEPART(QQ,CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3)),
DATEPART(YEAR,CONVERT(DATETIME,DATEADD(DD,FA.DTE_CREAT,'30/12/1899'),3)), AR.VALORISATION, CS.PRX_ACT, CS.PRX_STD, CS.COUT_PUMP, CS.PRX_FAACT