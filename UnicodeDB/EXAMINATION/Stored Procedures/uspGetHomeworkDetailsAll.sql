
CREATE PROCEDURE [EXAMINATION].[uspGetHomeworkDetailsAll] 
	-- Add the parameters for the stored procedure here
   
@iBatchId INT,    
@iCenterId INT    


AS
BEGIN 

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 select I_Homework_ID,S_Homework_Name,S_Homework_Desc,I_Term_ID,I_session_ID,Dt_Submission_Date
  FROM EXAMINATION.T_Homework_Master
  where I_Batch_ID = @iBatchId                              
                and I_Center_ID= @iCenterId and I_Status=1


END
