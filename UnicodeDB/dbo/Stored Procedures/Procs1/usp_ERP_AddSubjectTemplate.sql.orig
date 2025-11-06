-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <25th Sept 2023>
-- Description:	<to add the template header>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddSubjectTemplate]
	-- Add the parameters for the stored procedure here
	@iBrandID int ,
	@iSubjectTemplateHeaderID int = null,
	@sSubjectTitle varchar(255),
	@iIsDefault int,
	@iCreatedBy int,
	@UTSubjectStructure UT_SubjectStructure readonly
AS
begin transaction
BEGIN TRY 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @iLsatID int
	if(@iSubjectTemplateHeaderID>0)
	BEGIN
	if exists (select * from [dbo].[T_ERP_Subject_Template_Header] where S_Title = @sSubjectTitle and I_Brand_ID = @iBrandID)
	BEGIN
	SELECT 0 StatusFlag,'Duplicate Subject Template Name' Message
	END
	
	ELSE
	BEGIN
	update [dbo].[T_ERP_Subject_Template_Header] 
	set 
	[S_Title]						= @sSubjectTitle,
	[I_IsDefault]					= @iIsDefault
	
	where [I_Brand_ID] = @iBrandID and [I_Subject_Template_Header_ID] =@iSubjectTemplateHeaderID
	
	SELECT 1 StatusFlag,'Subject Template updated' Message
	END
	
	END
	ELSE
	BEGIN
	INSERT INTO [dbo].[T_ERP_Subject_Template_Header]
(
[S_Title],
[I_Brand_ID],
[I_IsDefault],
[I_CreatedBy],
[Dt_CreatedAt]
)
VALUES
(
	@sSubjectTitle,
	@iBrandID,
	@iIsDefault,
	@iCreatedBy,
	GETDATE()
)

set @iLsatID = SCOPE_IDENTITY()
INSERT into [T_ERP_Subject_Template]
(
 [I_Subject_Template_Header_ID]
,[S_Structure_Name]
,[I_Sequence_Number]
,[I_IsLeaf_Node]
)
select 
@iLsatID
,StructureName
,SequenceNumber
,IsLeaf
 from @UTSubjectStructure
	SELECT 1 StatusFlag,'Subject Template added' Message
	END
	
	END
	
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
END CATCH
commit transaction
