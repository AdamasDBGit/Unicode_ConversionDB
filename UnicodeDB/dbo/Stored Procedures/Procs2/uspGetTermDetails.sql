-- =============================================
-- Author:		Debarshi Basu
-- Create date: 12/03/2007
-- Description:	Get the Term Details
-- =============================================uspGetTermDetails 2
CREATE PROCEDURE [dbo].[uspGetTermDetails] 
(
	-- Add the parameters for the stored procedure here
	@iTermID int
)
AS
BEGIN
	SET NOCOUNT OFF

    -- Term Basic Details
    -- Table[0]
	SELECT	MASTER.I_Term_ID,
			MASTER.I_Brand_ID,
			MASTER.S_Term_Code,
			MASTER.S_Term_Name,
			MASTER.I_Total_Session_Count,
			MASTER.S_Crtd_By,
			MASTER.S_Upd_By,
			MASTER.Dt_Crtd_On,
			MASTER.Dt_Upd_On,
			MASTER.I_Status,
			(SELECT COUNT(A.I_Course_Center_ID)
	FROM dbo.T_Course_Center_Detail A
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = A.I_Centre_Id
	INNER JOIN dbo.T_Term_Course_Map B
	ON A.I_Course_ID = B.I_Course_ID
	INNER JOIN dbo.T_Term_Master C
	ON C.I_Term_ID = B.I_Term_ID
	WHERE B.I_Term_ID = @iTermID
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND C.I_Status = 1
	AND CM.I_Status = 1
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())
	AND GETDATE() >= ISNULL(CM.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(CM.Dt_Valid_To, GETDATE())) AS I_Is_Editable,
			MASTER.I_Status 
	FROM dbo.T_Term_Master MASTER 
	WHERE MASTER.I_Term_ID = @iTermID
	AND MASTER.I_Status <> 0

	-- Module List
	-- Table[2]
	SELECT	A.I_Module_Term_ID,
			A.I_Module_ID,
			A.I_Sequence,
			A.I_Status,
			A.C_Examinable,
			B.I_Skill_ID,
			B.I_Brand_ID,
			B.S_Module_Code,
			B.S_Module_Name,
			(SELECT COUNT(I_Session_Module_ID)
	FROM dbo.T_Session_Module_Map
	WHERE I_Module_ID = A.I_Module_ID ) AS I_No_Of_Session
	FROM dbo.T_Module_Term_Map A, dbo.T_Module_Master B   
	INNER JOIN dbo.T_Brand_Master BM
	ON B.I_Brand_ID = BM.I_Brand_ID
	WHERE A.I_Term_ID = @iTermID
	AND A.I_Module_ID = B.I_Module_ID
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND A.I_Status <> 0
	AND BM.I_Status <> 0

END
