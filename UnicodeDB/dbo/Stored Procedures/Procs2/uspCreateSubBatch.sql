CREATE PROCEDURE [dbo].[uspCreateSubBatch]                   
(                     
			@I_Batch_ID int 
           ,@S_Sub_Batch_Code NVARCHAR(MAX) 
           ,@S_Sub_Batch_Name NVARCHAR(MAX) 
           ,@I_Status int 
           ,@S_Crtd_By NVARCHAR(MAX)=NULL  
           ,@Dt_Crtd_On datetime=NULL
           ,@I_Sub_Batch_ID int 
           ,@UpdtBy NVARCHAR(MAX) =NULL
           ,@UpdtOn  datetime=NULL       
)                    
AS                    
BEGIN TRY   

  DECLARE @SubBatchCnt1 as INT  
  SELECT @SubBatchCnt1=COUNT(*) FROM   T_Student_Sub_Batch_Master   WHERE S_Sub_Batch_Code=@S_Sub_Batch_Code
           AND S_Sub_Batch_Name=@S_Sub_Batch_Name AND I_Batch_ID=@I_Batch_ID
    
  IF   @I_Sub_Batch_ID=0  AND @SubBatchCnt1=0
  
  BEGIN 
INSERT INTO [dbo].[T_Student_Sub_Batch_Master] 
           ([I_Batch_ID]
           ,[S_Sub_Batch_Code]
           ,[S_Sub_Batch_Name]
           ,[I_Status]
           ,[S_Crtd_By]
           ,[Dt_Crtd_On]
           )
     VALUES
           (@I_Batch_ID
           ,@S_Sub_Batch_Code
           ,@S_Sub_Batch_Name
           ,@I_Status
           ,@S_Crtd_By
           ,@Dt_Crtd_On
          -- ,getdate()
         -- ,convert(datetime,@Dt_Crtd_On,103)
            )
SELECT TOP 1 I_Sub_Batch_ID, S_Sub_Batch_Code FROM dbo.T_Student_Sub_Batch_Master ORDER BY I_Sub_Batch_ID DESC            
END
ELSE
  DECLARE @SubBatchCnt as INT  
  SELECT @SubBatchCnt=COUNT(*) FROM   T_Student_Sub_Batch_Master   WHERE S_Sub_Batch_Code=@S_Sub_Batch_Code
           AND S_Sub_Batch_Name=@S_Sub_Batch_Name AND I_Status=1 AND I_Batch_ID=@I_Batch_ID
    IF @SubBatchCnt =0
    BEGIN
    UPDATE [dbo].[T_Student_Sub_Batch_Master]
	   SET [I_Batch_ID] = @I_Batch_ID
		  ,[S_Sub_Batch_Code] = @S_Sub_Batch_Code
		  ,[S_Sub_Batch_Name] = @S_Sub_Batch_Name
		  ,[I_Status] = @I_Status
		  ,[S_Updt_By] = @UpdtBy
		 -- ,Dt_Upd_On=convert(datetime,@UpdtOn,103)
		  ,[Dt_Upd_On] = @UpdtOn
	 WHERE I_Sub_Batch_ID=@I_Sub_Batch_ID
    END      
           

END TRY            
BEGIN CATCH            
 --Error occurred:              
            
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int            
 SELECT @ErrMsg = ERROR_MESSAGE(),            
   @ErrSeverity = ERROR_SEVERITY()            
            
 RAISERROR(@ErrMsg, @ErrSeverity, 1)            
END CATCH

