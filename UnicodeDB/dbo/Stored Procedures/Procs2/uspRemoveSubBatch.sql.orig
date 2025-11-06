

CREATE PROCEDURE [dbo].[uspRemoveSubBatch]  
 @I_Sub_Batch_ID int 
 ,@UpdtBy  varchar(20) =NULL
  ,@UpdtOn  datetime=NULL 
AS  
   
BEGIN  
  UPDATE [dbo].[T_Student_Sub_Batch_Master]
	   SET 
	      [I_Status] = 0
		  ,[S_Updt_By] = @UpdtBy
		  ,[Dt_Upd_On] = @UpdtOn
	 WHERE I_Sub_Batch_ID=@I_Sub_Batch_ID
  
END
