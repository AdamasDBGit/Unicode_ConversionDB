-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:15/05/2007 
-- Description:Select Details of Employer record from T_Employer_Detail
-- Serching cryteria Employer ID
-- =================================================================

CREATE PROCEDURE [PLACEMENT].[uspGetEmployerDetail]
(
	@iEmployerID  INT =null
)
AS
BEGIN

   SELECT 
        ISNULL(I_Employer_ID,0) AS I_Employer_ID , 
		ISNULL(I_State_ID,0) AS I_State_ID   , 
		ISNULL(I_Nature_of_Business,0) AS I_Nature_of_Business, 
		ISNULL(I_Country_ID,0) AS I_Country_ID       , 
		ISNULL(I_City_ID,0) AS I_City_ID,
        ISNULL(S_Company_Code,' ') AS S_Company_Code, 
		ISNULL(S_Company_Name,' ') AS S_Company_Name, 
		ISNULL(Dt_First_Enquiry_Date,' ') AS Dt_First_Enquiry_Date, 
		ISNULL(S_Group_Company_Code,' ') AS S_Group_Company_Code, 
		ISNULL(S_Address,' ') AS S_Address,
        ISNULL(S_Pincode,' ') AS  S_Pincode       
     FROM [PLACEMENT].T_Employer_Detail 
     WHERE I_Employer_ID = COALESCE(@iEmployerID,I_Employer_ID)
	    AND I_Status = 1

-- Select for Contact Details of employer
    SELECT 
		ISNULL(I_Employer_Contact_ID,0) AS I_Employer_Contact_ID , 
		ISNULL(S_Contact_Name,' ') AS S_Contact_Name , 
		ISNULL(S_Contact_Designation,' ') AS S_Contact_Designation, 
		ISNULL(S_Contact_Address,' ') AS S_Contact_Address,
        ISNULL(S_Email,' ') AS S_Email , 
		ISNULL(S_Telephone,' ') AS S_Telephone , 
		ISNULL(S_Cellphone,' ') AS S_Cellphone , 
		ISNULL(S_Fax,' ') AS S_Fax ,
               B_Is_Primary 
     FROM [PLACEMENT].T_Employer_Contact
     WHERE I_Employer_ID = COALESCE(@iEmployerID,I_Employer_ID)
         AND I_Status = 1
        
END
