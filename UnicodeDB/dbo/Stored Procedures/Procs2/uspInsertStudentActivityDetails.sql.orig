CREATE PROCEDURE [dbo].[uspInsertStudentActivityDetails]
    (
      @S_Activity_IDs VARCHAR(MAX) = NULL ,
      @I_Student_Detail_ID INT ,
      @I_Batch_ID INT ,
      @sCrtdBy VARCHAR(20) ,
      @iStatus INT ,
      @dtCrtdOn DATETIME   
 
 
    )
AS 
    BEGIN TRY   
        BEGIN TRANSACTION T1 
	----Akash
	--INSERT INTO dbo.T_Student_Activity_Details_Archive
	--        ( I_Student_Activity_ID ,
	--          I_Student_Detail_ID ,
	--          I_Batch_ID ,
	--          I_Activity_ID ,
	--          I_Status ,
	--          S_Crtd_By ,
	--          Dt_Crtd_On,
	--          I_Employee_ID
	--        )
	--SELECT I_Student_Activity_ID ,
	--          I_Student_Detail_ID ,
	--          I_Batch_ID ,
	--          I_Activity_ID ,
	--          I_Status ,
	--          @sCrtdBy ,
	--          GETDATE() ,
	--          I_Employee_ID
	--           FROM dbo.T_Student_Activity_Details TSAD
	--WHERE
	--I_Student_Detail_ID = @I_Student_Detail_ID
	--AND
	--I_Batch_ID=@I_Batch_ID
	----Akash End
	
	
	--delete from T_Student_Activity_Details where I_Student_Detail_ID = @I_Student_Detail_ID 
	-----Akash 17.10.2014
	--and I_Batch_ID=@I_Batch_ID
	-----Akash 17.10.2014
	
	
        CREATE TABLE #temp
            (
              ID INT IDENTITY(1, 1) ,
              ActivityID INT
            )
        INSERT  INTO #temp
                ( ActivityID 
                )
                SELECT  CAST(Val AS INT)
                FROM    dbo.fnString2Rows(@S_Activity_IDs, ',') FSR
	
        DECLARE @i INT= 1
        DECLARE @j INT= ( SELECT    COUNT(ID)
                          FROM      #temp
                        )
	
        WHILE ( @i <= @j ) 
            BEGIN
	
                IF NOT EXISTS ( SELECT  *
                                FROM    dbo.T_Student_Activity_Details TSAD
                                        WITH ( NOLOCK )
                                WHERE   TSAD.I_Student_Detail_ID = @I_Student_Detail_ID
                                        AND TSAD.I_Batch_ID = @I_Batch_ID
                                        AND TSAD.I_Status IN ( 0, 1 )
                                        AND TSAD.I_Activity_ID = ( SELECT
                                                              TT.ActivityID
                                                              FROM
                                                              #temp TT
                                                              WHERE
                                                              TT.ID = @i
                                                              ) ) 
                    BEGIN
	
                        INSERT  INTO dbo.T_Student_Activity_Details
                                ( I_Student_Detail_ID ,
                                  I_Batch_ID ,
                                  I_Activity_ID ,
                                  I_Status ,
                                  S_Crtd_By ,
                                  Dt_Crtd_On	          
	                          )
                                SELECT  @I_Student_Detail_ID ,
                                        @I_Batch_ID ,
                                        ActivityID ,
                                        @iStatus ,
                                        @sCrtdBy ,
                                        @dtCrtdOn
                                FROM    #temp T1
                                WHERE   T1.ID = @i
	         
	         
	         
                    END
	         
                ELSE 
                    BEGIN
	         
                        UPDATE  dbo.T_Student_Activity_Details
                        SET     I_Status = 1,Dt_Updt_On=@dtCrtdOn,S_Updt_By=@sCrtdBy
                        WHERE   I_Student_Detail_ID = @I_Student_Detail_ID
                                AND I_Batch_ID = @I_Batch_ID
                                AND I_Status = 0
                                AND I_Activity_ID = ( SELECT  TT.ActivityID
                                                      FROM    #temp TT
                                                      WHERE   TT.ID = @i
                                                    )
                    END
	         
	         
                SET @i = @i + 1
	         
            END
	         
        UPDATE  dbo.T_Student_Activity_Details
        SET     I_Status = 0,Dt_Updt_On=@dtCrtdOn,S_Updt_By=@sCrtdBy
        WHERE   I_Activity_ID NOT IN ( SELECT   T1.ActivityID
                                       FROM     #temp T1 )
                AND I_Student_Detail_ID = @I_Student_Detail_ID
                AND I_Batch_ID = @I_Batch_ID
	         
        DROP TABLE #temp
	         
	         
	         
	 --select @I_Student_Detail_ID,@I_Batch_ID,cast(Val as int),@iStatus,@sCrtdBy,@dtCrtdOn
	 --from fnString2Rows(@S_Activity_IDs,',')
	
 
   
        COMMIT TRANSACTION T1     
    END TRY    
    BEGIN CATCH    
        ROLLBACK TRANSACTION T1    
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
