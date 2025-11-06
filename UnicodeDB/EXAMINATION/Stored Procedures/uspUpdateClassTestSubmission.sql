
CREATE PROCEDURE [EXAMINATION].[uspUpdateClassTestSubmission]
    (
      --@iHomeworkId INT,          
--@iStudentDetailId INT,          
--@dtSubmissionDate datetime = NULL ,          
      @sCreatedBy VARCHAR(20) = NULL ,
      @dCreatedOn DATETIME = NULL ,
      @ClassTestTrackXML XML    
         
    )
AS 
    SET NOCOUNT OFF          
    BEGIN TRY           
        CREATE TABLE #temp1
            (
              I_ClassTest_ID INT ,
              I_Student_Detail_ID INT ,
              Dt_Submission_Date DATETIME ,
              Dt_Return_Date DATETIME ,
              N_Marks VARCHAR(10) ,
              I_Employee_ID INT ,
              I_Status INT ,
              S_Crtd_By VARCHAR(20) ,
              Dt_Crtd_On DATETIME,
              N_Total_Marks VARCHAR(10)
            )        
            
        INSERT  INTO #temp1
                SELECT  T.c.value('@I_ClassTest_ID', 'INT') ,
                        T.c.value('@I_Student_Detail_ID', 'INT') ,
                        T.c.value('@Dt_Submission_Date', 'datetime') ,
                        T.c.value('@Dt_Return_Date', 'datetime') ,
                        T.c.value('@N_Marks', 'VARCHAR(10)') ,
                        T.c.value('@I_Employee_ID', 'INT') ,
                        1 ,
                        @sCreatedBy ,
                        @dCreatedOn,
                        T.c.value('@N_Total_Marks','VARCHAR(10)')
                FROM    @ClassTestTrackXML.nodes('/Root/ClassTestTrack') T ( c )        
                 
           
        UPDATE  EXAMINATION.T_ClassTest_Submission
        SET     Dt_Submission_Date = CASE WHEN ISNULL(T.Dt_Submission_Date, '') = ''
                                          THEN THS.Dt_Submission_Date
                                          WHEN CONVERT(DATE, T.Dt_Submission_Date) = '1900-01-01'
                                          THEN THS.Dt_Submission_Date
                                          ELSE T.Dt_Submission_Date
                                     END ,
                Dt_Return_Date = CASE WHEN ISNULL(T.Dt_Return_Date, '') = ''
                                      THEN THS.Dt_Return_Date
                                      WHEN CONVERT(DATE, T.Dt_Return_Date) = '1900-01-01'
                                      THEN THS.Dt_Return_Date
                                      ELSE T.Dt_Return_Date
                                 END ,
                N_Marks = CASE WHEN T.N_Marks='' THEN NULL
                        ELSE T.N_Marks END  ,
                        N_Total_Marks = CASE WHEN T.N_Total_Marks='' THEN NULL
                        ELSE T.N_Total_Marks END  ,
                I_Employee_ID = CASE WHEN T.I_Employee_ID = ''
                                     THEN THS.I_Employee_ID
                                     ELSE T.I_Employee_ID
                                END ,      
    --I_Employee_ID = T.I_Employee_ID ,    
                Dt_Upd_On = T.Dt_Crtd_On ,
                S_Updt_By = T.S_Crtd_By
        FROM    EXAMINATION.T_ClassTest_Submission AS THS
                INNER JOIN #temp1 AS T ON THS.I_ClassTest_ID = T.I_ClassTest_ID
                                          AND THS.I_Student_Detail_ID = T.I_Student_Detail_ID        
                    
                    
INSERT INTO EXAMINATION.T_ClassTest_Submission
        ( I_ClassTest_ID ,
          I_Student_Detail_ID ,
          Dt_Submission_Date ,
          Dt_Return_Date ,
          N_Marks,
          I_Employee_ID ,
          I_Status ,
          S_Crtd_By ,
          Dt_Crtd_On,
          N_Total_Marks
        )


                SELECT  T.I_ClassTest_ID ,
                        T.I_Student_Detail_ID ,
                        T.Dt_Submission_Date ,
                        CASE WHEN T.Dt_Return_Date = '' THEN NULL
                             ELSE T.Dt_Return_Date
                        END ,
                        N_Marks=CASE WHEN T.N_Marks='' THEN NULL
                        ELSE T.N_Marks END ,    
      --T.I_Employee_ID ,    
                        I_Employee_ID = CASE WHEN T.I_Employee_ID = ''
                                             THEN NULL
                                             ELSE T.I_Employee_ID
                                        END ,
                        T.I_Status ,
                        T.S_Crtd_By ,
                        T.Dt_Crtd_On,
                        N_Total_Marks=CASE WHEN T.N_Total_Marks='' THEN NULL
                        ELSE T.N_Total_Marks END
                FROM    #temp1 AS T
                        LEFT OUTER JOIN EXAMINATION.T_ClassTest_Submission TCTS ON T.I_ClassTest_ID=TCTS.I_ClassTest_ID
                                                              AND T.I_Student_Detail_ID = TCTS.I_Student_Detail_ID
                WHERE   TCTS.I_ClassTest_ID IS NULL        
              
    END TRY              
    BEGIN CATCH              
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT              
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()              
              
        RAISERROR(@ErrMsg, @ErrSeverity, 1)              
    END CATCH
