-- =============================================
-- Author:		Avinaba Dhar
-- Create date: 27/12/2006
-- Description:	Inserts Work Experience of All the Employee 
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertEmployeeWorkExp] 
(
	@iEmpProsEmployeeId 	      INT			,
	@dEweFromDate				  DATETIME		,
	@dEweToDate				      DATETIME		,			
	@vEweCompany				  VARCHAR(20)	,
	@vEweIndustry				  VARCHAR(20)	,
	@vEweJobType				  VARCHAR(20)	,
	@vEweJobDescription		      VARCHAR(100)	,
	@vEweCrtd_By				  VARCHAR(20)	,	
	@cEweStatus				   	  CHAR(1)		,
	@vEweupdby				      VARCHAR(20)	,
	@dEweCrtdOn				      DATETIME		,
	@dEweUpdOn					  DATETIME		
	
)
AS
BEGIN TRY

		INSERT INTO T_Employee_WorkExp
			(
				I_EMP_PROS_EMPLOYEE_ID	    ,
				DT_EWE_FROM_DATE		    ,
				DT_EWE_TO_DATE		        ,
				S_EWE_COMPANY			    ,
				S_EWE_INDUSTRY			    ,
				S_EWE_JOB_TYPE		        ,	
				S_EWE_JOB_DESCRIPTION		,
				S_EWE_CRTD_BY			    ,
				C_EWE_STATUS		        ,
				S_EWE_UPD_BY			    ,
				DT_EWE_CRTD_ON				,
				DT_EWE_UPD_ON	
	
			)
		VALUES
			(
				@iEmpProsEmployeeId 	    ,
				@dEweFromDate	            ,
				@dEweToDate		            ,
				@vEweCompany			    ,
				@vEweIndustry			    ,
				@vEweJobType			    ,	
				@vEweJobDescription			,
				@vEweCrtd_By			    ,
				@cEweStatus			        ,
				@vEweupdby				    ,
				@dEweCrtdOn				    ,
				@dEweUpdOn	
            )
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
