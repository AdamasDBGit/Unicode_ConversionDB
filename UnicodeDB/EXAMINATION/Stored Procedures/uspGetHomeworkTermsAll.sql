
CREATE PROCEDURE [EXAMINATION].[uspGetHomeworkTermsAll] 
	-- Add the parameters for the stored procedure here
   
@iBatchId INT  

AS
BEGIN 

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 select T.I_Term_ID,S_Term_Name
  FROM T_Term_Master T INNER JOIN EXAMINATION.T_Homework_Master H
  ON T.I_Term_ID=H.I_Term_ID
  where I_Batch_ID = @iBatchId                              
               


END
