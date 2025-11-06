-- User Defined Function

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetStudentRegistrationCount]
(
	@iBatchID INT,
	@iCenterID INT,
	@iStatus INT
)
RETURNS INT
AS
BEGIN
	DECLARE @iCount INT

	SELECT @iCount = COUNT(*) 
	FROM dbo.T_Student_Registration_Details 
	WHERE I_Batch_ID = @iBatchID 
	  AND I_Destination_Center_ID = @iCenterID 
	  AND I_Status = @iStatus
	  
	RETURN @iCount
END