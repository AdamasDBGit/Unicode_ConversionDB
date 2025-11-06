/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:15/05/2007 
-- Description:Insert short listed student record in T_Shortlisted_Students table 
-- =================================================================
*/

CREATE PROCEDURE [PLACEMENT].[uspAddShortlistedStudent]
   (
	
	@iStudentDetailID        INT           ,
	@iVacancyID              INT           ,
	@DtScheduledInterview    DATETIME      ,
	@cCompanyInvitation      CHAR(1)      ,
	@cStudentAcknowledgement CHAR(1)       ,
	@cInterviewStatus        CHAR(1)       ,
	@DtActualInterview       DATETIME      ,
	@DtPlacement             DATETIME      ,
	@sPlacementExecutive     VARCHAR(50)   ,
	@sFailureReason          VARCHAR(200)  ,
	@sDesignation            VARCHAR(50)   ,
	@nAnnualSalary           NUMERIC(18,2) ,
	@sCrtdBy                 VARCHAR(20)   ,
	@DtCrtdOn                DATETIME      
   )
AS
BEGIN TRY

   SET NOCOUNT OFF;
   -- Insert short listed student in T_Shortlisted_Students
  
IF NOT EXISTS(SELECT I_Student_Detail_ID FROM T_Shortlisted_Students  WHERE I_Student_Detail_ID=@iStudentDetailID  AND I_Vacancy_ID =@iVacancyID)
BEGIN

 INSERT INTO PLACEMENT.T_Shortlisted_Students
   (
	     
	    I_Student_Detail_ID			,
        I_Vacancy_ID                ,
        Dt_Scheduled_Interview      ,
        C_Company_Invitation        ,
        C_Student_Acknowledgement   ,
        C_Interview_Status          ,
        Dt_Actual_Interview         ,
        Dt_Placement                ,
        S_Placement_Executive       ,
        S_Failure_Reason            ,
        S_Designation               ,
        N_Annual_Salary             ,
        I_Status					,
		S_Crtd_By                   ,
        Dt_Crtd_On                  
   )

   VALUES
   (
	
	@iStudentDetailID        ,
	@iVacancyID              ,
	@DtScheduledInterview    ,
	@cCompanyInvitation      ,
	@cStudentAcknowledgement ,
	@cInterviewStatus        ,
	@DtActualInterview       ,
	@DtPlacement             ,
	@sPlacementExecutive     ,
	@sFailureReason          ,
	@sDesignation            ,
	@nAnnualSalary           ,
	1						 ,
	@sCrtdBy                 ,
	@DtCrtdOn                
   )
END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
