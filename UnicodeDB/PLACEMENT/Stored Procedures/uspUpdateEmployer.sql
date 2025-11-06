/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:17/05/2007 
-- Description:Update Employer Details record in T_Employer_Detail table 
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspUpdateEmployer]
   (
	@iEmployerID        INT          ,
        @iNatureofBusiness  INT          ,
        @iStateID           INT          ,
        @iCountryID         INT          ,
        @iCityID            INT          ,
        @sCompanyCode       VARCHAR(50)  ,
        @sCompanyName       VARCHAR(250) ,
        @DtFirstEnquiryDate DATETIME     ,
        @sGroupCompanyCode  VARCHAR(50)  ,
        @sAddress           VARCHAR(200) ,
        @sPincode           VARCHAR(50)  ,
        @iStatus	    INT          ,
        @sUpdBy             VARCHAR(20)  ,
        @DtUpdOn            DATETIME
   )
AS
BEGIN TRY 

      UPDATE [PLACEMENT].T_Employer_Detail
      SET
	I_Nature_of_Business	= @iNatureofBusiness  ,
	I_State_ID		= @iStateID           ,
       	I_Country_ID		= @iCountryID         ,
       	I_City_ID		= @iCityID            ,
       	S_Company_Code		= @sCompanyCode       ,
       	S_Company_Name		= @sCompanyName       ,
       	Dt_First_Enquiry_Date	= @DtFirstEnquiryDate ,
       	S_Group_Company_Code	= @sGroupCompanyCode  ,
       	S_Address		= @sAddress           ,
       	S_Pincode		= @sPincode           ,
        I_Status		= @iStatus            ,
       	S_Upd_By		= @sUpdBy             ,
       	Dt_Upd_On		= @DtUpdOn
      WHERE
	    I_Employer_ID = @iEmployerID
           
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
