/*  
-- =============================================================================================================================  
-- Author:Sandeep Acharyya  
-- Create date:28/02/2011  
-- Description:This procedure will be insert the eligibility of the student for Completion or participation type of certificate  
-- Parameter : StudentDetailID,CourseID, TermID (Optional), UpdatedBy, UpdatedOn  
-- =============================================================================================================================  
*/  
  
CREATE PROCEDURE [PSCERTIFICATE].[uspUpdateStudentCertificateEligibility]  
    (  
      @iStudentDetailID int,  
      @iCourseID int,  
      @iTermID int = null,  
      @sUser varchar(20),  
      @dDate DATETIME,  
      @bAttendanceNotRequired BIT = 0,  
      @bFinancialCheckNotRequired BIT = 0  
    )  
AS  
BEGIN  
    BEGIN TRY  
  DECLARE @bAttendanceCriteriaPassed BIT, @bFinancialCriteriaPassed BIT  
  SET @bAttendanceCriteriaPassed = 0  
  SET @bFinancialCriteriaPassed = 0  
      
  DECLARE @CenterID INT  
  SELECT TOP 1 @CenterID = [TSCd].[I_Centre_Id] FROM [dbo].[T_Student_Center_Detail] AS TSCD  
  WHERE [TSCD].[I_Student_Detail_ID] = @iStudentDetailID AND [TSCD].[I_Status] = 1  
      
  DECLARE @TotalSessionCount INT  
  SELECT @TotalSessionCount = COUNT(SM.I_Session_Module_ID)  
  FROM dbo.T_Term_Course_Map TC  
   INNER JOIN dbo.T_Module_Term_Map MT  
   ON TC.I_Term_ID = MT.I_Term_ID  
    AND MT.I_Status = 1  
   INNER JOIN dbo.T_Session_Module_Map SM  
   ON ISNULL(MT.I_Module_ID,0) = ISNULL(SM.I_Module_ID,0)  
    AND SM.I_Status = 1  
  WHERE TC.I_Course_ID = ISNULL(@iCourseID,TC.I_Course_ID)   
  AND TC.I_Status = 1  
  
  DECLARE @TotalSession INT  
  SELECT @TotalSession = COUNT(SM.I_Session_Module_ID)  
  FROM dbo.T_Term_Course_Map TC  
   INNER JOIN dbo.T_Module_Term_Map MT  
   ON TC.I_Term_ID = MT.I_Term_ID  
    AND MT.I_Status = 1  
   INNER JOIN dbo.T_Session_Module_Map SM  
   ON ISNULL(MT.I_Module_ID,0) = ISNULL(SM.I_Module_ID,0)  
    AND SM.I_Status = 1  
  WHERE TC.I_Course_ID = @iCourseID  
  AND TC.I_Term_ID = ISNULL(@iTermID,TC.I_Term_ID)  
  AND TC.I_Status = 1  
    
  DECLARE @MinAttendance INT  
  SET @MinAttendance = -1  
    
  SELECT @MinAttendance = CAST([TCC].[S_Config_Value] AS INT) FROM [dbo].[T_Center_Configuration] AS TCC  
  WHERE [TCC].[S_Config_Code] = 'CENTER_ATTENDANCE_REQUIRED' AND [TCC].[I_Center_Id] = @CenterID  AND [TCC].[I_Status] = 1
    
  IF (@MinAttendance = -1)  
  BEGIN  
   SELECT @MinAttendance = CAST([TCC].[S_Config_Value] AS INT) FROM [dbo].[T_Center_Configuration] AS TCC  
   WHERE [TCC].[S_Config_Code] = 'CENTER_ATTENDANCE_REQUIRED' AND [TCC].[I_Status] = 1   
  END  
    
  IF (dbo.ufnGetStudentStatusAttendance(@CenterID, @iStudentDetailID, @iCourseID, @iTermID,null,@MinAttendance,@TotalSession) = 'Cleared')  
  BEGIN  
   SET @bAttendanceCriteriaPassed = 1  
  END  
    
  IF (EXAMINATION.fnCheckFinancialCriteria(@iStudentDetailID,@CenterID,@iCourseID, @iTermID,null,@TotalSessionCount,@TotalSession) = 'Y')  
  BEGIN  
   SET @bFinancialCriteriaPassed = 1   
  END  
  
  -- ENTER RECORD IN PSCERTIFICATE.T_Student_PS_Certificate FOR COURSE CERTIFICATE  
  IF ((@bAttendanceNotRequired = 1 OR @bAttendanceCriteriaPassed = 1) AND (@bFinancialCheckNotRequired = 1 OR @bFinancialCriteriaPassed = 1))  
  BEGIN  
   IF EXISTS ( SELECT TCM.[I_Course_ID] FROM    dbo.T_Course_Master TCM WITH(NOLOCK)  
      WHERE   TCM.I_Course_ID = @iCourseID AND TCM.I_Certificate_ID > 0 AND TCM.I_Status = 1 )  
   BEGIN                  
    IF NOT EXISTS (SELECT [TSPC].[I_Student_Certificate_ID] FROM [PSCERTIFICATE].[T_Student_PS_Certificate] AS TSPC  
        WHERE [TSPC].[I_Course_ID] = @iCourseID AND [TSPC].[I_Student_Detail_ID] = @iStudentDetailID)  
    BEGIN       
     IF EXISTS (SELECT [TSTD].[I_Student_Term_Detail_ID] FROM [dbo].[T_Student_Term_Detail] AS TSTD  
        WHERE [TSTD].[I_Course_ID] = @iCourseID AND [TSTD].[I_Student_Detail_ID] = @iStudentDetailID  
        AND [TSTD].[I_Term_ID] = ISNULL(@iTermID,[TSTD].[I_Term_ID])  
        AND ([TSTD].[I_Is_Completed] = 0 OR [TSTD].[S_Term_Status] <> 'Pass'))  
      INSERT  INTO PSCERTIFICATE.T_Student_PS_Certificate  
        (I_Student_Detail_ID,I_Course_ID,B_PS_Flag,I_Status,S_Crtd_By,Dt_Crtd_On,C_Certificate_Type)  
      SELECT  @iStudentDetailID,@iCourseID,0,1,@sUser,@dDate,'P'  
     ELSE  
      INSERT  INTO PSCERTIFICATE.T_Student_PS_Certificate  
        (I_Student_Detail_ID,I_Course_ID,[I_Term_ID],B_PS_Flag,I_Status,S_Crtd_By,Dt_Crtd_On,C_Certificate_Type)  
      SELECT  @iStudentDetailID,@iCourseID,@iTermID,0,1,@sUser,@dDate,'C'  
    END  
   END  
  END  
  
 -- Update the S_Certificate_Serial_No column in T_Student_PS_Certificate table for all Certificate entries done today  
        UPDATE  PSCERTIFICATE.T_Student_PS_Certificate  
        SET     S_Certificate_Serial_No = 'CERT_'  
                + CAST(SPSC.I_Student_Certificate_ID AS VARCHAR(150))  
        FROM    PSCERTIFICATE.T_Student_PS_Certificate SPSC  
        WHERE   SPSC.S_Crtd_By = @sUser  
                AND SPSC.Dt_Crtd_On = @dDate  
                AND ISNULL(SPSC.B_PS_Flag, 0) = 0  
  
    END TRY  
    BEGIN CATCH  
   
        DECLARE @ErrMsg NVARCHAR(4000),  
            @ErrSeverity int  
  
        SELECT  @ErrMsg = ERROR_MESSAGE(),  
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR ( @ErrMsg, @ErrSeverity, 1 )  
    END CATCH  
END
