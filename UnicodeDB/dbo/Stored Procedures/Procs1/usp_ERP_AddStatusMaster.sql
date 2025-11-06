-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <14th Sept 2023>
-- Description:	<to add or update the status master>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddStatusMaster] 
	-- Add the parameters for the stored procedure here
	@StatusDesc NVARCHAR(MAX) null,
    @StatusSMSDesc NVARCHAR(MAX) null,
    @StatusID int null,
    @Amount numeric null,
	@Brandid int null,
	@Is_GST_Applicable bit null,
	 @I_GST_FeeComponent_Catagory_ID int null  ,
	 @Valid_from datetime null,        
  @Valid_to datetime null    
AS
begin transaction
BEGIN TRY 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 DECLARE @createdStatusID INT;
	if(@StatusID>0)
	BEGIN
	if exists (select * from T_Status_Master where S_Status_Desc = @StatusDesc and I_Status_Id != @StatusID and S_Status_Desc_SMS = @StatusDesc)
	BEGIN
	SELECT 0 StatusFlag,'Duplicate Status Master' Message
	END
	ELSE
	BEGIN
	update [dbo].[T_Status_Master] 
	set 
	[S_Status_Desc]					= @StatusDesc,
	[S_Status_Type]					= 'ReceiptType',
	[S_Status_Desc_SMS]				= @StatusSMSDesc,
	[N_Amount]						= @Amount
	
	where I_Status_Id = @StatusID
	IF @Is_GST_Applicable = 0        
  Begin
   EXEC Usp_ERP_DefaultGSTMAP_Comp @StatusID,@BrandID,2
  END
  
	
	SELECT 1 StatusFlag,'Status Updated' Message
	END
	
	END
	ELSE
	BEGIN
	if exists (select * from T_Status_Master where S_Status_Desc = @StatusDesc and S_Status_Desc_SMS = @StatusDesc)
	BEGIN
	SELECT 0 StatusFlag,'Duplicate Status Master' Message
	END
	ELSE
	BEGIN
	DECLARE @StatusValue INT;
	set @StatusValue = (Select Max(I_Status_Value)+1 from T_Status_Master);


	INSERT INTO [dbo].[T_Status_Master]
(
[S_Status_Desc],
[S_Status_Type],
[S_Status_Desc_SMS],
[I_Status_Value],
[N_Amount],
[I_Brand_ID]
)
VALUES
(
	@StatusDesc,
	'ReceiptType',
	@StatusSMSDesc,
	@StatusValue,
	@Amount,
	@Brandid
)
set @createdStatusID = SCOPE_IDENTITY();
IF @Is_GST_Applicable = 1 AND @I_GST_FeeComponent_Catagory_ID IS NOT NULL        
   Begin  
   UPDATE T_ERP_GST_Item_Category        
     SET I_Fee_Component_ID = @createdStatusID        
     WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID   
	 --IF @Valid_from IS NOT NULL AND @Valid_to IS NOT NULL
	  --BEGIN        
      --Insert into T_Tax_Country_Fee_Component        
      --(I_Tax_ID, I_Country_ID, I_Fee_Component_ID, N_Tax_Rate, Dt_Valid_From, Dt_Valid_To, I_Status, S_Crtd_By, Dt_Crtd_On)        
        
      --select I_Tax_ID,        
      -- 1,        
      -- @createdStatusID,        
      -- 0,        
      -- @Valid_from,        
      -- @Valid_to,        
      -- 1,        
      -- 1,        
      -- GETDATE()  from T_Tax_Master where S_Tax_Code in ('CGST', 'SGST', 'IGST')        
    --END 
	
	
   end
   ELSE
   BEGIN
   EXEC Usp_ERP_DefaultGSTMAP_Comp @createdStatusID,@BrandID,2
   END

	SELECT 1 StatusFlag,'Status added' Message
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


	
