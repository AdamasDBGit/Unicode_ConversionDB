CREATE  PROCEDURE [dbo].[usp_ERP_SaveAdhocPaymentSchedule]          
(          
    @AdhocPaymentScheduleHeaderID INT = NULL,           
    @AdHocFeeComponentID INT,          
    @Amount DECIMAL(18,2),          
    @SchoolProgramID INT,          
    @StartDate DATETIME,          
    @EndDate DATETIME,          
    @BrandID INT,          
    @SessionID INT,          
    @Description NVARCHAR(max) = NULL,          
    @IsCollectWithHighPriority BIT = 0,     
    @NotifyRecipient BIT = 0,   -- ? new parameter  
    @ScheduleDetails UT_AdhocScheduleDetail READONLY,           
    @StudentDetails UT_AdhocStudentDetail READONLY            
)          
AS          
BEGIN          
    SET NOCOUNT ON;          
    BEGIN TRY          
        BEGIN TRANSACTION;          
          
        -- Step 1: Insert or Update `T_ERP_AdhocPaymentScheduleHeader`          
        IF @AdhocPaymentScheduleHeaderID IS NULL OR @AdhocPaymentScheduleHeaderID = 0          
        BEGIN          
            INSERT INTO T_ERP_AdhocPaymentScheduleHeader          
            (          
                inAdHocFeeComponentID, nAmount, inSchoolProgramID,           
                dtStartDate, dtEndDate, inBrandID, inSessionID, sDescription,          
                IsCollectWithHighPriority, NotifyRecipient   -- ? included  
            )          
            VALUES           
            (          
                @AdHocFeeComponentID, @Amount, @SchoolProgramID,           
                @StartDate, @EndDate, @BrandID, @SessionID, @Description,          
                @IsCollectWithHighPriority, @NotifyRecipient   -- ? included  
            );          
          
            SET @AdhocPaymentScheduleHeaderID = SCOPE_IDENTITY();          
        END          
        ELSE          
        BEGIN          
            -- Update existing schedule          
            UPDATE T_ERP_AdhocPaymentScheduleHeader          
            SET           
                inAdHocFeeComponentID = @AdHocFeeComponentID,          
                nAmount = @Amount,          
                inSchoolProgramID = @SchoolProgramID,          
                dtStartDate = @StartDate,          
                dtEndDate = @EndDate,          
                inBrandID = @BrandID,          
                inSessionID = @SessionID,          
                sDescription = @Description,          
                IsCollectWithHighPriority = @IsCollectWithHighPriority,  
                NotifyRecipient = @NotifyRecipient   -- ? included  
            WHERE inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID;          
        END          
          
        -- Step 2: Delete Students First (Before Deleting Class/Section/Stream)          
        DELETE FROM T_ERP_AdhocPaymentScheduleStudentDetail          
        WHERE inAdhocPaymentScheduleHeaderDetailID IN (          
            SELECT inAdhocPaymentScheduleHeaderDetailID           
            FROM T_ERP_AdhocPaymentScheduleHeaderDetail           
            WHERE inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID          
        )          
        AND NOT EXISTS (          
            SELECT 1           
            FROM @StudentDetails SD          
            WHERE SD.inStudentDetailID = T_ERP_AdhocPaymentScheduleStudentDetail.inStudentDetailID          
        );          
          
        -- Step 3: Delete Removed Classes/Sections/Streams          
        DELETE FROM T_ERP_AdhocPaymentScheduleHeaderDetail          
        WHERE inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID          
        AND NOT EXISTS (          
            SELECT 1           
            FROM @ScheduleDetails SD           
            WHERE SD.inClassID = T_ERP_AdhocPaymentScheduleHeaderDetail.inClassID           
            AND (SD.inStreamID = T_ERP_AdhocPaymentScheduleHeaderDetail.inStreamID OR (SD.inStreamID IS NULL AND T_ERP_AdhocPaymentScheduleHeaderDetail.inStreamID IS NULL))          
            AND SD.inSectionID = T_ERP_AdhocPaymentScheduleHeaderDetail.inSectionID          
        );          
          
        -- Step 4: Insert New Classes          
        INSERT INTO T_ERP_AdhocPaymentScheduleHeaderDetail          
        (inAdhocPaymentScheduleHeaderID, inClassID, inStreamID, inSectionID)          
        SELECT           
            @AdhocPaymentScheduleHeaderID, SD.inClassID, SD.inStreamID, SD.inSectionID          
        FROM @ScheduleDetails SD          
        WHERE NOT EXISTS (          
            SELECT 1           
            FROM T_ERP_AdhocPaymentScheduleHeaderDetail EXISTING          
            WHERE EXISTING.inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID          
            AND EXISTING.inClassID = SD.inClassID          
            AND (EXISTING.inStreamID = SD.inStreamID OR (EXISTING.inStreamID IS NULL AND SD.inStreamID IS NULL))          
            AND EXISTING.inSectionID = SD.inSectionID          
        );          
          
        -- Step 5: Insert Students & Assign Invoice No          
        DECLARE @InsertedRecords TABLE (          
            inAdhocPaymentScheduleStudentDetailID INT,          
            inAdhocPaymentScheduleHeaderDetailID INT,          
            inStudentDetailID INT          
        );          
          
        INSERT INTO T_ERP_AdhocPaymentScheduleStudentDetail          
        (inAdhocPaymentScheduleHeaderDetailID, inStudentDetailID, inPaymentStatus)          
        OUTPUT inserted.inAdhocPaymentScheduleStudentDetailID,           
               inserted.inAdhocPaymentScheduleHeaderDetailID,           
               inserted.inStudentDetailID          
        INTO @InsertedRecords          
        SELECT           
            H.inAdhocPaymentScheduleHeaderDetailID,           
            S.inStudentDetailID,           
            0          
        FROM @StudentDetails S          
        INNER JOIN T_ERP_AdhocPaymentScheduleHeaderDetail H          
            ON H.inClassID = S.inClassID          
            AND (H.inStreamID = S.inStreamID OR (H.inStreamID IS NULL AND S.inStreamID IS NULL))          
            AND H.inSectionID = S.inSectionID          
            AND H.inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID          
        WHERE S.inStudentDetailID IS NOT NULL          
        AND NOT EXISTS (          
            SELECT 1           
            FROM T_ERP_AdhocPaymentScheduleStudentDetail EXISTING          
            WHERE EXISTING.inAdhocPaymentScheduleHeaderDetailID = H.inAdhocPaymentScheduleHeaderDetailID          
            AND EXISTING.inStudentDetailID = S.inStudentDetailID          
        );          
          
        -- Update invoice numbers          
        UPDATE T          
        SET T.sInvoiceNo = 'TEMP/' + RIGHT('000000' + CAST(T.inAdhocPaymentScheduleStudentDetailID AS NVARCHAR(50)), 6)          
        FROM T_ERP_AdhocPaymentScheduleStudentDetail T          
        INNER JOIN @InsertedRecords I          
            ON T.inAdhocPaymentScheduleStudentDetailID = I.inAdhocPaymentScheduleStudentDetailID;          
          
        COMMIT TRANSACTION;          
          
        -- ? Return Status Response          
        SELECT 1 AS StatusFlag, 'Adhoc Schedule Created or Updated Successfully' AS Message,@AdhocPaymentScheduleHeaderID AS Id;          
    END TRY          
    BEGIN CATCH          
        ROLLBACK TRANSACTION;          
        DECLARE @ErrorMessage NVARCHAR(max) = ERROR_MESSAGE();          
        -- Return Error Message          
        SELECT 0 AS StatusFlag, @ErrorMessage AS Message;          
    END CATCH;          
END;    


