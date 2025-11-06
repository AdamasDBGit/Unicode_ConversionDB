-- =============================================
-- Author:		Swagataa De
-- Create date: 12/03/2007
-- Description:	Get the Module Details
-- =============================================
CREATE PROCEDURE [dbo].[uspGetModuleDetails] 
(
	-- Add the parameters for the stored procedure here
	@iModuleID int
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    -- Module Basic Details
    -- Table[0]
	SELECT	MASTER.I_Module_ID,
			MASTER.I_Skill_ID,
			MASTER.I_Brand_ID,
			MASTER.S_Module_Code,
			MASTER.S_Module_Name,
			MASTER.S_Crtd_By,
			MASTER.S_Upd_By,
			MASTER.Dt_Crtd_On,
			MASTER.Dt_Upd_On,
			MASTER.I_Status, 
			BM.S_Brand_Code,
			BM.S_Brand_Name,
			(SELECT COUNT(A.I_Course_Center_ID) 
	FROM dbo.T_Course_Center_Detail A
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = A.I_Centre_Id
	INNER JOIN dbo.T_Term_Course_Map B
	ON A.I_Course_ID = B.I_Course_ID
	INNER JOIN dbo.T_Module_Term_Map C
	ON B.I_Term_ID = C.I_Term_ID
	INNER JOIN dbo.T_Module_Master D
	ON C.I_Module_ID = D.I_Module_ID
	WHERE C.I_Module_ID = @iModuleID
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND C.I_Status = 1
	AND D.I_Status = 1
	AND CM.I_Status = 1
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())
	AND GETDATE() >= ISNULL(C.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(C.Dt_Valid_To, GETDATE())
	AND GETDATE() >= ISNULL(CM.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(CM.Dt_Valid_To, GETDATE())) AS I_Is_Editable,
			(SELECT COUNT(I_Session_Module_ID)
	FROM dbo.T_Session_Module_Map
	WHERE I_Module_ID = MASTER.I_Module_ID ) AS I_No_Of_Session,
			MASTER.I_Status 
	FROM dbo.T_Module_Master MASTER
	INNER JOIN dbo.T_Brand_Master BM
	ON MASTER.I_Brand_ID = BM.I_Brand_ID
	WHERE MASTER.I_Module_ID = @iModuleID
	AND MASTER.I_Status <> 0
	AND BM.I_Status <> 0
	
	-- Module Book Details
	-- Table[1]
	SELECT	A.I_Module_Book_ID,
			A.I_Book_ID,
			A.I_Status,
			B.S_Book_Code,
			B.S_Book_Name,
			B.S_Book_Desc,
			B.I_Brand_ID
	FROM dbo.T_Module_Book_Map A, dbo.T_Book_Master B
	INNER JOIN dbo.T_Brand_Master BM
	ON B.I_Brand_ID = BM.I_Brand_ID
	WHERE A.I_Module_ID = @iModuleID	 
	AND A.I_Book_ID = B.I_Book_ID
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND A.I_Status <> 0
	AND BM.I_Status <> 0
	
	-- Session List
	-- Table[2]
	SELECT	A.I_Session_Module_ID,
			A.I_Session_ID,
			A.I_Sequence,
			A.I_Status,
			A.I_Module_ID,
			B.I_Session_Type_ID,
			B.I_Brand_ID,
			B.S_Session_Code,
			B.S_Session_Name,
			B.N_Session_Duration,
			B.S_Session_Topic,
			B.I_Is_Editable
	FROM dbo.T_Session_Module_Map A, dbo.T_Session_Master B  
	INNER JOIN dbo.T_Brand_Master BM
	ON B.I_Brand_ID = BM.I_Brand_ID 
	WHERE A.I_Module_ID = @iModuleID
	AND A.I_Session_ID = B.I_Session_ID
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND A.I_Status <> 0
	AND BM.I_Status <> 0

END
