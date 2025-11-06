CREATE PROCEDURE [dbo].[uspCheckSuccessfulCenterTransfer] 
(  
  @iTransferRequestId INT = NULL
 ,@iSourceCenterId INT = NULL
 ,@iDestinationCenterId INT = NULL
 ,@iStudentDetailId INT = NULL
)  
AS 
BEGIN

DECLARE @count INT 

SET @count = 0

IF @iTransferRequestId IS NOT NULL
BEGIN
	SELECT @iSourceCenterId = I_Source_Centre_Id
		  ,@iDestinationCenterId = I_Destination_Centre_Id
		  ,@iStudentDetailId = I_Student_Detail_ID
	FROM dbo.T_Student_Transfer_Request
	WHERE I_Transfer_Request_ID = @iTransferRequestId
END

IF EXISTS
(
SELECT 'TRUE' FROM T_INVOICE_PARENT 
WHERE I_STUDENT_DETAIL_ID = @iStudentDetailId
AND I_CENTRE_ID = @iSourceCenterId and I_Status = 0
)
BEGIN
	SET @count = @count + 1
END
IF EXISTS
(
SELECT 'TRUE' FROM T_INVOICE_PARENT 
WHERE I_STUDENT_DETAIL_ID = @iStudentDetailId
AND I_CENTRE_ID = @iSourceCenterId and I_Status = 2
)
BEGIN
	SET @count = @count + 1
END
IF EXISTS
(
SELECT 'TRUE' FROM T_INVOICE_PARENT 
WHERE I_STUDENT_DETAIL_ID = @iStudentDetailId
AND I_CENTRE_ID = @iDestinationCenterId and I_Status = 3
)
BEGIN
	SET @count = @count + 1
END 

IF @count = 3
BEGIN
	SELECT 'TRUE'
END
ELSE
BEGIN
	SELECT 'FALSE'
END
	
END
