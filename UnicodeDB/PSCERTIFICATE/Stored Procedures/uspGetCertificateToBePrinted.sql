-- =============================================
-- Author:		NN
-- Create date: 05/06/2007
-- Description:	
-- =============================================
CREATE PROCEDURE [PSCERTIFICATE].[uspGetCertificateToBePrinted] 
	-- Add the parameters for the stored procedure here
	@iStatus int = 0, 
	@fromDate datetime = null,
	@toDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ISNULL(A.I_student_Certificate_ID,0) AS  I_student_Certificate_ID,
           ISNULL(A.I_Student_Detail_ID,0) AS I_Student_Detail_ID			,
           ISNULL(B.S_First_Name,' ') AS  S_First_Name						,
           ISNULL(B.S_Middle_Name,' ') AS S_Middle_Name						,
           ISNULL(B.S_Last_Name,' ') AS S_Last_Name
	FROM T_Student_PS_Certificate A INNER JOIN T_Student_Detail B
	ON A.I_Student_Detail_ID = B.I_Student_Detail_ID
	AND A.I_Status = @iStatus
	AND A.Dt_Certificate_Issue_Date >= COALESCE(@fromDate, A.Dt_Certificate_Issue_Date)
    AND A.Dt_Certificate_Issue_Date <= COALESCE(@toDate, A.Dt_Certificate_Issue_Date)
END
