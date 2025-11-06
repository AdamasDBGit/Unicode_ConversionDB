
CREATE PROCEDURE [dbo].[usp_ERP_insert_Update_Student_DocumentMap] (
    @Created_By int = null,      
    @EnquiryID int = null,    
    @Student_Document_Map UT_Student_Document_Map READONLY            
)
AS
BEGIN

    -------------------- Inserting Data --------------------
    MERGE T_ERP_Document_Student_Map AS target
    USING @Student_Document_Map AS source
    ON target.R_I_Enquiry_Regn_ID = Source.[I_Enquiry_Regn_ID]
    AND target.I_Document_StudRegn_ID = Source.[I_Document_StudRegn_ID]
    AND Target.R_I_Document_Type_ID = Source.[R_I_Document_Type_ID]
    
    WHEN MATCHED THEN
        UPDATE 
        SET 
            target.R_I_Document_Type_ID = Source.R_I_Document_Type_ID,
            Target.I_Seq_No = source.I_Seq_No,
            target.S_Imagepath = source.S_Imagepath,
            target.Is_Active = source.Is_Active,
            target.Dtt_UpdatedAt = GetDate(),
            target.I_UpdatedBy = @Created_By,
            target.Is_verified = CASE 
            WHEN target.Is_verified = 0 THEN 0 
            ELSE target.Is_verified 
			END

    WHEN NOT MATCHED THEN
        INSERT (
            R_I_Enquiry_Regn_ID,
            R_I_Document_Type_ID,
            I_Seq_No,
            Is_verified,
            Dtt_Verified_date,
            Is_Active,
            I_CreatedBy,
            I_UpdatedBy,
            Dtt_CreatedAt,
            Dtt_UpdatedAt,
            S_Imagepath
        )
        VALUES (
            Source.[I_Enquiry_Regn_ID],
            Source.R_I_Document_Type_ID,
            Source.I_Seq_No,
            0,
            NULL,
            1,
            @Created_By,
            NULL,
            GetDate(),
            NULL,
            Source.S_Imagepath
        )
    
    WHEN NOT MATCHED BY SOURCE 
    AND R_I_Enquiry_Regn_ID = @EnquiryID THEN
        UPDATE 
        SET 
            Is_Active = 0,
            Dtt_UpdatedAt = GETDATE();

    -------------------- Checking for mandatory documents --------------------
    DECLARE @mandatoryCategoryCount int, @validDocumentCount int;

    -- Count the mandatory categories
    SET @mandatoryCategoryCount = (
        SELECT COUNT(*) 
        FROM T_ERP_Document_Category 
        WHERE I_IsMandatory = 1
    );

    -- Count the valid documents from student document map
    SET @validDocumentCount = (
        SELECT COUNT(DISTINCT t1.R_I_Document_Type_ID)
        FROM T_ERP_Document_Student_Map t1
        INNER JOIN T_ERP_Document_Type_Master t2
        ON t1.R_I_Document_Type_ID = t2.I_Document_Type_ID
        INNER JOIN T_ERP_Document_Category dc
        ON t2.I_Document_Category_ID = dc.I_Document_Category_ID
        WHERE t1.R_I_Enquiry_Regn_ID = @EnquiryID
        AND dc.I_IsMandatory = 1
        AND t1.Is_Active = 1
    );

    -- If the count of valid documents matches the mandatory category count, update the admission stage
    IF (@validDocumentCount >= @mandatoryCategoryCount)
    BEGIN
        UPDATE T_Enquiry_Regn_Detail
        SET R_I_AdmStgTypeID = 4
        WHERE I_Enquiry_Regn_ID = @EnquiryID;
    END

    -- Return success message
    SELECT 1 AS StatusFlag, 'Document(s) uploaded successfully.' AS Message;

END
