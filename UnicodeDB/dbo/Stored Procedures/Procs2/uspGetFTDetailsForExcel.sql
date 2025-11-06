/*****************************************************************************
Created by  : Debarshi Basu
Date		: 23.11.2007
Description : This SP will retrieve the FT details for a particular FT
Parameters  : FTId
Returns     : Dataset
*****************************************************************************/

CREATE PROCEDURE [dbo].[uspGetFTDetailsForExcel]
	@iFtID INT

AS
BEGIN

	SELECT A.I_Fund_Transfer_Header_ID,A.I_Centre_Id,A.Dt_Fund_Transfer_Date,
	A.N_CourseFees,A.N_Other_Collections,A.N_Total_Collection,A.N_RFF_Company,A.N_Total_Receivable,
	A.N_Total_Share_Center,B.S_Center_Name,B.S_Center_Code,B.S_ServiceTax_Regd_Code,D.S_Brand_Name,
	B.I_Is_OwnCenter,B.I_Is_Center_Serv_Tax_Reqd,
	A.Dt_Date_From,A.Dt_Date_To
	FROM dbo.T_Fund_Transfer_Header A
	inner join dbo.T_Centre_Master B
	on A.I_Centre_Id = B.I_Centre_Id
	inner join dbo.T_Brand_Center_Details C
	on B.I_Centre_Id = C.I_Centre_Id
	inner join dbo.T_Brand_Master D
	on C.I_Brand_ID = D.I_Brand_ID
	where I_Fund_Transfer_Header_ID = @iFtID
	

	SELECT FTD.*,RH.S_Receipt_No,RH.I_Receipt_Type
	FROM T_Fund_Transfer_Details FTD
	INNER JOIN dbo.T_Receipt_Header RH
	ON FTD.I_FTD_Receipt_Header_ID = RH.I_Receipt_Header_ID
	WHERE I_FTD_Fund_Transfer_Header_ID = @iFtID
	order by FTD.I_FTD_Receipt_Header_ID
	
END
