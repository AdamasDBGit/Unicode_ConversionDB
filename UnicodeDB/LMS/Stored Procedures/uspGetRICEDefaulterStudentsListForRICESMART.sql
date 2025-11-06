

-- =============================================
-- Author:		<susmita Paul>
-- Create date: <2023-Feb-02>
-- Description:	<Fetch all the RICE defaulter students List>
-- =============================================
CREATE PROCEDURE [LMS].[uspGetRICEDefaulterStudentsListForRICESMART]
	
AS
BEGIN
	
	--select DISTINCT SD.S_Student_ID,SD.I_Student_Detail_ID,ERD.I_Enquiry_Regn_ID,
	--ER.CustomerID,BM.I_Brand_ID,BM.S_Brand_Code,BM.S_Brand_Name
	--from 
	--T_Student_Detail as SD
	--inner join
	--T_Student_Batch_Details as SBD on SD.I_Student_Detail_ID=SBD.I_Student_ID
	--inner join
	--T_Student_Batch_Master as SBM on SBM.I_Batch_ID=SBD.I_Batch_ID
	--inner join
	--T_Center_Batch_Details as CBD on CBD.I_Batch_ID=SBM.I_Batch_ID
	--inner join
	--T_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID
	--inner join
	--T_Brand_Center_Details as BCD on BCD.I_Centre_Id=CBD.I_Centre_Id
	--inner join
	--T_Brand_Master as BM on BM.I_Brand_ID=BCD.I_Brand_ID
	--inner join
	--T_Centre_Master as CM on CM.I_Centre_Id=CBD.I_Centre_Id
	--left join
	--ECOMMERCE.T_Registration_Enquiry_Map as REM on REM.EnquiryID=ERD.I_Enquiry_Regn_ID
	--left join
	--ECOMMERCE.T_Registration as ER on ER.RegID=REM.RegID
	--where SD.IsDiscontinued=0 and SD.IsDefaulter=1 and SD.I_Status=1 and ER.StatusID=1
	--and CBD.I_Centre_Id in (132) and SBD.I_Status in (1,2)
	----and SBM.I_Status = 4 and SBD.I_Status=1 and CBD.I_Centre_Id in (132)

	select DISTINCT SD.S_Student_ID,SD.I_Student_Detail_ID,ERD.I_Enquiry_Regn_ID,
	ER.CustomerID,BM.I_Brand_ID,BM.S_Brand_Code,BM.S_Brand_Name,
	SBM.I_Batch_ID,SBM.S_Batch_Code,SBM.S_Batch_Name,SBM.Dt_BatchStartDate,CBD.I_Centre_Id,
	CM.S_Center_Name
	from 
	T_Student_Detail as SD
	inner join
	T_Student_Batch_Details as SBD on SD.I_Student_Detail_ID=SBD.I_Student_ID
	inner join
	T_Student_Batch_Master as SBM on SBM.I_Batch_ID=SBD.I_Batch_ID
	inner join
	T_Center_Batch_Details as CBD on CBD.I_Batch_ID=SBM.I_Batch_ID
	inner join
	T_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID
	inner join
	T_Brand_Center_Details as BCD on BCD.I_Centre_Id=CBD.I_Centre_Id
	inner join
	T_Brand_Master as BM on BM.I_Brand_ID=BCD.I_Brand_ID
	inner join
	T_Centre_Master as CM on CM.I_Centre_Id=CBD.I_Centre_Id
	left join
	ECOMMERCE.T_Registration_Enquiry_Map as REM on REM.EnquiryID=ERD.I_Enquiry_Regn_ID
	left join
	ECOMMERCE.T_Registration as ER on ER.RegID=REM.RegID
	where SD.IsDiscontinued=0 and SD.IsDefaulter=1 and SD.I_Status=1 and ER.StatusID=1
	and CBD.I_Centre_Id in (132) and SBD.I_Status in (1,2)


END
