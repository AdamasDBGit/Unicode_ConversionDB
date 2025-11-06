/*      
-- =================================================================      
-- Author: Chandan Dey      
-- Modified By :      
-- Create date:31/10/2007      
-- Description:      
-- =================================================================      
*/      
CREATE PROCEDURE [PSCERTIFICATE].[uspGetPSCStatus] --NULL,NULL,NULL,NULL,NULL,NULL     
(       
 @iCenterID INT,      
 @iCourseID INT = NULL,      
 @iTermID INT = NULL,      
 @sCertSrlNo VARCHAR(200)= NULL,      
 --@sRegistrationNo VARCHAR(20) = NULL,      
 --@iStudentDetailID INT = NULL      
 @dtFromDate DATETIME = NULL,      
 @dtToDate DATETIME = NULL,  
 @iflag int = NULL     
)      
AS      
IF(@iTermID <> 0 )      
BEGIN      
  SELECT       
  DISTINCT(ISNULL(CDI.I_Despatch_ID,0)) AS I_Despatch_ID ,      
  ISNULL(CDI.Dt_Dispatch_Date,'') AS Dt_Dispatch_Date,      
  ISNULL(CDI.S_Docket_No,'') AS S_Docket_No,      
  ISNULL(SPSC.S_Certificate_Serial_No,'') AS S_Certificate_Serial_No,      
  ISNULL(SD.S_First_Name,'') AS S_First_Name,      
  ISNULL(SD.S_Middle_Name,'') AS S_Middle_Name,      
  ISNULL(SD.S_Last_Name,'') AS S_Last_Name,      
  ISNULL(SD.S_Title,'') AS S_Title,      
  ISNULL(CM.S_Course_Name,'') AS S_Course_Name,      
  ISNULL(CM.S_Course_Code,'') AS S_Course_Code,      
  ISNULL(TM.S_Term_Name,'') AS S_Term_Name,      
  ISNULL(TCM.S_Courier_Name,' ') AS S_Courier_Name  ,      
  ISNULL(SPSC.I_Status,0) AS I_Status,      
  ISNULL(SD.S_Student_ID, ' ') AS S_Student_ID,      
  SCOD.I_Batch_ID      
  FROM       
  PSCERTIFICATE.T_Student_PS_Certificate SPSC      
  LEFT OUTER JOIN PSCERTIFICATE.T_Certificate_Logistic CL      
  ON CL.I_Student_Certificate_ID = SPSC.I_Student_Certificate_ID      
  LEFT OUTER JOIN PSCERTIFICATE.T_Certificate_Despatch_Info CDI      
  ON CDI.I_Logistic_ID = CL.I_Logistic_ID      
  LEFT OUTER JOIN dbo.T_Courier_Master TCM      
  ON TCM.I_Courier_ID = CDI.I_Courier_ID      
  LEFT OUTER JOIN dbo.T_Student_Detail SD      
  ON SD.I_Student_Detail_ID = SPSC.I_Student_Detail_ID       
  LEFT OUTER JOIN dbo.T_Student_Center_Detail SCD      
  ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID      
  LEFT OUTER JOIN dbo.T_Student_Course_Detail SCOD      
  ON SD.I_Student_Detail_ID = SCOD.I_Student_Detail_ID      
  AND SPSC.I_Course_ID = SCOD.I_Course_ID      
  AND SCOD.I_Status = 1      
  LEFT OUTER JOIN dbo.T_Course_Master CM      
  ON CM.I_Course_ID = SPSC.I_Course_ID      
  LEFT OUTER JOIN dbo.T_Term_Master TM      
  ON TM.I_Term_ID = SPSC.I_Term_ID      
  LEFT OUTER JOIN EXAMINATION.T_Eligibility_List EL      
  ON EL.I_Student_Detail_ID = SPSC.I_Student_Detail_ID       
  LEFT OUTER JOIN EXAMINATION.T_Examination_Detail ED      
  ON ED.I_Exam_ID = EL.I_Exam_ID      
  WHERE      
  SCD.I_Centre_ID = COALESCE(@iCenterID, SCD.I_Centre_ID)      
  AND SPSC.S_Certificate_Serial_No = COALESCE(@sCertSrlNo, SPSC.S_Certificate_Serial_No)      
  AND SPSC.I_Course_ID = COALESCE(@iCourseID, SPSC.I_Course_ID)      
  AND SPSC.I_Term_ID = COALESCE(@iTermID, SPSC.I_Term_ID)      
  --AND SPSC.I_Student_Detail_ID = COALESCE(@iStudentDetailID, SPSC.I_Student_Detail_ID)      
  AND CDI.Dt_Dispatch_Date >= COALESCE(@dtFromDate, CDI.Dt_Dispatch_Date)      
  AND CDI.Dt_Dispatch_Date <= COALESCE(@dtToDate, CDI.Dt_Dispatch_Date)      
