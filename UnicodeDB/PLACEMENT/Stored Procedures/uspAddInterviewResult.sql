/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:15/05/2007 
-- Description:Update short listed student record in T_Shortlisted_Students table 
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspAddInterviewResult]
   (
	@iShortlistedStudentID   INT           ,
    @DtPlacement             DATETIME      ,
	@sFailureReason          VARCHAR(200) = null ,
	@nAnnualSalary           NUMERIC(18,2) = null ,
	@sDesignation            VARCHAR(50)  = null ,
    @sPlacementExecutive     VARCHAR(50) = null   ,
	@cInterviewStatus        CHAR(1)       ,
	@iVacancyID INT ,
	@sUpdBy                  VARCHAR(20)   ,
	@DtUpdOn                 DATETIME
   )
AS
BEGIN TRY 

      UPDATE [PLACEMENT].T_Shortlisted_Students
      SET
        Dt_Placement                = @DtPlacement             ,
        S_Failure_Reason            = @sFailureReason          ,
        S_Designation               = @sDesignation            ,
        N_Annual_Salary             = @nAnnualSalary           ,
        S_Placement_Executive       = @sPlacementExecutive     ,
		C_Interview_Status          = @cInterviewStatus        ,
        S_Upd_By                    = @sUpdBy                  ,
        Dt_Upd_On                   = @DtUpdOn
      WHERE
	    I_Student_Detail_ID = @iShortlistedStudentID 
		AND I_Vacancy_ID = @iVacancyID
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
