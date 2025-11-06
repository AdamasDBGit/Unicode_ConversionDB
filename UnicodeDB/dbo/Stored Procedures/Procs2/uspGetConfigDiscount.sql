/*****************************************************************************************************************
Created by: Debarshi Basu
Date: 14 July, 2010
Description: Populates the metadata for discount
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetConfigDiscount]

AS
BEGIN

	SELECT ISNULL(CDD.I_Center_Id,0) AS I_Center_Id,
	   CDD.I_Hierarchy_Level_Id,
	   CDD.I_Hierarchy_Detail_ID,
	   CDD.N_Discount_Percentage,	 
	   CDD.I_Center_Discount_Id,  
	   ISNULL(CDD.I_Brand_Id,0) AS I_Brand_Id,
	   HD.S_Hierarchy_Name
FROM dbo.T_Center_Discount_Details CDD
INNER JOIN dbo.T_Hierarchy_Details HD
ON CDD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
WHERE CDD.I_Status = 1

END
