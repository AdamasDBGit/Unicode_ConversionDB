-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <21st August 2023>
-- Description:	<for adding guardian>
-- =============================================
CREATE PROCEDURE [guardian].[uspStudentGuardianAdd]
	-- Add the parameters for the stored procedure here
	@sStudentID nvarchar(200) = null,
	@sFirstName nvarchar(200)=null,
	@sMiddleName nvarchar(200)=null,
	@sLastName nvarchar(200)=null,
	@sMobile nvarchar(200) = null,
	@sEmail nvarchar(200) = null,
	@iRelationshipId int = null,
	@iIsPrimary int = null,
	@iBrandID int = null,
	@iParentMasterID int = null,
	@iIsBusTravel int = null
	--@iSlotID int 
	
AS
BEGIN
	BEGIN TRANSACTION

	BEGIN TRY
		DECLARE @iLastParentID int
		DECLARE @iParentID int 

		IF EXISTS (SELECT * FROM T_Student_Detail WHERE S_Student_ID = @sStudentID)
		BEGIN
			IF (@iParentMasterID is Null)
			BEGIN
				--SET @iParentID = (
				--	SELECT TOP 1 TPM.I_Parent_Master_ID
				--	FROM T_Student_Parent_Maps TSPM
				--	INNER JOIN T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
				--	WHERE TSPM.S_Student_ID = @sStudentID AND TPM.I_Relation_ID IN (1, 2)
				--)
				--UPDATE T_Student_Detail SET I_buzzedDB_Slot_ID = @iSlotID WHERE S_Student_ID = @sStudentID;
				INSERT INTO T_Parent_Master
				(
					--I_Parent_Parent_Master_ID,
					I_Relation_ID,
					I_Brand_ID,
					S_Mobile_No,
					S_First_Name,
					S_Middile_Name,
					S_Last_Name,
					S_Guardian_Email,
					I_Status,
					I_IsPrimary,
					I_IsBusTravel
				
				)
				VALUES
				(
					--@iParentID,
					@iRelationshipId,
					@iBrandID,
					@sMobile,
					@sFirstName,
					@sMiddleName,
					@sLastName,
					@sEmail,
					1,
					@iIsPrimary,
					@iIsBusTravel
				)

				SET @iLastParentID = SCOPE_IDENTITY()
				
				INSERT INTO T_Student_Parent_Maps
				(
					I_Brand_ID,
					S_Student_ID,
					I_Parent_Master_ID,
					I_Status
				)
				VALUES
				(
					@iBrandID,
					@sStudentID,
					@iLastParentID,
					1
				)

				SELECT 1 AS StatusFlag, 'Guardian added' AS Message,@iLastParentID AS ParentID
			END
			ELSE
			BEGIN
				SET @iLastParentID = @iParentMasterID

				INSERT INTO T_Student_Parent_Maps
				(
					I_Brand_ID,
					S_Student_ID,
					I_Parent_Master_ID,
					I_Status
				)
				VALUES
				(
					@iBrandID,
					@sStudentID,
					@iLastParentID,
					1
				)

				SELECT 1 AS StatusFlag, 'Guardian added' AS Message,@iLastParentID AS ParentID
			END
		END
		-- Add more logic here for other cases if needed

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
			SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
END
