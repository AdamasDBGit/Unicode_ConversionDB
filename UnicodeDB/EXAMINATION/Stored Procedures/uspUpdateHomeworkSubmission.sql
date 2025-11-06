CREATE PROCEDURE [EXAMINATION].[uspUpdateHomeworkSubmission]    
    (    
      --@iHomeworkId INT,          
--@iStudentDetailId INT,          
--@dtSubmissionDate datetime = NULL ,          
      @sCreatedBy VARCHAR(20) = NULL ,    
      @dCreatedOn DATETIME = NULL ,    
      @HomeworkTrackXML XML    
         
    )    
AS     
    SET NOCOUNT OFF          
    BEGIN TRY           
        CREATE TABLE #temp1    
            (    
              I_Homework_ID INT ,    
              I_Student_Detail_ID INT ,    
              Dt_Submission_Date DATETIME ,    
              Dt_CCO_Submission_Date DATETIME,    
              Dt_Faculty_Submission_Date DATETIME,    
              Dt_Return_Date DATETIME ,    
              S_Material_BarCode nvarchar(500),    
              S_Remarks VARCHAR(100) ,    
              I_Employee_ID INT,    
              I_Status INT ,    
              S_Crtd_By VARCHAR(20) ,    
              Dt_Crtd_On DATETIME    
            )        
            
        INSERT  INTO #temp1    
                SELECT  T.c.value('@I_Homework_ID', 'INT') ,    
                        T.c.value('@I_Student_Detail_ID', 'INT') ,    
                        T.c.value('@Dt_Submission_Date', 'datetime') ,    
                        T.c.value('@Dt_CCO_Submission_Date', 'datetime') ,    
                        T.c.value('@Dt_Faculty_Submission_Date', 'datetime') ,    
                        T.c.value('@Dt_Return_Date', 'datetime') ,    
                        T.c.value('@S_MaterialBarCode', 'NVARCHAR(500)') ,    
                        T.c.value('@S_Remarks', 'VARCHAR(100)') ,    
                        T.c.value('@I_Employee_ID', 'INT') ,    
                        1 ,    
                        @sCreatedBy ,    
                        @dCreatedOn    
                FROM    @HomeworkTrackXML.nodes('/Root/HomeworkTrack') T ( c )        
                 
           
  UPDATE  EXAMINATION.T_Homework_Submission    
  SET     Dt_Submission_Date = CASE WHEN ISNULL(T.Dt_Submission_Date, '') = '' THEN THS.Dt_Submission_Date WHEN CONVERT(DATE, T.Dt_Submission_Date) = '1900-01-01' THEN THS.Dt_Submission_Date  ELSE T.Dt_Submission_Date  END,         
    Dt_CCO_Submission_Date = CASE WHEN ISNULL(T.Dt_CCO_Submission_Date, '') = '' THEN THS.Dt_CCO_Submission_Date WHEN CONVERT(DATE, T.Dt_CCO_Submission_Date) = '1900-01-01' THEN THS.Dt_CCO_Submission_Date ELSE T.Dt_CCO_Submission_Date END ,    
    Dt_Faculty_Submission_Date = CASE WHEN ISNULL(T.Dt_Faculty_Submission_Date, '') = '' THEN THS.Dt_Faculty_Submission_Date WHEN CONVERT(DATE, T.Dt_Faculty_Submission_Date) = '1900-01-01' THEN THS.Dt_Faculty_Submission_Date  ELSE T.Dt_Faculty_Submission_Date END ,   
    Dt_Return_Date = CASE WHEN ISNULL(T.Dt_Return_Date, '') = '' THEN THS.Dt_Return_Date WHEN CONVERT(DATE, T.Dt_Return_Date) = '1900-01-01' THEN THS.Dt_Return_Date    ELSE T.Dt_Return_Date END ,    
    S_Material_BarCode=T.S_Material_BarCode,    
    N_Marks = CASE WHEN T.S_Remarks='' THEN NULL
                        ELSE T.S_Remarks END,
	--T.S_Remarks ,
	
    I_Employee_ID = CASE WHEN T.I_Employee_ID = '' THEN THS.I_Employee_ID    
          ELSE T.I_Employee_ID    
        END,      
    --I_Employee_ID = T.I_Employee_ID ,    
    Dt_Updt_On = T.Dt_Crtd_On ,    
    S_Updt_By = T.S_Crtd_By    
  FROM    EXAMINATION.T_Homework_Submission AS THS    
    INNER JOIN #temp1 AS T ON THS.I_Homework_ID = T.I_Homework_ID    
            AND THS.I_Student_Detail_ID = T.I_Student_Detail_ID        
                    
                    
        INSERT  INTO EXAMINATION.T_Homework_Submission    
                ( I_Homework_ID ,    
                  I_Student_Detail_ID ,    
                  Dt_Submission_Date ,    
                  Dt_CCO_Submission_Date,    
                  Dt_Faculty_Submission_Date,    
                  Dt_Return_Date ,    
                  S_Material_BarCode,    
                  N_Marks ,    
                  I_Employee_ID ,    
                  I_Status ,    
                  S_Crtd_By ,    
                  Dt_Crtd_On          
                )    
                SELECT  T.I_Homework_ID ,    
      T.I_Student_Detail_ID,    
      T.Dt_Submission_Date,    
      CASE WHEN T.Dt_CCO_Submission_Date = '' THEN NULL ELSE T.Dt_CCO_Submission_Date END ,    
      CASE WHEN T.Dt_Faculty_Submission_Date = '' THEN NULL ELSE T.Dt_Faculty_Submission_Date END ,    
      CASE WHEN T.Dt_Return_Date = '' THEN NULL ELSE T.Dt_Return_Date END ,    
      T.S_Material_BarCode,    
      CASE WHEN T.S_Remarks='' THEN NULL
                        ELSE T.S_Remarks END  ,    
      --T.I_Employee_ID ,    
      I_Employee_ID = CASE WHEN T.I_Employee_ID = '' THEN NULL    
          ELSE T.I_Employee_ID    
        END,      
      T.I_Status  ,    
      T.S_Crtd_By  ,    
      T.Dt_Crtd_On     
                FROM    #temp1 AS T    
                        LEFT OUTER JOIN EXAMINATION.T_Homework_Submission AS THS ON T.I_Homework_ID = THS.I_Homework_ID    
                                                              AND T.I_Student_Detail_ID = THS.I_Student_Detail_ID    
                WHERE   THS.I_Homework_ID IS NULL        
              
    END TRY              
    BEGIN CATCH              
        DECLARE @ErrMsg NVARCHAR(4000) ,    
            @ErrSeverity INT              
        SELECT  @ErrMsg = ERROR_MESSAGE() ,    
                @ErrSeverity = ERROR_SEVERITY()              
              
        RAISERROR(@ErrMsg, @ErrSeverity, 1)              
    END CATCH
