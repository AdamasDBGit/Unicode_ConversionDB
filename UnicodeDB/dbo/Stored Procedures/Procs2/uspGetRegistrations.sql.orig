-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 9 Spet, 2010  
-- Description: Selects All the Registrations  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetRegistrations]  
@iCenterID INT,  
@sFirstName VARCHAR(50) = NULL,  
@sMiddleName VARCHAR(50) = NULL,  
@sLastName VARCHAR(50) = NULL,  
@EnquiryNumber VARCHAR(50) = NULL  
AS  
BEGIN  
  SELECT DISTINCT ERD.I_Enquiry_Regn_ID,  
  ERD.S_Enquiry_No AS EnquiryNumber,  
  ISNULL(ERD.S_First_Name,'') + ' '  + ISNULL(ERD.S_Middle_Name,'') + ' ' + ISNULL(ERD.S_Last_Name,'') AS [Name]  
  FROM dbo.T_Student_Registration_Details SRD  
  INNER JOIN dbo.T_Enquiry_Regn_Detail ERD  
  ON SRD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID  
  --AND SRD.I_Destination_Center_ID = ERD.I_Centre_Id  
  WHERE SRD.I_Status = 1  
  AND SRD.I_Destination_Center_ID = @iCenterID  
  AND ERD.S_Enquiry_No = ISNULL(@EnquiryNumber,ERD.S_Enquiry_No)  
  AND ERD.S_First_Name = ISNULL(@sFirstName,ERD.S_First_Name)  
  AND ERD.S_Middle_Name = ISNULL(@sMiddleName,ERD.S_Middle_Name)  
  AND ERD.S_Last_Name = ISNULL(@sLastName,ERD.S_Last_Name)  
END
