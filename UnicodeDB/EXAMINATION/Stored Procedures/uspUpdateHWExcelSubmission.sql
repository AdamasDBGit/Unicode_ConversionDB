
CREATE PROCEDURE [EXAMINATION].[uspUpdateHWExcelSubmission]
    (
      --@iHomeworkId INT,          
--@iStudentDetailId INT,          
--@dtSubmissionDate datetime = NULL ,          
      @sCreatedBy VARCHAR(20) = NULL ,
      @dCreatedOn DATETIME = NULL ,
      @HWTrackXML XML    
         
    )
AS 
    SET NOCOUNT OFF          
    BEGIN TRY 
    
    DECLARE @BatchID INT
              
        CREATE TABLE #temp1
            (
              I_HW_ID INT ,
              I_Student_Detail_ID INT ,
              S_Student_ID VARCHAR(MAX),
              I_Batch_ID INT,
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
        (
        I_HW_ID,
              S_Student_ID,
              Dt_Submission_Date,
              Dt_Return_Date,
              N_Marks,
              I_Employee_ID,
              I_Status ,
              S_Crtd_By ,
              Dt_Crtd_On,
              N_Total_Marks
        )
                SELECT  T.c.value('@I_ClassTest_ID', 'INT') ,
                        T.c.value('@S_Student_ID', 'VARCHAR(MAX)') ,
                        T.c.value('@Dt_Submission_Date', 'datetime') ,
                        T.c.value('@Dt_Return_Date', 'datetime') ,
                        T.c.value('@N_Marks', 'VARCHAR(10)') ,
                        T.c.value('@I_Employee_ID', 'INT') ,
                        1 ,
                        @sCreatedBy ,
                        @dCreatedOn,
                        T.c.value('@N_Total_Marks','VARCHAR(10)')
                FROM    @HWTrackXML.nodes('/Root/ClassTestTrack') T ( c ) 
                
                --SELECT * FROM #temp1 T;
                

				--select @BatchID=I_Batch_ID from EXAMINATION.T_Homework_Master where I_Homework_ID=
				--(
				--	select TOP 1 I_HW_ID from #temp1
				--)

				--update #temp1 set I_Batch_ID=@BatchID

				--select * from
				--(
				--	select S_Student_ID,COUNT(N_Marks) from #temp1 group by S_Student_ID
				--	having COUNT(N_Marks)>1
				--)


                UPDATE T1
                SET
                T1.I_Student_Detail_ID=T2.I_Student_Detail_ID,T1.I_Batch_ID=T2.I_Batch_ID
                FROM
                #temp1 T1
                INNER JOIN
                (
                SELECT TSD.S_Student_ID,TSD.I_Student_Detail_ID,TSBD.I_Batch_ID FROM
                dbo.T_Student_Detail TSD
                INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID
                WHERE
                TSBD.I_Status=1
                ) T2 ON T1.S_Student_ID = T2.S_Student_ID
                
                --SELECT * FROM #temp1 T;
                
                --SELECT @BatchID=TCTM.I_Batch_ID FROM EXAMINATION.T_Homework_Submission TCTM
                --WHERE
                --TCTM.I_ClassTest_ID=
                --(
                --SELECT TOP 1 I_ClassTest_ID FROM #temp1 T1
                --)
                
                
                 
                
                        
                 
     
        UPDATE  EXAMINATION.T_Homework_Submission
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
                I_Employee_ID = CASE WHEN T.I_Employee_ID = ''
                                     THEN THS.I_Employee_ID
                                     ELSE T.I_Employee_ID
                                END ,      
    --I_Employee_ID = T.I_Employee_ID ,    
                Dt_Updt_On = T.Dt_Crtd_On ,
                S_Updt_By = T.S_Crtd_By
        FROM    EXAMINATION.T_Homework_Submission AS THS
                INNER JOIN #temp1 AS T ON THS.I_Homework_ID = T.I_HW_ID
                                          AND THS.I_Student_Detail_ID = T.I_Student_Detail_ID 
                                          --AND T.I_Batch_ID=@BatchID       
                    
                    
INSERT INTO EXAMINATION.T_Homework_Submission
        ( I_Homework_ID ,
          I_Student_Detail_ID ,
          Dt_Submission_Date ,
          Dt_Return_Date ,
          N_Marks,
          I_Employee_ID ,
          I_Status ,
          S_Crtd_By ,
          Dt_Crtd_On
        )


                SELECT  T.I_Hw_ID ,
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
                        T.Dt_Crtd_On
                FROM    #temp1 AS T
                        LEFT OUTER JOIN EXAMINATION.T_Homework_Submission TCTS ON T.I_HW_ID=TCTS.I_Homework_ID
                                                              AND T.I_Student_Detail_ID = TCTS.I_Student_Detail_ID
                WHERE   TCTS.I_Homework_ID IS NULL  --AND T.I_Batch_ID=@BatchID 
						AND T.I_Student_Detail_ID IS NOT NULL
                    
              
    END TRY              
    BEGIN CATCH              
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT              
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()              
              
        RAISERROR(@ErrMsg, @ErrSeverity, 1)              
    END CATCH
