CREATE PROCEDURE [dbo].[uspValidateCourseSOLevelAssociation] 
(
	-- Add the parameters for the stored procedure here
	@iCourseID int
)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
	DECLARE @iFlag INT

	SET @iFlag = 0
			
	IF NOT EXISTS(	SELECT	I_Term_ID
					FROM dbo.T_Term_Course_Map WITH(NOLOCK)
					WHERE I_Course_ID = @iCourseID
					AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
					AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
					AND I_Status <> 0	)
	BEGIN
		SET @iFlag = 1
	END
			
	SELECT @iFlag Flag 		

END
