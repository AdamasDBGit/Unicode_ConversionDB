/*
-- =================================================================
-- Author:Chandan Dey
-- Create date: 29/01/2008 
-- Description: INSERT/UPDATE [LOGISTICS].T_Logistics_Master
-- =================================================================
*/
--EXEC	 [LOGISTICS].[uspPopulateLogisticsItem]	'ACE', 'ACC0014','AA', 159, 3.48, 'B', 'ECM', NULL, 'dbo', 'dbo', '01/30/2008', '01/30/2008'

CREATE PROCEDURE [LOGISTICS].[uspPopulateLogisticsItem]
(
     @sBrandCode		VARCHAR(20)
	,@sItemCode			VARCHAR(50)
	,@sItemDesc			VARCHAR(200)
	,@fItemPriceINR		FLOAT
	,@fItemPriceUSD		FLOAT
	,@sCategory			CHAR(10)
	,@sItemType			VARCHAR(100)
	,@sRemarks			VARCHAR(200)
	,@sCrtdBy			VARCHAR(20)
    ,@sUpdBy			VARCHAR(20)
    ,@dtCrtdOn			DATETIME
	,@dtUpdOn			DATETIME
)
AS
BEGIN TRY
SET NOCOUNT OFF;
	BEGIN
		DECLARE @iBrandID INT
		DECLARE @iItemTypeID INT
		DECLARE @iCount INT
		DECLARE @iReturn INT
		SET @iReturn = 0

		SELECT @iBrandID = I_Brand_ID FROM [dbo].[T_Brand_Master] WHERE S_Brand_Code = @sBrandCode
		SELECT @iItemTypeID = I_Logistics_Type_ID FROM [LOGISTICS].[T_Logistics_Type_Master] WHERE S_Logistics_Type_Desc = @sItemType

		SET @iCount = (SELECT COUNT(*) FROM [LOGISTICS].T_Logistics_Master WHERE I_Brand_ID = @iBrandID AND S_Item_Code = @sItemCode)

		IF(@iBrandID > 0)
		BEGIN
		SET @iReturn = 1
			IF(@iCount > 0)
				BEGIN
					UPDATE [LOGISTICS].T_Logistics_Master SET
						I_Logistics_Type_ID = @iItemTypeID
						,S_Item_Desc = @sItemDesc
						,I_Item_Price_INR = @fItemPriceINR
						,I_Item_Price_USD = @fItemPriceUSD
						,S_Item_Grade = @sCategory
						,S_Remarks = @sRemarks
						,S_Upd_By = @sUpdBy
						,Dt_Upd_On = @dtUpdOn
					WHERE I_Brand_ID = @iBrandID
						  AND S_Item_Code = @sItemCode

				END	

		
			if(@iCount = 0)
				BEGIN
					INSERT INTO [LOGISTICS].T_Logistics_Master 
						(
							I_Brand_ID 
							,I_Logistics_Type_ID
							,S_Item_Code, S_Item_Desc 
							,I_Item_Price_INR 
							,I_Item_Price_USD 
							,S_Item_Grade 
							,S_Remarks 
							,S_Crtd_By 
							,Dt_Crtd_On
						)
						VALUES 
						(
							@iBrandID
							,@iItemTypeID
							,@sItemCode
							,@sItemDesc
							,@fItemPriceINR
							,@fItemPriceUSD
							,@sCategory
							,@sRemarks
							,@sCrtdBy
							,@dtCrtdOn
						)
				END
		END
	END

SELECT @iReturn
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
