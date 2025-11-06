-- =============================================
-- Author:		Babin Saha
-- Create date: 04/09/2007
-- Description:	This sp use to get Target Total
-- =============================================
CREATE PROCEDURE [MBP].[uspGetTargetTotal]
(  
@iYear		INT  
,@iMBPPlanType	INT 
,@iProduct INT = NULL	
 ,@iCenterID VARCHAR(8000)  = NULL	
,@iMonth	INT = NULL	
)
AS
BEGIN TRY 

DECLARE @tblMBP TABLE
(
	ID INT IDENTITY(1,1)
	,MD_TotalEnquiry	INT
	,MD_TotalBilling	NUMERIC(18,2)
	,MD_TotalBooking	NUMERIC(18,2)
	,MD_TotalEnrollment	INT
	,MD_ProductID		INT	
	,MD_ProductName		VARCHAR(255)
	,MD_Curency		VARCHAR(20)
	,MD_Curency_ID INT
)
INSERT INTO @tblMBP
			SELECT 
			SUM(MD.I_Target_Enquiry) AS MD_TotalEnquiry, 
			SUM(MD.I_Target_Billing) AS MD_TotalBilling,
			SUM(MD.I_Target_Booking) AS MD_TotalBooking, 
			SUM (MD.I_Target_Enrollment) AS MD_TotalEnrollment,
			PM.I_Product_ID,
			PM.S_Product_Name,
			CURM.S_Currency_Code AS S_Currency_Code,
			TCM.I_Currency_ID
			FROM MBP.T_MBP_Detail MD
			INNER JOIN MBP.T_Product_Master PM
			ON MD.I_Product_ID = PM.I_Product_ID
			INNER JOIN dbo.T_Centre_Master CM
			ON CM.I_Centre_Id = MD.I_Center_Id
			INNER JOIN dbo.T_Country_Master TCM
			ON CM.I_Country_ID = TCM.I_Country_ID
			INNER JOIN dbo.T_Currency_Master CURM
			ON CURM.I_Currency_ID = TCM.I_Currency_ID
			WHERE MD.I_Year = @iYear
			AND MD.I_Type_ID = @iMBPPlanType
			AND PM.I_Product_ID = COALESCE(@iProduct,PM.I_Product_ID)
			AND MD.I_Center_ID IN (SELECT ID FROM [dbo].[fnSplitter](@iCenterID))
			AND MD.I_Month = @iMonth
			GROUP BY PM.I_Product_ID,PM.S_Product_Name,CURM.S_Currency_Code,TCM.I_Currency_ID


INSERT INTO @tblMBP
			SELECT 
			SUM(MDA.I_Target_Enquiry) AS MDA_TotalEnquiry, 
			SUM(MDA.I_Target_Billing) AS MDA_TotalBilling,
			SUM(MDA.I_Target_Booking) AS MDA_TotalBooking, 
			SUM (MDA.I_Target_Enrollment) AS MDA_TotalEnrollment,
			PM.I_Product_ID,
			PM.S_Product_Name,
			CURM.S_Currency_Code AS S_Currency_Code,
			TCM.I_Currency_ID
			FROM MBP.T_MBP_Detail_Audit MDA
			INNER JOIN MBP.T_Product_Master PM
			ON MDA.I_Product_ID = PM.I_Product_ID
			INNER JOIN dbo.T_Centre_Master CM
			ON CM.I_Centre_Id = MDA.I_Center_Id
			INNER JOIN dbo.T_Country_Master TCM
			ON CM.I_Country_ID = TCM.I_Country_ID
			INNER JOIN dbo.T_Currency_Master CURM
			ON CURM.I_Currency_ID = TCM.I_Currency_ID
			WHERE I_Year = @iYear
			AND I_Type_ID =@iMBPPlanType
			AND PM.I_Product_ID = COALESCE(@iProduct,PM.I_Product_ID)
			AND MDA.I_Center_ID IN (SELECT ID FROM [dbo].[fnSplitter](@iCenterID))
			AND MDA.I_Month = @iMonth
			GROUP BY PM.I_Product_ID,PM.S_Product_Name,CURM.S_Currency_Code,TCM.I_Currency_ID


SELECT 
SUM (MD_TotalEnquiry) AS TotalEnquiry
,SUM(MD_TotalBilling) AS TotalBilling
,SUM(MD_TotalBooking) AS TotalBooking
,SUM(MD_TotalEnrollment) AS TotalEnrollment
,MD_ProductName AS ProductName 
,MD_Curency
,MD_Curency_ID	
FROM @tblMBP

GROUP BY MD_ProductID,MD_ProductName ,MD_Curency,MD_Curency_ID	




END TRY


	BEGIN CATCH
	--Error occurred:  
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
