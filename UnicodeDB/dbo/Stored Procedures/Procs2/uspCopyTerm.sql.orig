CREATE PROCEDURE [dbo].[uspCopyTerm]
(
	@iSourceTermID INT,	
	
	@sDestinationTermCode VARCHAR(500),
	@sDestinationTermName VARCHAR(500),

	@sUpdatedBy VARCHAR(200),
	@dUpdatedOn DATETIME,
	@iDestinationBrandID INT
)

AS 

BEGIN TRY

    SET NoCount ON ;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @I_Term_Id_New INT
	BEGIN TRANSACTION
	INSERT INTO [dbo].[T_Term_Master]
	(
		[I_Brand_ID]
		,[S_Term_Code]
		,[S_Term_Name]
		,[S_Crtd_By]
		,[S_Upd_By]
		,[Dt_Crtd_On]
		,[Dt_Upd_On]
		,[I_Is_Editable]
		,[I_Status]
		,[I_Total_Session_Count]
	)
	SELECT
	@iDestinationBrandID
	,@sDestinationTermCode
	,@sDestinationTermName
	,@sUpdatedBy
	,NULL
	,@dUpdatedOn
	,NULL
	,[I_Is_Editable]
	,[I_Status]
	,[I_Total_Session_Count]
	FROM [dbo].[T_Term_Master]
	WHERE I_Term_Id=@iSourceTermID

	SET @I_Term_Id_New=SCOPE_IDENTITY()

	INSERT INTO [dbo].[T_Module_Term_Map]
	(
		[I_Term_ID]
		,[I_Module_ID]
		,[I_Sequence]
		,[C_Examinable]
		,[S_Crtd_By]
		,[S_Upd_By]
		,[Dt_Valid_From]
		,[Dt_Crtd_On]
		,[Dt_Valid_To]
		,[Dt_Upd_On]
		,[I_Status]
	)
	SELECT 
	 @I_Term_Id_New
	,[I_Module_ID]
	,[I_Sequence]
	,[C_Examinable]
	,@sUpdatedBy
	,NULL
	,@dUpdatedOn
	,@dUpdatedOn
	,NULL
	,NULL
	,[I_Status]
	FROM [dbo].[T_Module_Term_Map]
	WHERE I_Term_id=@iSourceTermID
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )

END CATCH
