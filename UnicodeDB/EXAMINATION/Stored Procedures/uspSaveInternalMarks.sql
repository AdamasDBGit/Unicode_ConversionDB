/**************************************************************************************************************        
Created by  : Debarshi Basu        
Date  : 01.05.2007        
Description : This SP will save the internal marks of the students        
Parameters  :  @iExamComponentID int,        
    @sInternalMarks xml,        
    @sCreatedBy varchar(20),        
    @DtCreatedOn datetime,        
    @sUpdatedBy  varchar(20),        
    @DtUpdatedOn datetime        
**************************************************************************************************************/        
        
        
CREATE PROCEDURE [EXAMINATION].[uspSaveInternalMarks]
    @iBatchExamID INT = NULL ,
    @iExamComponentID INT ,
    @sInternalMarks XML ,
    @iBatchID INT ,
    @iTermID INT ,
    @iModuleID INT = NULL ,
    @EmployeeIds VARCHAR(MAX) ,
    @iStatus INT ,
    @sCreatedBy VARCHAR(20) ,
    @DtCreatedOn DATETIME ,
    @sUpdatedBy VARCHAR(20) ,
    @DtUpdatedOn DATETIME ,
    @DtExamDate DATETIME
AS
    BEGIN TRY        
        
        BEGIN TRANSACTION         
         
-- Create Temporary Table To store values from XML        
        CREATE TABLE #tempTable
            (
              ID_Identity INT IDENTITY(1, 1) ,
              I_Student_Detail_ID INT ,
              I_Exam_Total NUMERIC(8, 2) ,
              S_Remarks VARCHAR(500) ,
              I_Center_ID INT
            )        
        
