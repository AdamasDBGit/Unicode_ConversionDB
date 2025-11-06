CREATE PROCEDURE [dbo].[USP_ERP_Insert_update_Student_Approve]
    @Student_Promotion_History_Header_ID INT = NULL,
    @BrandID INT , 
    @CreatedByUserID INT , 
    @MyData dbo.UT_Academic_Approved_Student READONLY
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SourceSessionID INT;
    SET @SourceSessionID = (SELECT TOP 1 I_Source_Academic_Session FROM @MyData);
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF @Student_Promotion_History_Header_ID IS NULL
        BEGIN
            -- Temporary table to hold student due details
            CREATE TABLE #temp_student_due (
                ID INT IDENTITY(1,1),
                SessionID INT,
                BrandID INT,
                CenterID INT,
                Student_Detail_ID INT,
                Total_Inv_Amount NUMERIC(10,2),
                Total_Recpt_Amount NUMERIC(10,2),
                Stud_Due_Amount NUMERIC(10,2),
                Due_Status VARCHAR(50)
            );

            -- Insert data using stored procedure
            INSERT INTO #temp_student_due (SessionID, BrandID, CenterID, Student_Detail_ID, Total_Inv_Amount, Total_Recpt_Amount, Stud_Due_Amount, Due_Status)
            EXEC USP_ERP_Get_Student_Invoice_Due_Details @SourceSessionID, @BrandID;
            
            -- Temporary table to hold header data
            CREATE TABLE #Header (
                I_Source_Academic_Session INT,
                I_Destination_Academic_Session INT,
                I_Student_Detail_ID INT,
                I_Source_Class_ID INT,
                I_Source_Stream_ID INT,
                I_Source_SectionID INT,
                I_Destination_Class_ID INT,
                I_Destination_Stream_ID INT,
                I_Destination_SectionID INT,
                I_Promotion_Status INT,
                Is_Due_Cleared BIT,
                Stud_Due_Amount NUMERIC(10,2),
                Remarks NVARCHAR(MAX),
                CreatedBy INT,
                CreatedDate DATETIME,
                UpdatedBy INT,
                UpdatedDate DATETIME
            );
            
            -- Insert data into header table
            INSERT INTO #Header
            SELECT 
                UT.I_Source_Academic_Session,
                UT.I_Destination_Academic_Session,
                UT.I_Student_Detail_ID,
                UT.I_Source_Class_ID,
                UT.I_Source_Stream_ID,
                UT.I_Source_SectionID,
                UT.I_Destination_Class_ID,
                UT.I_Destination_Stream_ID,
                UT.I_Destination_SectionID,
                UT.I_Promotion_Status,
                CASE WHEN t_Stud_Due.Due_Status = 'Paid' THEN 1 ELSE 0 END AS Is_Due_Cleared,
                t_Stud_Due.Stud_Due_Amount,
                UT.Remarks,
                @CreatedByUserID AS CreatedBy,
                GETDATE() AS CreatedDate,
                @CreatedByUserID AS UpdatedBy,
                GETDATE() AS UpdatedDate
            FROM @MyData UT
            INNER JOIN #temp_student_due t_Stud_Due 
                ON t_Stud_Due.Student_Detail_ID = UT.I_Student_Detail_ID
            WHERE NOT EXISTS (
                SELECT 1 FROM T_ERP_Student_Promotion_History_Header trg 
                WHERE trg.I_Student_DetailID = UT.I_Student_Detail_ID
                AND trg.I_Source_Academic_Session = UT.I_Source_Academic_Session
            );
            
            -- Temporary table to capture inserted IDs
            CREATE TABLE #CapturedIDs (
                I_Student_Promotion_History_Header_ID INT,
                I_Student_DetailID INT,
                I_Source_Academic_Session INT
            );
            
            -- Insert into main promotion history header table
            INSERT INTO T_ERP_Student_Promotion_History_Header (
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
                Is_Due_Cleared,
                RemainingDueOfSourceSession,
                S_Last_Remarks,
                CreatedBy,
                Dt_Created_At,
                S_Last_Action_By,
                Dt_Last_Action_At
            )
            OUTPUT INSERTED.I_Student_Promotion_History_Header_ID, INSERTED.I_Student_DetailID, INSERTED.I_Source_Academic_Session
            INTO #CapturedIDs
            SELECT * FROM #Header;
            
            -- Insert into promotion history detail table
            INSERT INTO T_ERP_Student_Promotion_History_Detail (
                I_Student_Promotion_History_Header_ID,
                I_Source_Academic_Session,
                I_Destination_Academic_Session,
                I_Student_DetailID,
                I_Promotion_Status_ID,
                S_Remarks,
                S_Action_By,
                S_Action_On
            )
            SELECT 
                cap.I_Student_Promotion_History_Header_ID,
                UTH.I_Source_Academic_Session,
                UTH.I_Destination_Academic_Session,
                cap.I_Student_DetailID,
                UTH.I_Promotion_Status,
                UTH.Remarks,
                @CreatedByUserID,
                GETDATE()
            FROM @MyData UTH
            INNER JOIN #CapturedIDs cap 
                ON UTH.I_Student_Detail_ID = cap.I_Student_DetailID
                AND UTH.I_Source_Academic_Session = cap.I_Source_Academic_Session;
            
            -- Cleanup temporary tables
            DROP TABLE #temp_student_due;
            DROP TABLE #CapturedIDs;
            DROP TABLE #Header;

        END
        ELSE
        BEGIN
            PRINT 'Update part - to be implemented if required';
        END
		select 1 StatusFlag,'Student Approved Promotion saved' Message    
            COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000),                  
                @ErrSeverity int                  
                  
        SELECT ERROR_MESSAGE() as Message,                  
               0 StatusFlag      
    END CATCH;
END;
