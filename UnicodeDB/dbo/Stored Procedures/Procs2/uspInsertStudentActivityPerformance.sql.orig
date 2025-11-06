CREATE PROCEDURE [dbo].[uspInsertStudentActivityPerformance]
    (
      @sEvaluationXML XML ,
      @sCrtdBy VARCHAR(20) ,
      @sCrtdOn DATETIME ,
      @iEmployeeId INT = null
    )
AS 
    BEGIN TRY 
    
		
        SELECT  T.c.value('@I_Student_Activity_ID', 'int') AS I_Student_Activity_ID,
                T.c.value('@I_Term_ID', 'int') AS I_Term_ID,
                T.c.value('@I_Evaluation_ID', 'int') AS I_Evaluation_ID,
                T.c.value('@S_Grade', 'varchar(50)') AS S_Grade,
                1 AS I_Status,
                @sCrtdBy AS S_Crtd_By,
                @sCrtdOn AS Dt_Crtd_On
        INTO    #temp
        FROM    @sEvaluationXML.nodes('/Root/StudentGrades') T ( c )   
        
        UPDATE  dbo.T_Student_Activity_Performance
        SET     I_Status = 0 ,
                S_Crtd_By = @sCrtdBy ,
                Dt_Crtd_On = @sCrtdOn
        FROM    T_Student_Activity_Performance AS TSAP
                INNER JOIN #temp AS T1 ON TSAP.I_Student_Activity_ID = T1.I_Student_Activity_ID
                                          AND TSAP.I_Term_ID = T1.I_Term_ID
        
        INSERT  INTO dbo.T_Student_Activity_Performance
                ( I_Student_Activity_ID ,
                  I_Term_ID ,
                  I_Evaluation_ID ,
                  S_Student_Grade ,
                  I_Status ,
                  S_Crtd_By ,
                  Dt_Crtd_On 
		        
                )
                SELECT  *
                FROM    #temp
        
        IF(@iEmployeeId is not null) 
        BEGIN       
			UPDATE dbo.T_Student_Activity_Details
			SET I_Employee_ID =	@iEmployeeId
			FROM    T_Student_Activity_Details AS TSAD
			 INNER JOIN #temp AS T1 ON TSAD.I_Student_Activity_ID = T1.I_Student_Activity_ID	
        END        
        
    END TRY
    BEGIN CATCH
	
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT

        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH
