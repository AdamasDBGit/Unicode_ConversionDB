
-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <10th Nov 2023>
-- Description:	<to add or update the class>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddFeeComponent_BKP_Dec2023] 
	-- Add the parameters for the stored procedure here
	@FeeHeadID int NULL,
    @FeeComponent NVARCHAR(MAX),
    @IsRefundable int,
    @SpecialFee int,
    @IsAdhoc int,
    @FinancialAccount NVARCHAR(MAX),
	@Updatedby int
AS
begin transaction
BEGIN TRY 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@FeeHeadID>0)
	BEGIN
	if exists (select * from [dbo].[T_ERP_Fee_Component] where S_Fee_Component_Name = @FeeComponent and I_Fee_Component_ID != @FeeHeadID)
	BEGIN
	SELECT 0 StatusFlag,'Duplicate Fee Component Name' Message
	END
	ELSE
	BEGIN
	update [dbo].[T_ERP_Fee_Component] 
	set 
	[S_Fee_Component_Name] = @FeeComponent,
    [I_is_refundable] = @IsRefundable,
    [I_Is_Special_Fee] = @SpecialFee,
    [I_is_adhoc] = @IsAdhoc,
    [S_financial_account_code] = @FinancialAccount,
	[I_UpdatedBy] = @Updatedby,
	[Dt_UpdatedAt] = GETDATE()
	
	where [I_Fee_Component_ID] = @FeeHeadID
	
	SELECT 1 StatusFlag,'Fee Component updated' Message
	END
	
	END
	ELSE
	BEGIN
	if exists (select * from [dbo].[T_ERP_Fee_Component] where S_Fee_Component_Name = @FeeComponent)
	BEGIN
	SELECT 0 StatusFlag,'Duplicate Fee Component Name' Message
	END
	ELSE
	BEGIN
	INSERT INTO [dbo].[T_ERP_Fee_Component]
(
      [S_Fee_Component_Name]
      ,[I_is_refundable]
      ,[I_Is_Special_Fee]
      ,[I_is_adhoc]
      ,[S_financial_account_code]
      ,[I_CreatedBy]
	  ,[Dt_CreatedAt]
)
VALUES
(
	 @FeeComponent ,
    @IsRefundable ,
    @SpecialFee ,
    @IsAdhoc ,
    @FinancialAccount ,
	@Updatedby,
	GETDATE()
)

	SELECT 1 StatusFlag,'Fee Component added' Message
	END
	
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


	