END      
ELSE IF @iflag = 0  
BEGIN      
  SELECT       
  DISTINCT(ISNULL(CDI.I_Despatch_ID,0)) AS I_Despatch_ID ,      
  ISNULL(CDI.Dt_Dispatch_Date,'') AS Dt_Dispatch_Date,      
  ISNULL(CDI.S_Docket_No,'') AS S_Docket_No,      
  ISNULL(SPSC.S_Certificate_Serial_No,'') AS S_Certificate_Serial_No,      
  ISNULL(SD.S_First_Name,'') AS S_First_Name,      
  ISNULL(SD.S_Middle_Name,'') AS S_Middle_Name,      
  ISNULL(SD.S_Last_Name,'') AS S_Last_Name,      
  ISNULL(SD.S_Title,'') AS S_Title,      
  ISNULL(CM.S_Course_Name,'') AS S_Course_Name,      
  ISNULL(CM.S_Course_Code,'') AS S_Course_Code,      
  ISNULL(TM.S_Term_Name,'') AS S_Term_Name,      
  ISNULL(TCM.S_Courier_Name,' ') AS S_Courier_Name  ,      
  ISNULL(SPSC.I_Status,0) AS I_Status,      
  ISNULL(SD.S_Student_ID, ' ') AS S_Student_ID,      
  SCOD.I_Batch_ID      
  FROM       
  PSCERTIFICATE.T_Student_PS_Certificate SPSC      
  LEFT OUTER JOIN PSCERTIFICATE.T_Certificate_Logistic CL      
  ON CL.I_Student_Certificate_ID = SPSC.I_Student_Certificate_ID      
  LEFT OUTER JOIN PSCERTIFICATE.T_Certificate_Despatch_Info CDI      
  ON CDI.I_Logistic_ID = CL.I_Logistic_ID      
  LEFT OUTER JOIN dbo.T_Courier_Master TCM      
  ON TCM.I_Courier_ID = CDI.I_Courier_ID      
  LEFT OUTER JOIN dbo.T_Student_Detail SD      
  ON SD.I_Student_Detail_ID = SPSC.I_Student_Detail_ID       
  LEFT OUTER JOIN dbo.T_Student_Center_Detail SCD      
  ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID      
  LEFT OUTER JOIN dbo.T_Course_Master CM      
  ON CM.I_Course_ID = SPSC.I_Course_ID      
  LEFT OUTER JOIN dbo.T_Student_Course_Detail SCOD      
  ON SD.I_Student_Detail_ID = SCOD.I_Student_Detail_ID      
  AND SPSC.I_Course_ID = SCOD.I_Course_ID      
  AND SCOD.I_Status = 1      
  LEFT OUTER JOIN dbo.T_Term_Master TM      
  ON TM.I_Term_ID = SPSC.I_Term_ID      
  LEFT OUTER JOIN EXAMINATION.T_Eligibility_List EL      
  ON EL.I_Student_Detail_ID = SPSC.I_Student_Detail_ID       
  LEFT OUTER JOIN EXAMINATION.T_Examination_Detail ED      
  ON ED.I_Exam_ID = EL.I_Exam_ID      
  WHERE      
     SCD.I_Centre_ID = COALESCE(@iCenterID, SCD.I_Centre_ID)      
  AND SPSC.S_Certificate_Serial_No = COALESCE(@sCertSrlNo, SPSC.S_Certificate_Serial_No)      
  AND SPSC.I_Course_ID = COALESCE(@iCourseID, SPSC.I_Course_ID)      
  AND SPSC.I_Term_ID IS NULL      
  AND CDI.Dt_Dispatch_Date >= COALESCE(@dtFromDate, CDI.Dt_Dispatch_Date)      
  AND CDI.Dt_Dispatch_Date <= COALESCE(@dtToDate, CDI.Dt_Dispatch_Date)      
