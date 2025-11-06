CREATE PROCEDURE [dbo].[usp_ERP_VerifyDocumentForStudent]    
(    
    @DocumentStudRegnID INT,    
    @Status INT    
)    
AS    
BEGIN    
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.    
    SET NOCOUNT ON;    

    DECLARE @mandatoryDocsCount INT,
            @approveCount INT,
            @regID INT,
            @rejectedCount INT;

    -- Update the document verification status
    UPDATE T_ERP_Document_Student_Map 
    SET Is_verified = @Status, 
        Dtt_Verified_date = GETDATE()    
    WHERE I_Document_StudRegn_ID = @DocumentStudRegnID;

    -- Get the total count of mandatory documents
    SET @mandatoryDocsCount = (SELECT COUNT(*) 
                               FROM T_ERP_Document_Category 
                               WHERE I_IsMandatory = 1);

    -- Get the registration ID for the student
    SET @regID = (SELECT TOP 1 R_I_Enquiry_Regn_ID 
                  FROM T_ERP_Document_Student_Map 
                  WHERE I_Document_StudRegn_ID = @DocumentStudRegnID);

    -- Get the count of rejected mandatory documents
    SET @rejectedCount = (SELECT COUNT(*) 
                          FROM T_ERP_Document_Student_Map t1 
                          INNER JOIN T_ERP_Document_Type_Master t2
                              ON t1.R_I_Document_Type_ID = t2.I_Document_Type_ID 
                          WHERE t1.R_I_Enquiry_Regn_ID = @regID 
                            AND t2.Is_Mandatory = 1 
                            AND t1.Is_verified = 2);

    -- Get the count of approved mandatory documents
    SET @approveCount = (SELECT COUNT(DISTINCT t1.R_I_Document_Type_ID)
                         FROM T_ERP_Document_Student_Map t1
                         INNER JOIN T_ERP_Document_Type_Master t2
                             ON t1.R_I_Document_Type_ID = t2.I_Document_Type_ID
                         INNER JOIN T_ERP_Document_Category dc
                             ON t2.I_Document_Category_ID = dc.I_Document_Category_ID
                         WHERE t1.R_I_Enquiry_Regn_ID = @regID
                           AND dc.I_IsMandatory = 1
                           AND t1.Is_Active = 1
                           AND t1.Is_verified = 1);

    -- Update the Admission Stage Type based on the verification status
    IF (@mandatoryDocsCount <= @approveCount)
    BEGIN
        UPDATE T_Enquiry_Regn_Detail 
        SET R_I_AdmStgTypeID = 5 
        WHERE I_Enquiry_Regn_ID = 
              (SELECT R_I_Enquiry_Regn_ID 
               FROM T_ERP_Document_Student_Map   
               WHERE I_Document_StudRegn_ID = @DocumentStudRegnID);
    END
    ELSE
    BEGIN
        UPDATE T_Enquiry_Regn_Detail 
        SET R_I_AdmStgTypeID = 4 
        WHERE I_Enquiry_Regn_ID = 
              (SELECT R_I_Enquiry_Regn_ID 
               FROM T_ERP_Document_Student_Map   
               WHERE I_Document_StudRegn_ID = @DocumentStudRegnID);
    END

    -- Return the status flag and a message
    SELECT @Status AS StatusFlag, 'Status Updated' AS Message;    
END;
