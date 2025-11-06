CREATE PROCEDURE [dbo].[uspGetDummyCorporateStudent]  --6,null
(  
 @CorporateId INT = NULL,  
 @CenterId INT = NULL  
)  
AS  
BEGIN  
SELECT A.I_Student_Detail_ID,  
    A.I_Enquiry_Regn_ID,  
    A.S_Student_ID,  
    A.S_Title,  
    A.S_First_Name,  
    A.S_Email_ID,  
    A.S_Phone_No,  
    A.S_Perm_Address1,  
    A.S_Perm_Address2,  
    A.I_Perm_Country_ID,  
    A.I_Perm_State_ID,  
    A.I_Perm_City_ID,  
    A.S_Perm_Area,  
    A.S_Perm_Pincode  
    FROM dbo.T_Student_Detail A  
INNER JOIN dbo.T_Enquiry_Regn_Detail B  
ON A.I_Enquiry_Regn_ID = B.I_Enquiry_Regn_ID  
WHERE  B.I_Corporate_Plan_ID = ISNULL(@CorporateId,B.I_Corporate_Plan_ID)   
AND B.I_Centre_Id = ISNULL(@CenterId,B.I_Centre_Id)  
AND A.I_Status = 1  
END
