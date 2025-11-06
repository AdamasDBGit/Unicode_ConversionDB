-- =============================================  
-- Author:  Soumyopriyo Saha  
-- Create date: 04/10/2010  
-- Description: Add new corporate  
-- =============================================  
CREATE PROCEDURE [CORPORATE].[uspCreateCorporateDetails]   
(  
 @CorporateName varchar(50),   
 @Address1 varchar(500),  
 @Address2 varchar(500),  
 @CountryID int,  
 @StateID int,  
 @CityID int,  
 @Area varchar(50),  
 @ContactName varchar(50),  
 @PhoneNumber varchar(20),  
 @Fax varchar(50),  
 @EmailID varchar(50),  
 @PinCode VARCHAR(20),  
 @CrtdBy varchar(50),  
 @dtCrtdOn datetime  
)  
   
AS  
BEGIN TRY   
INSERT INTO CORPORATE.T_Corporate_Details (  
 S_Corporate_Name,  
 S_Address1,  
 S_Address2,  
 S_PinCode,  
 S_Area,  
 I_Country_ID,  
 I_State_ID,  
 I_City_ID,  
 S_Contact_Name,  
 S_Phone_No,  
 S_Email_ID,  
 S_Fax_No,  
 I_Status,  
 S_Crtd_By,  
 Dt_Crtd_On   
) VALUES (   
 /* S_Corporate_Name - varchar(50) */ @CorporateName,  
 /* S_Address1 - varchar(200) */ @Address1,  
 /* S_Address2 - varchar(200) */ @Address2,  
 /* S_PinCode - varchar(20) */ @PinCode,  
 /* S_Area - varchar(50) */ @Area,  
 /* I_Country_ID - int */ @CountryID,  
 /* I_State_ID - int */ @StateID,  
 /* I_City_ID - int */ @CityID,  
 /* S_Contact_Name - varchar(200) */ @ContactName,  
 /* S_Phone_No - varchar(20) */ @PhoneNumber,  
 /* S_Email_ID - varchar(50) */ @EmailID,  
 /* S_Fax_No - varchar(50) */ @Fax,  
 /* I_Status - int */ 1,  
 /* S_Crtd_By - varchar(50) */ @CrtdBy,  
 /* Dt_Crtd_On - datetime */ @dtCrtdOn)   
END TRY  
  
BEGIN CATCH  
 --Error occurred:    
 ROLLBACK TRANSACTION  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
