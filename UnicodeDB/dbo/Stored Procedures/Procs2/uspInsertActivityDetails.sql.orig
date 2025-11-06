CREATE PROCEDURE [dbo].[uspInsertActivityDetails]     
(      
 @I_Brand_ID      INT   ,   
 @iActivityID  INT = NULL,
 @S_Activity_Name    VARCHAR(50) ,     
 @S_Evaluation_IDs    VARCHAR(MAX)   ,    
 @vEsdCrtdBy      VARCHAR(20) ,    
 @I_Status         INT  ,    
 @vEsdUpdBy      VARCHAR(20) ,    
 @dEsdCrtdOn         DATETIME  ,    
 @dEsdUpdOn      DATETIME ,
 @iflag   INT
)    
AS    
BEGIN TRY   
   BEGIN TRANSACTION T1
  IF @iFlag = 1
  BEGIN
	 INSERT INTO dbo.T_Activity_Master
	         ( S_Activity_Name ,
	           I_Brand_ID ,
	           I_Status ,
	           S_Crtd_By ,
	           Dt_Crtd_On 
	         )
	 VALUES  ( @S_Activity_Name , -- S_Activity_Name - varchar(50)
	           @I_Brand_ID , -- I_Brand_ID - int
	           @I_Status , -- I_Status - int
	           @vEsdCrtdBy , -- S_Crtd_By - varchar(20)
	           @dEsdCrtdOn  -- Dt_Crtd_On - datetime
	           )
	 SET @iActivityID = @@IDENTITY
	 
	 insert into T_ActivityEvalCriteria_Map 
	 select @iActivityID,CAST(Val as INT) from fnString2Rows(@S_Evaluation_IDs,',') 
  END  
  ELSE IF @iflag = 2
  BEGIN
	delete from T_ActivityEvalCriteria_Map where I_Activity_ID = @iActivityID
	
	insert into T_ActivityEvalCriteria_Map 
	select @iActivityID,CAST(Val as INT) from fnString2Rows(@S_Evaluation_IDs,',') 
  END
  ELSE
  BEGIN
	update T_Activity_Master set I_Status = 0 where I_Activity_ID = @iActivityID
	
	delete from T_ActivityEvalCriteria_Map where I_Activity_ID = @iActivityID
  END
  
   
  COMMIT TRANSACTION T1     
END TRY    
BEGIN CATCH    
 ROLLBACK TRANSACTION T1    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
