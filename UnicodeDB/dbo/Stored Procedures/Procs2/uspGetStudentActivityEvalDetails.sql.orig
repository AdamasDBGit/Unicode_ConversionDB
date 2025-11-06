CREATE PROCEDURE [dbo].[uspGetStudentActivityEvalDetails] --1092,15,743,53,'12-13/0002'
    (    
      @iTermID INT = NULL ,    
      @iActivityID INT = NULL ,    
      @iCenterID INT = NULL ,    
      @iBatchID INT = NULL, 
      @S_StudentID varchar = NULL  
    )    
AS     
    BEGIN TRY     
        
      
        SELECT  TSAD.I_Student_Detail_ID ,    
                TSD.S_Student_ID ,    
                TSD.S_First_Name + ' ' + S_Middle_Name + ' ' + S_Last_Name AS StudentName ,    
                TSAD.I_Student_Activity_ID ,    
                TAEM.I_Evaluation_ID ,    
                TAEM.S_Evaluation_Name ,    
                ISNULL(S_Student_Grade, '') AS S_Student_Grade    
        INTO    #temp    
        FROM    dbo.T_Student_Activity_Details AS TSAD    
                INNER JOIN dbo.T_Activity_Master AS TAM ON TSAD.I_Activity_ID = TAM.I_Activity_ID    
                INNER JOIN dbo.T_Student_Detail AS TSD ON TSAD.I_Student_Detail_ID = TSD.I_Student_Detail_ID    
                INNER JOIN dbo.T_ActivityEvalCriteria_Map AS TAECM ON TAECM.I_Activity_ID = TAM.I_Activity_ID    
                INNER JOIN dbo.T_Activity_Evaluation_Master AS TAEM ON TAECM.I_Evaluation_ID = TAEM.I_Evaluation_ID    
                INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TSAD.I_Batch_ID = TCBD.I_Batch_ID    
                                                              AND I_Centre_Id = @iCenterID    
                LEFT OUTER JOIN dbo.T_Student_Activity_Performance AS TSAP ON TAEM.I_Evaluation_ID = TSAP.I_Evaluation_ID    
                                                              AND TSAD.I_Student_Activity_ID = TSAP.I_Student_Activity_ID    
                                                              AND TSAP.I_Term_ID = @iTermID    
        WHERE   TAM.I_Activity_ID = @iActivityID    
                AND TSAD.I_Batch_ID = @iBatchID   
                AND TAEM.I_Status = 1    
                AND TAM.I_Status = 1    
                AND TSAD.I_Status = 1    
                AND ISNULL(TSAP.I_Status, 1) = 1    
                AND TSD.I_Status = 1  
               AND TSD.S_Student_ID = @S_StudentID
        ORDER BY TSD.I_Student_Detail_ID ,    
                TAEM.S_Evaluation_Name    
      
        SELECT  I_Student_Detail_ID ,    
                StudentName ,    
                S_Student_ID ,    
                I_Student_Activity_ID ,    
                STUFF(( SELECT  ', ' + CAST(I_Evaluation_ID AS VARCHAR(20))    
                        FROM    #temp    
                        WHERE   ( I_Student_Activity_ID = Results.I_Student_Activity_ID    
                                  AND I_Student_Detail_ID = Results.I_Student_Detail_ID    
                                )    
                      FOR    
                        XML PATH('')    
                      ), 1, 2, '') AS EvaluationIDs,  
                STUFF(( SELECT  ', ' + S_Evaluation_Name    
                        FROM    #temp    
                        WHERE   ( I_Student_Activity_ID = Results.I_Student_Activity_ID    
                                  AND I_Student_Detail_ID = Results.I_Student_Detail_ID    
                                )    
                      FOR    
                        XML PATH('')    
                      ), 1, 2, '') AS EvaluationNames     
        INTO    #temp2    
        FROM    #temp Results    
        GROUP BY I_Student_Detail_ID ,    
                StudentName ,    
                S_Student_ID ,    
                I_Student_Activity_ID    
            
      
      
        DECLARE @cols NVARCHAR(2000)    
        DECLARE @query NVARCHAR(4000)    
    
        SELECT  @cols = STUFF(( SELECT DISTINCT TOP 100 PERCENT    
                                        '],[' + t.S_Evaluation_Name    
                                FROM    #temp AS t    
                                ORDER BY '],[' + t.S_Evaluation_Name    
                              FOR    
                                XML PATH('')    
                              ), 1, 2, '') + ']'    
    
        SET @query = N'SELECT A.EvaluationIDs,A.EvaluationNames,B.* FROM #temp2 A inner join (SELECT I_Student_Detail_ID,StudentName,S_Student_ID,I_Student_Activity_ID,'    
            + @cols    
            + ' FROM    
(SELECT t1.I_Student_Detail_ID,t1.S_Student_ID,t1.StudentName,t1.I_Student_Activity_ID,t1.S_Evaluation_Name,t1.S_Student_Grade FROM #temp AS t1) p    
PIVOT (MAX([S_Student_Grade]) FOR S_Evaluation_Name IN ( ' + @cols + ' ))    
AS pvt) B ON A.I_Student_Detail_ID = B.I_Student_Detail_ID    
  AND A.I_Student_Activity_ID = B.I_Student_Activity_ID'    
      
        EXECUTE(@query)    
      
      
      
      
      
        DROP TABLE #temp,#temp2    
    END TRY    
    BEGIN CATCH    
     
        DECLARE @ErrMsg NVARCHAR(4000) ,    
            @ErrSeverity INT    
    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,    
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
