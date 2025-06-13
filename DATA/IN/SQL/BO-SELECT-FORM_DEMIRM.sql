-- -----------------------------------------------------------------------------------------------------------------
-- Récupération champs table mère FORMULAIRE DEMIRM POUR CRC - BONS RADIOLOGIE IRM
-- -----------------------------------------------------------------------------------------------------------------

SELECT DISTINCT
       CONVERT(datetime, irm.EXAM_DATE_DEM, 103) AS DATE_DEMANDE_EXAMEN,   					            -- Date de l'examen RECIST 
       irm.CLINI_LIBELLE AS DEMANDEUR_EXAMEN,															-- Demandeur de l'examen	
	   irm.EXAM_TEL_PRESC AS NOM_POSTE_DEMANDEUR,                                                       -- Numéro de poste du demandeur
	   pat.CLI_Donn_Nom AS NOM_PATIENT,                                                                 -- Nom du patient
	   pat.CLI_Donn_Prenom AS PRENOM_PATIENT,                                                           -- Prénom du patient
       irm.PNUM AS IPP,                                                                                 -- IPP du Patient
       '' AS ETUDE,                                                                                     -- TODO - CHAMP A AJOUTER DANS FORMULAIRE - Etude
       '' AS DATE_LIMTE_RECIST,                                                                  -- TODO - CHAMP A AJOUTER DANS FORMULAIRE - Date limite de retour des mesures RECISTs
	   '' AS DATE_EXAMEN,                                                                               -- ATTENTION - Impossible à avoir car manuel sur le bon d'IRM
       'IRM' as TYPE_EXAMEN, 																        -- SCANNER ou IRM 
       'Examen CGFL' AS LIEU_EXAMEN,			 														-- Voir pour récupérer doc Zensolutions mais dans formulaire  ARC  - Examen CGFL ou Examen Exterieur
       REPLACE(REPLACE(fldeb.Cli_Code, '01', 'Baseline'), '02', 'Suivi Recist') AS TYPE_RELECTURE, 	    -- Baseline ou Suivi Recist 
       '' AS DATE_BASELINE, 																	        -- TODO - CHAMP A AJOUTER DANS FORMULAIRE - Date de la baseline
       '' AS DATE_EXAMEN_COMPARAISON, 															        -- TODO - CHAMP A AJOUTER DANS FORMULAIRE - Date de l'examen de comparaison
       '' AS LIEN_VERS_CR, 								        -- PAS INFO
       '' AS LIGNE_XPLORE, 																	       	    -- SERA AJOUTE par SABRINA														     	 	
	   'NON' AS RELECTURE_REALISEE,                                                                        -- PAS INFO manque lien date_examen entre bon scanner et RECIST
	   '' AS RELECTURE_PAR, 															     		    -- JAMAIS INFO INTERFACES Radiologue ayant effectué la relecture SI RECIST NON REALISE
	   '' AS COMMENTAIRE 	
FROM PRD.dbo.FRM0DEMIRM irm
	 INNER JOIN PRD.dbo.Tbld_CLI_MVTS_Patients pat ON irm.Cli_Num_IPP = pat.CLI_Code_NoIPP                    -- Patient
	 INNER JOIN PRD.dbo.Tbld_CLI_MVTS_Episodes epi ON irm.Cli_Num_IPP = epi.CLI_Code_NoIPP                    -- Episode
	 LEFT JOIN PRD.dbo.FRM_LIEN0DEMIRM_RECIST fldr ON irm.Cli_Code_Contexte = fldr.Cli_Code_Contexte          -- RECIST
	 LEFT JOIN PRD.dbo.FRM_LIEN0DEMIRM_EXAM_BASEL1 fldeb ON irm.Cli_Code_Contexte = fldeb.Cli_Code_Contexte   -- BASELINE 	
WHERE irm.EXAM_DATE_DEM >= CONVERT(datetime, '01/01/2025', 103) -- Supérieur à date de démarrage
  AND fldr.Cli_Code = '01' -- RECIST=OUI
ORDER BY irm.EXAM_DATE_DEM DESC
;

