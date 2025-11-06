CREATE PROCEDURE [dbo].[uspConfigureCourse]   
(  
 @iCourseID int = NULL,  
 @iGradingPatternID int = NULL,  
 @cAptitudeTestRequired char(1) = NULL,  
 @iCertificateID int = NULL,  
 @cCareerCourse char(1) = NULL,  
 @cShortTermCourse char(1) = NULL,  
 @cPlacementApplicable char(1) = NULL,  
 @cDropoutAllowed CHAR(1) = NULL,  
 @iNoOfDays INT = 0,  
 @cSTApplicable CHAR(1) = NULL,  
 @iMinNoOfWeekForPlacement INT = 0,  
 @iMaxNoOfWeekForPlacement INT = 0,  
 @sCreatedBy varchar(20)= NULL ,  
 @dCreatedOn datetime = NULL   
)  
  
AS  
BEGIN TRY  
  SET NOCOUNT OFF;  
  
  UPDATE dbo.T_Course_Master  
  SET I_Grading_Pattern_ID = @iGradingPatternID,  
  C_AptitudeTestReqd = @cAptitudeTestRequired,  
  C_IsCareerCourse = @cCareerCourse,  
  C_IsShortTermCourse = @cShortTermCourse,  
  C_IsPlacementApplicable = @cPlacementApplicable,  
  I_Certificate_ID = CASE WHEN @iCertificateID = 0 THEN NULL ELSE @iCertificateID END,  
  I_Is_Dropout_Allowed = @cDropoutAllowed,  
  I_No_Of_Days = @iNoOfDays,  
  I_Is_ST_Applicable = @cSTApplicable,  
  I_Min_Week_For_Placement = @iMinNoOfWeekForPlacement,  
  I_Max_Week_For_Placement = @iMaxNoOfWeekForPlacement,  
  S_Upd_By = @sCreatedBy,  
  Dt_Upd_On= @dCreatedOn  
  WHERE I_Course_ID = @iCourseID  
  AND I_Status = 1  
  
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
