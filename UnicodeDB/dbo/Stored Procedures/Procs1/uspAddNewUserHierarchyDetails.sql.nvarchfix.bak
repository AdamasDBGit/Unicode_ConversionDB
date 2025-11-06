CREATE PROCEDURE [dbo].[uspAddNewUserHierarchyDetails] 
(
	@iUserHierarchyDetailId int,
	@iUserId int,	
	@iHierarchyMasterId int,
	@iOldHierarchyDetId int,
	@iNewHierarchyDetId int
	
)

AS
SET NOCOUNT OFF
BEGIN TRY

	BEGIN TRANSACTION

	
	Update T_User_Hierarchy_Details
	set I_Status=0,
	Dt_Valid_To = getdate()
	where  I_User_ID = @iUserId 
	and I_Hierarchy_Master_ID = @iHierarchyMasterId
	and DATEADD(MI, DATEDIFF(MI, 0, Dt_Valid_From), 0)<>DATEADD(MI, DATEDIFF(MI, 0, GETDATE()), 0)
	--and I_Hierarchy_Detail_ID = @iOldHierarchyDetId 
	and I_Status = 1

	IF @iNewHierarchyDetId <> 0
	BEGIN 
	
	if not exists(select * from T_User_Hierarchy_Details where I_User_ID=@iUserId and I_Status=1 and I_Hierarchy_Master_ID=@iHierarchyMasterId and I_Hierarchy_Detail_ID=@iNewHierarchyDetId)
	begin
		Insert into T_User_Hierarchy_Details
		( I_User_Id,
		  I_Hierarchy_Master_ID,
		  I_Hierarchy_Detail_ID,
		  Dt_Valid_From,
		  I_Status
		)

		values
		(   @iUserID,
			@iHierarchyMasterId,
			@iNewHierarchyDetId,
			getdate(),
			1
		)
	end	
	
	END
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
