-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp use for save data in MBP.T_Product_Master Table 
-- =============================================
CREATE PROCEDURE [MBP].[uspCreateProduct]
(  
@sProductComponent			XML				,
@sProductDescription		VARCHAR (50)	,
@sProductName				VARCHAR (50)	,
@sCrtdBy					VARCHAR(20)		,
@sUpdBy						VARCHAR(20)		,
@dtCrtdOn					DATETIME		,
@dtUpdOn					DATETIME		,
@iBrandID					INT			
)
AS
	BEGIN TRY 
	DECLARE @iProductID INT 

	BEGIN TRANSACTION Trn_Product_Add

		INSERT INTO MBP.T_Product_Master
		(		
		S_Product_Name,
		S_Product_Description,
		S_Crtd_By,
		S_Upd_By,
		Dt_Crtd_On,
		Dt_Upd_On,
		I_Brand_ID
		 )
		VALUES
		(
		@sProductName,
		@sProductDescription,
		@sCrtdBy,
		@sUpdBy,
		@dtCrtdOn,
		@dtUpdOn,
		@iBrandID
		)

	SET @iProductID= SCOPE_IDENTITY();

IF(@iProductID > 0 )
	BEGIN
		-- code enter course id in T_Product_Component from xml
		INSERT INTO MBP.T_Product_Component(I_Product_ID,I_Course_ID,I_Course_Family_ID,S_Crtd_By,S_Upd_By,
		Dt_Crtd_On,Dt_Upd_On )
		SELECT @iProductID,
				T.c.value('@CourseID','int'),
				T.c.value('@CourseFamilyID','int'),
				@sCrtdBy,
				@sUpdBy,
				@dtCrtdOn,
				@dtUpdOn
		FROM @sProductComponent.nodes('/Product/ProductComponent')T(c)
		
		IF(SCOPE_IDENTITY() > 0 )
			BEGIN
			COMMIT TRANSACTION Trn_Product_Add
			END
		ELSE
			BEGIN
			ROLLBACK TRANSACTION Trn_Product_Add
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
