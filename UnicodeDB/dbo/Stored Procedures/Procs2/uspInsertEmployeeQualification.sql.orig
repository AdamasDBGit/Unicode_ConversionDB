-- =============================================
-- Author:		Avinaba Dhar
-- Create date: 27/12/2006
-- Description:	Inserts Qualification of All the Employee 
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertEmployeeQualification] 
(
	@iEquQualificationTypeId					  INT			,
	@iEquQualificationNameId					  INT			,
	@iEquProsEmployeeId							  INT			,
	@dEquPassyear							   	  DATETIME		,
	@vEquPercentage								  INT			,
	@vEquCrtdBy								      VARCHAR(20)	,
	@cEquStatus									  CHAR(1)		,
	@vEquUpdBy									  VARCHAR(20)	,
	@dEquCrtdOn									  DATETIME		,
	@dEquUpdOn									  DATETIME
	
)
AS
BEGIN TRY

		INSERT INTO T_Employee_Qualification
			(
				I_EQU_QUALIFICATION_TYPE_ID		,
				I_EQU_QUALIFICATION_NAME_ID		,	
				I_EQU_PROS_EMPLOYEE_ID			,
				DT_EQU_PASSYEAR					,	
				N_EQU_PERCENTAGE				,
				S_EQU_CRTD_BY					,
				C_EQU_STATUS					,	
				S_EQU_UPD_BY					,	
				DT_EQU_CRTD_ON					,		
				DT_EQU_UPD_ON							  
				
			)
		VALUES
			(
				@iEquQualificationTypeId	,					
				@iEquQualificationNameId		,			 
				@iEquProsEmployeeId			,
				@dEquPassyear				,
				@vEquPercentage					,						 
				@vEquCrtdBy						,
				@cEquStatus					,		 
				@vEquUpdBy					,							  
				@dEquCrtdOn						,						 
				@dEquUpdOn	
            )
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
