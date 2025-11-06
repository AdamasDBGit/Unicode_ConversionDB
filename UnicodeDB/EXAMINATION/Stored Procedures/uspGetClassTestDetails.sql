
CREATE PROCEDURE [EXAMINATION].[uspGetClassTestDetails]
    (
      --@iHomeworkId INT,        
      @dStartDate DATETIME = NULL ,
      @dEndDate DATETIME = NULL ,
      @iBatchId INT ,
      @iCenterId INT        
        
    )
AS 
    SET NOCOUNT OFF        
    BEGIN TRY         
        
 --SELECT I_Homework_ID,S_Homework_Name,Dt_Submission_Date FROM EXAMINATION.T_Homework_Master AS THM        
 -- WHERE   Dt_Submission_Date BETWEEN ISNULL(@dStartDate,'4/3/2000')        
 --                AND    ISNULL(@dEndDate, GETDATE())                                                 
 --                AND    THM.I_Batch_ID = @iBatchId                                  
 --                AND    THM.I_Center_ID = @iCenterId         
                    
               
               
 --SELECT THM.I_Homework_ID,S_Homework_Name,THM.Dt_Submission_Date,S_Term_Name,S_Session_Name,COUNT(I_Student_Detail_ID) AS I_Student_Count FROM EXAMINATION.T_Homework_Master AS THM      
 --left JOIN EXAMINATION.T_Homework_Submission AS ths    
 --ON THM.I_Homework_ID = ths.I_Homework_ID  
 --LEFT OUTER JOIN dbo.T_Term_Master AS ttm  
 --ON THM.I_Term_ID= ttm.I_Term_ID  
 --LEFT outer JOIN dbo.T_Session_Master AS tsm   
 --ON thm.I_session_ID = tsm.I_Session_ID  
 --WHERE THM.I_Batch_ID = @iBatchId                                  
 --                AND    THM.I_Center_ID = @iCenterId       
 --   AND DATEDIFF(dd, ISNULL(@dStartDate,THM.Dt_Submission_Date), THM.Dt_Submission_Date) >= 0      
 --AND DATEDIFF(dd, ISNULL(@dEndDate,THM.Dt_Submission_Date), THM.Dt_Submission_Date) <= 0       
 --AND thm.I_Status = 1           
 --group BY ths.I_Homework_ID,THM.I_Homework_ID,S_Term_name,S_Session_Name,S_Homework_Name,THM.Dt_Submission_Date
 
 
        SELECT  TCTM.I_ClassTest_ID AS I_Homework_ID ,
                TCTM.S_ClassTest_Name AS S_Homework_Name ,
                CONVERT(DATE, TCTM.Dt_Submission_Date) AS Dt_Submission_Date ,
                TTTM.S_Session_Name AS S_Term_Name ,
                TTTM.S_Session_Topic AS S_Session_Name ,
                TCTM.N_Total_Marks AS N_Total_Marks,
                COUNT(TCTS.I_Student_Detail_ID) AS I_Student_Count
        FROM    EXAMINATION.T_ClassTest_Master TCTM
                LEFT JOIN EXAMINATION.T_ClassTest_Submission TCTS ON TCTM.I_ClassTest_ID = TCTS.I_ClassTest_ID
                LEFT OUTER JOIN dbo.T_TimeTable_Master TTTM ON TCTM.I_TimeTable_ID = TTTM.I_TimeTable_ID
        WHERE   TCTM.I_Batch_ID = @iBatchId
                AND TCTM.I_Center_ID = @iCenterId
                AND DATEDIFF(dd, ISNULL(@dStartDate, TCTM.Dt_Submission_Date),
                             TCTM.Dt_Submission_Date) >= 0
                AND DATEDIFF(dd, ISNULL(@dEndDate, TCTM.Dt_Submission_Date),
                             TCTM.Dt_Submission_Date) <= 0
                AND TCTM.I_Status = 1
        GROUP BY TCTM.I_ClassTest_ID ,
                TCTM.S_ClassTest_Name ,
                TCTM.Dt_Submission_Date ,
                TTTM.S_Session_Name ,
                TTTM.S_Session_Topic,
                TCTM.N_Total_Marks
                       
            
    END TRY            
    BEGIN CATCH            
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()            
            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH         
        
        
--EXEC [EXAMINATION].uspGetHomeworkDetails '','',763,794
