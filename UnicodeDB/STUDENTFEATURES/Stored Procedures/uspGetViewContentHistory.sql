CREATE PROCEDURE [STUDENTFEATURES].[uspGetViewContentHistory]
(
@I_Batch_ID int,
@I_Student_Detail_ID int
)
AS
BEGIN
	BEGIN TRY
		SELECT 'Viewed '+TBCD.S_Session_Alias +' on ' +CONVERT(CHAR(10),TSCVH.Dt_Content_Viewed_On,103) ViewHistory		
		FROM dbo.T_Batch_Content_Details AS TBCD
		INNER JOIN STUDENTFEATURES.T_Student_Content_View_History AS TSCVH
		ON TBCD.I_Batch_Content_Details_ID = TSCVH.I_Batch_Content_Details_ID
		WHERE TSCVH.I_Student_Detail_ID=@I_Student_Detail_ID
		AND TBCD.I_Batch_ID=@I_Batch_ID
		
	END TRY
	BEGIN CATCH
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1) 
		
	END CATCH
END
