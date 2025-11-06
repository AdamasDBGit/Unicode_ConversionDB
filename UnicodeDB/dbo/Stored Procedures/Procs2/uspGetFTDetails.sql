/*****************************************************************************
Created by  : Debarshi Basu
Date		: 23.11.2007
Description : This SP will retrieve the FT details for a particular FT
Parameters  : FTId
Returns     : Dataset
*****************************************************************************/

CREATE PROCEDURE [dbo].[uspGetFTDetails]
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

	SELECT SUM(A.N_Tax_Amount_Company) AS N_Tax_Amount_Company,
		SUM(A.N_Tax_Amount_BP) AS N_Tax_Amount_BP,B.S_Tax_Desc,A.I_Tax_ID
	FROM dbo.T_FT_Tax_Detail A
	inner join dbo.T_Tax_Master B
	on A.I_Tax_ID = B.I_Tax_ID
	WHERE I_Fund_Transfer_Header_ID = @iFtID
	GROUP BY A.I_Tax_ID,B.S_Tax_Desc

	
	SELECT A.I_Fee_Component_ID,
	SUM(A.N_CompanyShare) AS Company_Share,
	SUM(A.N_Total_Amount - A.N_CompanyShare) AS BP_Share,
	B.S_Component_Name
	FROM dbo.T_FT_Fee_Component_Details A
	inner join dbo.T_Fee_Component_Master B
	on A.I_Fee_Component_ID = B.I_Fee_Component_ID
	WHERE I_Fund_Transfer_Header_ID = @iFtID
	GROUP BY A.I_Fee_Component_ID,B.S_Component_Name

	SELECT TOP 1 FTD.I_FTD_Receipt_Header_ID AS ID_Receipt,RH.S_Receipt_No AS I_FTD_Receipt_Header_ID
	FROM T_Fund_Transfer_Details FTD
	INNER JOIN dbo.T_Receipt_Header RH
	ON FTD.I_FTD_Receipt_Header_ID = RH.I_Receipt_Header_ID
	WHERE I_FTD_Fund_Transfer_Header_ID = @iFtID
	order by FTD.I_FTD_Receipt_Header_ID

	SELECT TOP 1 FTD.I_FTD_Receipt_Header_ID AS ID_Receipt,RH.S_Receipt_No AS I_FTD_Receipt_Header_ID
	FROM T_Fund_Transfer_Details FTD
	INNER JOIN dbo.T_Receipt_Header RH
	ON FTD.I_FTD_Receipt_Header_ID = RH.I_Receipt_Header_ID
	WHERE I_FTD_Fund_Transfer_Header_ID = @iFtID
	order by FTD.I_FTD_Receipt_Header_ID DESC
	
END
