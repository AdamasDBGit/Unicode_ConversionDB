CREATE PROCEDURE [MBP].[uspGetMBPValueForExcelSheet]
(	
	@iCenterID INT = NULL,
	@iYear INT = NULL
)
AS
BEGIN
SELECT * from MBP.T_MBP_Detail
where I_Center_ID =@iCenterID and I_Year =@iYear
END
