CREATE PROCEDURE [dbo].[uspCheckSessionDetails] 
(
	@iCenterID INT,
	@iBatchID INT,
	@iSessionID INT
) 
AS  
BEGIN  
 SET NOCOUNT ON 
 DECLARE @B_SessionFlag BIT  

IF (SELECT count(*) FROM T_TimeTable_Master WHERE I_Batch_ID=@iBatchID and I_Center_ID=@iCenterID and I_Status=1 and I_Session_ID=@iSessionID) >0
BEGIN
	SET @B_SessionFlag=1	
 END
 ELSE
 BEGIN
	SET @B_SessionFlag=0	 
 END
 SELECT @B_SessionFlag
END
