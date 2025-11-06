/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description: Select employer from T_Employer_Detail tabel
-- Parameter : @sCompanyName,@sCompanyCode , @dtFirstEnquiryDate 
-- =================================================================
*/


CREATE PROCEDURE [PLACEMENT].[uspGetEmployerList]
(
@sCompanyName VARCHAR(250)= null,
@sCompanyCode VARCHAR(50) = null,
@dtFirstEnquiryDate DATETIME =null,
@iEmployerID INT = null,
@iBrandID INT =null
)
AS
BEGIN

DECLARE @CompanyName VARCHAR(250)
DECLARE @CompanyCode VARCHAR(50)

IF(@sCompanyName IS null)
 SET @CompanyName=''
IF(@sCompanyCode IS null)
 SET @CompanyCode=''

SET @CompanyName= @sCompanyName+'%'
SET @CompanyCode= @sCompanyCode+'%'

 SELECT 
        ISNULL(ED.I_Employer_ID,0) AS  I_Employer_ID,
        ISNULL(ED.I_State_ID,0) AS I_State_ID  ,
        ISNULL(ED.I_Nature_of_Business,0) AS I_Nature_of_Business,
        ISNULL(ED.I_Country_ID,0) AS I_Country_ID ,
        ISNULL(ED.I_City_ID,0) AS I_City_ID,
        ISNULL(ED.S_Company_Code,' ') AS S_Company_Code,
        ISNULL(ED.S_Company_Name,' ') AS S_Company_Name,
        ISNULL(ED.Dt_First_Enquiry_Date,' ') AS Dt_First_Enquiry_Date,
        ISNULL(ED.S_Group_Company_Code,' ') AS S_Group_Company_Code,
        ISNULL(ED.S_Address,' ') AS S_Address ,
        ISNULL(ED.S_Pincode,' ') AS S_Pincode,
		ISNULL(UM.S_Login_ID,' ') AS S_Login_ID
         FROM [PLACEMENT].T_Employer_Detail ED
		 INNER JOIN dbo.T_User_Master UM
		 ON UM.I_Reference_ID = ED.I_Employer_ID
		 AND UM.S_User_Type = 'EM'		
         WHERE ED.I_Status = 1
		 AND
	     S_Company_Code LIKE COALESCE(@CompanyCode,S_Company_Code) AND 
	     S_Company_Name LIKE COALESCE(@CompanyName,S_Company_Name) AND 
	     Dt_First_Enquiry_Date LIKE COALESCE(@dtFirstEnquiryDate,Dt_First_Enquiry_Date)
		 AND I_Employer_ID = COALESCE(@iEmployerID,I_Employer_ID)
		 AND UM.I_User_ID IN (SELECT I_User_ID FROM [Placement].[fnGetUserIDFormBrand](@iBrandID))
		ORDER BY S_Company_Name

END
