-- =============================================
-- Author:		Avinaba Dhar
-- Create date: 27/12/2006
-- Description:	Updates Qualification of All the Employee 
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeQualification] 
(   
	@iEquEmployeeQualId						      INT			,
	@iEquQualificationTypeId					  INT			,
	@iEquQualificationNameId					  INT			,
	@iEquProsEmployeeId						      INT			,
	@dEquPassyear							   	  DATETIME		,
	@vEquPercentage								  INT			,
	@vEquCrtdBy									  VARCHAR(20)	,
	@cEquStatus									  CHAR(1)		,
	@vEquUpdBy									  VARCHAR(20)	,
	@dEquCrtdOn									  DATETIME		,
	@dEquUpdOn									  DATETIME
)
AS
BEGIN TRY

		UPDATE T_Employee_Qualification SET 
			
				I_EQU_QUALIFICATION_TYPE_ID=@iEquQualificationTypeId ,
				I_EQU_QUALIFICATION_NAME_ID=@iEquQualificationNameId ,	
				I_EQU_PROS_EMPLOYEE_ID=@iEquProsEmployeeId		     ,
				DT_EQU_PASSYEAR=@dEquPassyear						 ,	
				N_EQU_PERCENTAGE=@vEquPercentage					 ,
				S_EQU_CRTD_BY=@vEquCrtdBy						     ,
				C_EQU_STATUS=@cEquStatus						     ,	
				S_EQU_UPD_BY=@vEquUpdBy					             ,	   
				DT_EQU_CRTD_ON=@dEquCrtdOn				    		 ,		
				DT_EQU_UPD_ON=@dEquUpdOn			
	
			
		WHERE I_EQU_EMPLOYEE_QUAL_ID=@iEquEmployeeQualId	
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
