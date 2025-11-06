-- =============================================
-- Author:		Aritra Saha
-- Create date: 12/03/2007
-- Description:	Gets the Term List
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTermMaster] 
	-- Add the parameters for the stored procedure here
	@iBrandID int = null,
	@iTermID int=null
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    -- Insert statements for procedure here
	SELECT	MASTER.I_Term_ID,
			MASTER.I_Brand_ID,
			MASTER.S_Term_Code,
			MASTER.S_Term_Name,
			MASTER.I_Total_Session_Count,
			BM.S_Brand_Code,
			BM.S_Brand_Name,
			(SELECT COUNT('X')
	FROM dbo.T_Student_Attendance_Details
	WHERE I_Term_ID = MASTER.I_Term_ID
	) AS I_Is_Editable,
			MASTER.I_Status 
	FROM dbo.T_Term_Master MASTER 
	INNER JOIN dbo.T_Brand_Master BM
	ON MASTER.I_Brand_ID = BM.I_Brand_ID
	WHERE MASTER.I_Status <> 0
	AND MASTER.I_Brand_ID = ISNULL(@iBrandID,MASTER.I_Brand_ID)
	AND MASTER.I_Term_ID = ISNULL(@iTermID,MASTER.I_Term_ID)
	AND BM.I_Status <> 0
	ORDER BY MASTER.S_Term_Code,
			 MASTER.S_Term_Name
END
