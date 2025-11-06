-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 27/02/2007
-- Description:	Adds all the sales organization for the Brand
-- =============================================
CREATE PROCEDURE [dbo].[uspAddSalesOrganizationsToBrand] 
(
	@iBrandID int,
	@sSalesOrganizationList varchar(500),
	@sTransactionBy varchar(20),
	@dTransactionOn datetime
)

AS
SET NOCOUNT OFF
BEGIN TRY

DECLARE @iSalesOrgID int
DECLARE @iGetIndex int
DECLARE @sSalesOrgID varchar(20)
DECLARE @iLength int

BEGIN TRANSACTION
UPDATE dbo.T_Hierarchy_Brand_Details
SET Dt_Valid_To = GETDATE(),
I_Status = 0,
S_Upd_By = @sTransactionBy,
Dt_Upd_On = @dTransactionOn
WHERE I_Brand_ID = @iBrandID


SET @iGetIndex = CHARINDEX(',',LTRIM(RTRIM(@sSalesOrganizationList)),1)

IF @iGetIndex > 1
BEGIN
	WHILE LEN(@sSalesOrganizationList) > 0
	BEGIN
		SET @iGetIndex = CHARINDEX(',',@sSalesOrganizationList,1)
		SET @iLength = LEN(@sSalesOrganizationList)
		SET @iSalesOrgID = CAST(LTRIM(RTRIM(LEFT(@sSalesOrganizationList,@iGetIndex-1))) AS int)

		INSERT INTO dbo.T_Hierarchy_Brand_Details
		( I_Hierarchy_Master_ID, 
		  I_Brand_ID, 
		  I_Status,
		  Dt_Valid_From, 
		  S_Crtd_By, 
		  Dt_Crtd_On )
		VALUES
		( @iSalesOrgID, 
		  @iBrandID, 
		  1, 
		  GETDATE(),
		  @sTransactionBy, 
		  @dTransactionOn )
		
		SELECT @sSalesOrganizationList = SUBSTRING(@sSalesOrganizationList,@iGetIndex + 1, @iLength - @iGetIndex)
		SELECT @sSalesOrganizationList = LTRIM(RTRIM(@sSalesOrganizationList))

	END

END
COMMIT TRANSACTION
END TRY
BEGIN CATCH    
 ROLLBACK TRANSACTION   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    
END CATCH
