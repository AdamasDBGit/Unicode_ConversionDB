-- =============================================
-- Author:		Avinaba Dhar
-- Create date: 27/12/2006
-- Description:	Updates Address of All the Employee 
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeAddress] 
(   
	@iEadEmployeeAddressId     INT			,
	@iEadProsEmployeeId	       INT			,
	@iEadCountryId			   INT			,
	@iEadStateId			   INT			,
	@iEadCityId				   INT			,
	@vEadDistrictName		   NVARCHAR(MAX)	,
	@vEadAddressLine1		   NVARCHAR(MAX)	,
	@vEadAddressLine2		   NVARCHAR(MAX)	,
	@vEadZipCode			   NVARCHAR(MAX)	,
	@iEadAddressType		   INT			,
	@vEadCrtdBy				   NVARCHAR(MAX)	,
	@cEadStatus				   CHAR(1)		,
	@vEadUpdBy				   NVARCHAR(MAX)  ,
	@dEadCrtdOn				   DATETIME		,
	@dEadUpdOn			       DATETIME
)
AS
BEGIN TRY

		UPDATE T_Employee_Address SET 
			
				I_EAD_PROS_EMPLOYEE_ID=@iEadProsEmployeeId	,
				I_EAD_COUNTRY_ID=@iEadCountryId			    ,
				I_EAD_STATE_ID=@iEadStateId					,
				I_EAD_CITY_ID=@iEadCityId					,
				S_EAD_DISTRICT_NAME=@vEadDistrictName		,
				S_EAD_ADDRESS_LINE1=@vEadAddressLine1		,	
				S_EAD_ADDRESS_LINE2=@vEadAddressLine2		,
				S_EAD_ZIP_CODE=@vEadZipCode					,
				I_EAD_ADDRESS_TYPE=@iEadAddressType			,
				S_EAD_CRTD_BY=@vEadCrtdBy					,
				C_EAD_STATUS=@cEadStatus					,
				S_EAD_UPD_BY=@vEadUpdBy						,							  
				DT_EAD_CRTD_ON=@dEadCrtdOn					,
				DT_EAD_UPD_ON=@dEadUpdOn	 
	
			
		WHERE I_EAD_EMPLOYEE_ADDRESS_ID=@iEadEmployeeAddressId   
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

