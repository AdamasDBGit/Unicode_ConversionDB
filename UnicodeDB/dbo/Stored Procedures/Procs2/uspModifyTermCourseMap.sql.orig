-- =============================================
-- Author:		Aritra Saha
-- Create date: 13/03/2007
-- Description:	Adds all the Term Course Mapping
-- =============================================


CREATE PROCEDURE [dbo].[uspModifyTermCourseMap] 
(
	-- Add the parameters for the stored procedure here
	@iCourseID int,
	@sTermCourseMap text,
	@sModifiedBy varchar(20),
	@dModifiedOn datetime
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF
	
	DECLARE @iDocHandle int
	
	BEGIN TRANSACTION
	-- Update the Total number of Sessions for a Course
	UPDATE dbo.T_Course_Master
	SET I_No_Of_Session = 
	(	SELECT COUNT(A.I_Session_ID)
		FROM dbo.T_Session_Module_Map A
		INNER JOIN dbo.T_Module_Term_Map C
		ON A.I_Module_ID = C.I_Module_ID
		INNER JOIN dbo.T_Term_Course_Map D   
		ON C.I_Term_ID = D.I_Term_ID
		AND D.I_Course_ID = @iCourseID
		AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
		AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
		AND A.I_Status <> 0
		AND C.I_Status <> 0
		AND D.I_Status <> 0	),
	S_Upd_By = @sModifiedBy,
	Dt_Upd_On = @dModifiedOn
	WHERE I_Course_ID = @iCourseID
		
    -- Insert statements for procedure here
	UPDATE dbo.T_Term_Course_Map 
	SET Dt_Valid_To = @dModifiedOn,
	S_Upd_By = @sModifiedBy,
	Dt_Upd_On = @dModifiedOn,
	I_STATUS = 0
	WHERE I_Course_ID = @iCourseID
	
	EXEC sp_xml_preparedocument @iDocHandle output,@sTermCourseMap

	CREATE TABLE #TempTable 
	(
		I_Certificate_ID INT,   
		I_Course_ID INT,        
		I_Term_ID INT,          
		I_Sequence INT,         
		C_Examinable CHAR(1),       
		S_Crtd_By VARCHAR(20),                     
		Dt_Crtd_On DATETIME,                   
		Dt_Valid_From DATETIME,              
		I_Status INT
	)

	INSERT INTO #TempTable
	(	I_Certificate_ID,   
		I_Course_ID,        
		I_Term_ID,          
		I_Sequence,         
		C_Examinable,       
		S_Crtd_By,                     
		Dt_Crtd_On,                   
		Dt_Valid_From,              
		I_Status        
		)
	SELECT * FROM OPENXML(@iDocHandle, '/TermCourseMap/TermList',2)
	WITH 
	(	I_Certificate_ID int,   
		I_Course_ID int,        
		I_Term_ID int,          
		I_Sequence int,         
		C_Examinable char(1),       
		S_Crtd_By varchar(20),                     
		Dt_Crtd_On datetime,                   
		Dt_Valid_From datetime,              
		I_Status int   
		)

	UPDATE #TempTable SET I_Certificate_ID = NULL
	WHERE I_Certificate_ID = 0

	INSERT INTO dbo.T_Term_Course_Map
	(	I_Certificate_ID,   
		I_Course_ID,        
		I_Term_ID,          
		I_Sequence,         
		C_Examinable,       
		S_Crtd_By,                     
		Dt_Crtd_On,                   
		Dt_Valid_From,              
		I_Status        
		)
	SELECT * FROM #TempTable

	DROP TABLE #TempTable
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
