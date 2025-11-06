-- =============================================
-- Author:SM
-- Create date: 29/09/2007
-- Description: Search a Student Details from dbo.T_Student_Detail
-- =============================================

--EXEC [LOGISTICS].[uspGetStudentDespatchDetails] 85,44,260
CREATE PROCEDURE [LOGISTICS].[uspGetStudentDespatchDetails] 
(
 --@iCenterID	INT = NULL
 @HierarchyDetailID VARCHAR(100) = NULL
,@iBrandID INT = NULL
,@iCourseFamilyID INT = NULL 
)
AS
BEGIN
Select Main.I_Student_Detail_Id,Main.S_Student_ID,Main.S_Title,Main.S_First_Name,Main.S_Middle_Name,Main.I_Batch_ID,
Main.S_Last_Name,Main.I_Course_ID,Main.S_Course_Name,Main.CentreId,Main.CentreCode,Main.CentreName,Main.CourseFamilyName,
Main.S_Invoice_No ,Main.Dt_Invoice_Date,Main.Invoice_Amount,Main.Fee_Collected,Main.CW_Fee_receipt,Main.CW_Fee_Invoice,
One.I_Status Installment1,Two.I_Status Installment2,
Three.I_Status Installment3,Four.I_Status Installment4,Five.I_Status Installment5,
Six.I_Status Installment6,Seven.I_Status Installment7
From
(Select DISTINCT SD.I_Student_Detail_Id
,SD.S_Student_ID AS S_Student_ID
,SD.S_Title AS S_Title
,SD.S_First_Name  AS S_First_Name
,SD.S_Middle_Name AS S_Middle_Name
,SD.S_Last_Name AS S_Last_Name
,SCDD.I_Course_ID AS I_Course_ID
,CMM.S_Course_Name AS S_Course_Name
,SCD.I_Centre_Id AS CentreId
,CM.S_Center_Code AS CentreCode
,CM.S_Center_Name AS CentreName
,CFM.S_CourseFamily_Name AS CourseFamilyName
,IP.S_Invoice_No
,IP.Dt_Invoice_Date
,SCDD.I_Batch_ID
,ISNULL(IP.N_Invoice_Amount,0.00) AS Invoice_Amount
,SUM(ISNULL(RH.N_Receipt_Amount,0.00)) AS Fee_Collected
,SUM(ISNULL(RCD.N_Amount_Paid,0.00)) AS CW_Fee_Receipt
,SUM(ISNULL(ICD.N_Amount_Due,0.00)) AS CW_Fee_Invoice
from dbo.T_Student_Detail SD
INNER JOIN dbo.T_Student_Course_Detail SCDD
ON SCDD.I_Student_Detail_ID = SD.I_Student_Detail_ID
INNER JOIN dbo.T_Course_Master CMM
ON CMM.I_Course_ID = SCDD.I_Course_ID
INNER JOIN dbo.T_Student_Center_Detail SCD
ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID

INNER JOIN [dbo].[fnGetCentersForReports](@HierarchyDetailID, @iBrandID) FN1
ON SCD.I_Centre_ID = FN1.CenterID

--
--INNER JOIN dbo.T_Brand_Center_Details BCD
--ON BCD.I_Centre_Id  = SCD.I_Centre_ID 

INNER JOIN dbo.T_Centre_Master CM
ON CM.I_Centre_Id = SCD.I_Centre_Id
INNER JOIN dbo.T_CourseFamily_Master CFM
ON CMM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
INNER JOIN dbo.T_Invoice_Parent IP
ON IP.I_Student_Detail_ID =SD.I_Student_Detail_ID
INNER JOIN dbo.T_Invoice_Child_Header ICH
ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
INNER JOIN dbo.T_Invoice_Child_Detail ICD
ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
AND ICD.I_Fee_Component_ID = 2
INNER JOIN T_Receipt_Header RH
ON IP.I_Invoice_Header_ID = RH.I_Invoice_Header_ID
INNER JOIN dbo.T_Receipt_Component_Detail RCD 
ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
AND RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
and RCD.N_Amount_Paid >0
WHERE 
--SCD.I_Centre_Id LIKE COALESCE(@iCenterID,SCD.I_Centre_Id ) 
--BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)	
 CFM.I_CourseFamily_ID = @iCourseFamilyID
AND IP.I_Status = 1
AND RH.I_Status = 1
GROUP BY 
SD.I_Student_Detail_Id
,SD.S_Student_ID
,SD.S_Title
,SD.S_First_Name
,SD.S_Middle_Name
,SD.S_Last_Name
,SCDD.I_Course_ID
,CMM.S_Course_Name
,SCD.I_Centre_Id
,CM.S_Center_Code
,CM.S_Center_Name
,CFM.S_CourseFamily_Name
,IP.S_Invoice_No
,SCDD.I_Batch_ID
,IP.Dt_Invoice_Date
,ISNULL(IP.N_Invoice_Amount,0.00)
) Main
Left Outer Join
(Select I_Student_Detail_Id,I_Status
from LOGISTICS.T_Student_Despatch_Detailed
Where I_Installment_No =1
) as One on Main.I_Student_Detail_Id = One.I_Student_Detail_Id
Left Outer Join
(Select I_Student_Detail_Id,I_Status
from LOGISTICS.T_Student_Despatch_Detailed
Where I_Installment_No =2
) as Two on Main.I_Student_Detail_Id = Two.I_Student_Detail_Id
Left Outer Join
(Select I_Student_Detail_Id,I_Status
from LOGISTICS.T_Student_Despatch_Detailed
Where I_Installment_No =3
) as Three on Main.I_Student_Detail_Id = Three.I_Student_Detail_Id
Left Outer Join
(Select I_Student_Detail_Id,I_Status
from LOGISTICS.T_Student_Despatch_Detailed
Where I_Installment_No =4
) as Four on Main.I_Student_Detail_Id = Four.I_Student_Detail_Id
Left Outer Join
(Select I_Student_Detail_Id,I_Status
from LOGISTICS.T_Student_Despatch_Detailed
Where I_Installment_No =5
) as Five on Main.I_Student_Detail_Id = Five.I_Student_Detail_Id
Left Outer Join
(Select I_Student_Detail_Id,I_Status
from LOGISTICS.T_Student_Despatch_Detailed
Where I_Installment_No =6
) as Six on Main.I_Student_Detail_Id = Six.I_Student_Detail_Id
Left Outer Join
(Select I_Student_Detail_Id,I_Status
from LOGISTICS.T_Student_Despatch_Detailed
Where I_Installment_No =7
) as Seven on Main.I_Student_Detail_Id = Seven.I_Student_Detail_Id

END
