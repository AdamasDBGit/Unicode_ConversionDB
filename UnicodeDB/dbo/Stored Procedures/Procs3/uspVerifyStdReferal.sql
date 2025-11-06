CREATE PROCEDURE [dbo].[uspVerifyStdReferal]
(
@StudentID NVARCHAR(max),
@RefStudentID NVARCHAR(max),
@CentreID INT
)
AS

BEGIN

	DECLARE @stdid nvarchar(max)=NULL
	DECLARE @refstdid nvarchar(max)=NULL
	DECLARE @stdadmdt DATETIME=NULL
	DECLARE @refstdadmdt DATETIME=NULL
	DECLARE @CenterID INT=0
	
	SELECT @stdid=TSD.S_Student_ID,@stdadmdt=TSD.Dt_Crtd_On,@CenterID=TSCD.I_Centre_Id 
	FROM dbo.T_Student_Detail AS TSD 
	INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
	WHERE TSD.S_Student_ID=@StudentID AND TSCD.I_Status=1 AND TSD.I_Status=1
	
	SELECT @refstdid=TSD.S_Student_ID,@refstdadmdt=TSD.Dt_Crtd_On FROM dbo.T_Student_Detail AS TSD WHERE TSD.S_Student_ID=@RefStudentID
	
	IF ((@CenterID!=19 AND @CenterID!=18) OR @CentreID!=@CenterID)
		SELECT 'UnAuthorized Centre' AS RetText,@CentreID AS CentreID
	ELSE IF (@stdid IS NULL)
		SELECT 'Student Does Not Exist' AS RetText,@CentreID AS CentreID
	ELSE IF (@refstdid IS NULL)
		SELECT 'Referred Student Does Not Exist' AS RetText,@CentreID AS CentreID
	ELSE IF (DATEDIFF(d,@stdadmdt,@refstdadmdt)<0)
		SELECT 'Referred Student Admission Date is before the Referrer Student Admission Date. Invalid Reference! ' AS RetText,@CentreID AS CentreID	
	ELSE IF ((YEAR(@refstdadmdt)=YEAR(GETDATE()) AND MONTH(GETDATE())-MONTH(@refstdadmdt)!=1) OR (YEAR(@refstdadmdt)<YEAR(GETDATE()) AND MONTH(@refstdadmdt)!=12 AND MONTH(GETDATE())!=1)) 	
		SELECT ('Referal Student Admission Date Not Within Permissible Range.') AS RetText,@CentreID AS CentreID
	ELSE
		SELECT 'OK' AS RetText,@CentreID AS CentreID	


END


