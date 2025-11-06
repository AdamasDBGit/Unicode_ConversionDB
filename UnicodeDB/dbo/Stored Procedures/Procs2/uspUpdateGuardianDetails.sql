CREATE PROCEDURE [dbo].[uspUpdateGuardianDetails]    
(    
    @guardianID INT,    
    @Email NVARCHAR(max)    
)    
AS    
BEGIN    
    DECLARE @I_Relation_ID INT;

    -- Step 1: Update the email in T_Parent_Master for the guardian
    UPDATE T_Parent_Master    
    SET S_Guardian_Email = @Email    
    WHERE I_Parent_Master_ID = @guardianID;

    -- Step 2: Get the I_Relation_ID from T_Parent_Master
    SELECT @I_Relation_ID = I_Relation_ID
    FROM T_Parent_Master
    WHERE I_Parent_Master_ID = @guardianID;

    -- Step 3: Use a CTE to gather the necessary data
    WITH CTE_Student_Detail AS (
        SELECT spm.I_Student_Detail_ID, sd.I_Enquiry_Regn_ID
        FROM T_Student_Parent_Maps spm
        JOIN T_Student_Detail sd ON spm.I_Student_Detail_ID = sd.I_Student_Detail_ID
        WHERE spm.I_Parent_Master_ID = @guardianID
    )

    -- Step 4: Update the email in T_Enquiry_Regn_Detail based on I_Relation_ID
    UPDATE T_Enquiry_Regn_Detail
    SET 
        S_Father_Email = CASE WHEN @I_Relation_ID = 1 THEN @Email ELSE S_Father_Email END,
        S_Mother_Email = CASE WHEN @I_Relation_ID = 2 THEN @Email ELSE S_Mother_Email END
    FROM T_Enquiry_Regn_Detail erd
    INNER JOIN CTE_Student_Detail cte ON erd.I_Enquiry_Regn_ID = cte.I_Enquiry_Regn_ID;

    -- Return success message
    SELECT 1 AS statusFlag, 'Guardian details updated successfully' AS Message;
END

