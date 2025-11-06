CREATE FUNCTION [ACADEMICS].[ufnGetStudentAcademicDropoutStatusBatch]  
    (  
      @iStudentID int,  
      @iBatchID INT,
      @iCenterID int,  
      @iAllowedNumberOfNonAttendedDays int,  
      @dCurrenDate datetime  
    )  
RETURNS CHAR(1)  
AS   
   BEGIN  
  
    DECLARE @cDropoutStatus CHAR(1)  
    DECLARE @dDateCompare DATETIME  
  
    SELECT @dCurrenDate =dbo.fnGetDatePart(@dCurrenDate)  
  
    SET @cDropoutStatus = 'N'  
  
 --Check for a single Attendance has been given by the student  
 IF (ISNULL(( SELECT COUNT(*) FROM   
    DBO.T_STUDENT_ATTENDANCE_DETAILS WITH(NOLOCK)   
    WHERE I_STUDENT_DETAIL_ID =@iStudentID AND I_Centre_Id = @iCenterID AND I_Batch_ID = @iBatchID
   ),0)=0)  
 BEGIN  
   SET @cDropoutStatus = 'Y'  
   RETURN @cDropoutStatus   
 END  
   
 --Check All the Attendance for all session have been given by the student  
 DECLARE @iSessionCount INT  
 DECLARE @iTotalAttendanceCount INT  
  
 SELECT @iSessionCount=[dbo].[fnGetTotalSessionCount](@iBatchID,@iCenterID,NULL,NULL)
  
 SELECT @iTotalAttendanceCount = COUNT(*) FROM   
    DBO.T_STUDENT_ATTENDANCE_DETAILS WITH(NOLOCK)   
    WHERE I_STUDENT_DETAIL_ID =@iStudentID AND I_Centre_Id = @iCenterID AND I_Batch_ID = @iBatchID
  
 IF (@iSessionCount<=@iTotalAttendanceCount)  
 BEGIN  
   SET @cDropoutStatus = 'N'  
   RETURN @cDropoutStatus  
 END  
  
 -- Check if Student has given attendance within the configured number of days  
    IF ( ( SELECT   DATEDIFF(day,  
                                     ( SELECT   
                                                MAX(Dt_Attendance_Date)  
                                       FROM     dbo.T_Student_Attendance_Details WITH(NOLOCK)  
                                       WHERE    I_Student_Detail_ID = @iStudentID  
                                                AND I_Centre_Id = @iCenterID
                                                AND I_Batch_ID = @iBatchID  
                                     ), @dCurrenDate)  
                 ) >= @iAllowedNumberOfNonAttendedDays )   
    BEGIN  
        SET @cDropoutStatus = 'Y'  
  RETURN @cDropoutStatus  
    END  
  -- Return the information to the caller  
    RETURN @cDropoutStatus  
END