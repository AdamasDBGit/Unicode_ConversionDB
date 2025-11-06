CREATE PROCEDURE [dbo].[uspUpdateStudentCenterDetails]
(
	@iStudentId INT,
	@iCentreId INT,
	@CreatedOn Datetime,
	@CreatedBy varchar(20)	
)

AS

BEGIN TRY
	SET NOCOUNT ON;
	
		DECLARE @iUserId INT
		DECLARE @iHierarchyMasterID INT
		DECLARE @iHierarchyDetailID INT
		-- Update the Student Center Detail
	
		UPDATE dbo.T_Student_Center_Detail 
		SET Dt_Valid_To = @CreatedOn,
			S_Upd_By = @CreatedBy,
			Dt_Upd_On = @CreatedOn,
			I_Status = 0
		WHERE I_Student_Detail_ID = @iStudentId 
		AND I_Status = 1
		
		INSERT INTO dbo.T_Student_Center_Detail
		(
		I_Student_Detail_ID,
		I_Centre_Id,
		Dt_Valid_From,
		I_Status,
		S_Crtd_By,
		Dt_Crtd_On
		)
		VALUES
		(@iStudentId,
		@iCentreId,
		@CreatedOn,
		1,
		@CreatedBy,
		@CreatedOn)
		
		SELECT @iUserId = I_User_ID FROM dbo.T_User_Master WHERE I_Reference_ID = @iStudentId
		
		-- Get the Hierarchy Details of the Destination Center	
		SELECT 	
		@iHierarchyDetailID = I_Hierarchy_Detail_ID,
		@iHierarchyMasterID = I_Hierarchy_Master_ID
		FROM dbo.T_Center_Hierarchy_Details
		WHERE I_Center_Id = @iCentreId
		AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
		AND I_Status = 1
		
		
		-- Update the User Hierarchy Detail of the Student
		UPDATE dbo.T_User_Hierarchy_Details
		SET Dt_Valid_To = @CreatedOn,
			I_Status = 0
		WHERE I_User_ID = @iUserId
		
		INSERT INTO dbo.T_User_Hierarchy_Details
		(
		I_User_ID,
		I_Hierarchy_Master_ID,
		I_Hierarchy_Detail_ID,
		Dt_Valid_From,
		I_Status		
		)
		VALUES
		(
		@iUserId,
		@iHierarchyMasterID,
		@iHierarchyDetailID,
		@CreatedOn,
		1
		)		
		
		-- Close the Student Transfer Request
		UPDATE dbo.T_Student_Transfer_Request
		SET I_Status = 0, Dt_Transfer_Date = getdate()
		WHERE I_Student_Detail_ID = @iStudentId
		
END TRY


BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
