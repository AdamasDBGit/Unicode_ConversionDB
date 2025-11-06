CREATE PROCEDURE [dbo].[uspAssignCourseToCenter]

	(
		@sSelectedCenters varchar(1000),
		@sSelectedCourseID varchar(100),
		@sLoginID varchar(200)
	)

AS
BEGIN TRY
	
DECLARE @iGetCenterIndex int
DECLARE @iGetCourseIndex int
DECLARE @iLength int
DECLARE @iCourseListLength int
DECLARE @iCenterID int
DECLARE @iCourseID int
DECLARE @sSelectedCourseIDs varchar(100)

SET @iGetCenterIndex = CHARINDEX(',',LTRIM(RTRIM(@sSelectedCenters)),1)


IF @iGetCenterIndex > 1
BEGIN 
	WHILE LEN(@sSelectedCenters) > 0
	BEGIN
		SET @iGetCenterIndex = CHARINDEX(',',@sSelectedCenters,1)
		SET @iLength = LEN(@sSelectedCenters)
		SET @iCenterID = CAST(LTRIM(RTRIM(LEFT(@sSelectedCenters,@iGetCenterIndex-1))) AS int)
		
		SET @sSelectedCourseIDs = @sSelectedCourseID
		SET @iGetCourseIndex = CHARINDEX(',',LTRIM(RTRIM(@sSelectedCourseIDs)),1)	
		WHILE LEN(@sSelectedCourseIDs) > 0
		BEGIN
			SET @iGetCourseIndex = CHARINDEX(',',@sSelectedCourseIDs,1)
			SET @iCourseListLength = LEN(@sSelectedCourseIDs)
			SET @iCourseID = CAST(LTRIM(RTRIM(LEFT(@sSelectedCourseIDs,@iGetCourseIndex-1))) AS int)
			
			UPDATE T_Course_Center_Detail 
			SET I_Status = 0, 
			S_Upd_By = @sLoginID, 
			Dt_Upd_On = GETDATE(),
			Dt_Valid_To = GETDATE()  
			WHERE I_Centre_ID = @iCenterID 
			AND I_Course_ID= @iCourseID
			
			INSERT INTO T_Course_Center_Detail
			(	I_Course_ID,
				I_Centre_Id,
				I_Status,
				S_Crtd_By,
				Dt_Crtd_On,
				Dt_Valid_From	) 
			VALUES
			(	@iCourseID,
				@iCenterID,
				1,
				@sLoginID,
				GETDATE(),
				GETDATE()	)
				
			-- Set the status of the course as non-editable
			UPDATE dbo.T_Course_Master
			SET I_Is_Editable = 0,
			S_Upd_By = @sLoginID,
			Dt_Upd_On = GETDATE()
			WHERE I_Course_ID = @iCourseID
			AND I_Status = 1
			
			-- Set the status of all the terms associated 
			-- with the course as non-editable
			UPDATE dbo.T_Term_Master
			SET I_Is_Editable = 0,
			S_Upd_By = @sLoginID,
			Dt_Upd_On = GETDATE()
			WHERE I_Status = 1 
			AND I_Term_ID IN 
			(	SELECT	A.I_Term_ID
				FROM dbo.T_Term_Course_Map A 
				INNER JOIN dbo.T_Term_Master B   
				ON A.I_Course_ID = @iCourseID
				AND A.I_Term_ID = B.I_Term_ID
				AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
				AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
				AND A.I_Status <> 0
				AND B.I_Status <> 0	)
				
			-- Set the status of all the modules associated 
			-- with the terms for the course as non-editable
			UPDATE dbo.T_Module_Master
			SET I_Is_Editable = 0,
			S_Upd_By = @sLoginID,
			Dt_Upd_On = GETDATE()
			WHERE I_Status = 1 
			AND I_Module_ID IN
			(	SELECT	A.I_Module_ID
				FROM dbo.T_Module_Term_Map A
				INNER JOIN dbo.T_Module_Master B
				ON A.I_Module_ID = B.I_Module_ID  
				INNER JOIN dbo.T_Term_Course_Map C
				ON A.I_Term_ID = C.I_Term_ID
				AND C.I_Course_ID = @iCourseID
				AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
				AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
				AND A.I_Status <> 0
				AND B.I_Status <> 0
				AND C.I_Status <> 0	)
				
			-- Set the status of all the sessions associated 
			-- with the modules for the terms
			-- which in turn are associated with the course as editable
			UPDATE 	dbo.T_Session_Master
			SET I_Is_Editable = 0,
			S_Upd_By = @sLoginID,
			Dt_Upd_On = GETDATE()
			WHERE I_Status = 1 
			AND I_Session_ID IN
			(	SELECT	A.I_Session_ID
				FROM dbo.T_Session_Module_Map A
				INNER JOIN dbo.T_Session_Master B
				ON A.I_Session_ID = B.I_Session_ID
				INNER JOIN dbo.T_Module_Term_Map C
				ON A.I_Module_ID = C.I_Module_ID
				INNER JOIN dbo.T_Term_Course_Map D   
				ON C.I_Term_ID = D.I_Term_ID
				AND D.I_Course_ID = @iCourseID
				AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
				AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
				AND A.I_Status <> 0
				AND B.I_Status <> 0
				AND C.I_Status <> 0
				AND D.I_Status <> 0	)
			
			SELECT @sSelectedCourseIDs = SUBSTRING(@sSelectedCourseIDs,@iGetCourseIndex + 1, @iCourseListLength - @iGetCourseIndex)
			SELECT @sSelectedCourseIDs = LTRIM(RTRIM(@sSelectedCourseIDs))
		END

		SELECT @sSelectedCenters = SUBSTRING(@sSelectedCenters,@iGetCenterIndex + 1, @iLength - @iGetCenterIndex)
		SELECT @sSelectedCenters = LTRIM(RTRIM(@sSelectedCenters))
	END
END 

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
