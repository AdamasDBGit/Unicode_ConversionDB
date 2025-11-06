CREATE PROCEDURE [dbo].[uspValidateTermModification] 
(
	@iTermID int
)

AS
BEGIN TRY

	-- Table[0]
	SELECT COUNT(A.I_Course_Center_ID) AS Course_Center
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
	AND GETDATE() <= ISNULL(CM.Dt_Valid_To, GETDATE())
	
	-- Table[1]
	SELECT COUNT(*) AS Course_Fee_Plan FROM dbo.T_Course_Fee_Plan
	WHERE I_Status <> 0 
	AND I_Course_ID IN 
	(SELECT I_Course_ID FROM dbo.T_Term_Course_Map
		WHERE I_Status <> 0
		AND I_Term_ID = @iTermID)
		
	
	-- Table[2]  
	SELECT Count(*) As Module_Count  FROM DBO.T_MODULE_TERM_MAP WHERE I_TERM_ID=@iTermID AND I_STATUS=1
 

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
