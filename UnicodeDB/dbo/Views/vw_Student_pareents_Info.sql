Create View vw_Student_pareents_Info
as
SELECT  Distinct 
   SPM.I_Brand_ID,
    SPM.I_Student_Detail_ID,
    SPM.S_Student_ID,
    MAX(CASE WHEN RM.S_Relation_Type = 'Father' 
             THEN PM.S_First_Name + 
                  CASE WHEN PM.S_Middile_Name IS NOT NULL AND PM.S_Middile_Name != '' 
                       THEN ' ' + PM.S_Middile_Name 
                       ELSE '' 
                  END + 
                  ' ' + PM.S_Last_Name 
             END) AS Father_Name,
    MAX(CASE WHEN RM.S_Relation_Type = 'Mother' 
             THEN PM.S_First_Name + 
                  CASE WHEN PM.S_Middile_Name IS NOT NULL AND PM.S_Middile_Name != '' 
                       THEN ' ' + PM.S_Middile_Name 
                       ELSE '' 
                  END + 
                  ' ' + PM.S_Last_Name 
             END) AS Mother_Name,
    MAX(CASE WHEN RM.S_Relation_Type = 'Father' THEN PM.S_Mobile_No END) AS Father_Mobile,
    MAX(CASE WHEN RM.S_Relation_Type = 'Mother' THEN PM.S_Mobile_No END) AS Mother_Mobile
FROM 
    T_Student_Parent_Maps SPM 
INNER JOIN 
    T_Parent_Master PM ON SPM.I_Parent_Master_ID = PM.I_Parent_Master_ID

LEFT JOIN 
    T_Relation_Master RM ON RM.I_Relation_Master_ID = PM.I_Relation_ID
WHERE SPM.I_Brand_ID = 107
   -- SPM.S_Student_ID = '19-0357'
GROUP BY 
   SPM.I_Brand_ID, SPM.I_Student_Detail_ID, SPM.S_Student_ID;