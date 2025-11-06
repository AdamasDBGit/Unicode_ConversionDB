-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp return the detail of upload document
-- =============================================
CREATE PROCEDURE [MBP].[uspUploadMBPDocument]
(  
		 @iProductid				INT = NULL
		,@iCenterid					INT = NULL
		,@iHierarchyDetailID		INT = NULL
		,@iDocumentID				INT	 = NULL
		,@iYear						INT	 = NULL
		,@iMonth					INT = NULL
		,@istatusId					INT = NULL
		,@itypeId					INT = NULL
		,@sCrtdBy					VARCHAR(20) = NULL
		,@dtCrtdOn					DATETIME 
)
AS
	BEGIN TRY  
	DECLARE @iCount INT ,@iMBP_Detail_ID INT

		
		SET @iCount = (SELECT Count(*) FROM MBP.T_MBP_Detail
		WHERE I_Product_ID = COALESCE(@iProductid,I_Product_ID)
		--AND I_Hierarchy_Detail_ID = COALESCE(@iHierarchyDetailID,I_Hierarchy_Detail_ID)
		AND I_Year = @iYear
		AND I_Month = @iMonth
		AND I_Type_ID = @itypeId)

		SET @iMBP_Detail_ID = (SELECT I_MBP_Detail_ID FROM MBP.T_MBP_Detail
		WHERE I_Product_ID = COALESCE(@iProductid,I_Product_ID)
		--AND I_Hierarchy_Detail_ID = COALESCE(@iHierarchyDetailID,I_Hierarchy_Detail_ID)
		AND I_Year = @iYear
		AND I_Month = @iMonth
		AND I_Type_ID = @itypeId)
--SELECT @iCount
--SELECT @iMBP_Detail_ID
		IF @iCount = 0
		BEGIN
		INSERT INTO MBP.T_MBP_Detail
		(
			I_Product_ID
			,I_Center_ID
			,I_Hierarchy_Detail_ID
			,I_Document_ID		
			,I_Year
			,I_Month
			,I_Status_ID
			,I_Type_ID
			,S_Crtd_By
			,Dt_Crtd_On
		)

		VALUES
		(
			@iProductid
			,@iCenterid
			,@iHierarchyDetailID
			,@iDocumentID
			,@iYear
			,@iMonth
			,@istatusId
			,@itypeId
			,@sCrtdBy
			,@dtCrtdOn	
		)
			--PRINT 'INSERT'	
		END
		IF @iCount<> 0 AND EXISTS(SELECT I_MBP_Detail_ID FROM MBP.T_MBP_Detail WHERE I_MBP_Detail_ID=@iMBP_Detail_ID) AND @iMBP_Detail_ID<>0
		BEGIN
			UPDATE MBP.T_MBP_Detail
			SET I_Document_ID = @iDocumentID
			, S_Upd_By = @sCrtdBy
			, Dt_Upd_On = @dtCrtdOn

			WHERE I_MBP_Detail_ID = @iMBP_Detail_ID
			
			--PRINT 'UPDATE'
		END
	END TRY
			BEGIN CATCH
			--Error occurred:  
				DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
				SELECT	@ErrMsg = ERROR_MESSAGE(),
						@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END CATCH
