CREATE PROC [dbo].[uspCheckIfCertPresent]
(
@iCourseID INT
)
AS 
BEGIN
	
	SET NOCOUNT ON
	
	SELECT ISNULL(I_Certificate_ID,0) I_Certificate_ID FROM dbo.T_Course_Master WHERE I_Course_ID=@iCourseID
	
END
