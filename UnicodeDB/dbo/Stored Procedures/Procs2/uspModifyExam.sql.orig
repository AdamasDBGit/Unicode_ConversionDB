-- =============================================
-- Author:		<RAJESH>
-- Create date: <11-01-2007>
-- Description:	<TO MODIFY EXAM>
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyExam]

	-- Add the parameters for the stored procedure here
	@iExamID int,
	@sExamName varchar(50),
	@sExamType varchar(10),	
	@sExamBy varchar(20),
	@dExamOn datetime,	
    @iFlag int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Exam_Component_Master(S_Component_Name, S_Component_Type, S_Crtd_By, Dt_Crtd_On,I_Status)
		VALUES(@sExamName, @sExamType,@sExamBy,@dExamOn,1)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Exam_Component_Master
		SET S_Component_Name = @sExamName,
		S_Component_Type = @sExamType,
		S_Upd_By=@sExamBy,
		Dt_Upd_On = @dExamOn
		where I_Exam_Component_ID = @iExamID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Exam_Component_Master
		SET I_Status = 0,
		S_Upd_By=@sExamBy,
		Dt_Upd_On = @dExamOn
		where I_Exam_Component_ID = @iExamID
	END
END