-- INsert Values into Temporary Table        
        INSERT  INTO #tempTable
                SELECT  T.c.value('@StudentID', 'int') ,
                        CASE WHEN T.c.value('@Marks', 'varchar(100)') = ''
                             THEN NULL
                             ELSE T.c.value('@Marks', 'numeric(8,2)')
                        END ,
                        CASE WHEN T.c.value('@Remarks', 'varchar(500)') = ''
                             THEN NULL
                             ELSE T.c.value('@Remarks', 'varchar(500)')
                        END ,
                        T.c.value('@CenterID', 'int')
                FROM    @sInternalMarks.nodes('/Students/StudentMarks') T ( c )        
         
         
 -- Insert values into the test design pattern table from temporary table         
        DECLARE @iCount INT        
        DECLARE @iStudentIDTemp INT         
        DECLARE @nExamTotal NUMERIC(8, 2)        
        DECLARE @sRemarks VARCHAR(500)        
        DECLARE @iRowCount INT        
        DECLARE @iCenterID INT        
        SELECT  @iRowCount = COUNT(ID_Identity)
        FROM    #tempTable        
        SET @iCount = 1        
         
         
          
        IF ( @iBatchExamID IS NULL )
            BEGIN        
                INSERT  INTO EXAMINATION.T_Batch_Exam_Map
                        ( I_Batch_ID ,
                          I_Term_ID ,
                          I_Module_ID ,
                          I_Exam_Component_ID ,
                          I_Status ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iBatchID ,
                          @iTermID ,
                          @iModuleID ,
                          @iExamComponentID ,
                          @iStatus ,
                          @sCreatedBy ,
                          @DtCreatedOn
                        )        
            
                SET @iBatchExamID = SCOPE_IDENTITY()          
            
                INSERT  INTO EXAMINATION.T_Batch_Exam_Faculty_Map
                        ( I_Batch_Exam_ID ,
                          I_Employee_ID         
                        )
                        SELECT  @iBatchExamID ,
                                CAST(Val AS INT)
                        FROM    dbo.fnString2Rows(@EmployeeIds, ',') AS FSR        
                          
                WHILE ( @iCount <= @iRowCount )
                    BEGIN        
                        SELECT  @iStudentIDTemp = I_Student_Detail_ID ,
                                @nExamTotal = I_Exam_Total ,
                                @sRemarks = S_Remarks ,
                                @iCenterID = I_Center_ID
                        FROM    #tempTable
                        WHERE   ID_Identity = @iCount        
           
           
                        INSERT  INTO EXAMINATION.T_Student_Marks
                                ( I_Student_Detail_ID ,
                                  I_Batch_Exam_ID ,
                                  I_Exam_ID ,
                                  I_Exam_Total ,
                                  S_Crtd_By ,
                                  Dt_Crtd_On ,
                                  Dt_Exam_Date ,
                                  S_Remarks ,
                                  I_Center_ID        
                                )
                        VALUES  ( @iStudentIDTemp ,
                                  @iBatchExamID ,
                                  NULL ,
                                  @nExamTotal ,
                                  @sCreatedBy ,
                                  @DtCreatedOn ,
                                  @DtExamDate ,
                                  @sRemarks ,
                                  @iCenterID
                                )        
             
                        SET @iCount = @iCount + 1        
                    END            
            END        
        ELSE
            BEGIN        
         
                UPDATE  EXAMINATION.T_Batch_Exam_Map
                SET     S_Updt_By = @sUpdatedBy ,
                        Dt_Updt_On = @DtUpdatedOn
                WHERE   I_Batch_Exam_ID = @iBatchExamID        
            
                DELETE  FROM EXAMINATION.T_Batch_Exam_Faculty_Map
                WHERE   I_Batch_Exam_ID = @iBatchExamID        
               
                INSERT  INTO EXAMINATION.T_Batch_Exam_Faculty_Map
                        ( I_Batch_Exam_ID ,
                          I_Employee_ID         
                        )
                        SELECT  @iBatchExamID ,
                                CAST(Val AS INT)
                        FROM    dbo.fnString2Rows(@EmployeeIds, ',') AS FSR        
               
                WHILE ( @iCount <= @iRowCount )
                    BEGIN        
                        SELECT  @iStudentIDTemp = I_Student_Detail_ID ,
                                @nExamTotal = I_Exam_Total ,
                                @sRemarks = S_Remarks ,
                                @iCenterID = I_Center_ID
                        FROM    #tempTable
                        WHERE   ID_Identity = @iCount        
          
                        IF EXISTS ( SELECT  *
                                    FROM    EXAMINATION.T_Student_Marks AS tsm
                                    WHERE   I_Student_Detail_ID = @iStudentIDTemp
                                            AND I_Batch_Exam_ID = @iBatchExamID )
                            BEGIN      
                                UPDATE  EXAMINATION.T_Student_Marks
                                SET     I_Exam_Total = @nExamTotal ,
                                        S_Remarks = @sRemarks ,
                                        S_Upd_By = @sUpdatedBy ,
                                        Dt_Upd_On = @DtUpdatedOn,
                                        Dt_Exam_Date=@DtExamDate
                                WHERE   I_Student_Detail_ID = @iStudentIDTemp
                                        AND I_Batch_Exam_ID = @iBatchExamID        
                            END    
         
                        ELSE
                            BEGIN     
                                INSERT  INTO EXAMINATION.T_Student_Marks
                                        ( I_Student_Detail_ID ,
                                          I_Batch_Exam_ID ,
                                          I_Exam_ID ,
                                          I_Exam_Total ,
                                          S_Crtd_By ,
                                          Dt_Crtd_On ,
                                          Dt_Exam_Date ,
                                          S_Remarks ,
                                          I_Center_ID        
                                        )
                                VALUES  ( @iStudentIDTemp ,
                                          @iBatchExamID ,
                                          NULL ,
                                          @nExamTotal ,
                                          @sCreatedBy ,
                                          @DtCreatedOn ,
                                          @DtExamDate ,
                                          @sRemarks ,
                                          @iCenterID
                                        )        
                            END         
                        SET @iCount = @iCount + 1        
                    END         
            END        
         
        DROP TABLE #tempTable        
         
        COMMIT TRANSACTION          
    END TRY                          
    BEGIN CATCH                          
 --Error occurred:                            
        ROLLBACK TRANSACTION                           
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT                          
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()                          
                          
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                          
    END CATCH
