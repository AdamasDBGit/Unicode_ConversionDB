-- =============================================
-- Author:		Avinaba Dhar
-- Create date: 27/12/2006
-- Description:	Updates Work Experience of All the Employee 
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeWorkExp] 
(   
    @iEweEmployeeWorkExpId	      INT			,
	@iEmpProsEmployeeId 		  INT			,
	@dEweFromDate				  DATETIME		,
	@dEweToDate					  DATETIME		,			
	@vEweCompany				  VARCHAR(20)	,
	@vEweIndustry				  VARCHAR(20)	,
	@vEweJobType				  VARCHAR(20)	,
	@vEweJobDescription			  VARCHAR(100)	,
	@vEweCrtd_By				  VARCHAR(20)	,	
	@cEweStatus				   	  CHAR(1)		,
	@vEweupdby					  VARCHAR(20)	,
	@dEweCrtdOn			          DATETIME		,
	@dEweUpdOn					  DATETIME	
)
AS
BEGIN TRY

		UPDATE T_Employee_WorkExp SET 
			
				I_EMP_PROS_EMPLOYEE_ID=@iEmpProsEmployeeId 	,
				DT_EWE_FROM_DATE=@dEweFromDate		        ,
				DT_EWE_TO_DATE=@dEweToDate				    ,
				S_EWE_COMPANY=@vEweCompany				    ,
				S_EWE_INDUSTRY=@vEweIndustry			    ,
				S_EWE_JOB_TYPE=@vEweJobType			        ,	
				S_EWE_JOB_DESCRIPTION=@vEweJobDescription	,
				S_EWE_CRTD_BY=@vEweCrtd_By				    ,
				C_EWE_STATUS=@cEweStatus		            ,
				S_EWE_UPD_BY=@vEweupdby			            ,
				DT_EWE_CRTD_ON=@dEweCrtdOn					,
				DT_EWE_UPD_ON=@dEweUpdOn	
			
		WHERE I_EWE_EMPLOYEE_WORKEXP_ID=@iEweEmployeeWorkExpId
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
