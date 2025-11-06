-- =============================================
-- Author:		Partha De
-- Create date: 27/12/2006
-- Description:	Inserts All Employee Role Details  
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertEmployeeRoles] 
(
	@iErdRoleId				INT,
	@iErdProsEmployeeId		INT,
	@cErdStatus				CHAR(1),
	@dErdStartDate			DATETIME,
	@dErdEndDate			DATETIME,
	@vErdCrtdBy				VARCHAR(20),
	@vErdUpdBy				VARCHAR(20),
	@dErdCrtdOn				DATETIME,
	@dErdUpdOn				DATETIME
	
)

AS
BEGIN TRY 
	INSERT INTO dbo.T_EMPLOYEE_ROLE_DTLS
		(	
			--I_ERD_EMP_ROLE_DTL_ID,
			I_ERD_ROLE_ID,
			I_ERD_PROS_EMPLOYEE_ID,
			C_ERD_STATUS,
			DT_ERD_START_DATE,
			DT_ERD_END_DATE,
			S_ERD_CRTD_BY,
			S_ERD_UPD_BY,
			DT_ERD_CRTD_ON,
			DT_ERD_UPD_ON
 			
		)
		VALUES 
		(
					
			@iErdRoleId	,
			@iErdProsEmployeeId ,
			@cErdStatus ,
			@dErdStartDate ,
			@dErdEndDate ,
			@vErdCrtdBy	,
			@vErdUpdBy ,
			@dErdCrtdOn	,
			@dErdUpdOn				
		)
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
