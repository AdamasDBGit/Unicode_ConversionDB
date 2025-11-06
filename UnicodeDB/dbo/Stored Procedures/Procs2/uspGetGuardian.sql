--exec uspGetGuardian '477B567B75F044AD925ABE0F749D713A'
CREATE PROCEDURE [dbo].[uspGetGuardian]    
(    
     
 @sToken nvarchar(MAX) =null,    
 @iParentID int = null    
)    
AS    
BEGIN    
    SELECT DISTINCT 
        --TS.S_Student_ID,
        TPM.I_Parent_Master_ID AS guardian_id,
        TRM.I_Relation_Master_ID,
        ISNULL(TPM.S_First_Name, '') AS first_name,
        ISNULL(TPM.S_Last_Name, '') AS last_name,
        -- Select the profile picture based on the relation ID
        CASE 
            WHEN TRM.I_Relation_Master_ID = 1 THEN ISNULL(TPM.S_Profile_Picture,TERD.S_Father_Photo)
            WHEN TRM.I_Relation_Master_ID = 2 THEN ISNULL(TPM.S_Profile_Picture,TERD.S_Mother_Photo)
            ELSE TPM.S_Profile_Picture
        END AS profile_picture,
        TRM.S_Relation_Type AS relation,
        TPM.S_Address AS address,
        TPM.S_Mobile_No AS phone_number,
        TPM.I_IsPrimary AS isPrimary,
        TPM.S_Guardian_Email AS Email
    FROM 
        T_Parent_Master AS TPM     
    JOIN 
        T_Student_Parent_Maps AS TSPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID    
    JOIN 
        (
            SELECT 
                TSPM.S_Student_ID,
                TPM.I_Parent_Master_ID,
                TSPM.I_Student_Detail_ID     
            FROM 
                T_Parent_Master TPM     
            JOIN  
                T_Student_Parent_Maps TSPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID    
            WHERE 
                TPM.S_Token = @sToken    
        ) AS TS ON TS.S_Student_ID = TSPM.S_Student_ID    
    JOIN 
        T_Student_Detail TSD ON TSD.I_Student_Detail_ID = TS.I_Student_Detail_ID
    JOIN 
        T_Enquiry_Regn_Detail TERD ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
    JOIN 
        T_Relation_Master AS TRM ON TRM.I_Relation_Master_ID = TPM.I_Relation_ID    
    WHERE 
        TPM.I_Parent_Master_ID = ISNULL(@iParentID, TPM.I_Parent_Master_ID) 
        AND TPM.I_Status = 1;    
END;
