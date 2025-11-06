-- EXEC  uspGetEmployeeActivationStatus 1,1,1,1

-- =============================================
-- Author:	Avinaba Dhar
-- Create date: 02/01/2007
-- Description:	Selects Employee Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeActivationStatus] 
(
	@iEmpBrandId			INT,
	@iEmpRegionId			INT,
	@iEmpCountryId			INT,
	@iEmpCenterId			INT
	
)

AS
	BEGIN 
		
		
				SELECT I_EMP_PROS_EMPLOYEE_ID,S_EMP_EMP_ID,S_EMP_FIRST_NAME + ' ' + S_EMP_LAST_NAME EMPLOYEE_NAME ,
				S_ESM_STATUS_CODE,C_EMP_STATUS
				
			
				 FROM 	DBO.T_EMPLOYEE_DTLS A , DBO.T_EOS_STATUS_MASTER B	
				 
				WHERE	A.I_EMP_BRAND_ID = @iEmpBrandId 
				AND		A.I_EMP_RGN_ID = @iEmpRegionId
				AND		A.I_EMP_COUNTRY_ID = @iEmpCountryId		
				AND		I_EMP_CENTRE_ID = @iEmpCenterId
 				AND		A.I_EMP_STATUS_ID= B.I_ESM_STATUS_ID 
				AND     A.C_EMP_STATUS <>'D'
				AND		B.I_ESM_STATUS_ID = 4

				
		END
