CREATE PROCEDURE [dbo].[uspValidateCenterCourseDeliveryPattern] 
(
	@slstCenterId VARCHAR(100),
	@sCourseID VARCHAR(10),
	@sDeliveryPatternID VARCHAR(10)
)
AS
BEGIN TRY
DECLARE @query VARCHAR(MAX) 
SET @query = 'SELECT I_Centre_Id
FROM dbo.T_Course_Center_Detail A
INNER JOIN dbo.T_Course_Delivery_Map B
ON
A.I_Course_ID = B.I_Course_ID
INNER JOIN
dbo.T_Course_Center_Delivery_FeePlan C
ON
B.I_Course_Delivery_ID = C.I_Course_Delivery_ID
AND
A.I_Course_Center_ID = C.I_Course_Center_ID
WHERE
I_Centre_Id IN ('+ @slstCenterId+')
AND
A.I_Course_ID ='+ @sCourseID+'
AND
I_Delivery_Pattern_ID ='+ @sDeliveryPatternID

EXECUTE (@query)
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
