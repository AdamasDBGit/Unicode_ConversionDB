CREATE PROCEDURE [dbo].[uspRevokeFeePlanFromCenter]    
(    
  @iSelectedFeePlanID int,    
  @sLoginID varchar(200)    
 )    
    
AS    
    
BEGIN TRY    
DECLARE @flag int    
set @flag = 0    
--IF NOT EXISTS( SELECT * FROM dbo.T_Student_Course_Detail WHERE I_Course_Center_Delivery_ID = @iSelectedFeePlanID)    
--BEGIN    
 DECLARE @iCourseID int    
 DECLARE @iCourseCenterID int    
 DECLARE @iCenterID INT    
 DECLARE @iCourseFeePlan INT    
      
 -- Get the Course ID, Course Center ID for the FeePlan     
 SELECT @iCourseID = A.I_Course_ID,     
   @iCourseCenterID = A.I_Course_Center_ID,    
   @iCenterID = A.I_Centre_Id,    
   @iCourseFeePlan = B.I_Course_Fee_Plan_ID    
 FROM dbo.T_Course_Center_Detail A WITH(NOLOCK)    
 INNER JOIN dbo.T_Course_Center_Delivery_FeePlan B    
 ON A.I_Course_Center_ID = B.I_Course_Center_ID    
 WHERE I_Course_Center_Delivery_ID = @iSelectedFeePlanID    
 AND A.I_Status = 1    
 AND B.I_Status = 1    
 AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())    
 AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())    
 AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())    
 AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())    
     
 BEGIN TRANSACTION    
 SET @flag = 1    
 -- Deactivate the FeePlan for the Center    
 UPDATE dbo.T_Course_Center_Delivery_FeePlan    
 SET I_Status = 0,     
 Dt_Valid_To = GETDATE()    
 WHERE I_Course_Center_Delivery_ID = @iSelectedFeePlanID    
    
 -- Check if any other FeePlan is active for the Course in that Center    
 IF NOT EXISTS( SELECT I_Course_Center_Delivery_ID     
     FROM dbo.T_Course_Center_Delivery_FeePlan    
     WHERE I_Course_Center_ID = @iCourseCenterID    
     AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())    
     AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())    
     AND I_Status = 1    
     )    
 BEGIN    
  -- Deactivate the Course for the Center    
   UPDATE dbo.T_Course_Center_Detail    
   SET I_Status = 0,    
   Dt_Valid_To = GETDATE(),    
   S_Upd_By = @sLoginID,    
   Dt_Upd_On = GETDATE()    
   WHERE I_Course_Center_ID = @iCourseCenterID    
    
  -- Check if Course is active in any Center    
  IF NOT EXISTS( SELECT I_Course_Center_ID    
      FROM dbo.T_Course_Center_Detail      
      WHERE I_Course_ID = @iCourseID    
      AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())    
      AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())    
      AND I_Status = 1    
      )    
  BEGIN    
        
   -- Set Editable flag for the Course as 1    
    UPDATE dbo.T_Course_Master    
    SET I_Is_Editable = 1,    
    S_Upd_By = @sLoginID,    
    Dt_Upd_On = GETDATE()     
    WHERE I_Course_ID = @iCourseID    
  END     
    
  --Set the Batch status as enrollment full for the batch whose feeplan is being revoked at the center.    
  --UPDATE dbo.T_Center_Batch_Details SET I_Status = 6 WHERE I_Centre_Id = @iCenterID AND I_Course_Fee_Plan_ID = @iCourseFeePlan    
     
 END    
 COMMIT TRANSACTION    
--END    
--ELSE    
--BEGIN    
-- RAISERROR('Fee plan cannot be revoked. Batches are created for this Fee Plan at this center.',1,1)    
--END    
	--Set the Batch status as enrollment full for the batch whose feeplan is being revoked at the center.    
    UPDATE dbo.T_Center_Batch_Details SET I_Status = 6 WHERE I_Centre_Id = @iCenterID AND I_Course_Fee_Plan_ID = @iCourseFeePlan    
END TRY    
BEGIN CATCH    
 --Error occurred:      
 IF(@flag = 1)    
 BEGIN    
  ROLLBACK TRANSACTION    
 END    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
