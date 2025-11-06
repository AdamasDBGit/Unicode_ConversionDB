-- =============================================
-- Author:		Soumyopriyo Saha
-- Create date: 27/09/2010
-- Description:	Deassign Batch From Center
-- =============================================

CREATE PROCEDURE [dbo].[uspDeassignBatchFromCenter]
(	
	@iCenterID INT,
	@iBatchID INT
)				
AS
BEGIN TRY
DELETE FROM	 dbo.T_Center_Batch_Details  WHERE I_Batch_ID = @iBatchID AND I_Centre_Id =  @iCenterID 
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
