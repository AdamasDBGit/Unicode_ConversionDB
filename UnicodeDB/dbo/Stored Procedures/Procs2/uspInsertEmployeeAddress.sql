-- =============================================
-- Author:		Avinaba Dhar
-- Create date: 27/12/2006
-- Description:	Inserts Address of All the Employee 
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertEmployeeAddress] 
(  
	@iEadProsEmployeeId		  INT			,
	@iEadCountryId			  INT			,
	@iEadStateId			  INT			,
	@iEadCityId				  INT			,
	@vEadDistrictName		  NVARCHAR(MAX)	,
	@vEadAddressLine1		  NVARCHAR(MAX)	,
	@vEadAddressLine2		  NVARCHAR(MAX)	,
	@vEadZipCode			  NVARCHAR(MAX)	,	
	@iEadAddressType		  INT			,
	@vEadCrtdBy				  NVARCHAR(MAX)	,
	@cEadStatus			      CHAR(1)		,
	@vEadUpdBy				  NVARCHAR(MAX)	,
	@dEadCrtdOn				  DATETIME		,
	@dEadUpdOn				  DATETIME
)
AS
BEGIN TRY

		INSERT INTO T_Employee_Address
			( 
				I_EAD_PROS_EMPLOYEE_ID	,
				I_EAD_COUNTRY_ID		,
				I_EAD_STATE_ID			,
				I_EAD_CITY_ID			,
				S_EAD_DISTRICT_NAME		,
				S_EAD_ADDRESS_LINE1		,	
				S_EAD_ADDRESS_LINE2		,
				S_EAD_ZIP_CODE			,
				I_EAD_ADDRESS_TYPE		,
				S_EAD_CRTD_BY			,
				C_EAD_STATUS			,					  
				S_EAD_UPD_BY			,
				DT_EAD_CRTD_ON			,
				DT_EAD_UPD_ON
	
			)
		VALUES
			(  
				@iEadProsEmployeeId	,
				@iEadCountryId		,
				@iEadStateId		,
				@iEadCityId			,
				@vEadDistrictName	,
				@vEadAddressLine1	,
				@vEadAddressLine2	,
				@vEadZipCode		,
				@iEadAddressType	,
				@vEadCrtdBy			,		
				@cEadStatus			,
				@vEadUpdBy			,
				@dEadCrtdOn		    ,
				@dEadUpdOn	 
            )
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

