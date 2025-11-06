/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:15/05/2007 
-- Description:Update short listed student record in T_Shortlisted_Students table 
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspUpdateShortlistedStudent]
   (
	@iShortlistedStudentID   INT           ,
	@iStudentDetailID        INT           ,
	@iVacancyID              INT           ,
	@DtScheduledInterview    DATETIME      ,
	@cCompanyInvitation      CHAR(1)       ,
	@cStudentAcknowledgement CHAR(1)       ,
	@cInterviewStatus        CHAR(1)       ,
	@DtActualInterview       DATETIME      ,
	@DtPlacement             DATETIME      ,
	@sPlacementExecutive     VARCHAR(50)   ,
	@sFailureReason          VARCHAR(200)  ,
	@sDesignation            VARCHAR(50)   ,
	@nAnnualSalary           NUMERIC(18,2) ,
	@iStatus				 INT           ,
    @sUpdBy                  VARCHAR(20)   ,
	@DtUpdOn                 DATETIME      
   )
AS
BEGIN TRY 

      UPDATE [PLACEMENT].T_Shortlisted_Students
      SET
	    I_Student_Detail_ID         = @iStudentDetailID        ,
        I_Vacancy_ID                = @iVacancyID              ,
        Dt_Scheduled_Interview      = @DtScheduledInterview    ,
        C_Company_Invitation        = @cCompanyInvitation      ,
        C_Student_Acknowledgement   = @cStudentAcknowledgement ,
        C_Interview_Status          = @cInterviewStatus        ,
        Dt_Actual_Interview         = @DtActualInterview       ,
        Dt_Placement                = @DtPlacement             ,
        S_Placement_Executive       = @sPlacementExecutive     ,
        S_Failure_Reason            = @sFailureReason          ,
        S_Designation               = @sDesignation            ,
        N_Annual_Salary             = @nAnnualSalary           ,
        I_Status					= @iStatus				   ,
        S_Upd_By                    = @sUpdBy                  ,
        Dt_Upd_On                   = @DtUpdOn
      WHERE
	    I_Shortlisted_Student_ID = @iShortlistedStudentID 
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