END      
ELSE   
BEGIN  
 BEGIN      
  SELECT       
  DISTINCT(ISNULL(CDI.I_Despatch_ID,0)) AS I_Despatch_ID ,      
  ISNULL(CDI.Dt_Dispatch_Date,'') AS Dt_Dispatch_Date,      
  ISNULL(CDI.S_Docket_No,'') AS S_Docket_No,      
  ISNULL(SPSC.S_Certificate_Serial_No,'') AS S_Certificate_Serial_No,      
  ISNULL(SD.S_First_Name,'') AS S_First_Name,      
  ISNULL(SD.S_Middle_Name,'') AS S_Middle_Name,      
  ISNULL(SD.S_Last_Name,'') AS S_Last_Name,      
  ISNULL(SD.S_Title,'') AS S_Title,      
  ISNULL(CM.S_Course_Name,'') AS S_Course_Name,      
  ISNULL(CM.S_Course_Code,'') AS S_Course_Code,      
  ISNULL(TM.S_Term_Name,'') AS S_Term_Name,      
  ISNULL(TCM.S_Courier_Name,' ') AS S_Courier_Name  ,      
  ISNULL(SPSC.I_Status,0) AS I_Status,      
  ISNULL(SD.S_Student_ID, ' ') AS S_Student_ID,      
  SCOD.I_Batch_ID      
  FROM       
  PSCERTIFICATE.T_Student_PS_Certificate SPSC      
  LEFT OUTER JOIN PSCERTIFICATE.T_Certificate_Logistic CL      
  ON CL.I_Student_Certificate_ID = SPSC.I_Student_Certificate_ID      
  LEFT OUTER JOIN PSCERTIFICATE.T_Certificate_Despatch_Info CDI      
  ON CDI.I_Logistic_ID = CL.I_Logistic_ID      
  LEFT OUTER JOIN dbo.T_Courier_Master TCM      
  ON TCM.I_Courier_ID = CDI.I_Courier_ID      
  LEFT OUTER JOIN dbo.T_Student_Detail SD      
  ON SD.I_Student_Detail_ID = SPSC.I_Student_Detail_ID       
  LEFT OUTER JOIN dbo.T_Student_Center_Detail SCD      
  ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID      
  LEFT OUTER JOIN dbo.T_Course_Master CM      
  ON CM.I_Course_ID = SPSC.I_Course_ID      
  LEFT OUTER JOIN dbo.T_Student_Course_Detail SCOD      
  ON SD.I_Student_Detail_ID = SCOD.I_Student_Detail_ID      
  AND SPSC.I_Course_ID = SCOD.I_Course_ID      
  AND SCOD.I_Status = 1      
  LEFT OUTER JOIN dbo.T_Term_Master TM      
  ON TM.I_Term_ID = SPSC.I_Term_ID      
  LEFT OUTER JOIN EXAMINATION.T_Eligibility_List EL      
  ON EL.I_Student_Detail_ID = SPSC.I_Student_Detail_ID       
  LEFT OUTER JOIN EXAMINATION.T_Examination_Detail ED      
  ON ED.I_Exam_ID = EL.I_Exam_ID      
  WHERE      
     SCD.I_Centre_ID = COALESCE(@iCenterID, SCD.I_Centre_ID)      
  AND SPSC.S_Certificate_Serial_No = COALESCE(@sCertSrlNo, SPSC.S_Certificate_Serial_No)      
  AND SPSC.I_Course_ID = COALESCE(@iCourseID, SPSC.I_Course_ID)    
  AND SPSC.I_Term_ID IS NULL      
  AND SPSC.Dt_Certificate_Issue_Date >= COALESCE(@dtFromDate, SPSC.Dt_Certificate_Issue_Date)      
  AND SPSC.Dt_Certificate_Issue_Date <= COALESCE(@dtToDate, SPSC.Dt_Certificate_Issue_Date)  
  AND CL.I_Status IN (0,1)    
END   
END
