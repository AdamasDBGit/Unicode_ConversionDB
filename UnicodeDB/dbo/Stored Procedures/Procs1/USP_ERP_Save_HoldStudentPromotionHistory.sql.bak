CREATE PROCEDURE [dbo].[USP_ERP_Save_HoldStudentPromotionHistory]
(
    @UT_StudentPromotionDetails AS dbo.UT_StudentPromotionDetails READONLY,
    @iBrandID INT,
    @iCenterID INT,
    @CreatedBy int
)
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY

    DECLARE @CurrentDate DATETIME = GETDATE();

    ----------------------------------------------------
    -- TEMP TABLE TO TRACK MERGE OUTPUT
    ----------------------------------------------------
    DECLARE @MergeOutput TABLE
    (
        ActionType NVARCHAR(10),
        I_Student_Promotion_History_Header_ID INT,
        I_Student_DetailID INT,
        I_Source_Academic_Session INT,
        I_Destination_Academic_Session INT,
        I_Promotion_Status INT,
        S_Remarks NVARCHAR(MAX)
    );

    ----------------------------------------------------
    -- MERGE OPERATION (Insert / Update)
    ----------------------------------------------------
    ;MERGE INTO T_ERP_Student_Promotion_History_Header AS TARGET
    USING @UT_StudentPromotionDetails AS SRC
        ON TARGET.I_Student_DetailID = SRC.I_Student_DetailID
       AND TARGET.I_Source_Academic_Session = SRC.I_Source_Academic_Session
	   AND TARGET.I_Promotion_Status =1
       AND TARGET.IsAcademicApproved=0
       AND TARGET.IsFinancialApproved IS NULL
	   AND TARGET.WillOnHold = 1
       AND TARGET.I_Brand_ID = @iBrandID
      

    WHEN MATCHED THEN 
        UPDATE SET
            TARGET.I_Destination_Class_ID         = SRC.I_Destination_Class_ID,
            TARGET.I_Destination_Stream_ID        = SRC.I_Destination_Stream_ID,
            TARGET.I_Destination_SectionID        = SRC.I_Destination_SectionID,
            TARGET.I_Promotion_Status             = 1,  -- Set to Promote
            TARGET.I_Destination_School_Group_ID  = SRC.I_Destination_School_Group_ID,
            TARGET.RollNo                         = SRC.RollNo,
            TARGET.S_Last_Remarks                 = SRC.Remarks,
            TARGET.IsAcademicApproved             = 1,
            TARGET.S_Last_Action_By               = @CreatedBy,
            TARGET.Dt_Last_Action_At              = @CurrentDate

    WHEN NOT MATCHED BY TARGET THEN 
        INSERT (
            I_Source_Academic_Session,
            I_Destination_Academic_Session,
            I_Student_DetailID,
            I_Source_Class_ID,
            I_Source_Stream_ID,
            I_Source_SectionID,
            I_Destination_Class_ID,
            I_Destination_Stream_ID,
            I_Destination_SectionID,
            I_Promotion_Status,
            I_Brand_ID,
            I_Center_ID,
            I_Source_School_Group_ID,
            I_Destination_School_Group_ID,
            RollNo,
            IsAcademicApproved,
            WillDemoted,
            S_Last_Remarks,
            WillOnHold,
            WillRetain,
            CreatedBy,
            Dt_Created_At
        )
        VALUES (
            SRC.I_Source_Academic_Session,
            SRC.I_Destination_Academic_Session,
            SRC.I_Student_DetailID,
            SRC.I_Source_Class_ID,
            SRC.I_Source_Stream_ID,
            SRC.I_Source_SectionID,
            SRC.I_Destination_Class_ID,
            SRC.I_Destination_Stream_ID,
            SRC.I_Destination_SectionID,
            1,  -- Promote by default
            @iBrandID,
            @iCenterID,
            SRC.I_Source_School_Group_ID,
            SRC.I_Destination_School_Group_ID,
            SRC.RollNo,
            CASE WHEN SRC.I_Promotion_Status IN (1,2,4) THEN 1 ELSE 0 END,
            CASE WHEN SRC.I_Promotion_Status = 4 THEN 1 ELSE 0 END,
            SRC.Remarks,
            CASE WHEN SRC.I_Promotion_Status = 3 THEN 1 ELSE 0 END,
            SRC.WillRetain,
            @CreatedBy,
            @CurrentDate
        )

    OUTPUT 
        CASE 
            WHEN $action = 'INSERT' THEN 'INSERT'
            WHEN $action = 'UPDATE' THEN 'UPDATE'
            ELSE $action
        END,
        INSERTED.I_Student_Promotion_History_Header_ID,
        COALESCE(INSERTED.I_Student_DetailID, SRC.I_Student_DetailID),
        COALESCE(INSERTED.I_Source_Academic_Session, SRC.I_Source_Academic_Session),
        COALESCE(INSERTED.I_Destination_Academic_Session, SRC.I_Destination_Academic_Session),
        COALESCE(INSERTED.I_Promotion_Status, SRC.I_Promotion_Status),
        SRC.Remarks
    INTO @MergeOutput;

 
     ----------------------------------------------------
        -- SUCCESS RESPONSE
        ----------------------------------------------------
        DECLARE @InsertedIDs NVARCHAR(MAX) = '';

        SELECT @InsertedIDs = 
            COALESCE(@InsertedIDs + ',', '') + CAST(I_Student_Promotion_History_Header_ID AS NVARCHAR(20))
        FROM @MergeOutput;

        SELECT 
            1 AS StatusFlag,
            'Student promotion history processed successfully.' AS Message
            

    END TRY
    BEGIN CATCH
        ----------------------------------------------------
        -- ERROR RESPONSE
        ----------------------------------------------------
        SELECT 
            0 AS StatusFlag,
            ERROR_MESSAGE() AS Message,
            ERROR_MESSAGE() AS ErrorMessage
            
    END CATCH
END;
