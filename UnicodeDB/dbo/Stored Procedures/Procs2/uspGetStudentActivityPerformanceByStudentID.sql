CREATE PROCEDURE [dbo].[uspGetStudentActivityPerformanceByStudentID] --[uspGetStudentActivityPerformanceByStudentID] 1280,8645
    (
      @iTermID INT ,
      @iStudentDetailID INT   
    )
AS 
    BEGIN TRY     

        --SELECT  S_First_Name + ' ' + S_Middle_Name + ' ' + S_Last_Name AS StudentName ,
        --        S_Student_ID
        --FROM    dbo.T_Student_Detail AS TSD
        --WHERE   I_Student_Detail_ID = @iStudentDetailID

        SELECT  DISTINCT( S_First_Name + ' ' + S_Middle_Name + ' ' + S_Last_Name) AS StudentName ,
                TSD.S_Student_ID,				
				TSAD.I_Activity_ID ,
                TAM.S_Activity_Name ,
                TAEM.S_Evaluation_Name ,
                TSAP.S_Student_Grade
        INTO    #temp
        FROM    dbo.T_Student_Detail AS TSD,dbo.T_Student_Activity_Details AS TSAD
                INNER JOIN dbo.T_Student_Activity_Performance AS TSAP ON TSAD.I_Student_Activity_ID = TSAP.I_Student_Activity_ID
                INNER JOIN dbo.T_Activity_Master AS TAM ON TSAD.I_Activity_ID = TAM.I_Activity_ID
                INNER JOIN dbo.T_Activity_Evaluation_Master AS TAEM ON TSAP.I_Evaluation_ID = TAEM.I_Evaluation_ID
        WHERE   TSD.I_Student_Detail_ID = @iStudentDetailID
                AND I_Term_ID = @iTermID
                AND TSAD.I_Status = 1
                AND TSAP.I_Status = 1
                
        DECLARE @itdI_Activity_ID INT          
		
		
        DECLARE STUDENTACTIVITY_CURSOR CURSOR FOR           
        SELECT DISTINCT I_Activity_ID
        FROM #temp
		
        OPEN STUDENTACTIVITY_CURSOR           
        FETCH NEXT FROM STUDENTACTIVITY_CURSOR           
		 INTO @itdI_Activity_ID
		 
        WHILE @@FETCH_STATUS = 0 
            BEGIN
        
                DECLARE @cols NVARCHAR(2000)    
                DECLARE @query NVARCHAR(4000)    
		    
                SELECT  @cols = STUFF(( SELECT DISTINCT TOP 100 PERCENT
                                                '],[' + t.S_Evaluation_Name
                                        FROM    #temp AS t
                                        WHERE   I_Activity_ID = @itdI_Activity_ID
                                        ORDER BY '],[' + t.S_Evaluation_Name
                                      FOR
                                        XML PATH('')
                                      ), 1, 2, '') + ']' 
        --SELECT  @cols
		
                SET @query = N'SELECT StudentName,S_Activity_Name,S_Student_ID,I_Activity_ID' + @cols
                    + ' FROM    
(SELECT t1.StudentName,t1.S_Activity_Name,T1.S_Student_ID,t1.I_Activity_ID,t1.S_Evaluation_Name,t1.S_Student_Grade FROM #temp AS t1 where I_Activity_ID = '
                    + CAST(@itdI_Activity_ID AS VARCHAR(10)) + ') p    
PIVOT (MAX([S_Student_Grade]) FOR S_Evaluation_Name IN ( ' + @cols + ' ))    
AS pvt'    

                EXECUTE(@query)  
                FETCH NEXT FROM STUDENTACTIVITY_CURSOR           
			INTO @itdI_Activity_ID      
            END          
			
        CLOSE STUDENTACTIVITY_CURSOR           
        DEALLOCATE STUDENTACTIVITY_CURSOR 
			             
        	
    
        DROP TABLE #temp
    END TRY    
    BEGIN CATCH    
     
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
