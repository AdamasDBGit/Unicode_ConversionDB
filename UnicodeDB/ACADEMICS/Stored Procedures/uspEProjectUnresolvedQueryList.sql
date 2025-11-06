/*******************************************************
Description : Get E-Project Unresolved Query List
Author	:   Swagata De  
Date	:	  
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectUnresolvedQueryList] 
(
	@iCenterID int =null,	
	@dFromDate datetime=null,
	@dToDate datetime =null,
	@iStatusID int = null
)
AS

BEGIN
	SELECT TQP.I_Query_Posting_ID,TQP.I_Student_Detail_ID,TQP.I_E_Project_Spec_ID,TQP.Dt_Query_Posting_Date,TQP.I_Status,
	   ERD.S_First_Name,ERD.S_Middle_Name,ERD.S_Last_Name,
	   EPS.I_E_Project_Spec_ID,EPS.S_Description,
	   TCM.S_Center_Code,TCM.S_Center_Name,
	   TCRM.S_Course_Code,TCRM.S_Course_Name,
	   TRM.S_Term_Code,TRM.S_Term_Name
	   
FROM ACADEMICS.T_Query_Posting TQP
INNER JOIN dbo.T_Student_Detail TSD WITH(NOLOCK)
ON TQP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH(NOLOCK)
ON TSD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
INNER JOIN dbo.T_Student_Center_Detail SCD WITH(NOLOCK)
ON TQP.I_Student_Detail_ID = SCD.I_Student_Detail_ID
INNER JOIN dbo.T_Centre_Master TCM WITH(NOLOCK)
ON SCD.I_Centre_Id = TCM.I_Centre_Id
INNER JOIN ACADEMICS.T_E_Project_Spec EPS WITH(NOLOCK)
ON TQP.I_E_Project_Spec_ID = EPS.I_E_Project_Spec_ID 
INNER JOIN dbo.T_Course_Master TCRM WITH(NOLOCK)
ON EPS.I_Course_ID = TCRM.I_Course_ID
INNER JOIN dbo.T_Term_Master TRM WITH(NOLOCK)
ON EPS.I_Term_ID = TRM.I_Term_ID
WHERE TCM.I_Centre_Id = ISNULL(@iCenterID,TCM.I_Centre_Id)
AND TQP.Dt_Query_Posting_Date >= ISNULL(@dFromDate,TQP.Dt_Query_Posting_Date)
AND TQP.Dt_Query_Posting_Date <= ISNULL(@dToDate,TQP.Dt_Query_Posting_Date)
AND TQP.I_Status = @iStatusID
AND TQP.S_Resolution IS NULL
END
