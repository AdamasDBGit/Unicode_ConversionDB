CREATE PROCEDURE [dbo].[usp_ERP_Exam_UpsertExamType]  
(  
    @inExamTypeID INT = NULL,    
    @stExamTypeName NVARCHAR(max),   
    @inTYPE INT,                 
    @inBrandID INT,               
    @IsMainExam BIT               
)  
AS  
BEGIN  
    SET NOCOUNT ON;   
    BEGIN TRANSACTION;   
  
    BEGIN TRY  
        -- Check for duplicate Exam Type Name  
        IF EXISTS (  
            SELECT 1   
            FROM [dbo].[T_ERP_Exam_Type_Master]  
            WHERE stExamTypeName = @stExamTypeName  
            AND (@inExamTypeID IS NULL OR inExamTypeID <> @inExamTypeID)  
        )  
        BEGIN  
            ROLLBACK TRANSACTION;  
            SELECT 0 AS StatusFlag, 'Duplicate Exam Type Name exists.' AS Message;  
            RETURN;  
        END  
  
        -- Insert or Update logic  
        IF @inExamTypeID IS NULL  
        BEGIN  
            INSERT INTO [dbo].[T_ERP_Exam_Type_Master]  
            (  
                stExamTypeName,  
                inTYPE,  
                inBrandID,  
                IsMainExam  
            )  
            VALUES  
            (  
                @stExamTypeName,  
                @inTYPE,  
                107,  
                @IsMainExam  
            );  
            SELECT 1 AS StatusFlag, 'Exam Type inserted successfully.' AS Message;  
        END  
        ELSE  
        BEGIN  
            UPDATE [dbo].[T_ERP_Exam_Type_Master]  
            SET  
                stExamTypeName = @stExamTypeName,  
                inTYPE = @inTYPE,  
                inBrandID = 107,  
                IsMainExam = @IsMainExam  
            WHERE  
                inExamTypeID = @inExamTypeID;  
            SELECT 1 AS StatusFlag, 'Exam Type updated successfully.' AS Message;  
        END  
  
        COMMIT TRANSACTION;   
    END TRY  
    BEGIN CATCH  
        ROLLBACK TRANSACTION;   
        DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity INT;  
        SELECT @ErrMsg = ERROR_MESSAGE(),  
               @ErrSeverity = ERROR_SEVERITY();  
        SELECT 0 AS StatusFlag, @ErrMsg AS Message;  
    END CATCH  
END  

