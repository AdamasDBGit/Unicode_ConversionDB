/*  
-- =================================================================  
-- Author:Chandan Dey  
-- Create date:16/06/2007  
-- Description:Get Certificate Serial No record From T_Student_PS_Certificate table  
-- Parameter : CourseID, TermID PSCert  
-- =================================================================  
*/  
  
CREATE PROCEDURE [PSCERTIFICATE].[uspGetCertificateSerialNo]  
(  
 @iCourseID INT ,  
 @iTermID INT,  
 @iPSCert INT,  
 @iStudentID INT  
)  
AS  
BEGIN  
 --IF(@iPSCert = 0 AND @iTermID IS NULL)  
 ---- Course Certificate  
 --BEGIN  
 -- SELECT ISNULL(SPC.I_Student_Certificate_ID, ' ') AS I_Student_Certificate_ID,  
 --       ISNULL(SPC.S_Certificate_Serial_No, ' ') AS S_Certificate_Serial_No,  
 --     ISNULL(CL.S_Logistic_Serial_No,'') AS S_Logistic_Serial_No  
 -- FROM  [PSCERTIFICATE].T_Student_PS_Certificate SPC  
 --    LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Logistic CL  
 --    ON CL.I_Student_Certificate_ID = SPC.I_Student_Certificate_ID  
 -- WHERE (SPC.I_Status = 2 OR SPC.I_Status = 3)  
 -- AND SPC.I_Course_ID = COALESCE(@iCourseID, SPC.I_Course_ID)  
 -- AND SPC.I_Term_ID IS NULL  
 -- AND SPC.B_PS_Flag = 0  
 -- AND SPC.I_Student_Detail_ID = COALESCE(@iStudentID, SPC.I_Student_Detail_ID)  
 -- AND CL.I_Status = 1  
 --END  
 --ELSE IF (@iPSCert = 1 ) --AND @iTermID IS NULL)  
 ---- PS  
 --BEGIN  
 -- SELECT ISNULL(SPC.I_Student_Certificate_ID, ' ') AS I_Student_Certificate_ID,  
 --       ISNULL(SPC.S_Certificate_Serial_No, ' ') AS S_Certificate_Serial_No,  
 --     ISNULL(CL.S_Logistic_Serial_No,'') AS S_Logistic_Serial_No  
 -- FROM  [PSCERTIFICATE].T_Student_PS_Certificate SPC  
 --    LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Logistic CL  
 --    ON CL.I_Student_Certificate_ID = SPC.I_Student_Certificate_ID  
 -- WHERE (SPC.I_Status = 2 OR SPC.I_Status = 3)  
 -- AND SPC.I_Course_ID = COALESCE(@iCourseID, SPC.I_Course_ID)  
 -- AND SPC.I_Term_ID = COALESCE(@iTermID, SPC.I_Term_ID)  
 -- AND SPC.B_PS_Flag = 1  
 -- AND SPC.I_Student_Detail_ID = COALESCE(@iStudentID, SPC.I_Student_Detail_ID)  
 -- AND CL.I_Status = 1  
 --END  
 --ELSE  
 ---- Term Certificate  
 ----BEGIN  
 SELECT ISNULL(SPC.I_Student_Certificate_ID, ' ') AS I_Student_Certificate_ID,  
       ISNULL(SPC.S_Certificate_Serial_No, ' ') AS S_Certificate_Serial_No,  
     ISNULL(CL.S_Logistic_Serial_No,'') AS S_Logistic_Serial_No  
 FROM  [PSCERTIFICATE].T_Student_PS_Certificate SPC  
    LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Logistic CL  
    ON CL.I_Student_Certificate_ID = SPC.I_Student_Certificate_ID  
 WHERE (SPC.I_Status = 3)  
    AND SPC.I_Course_ID = COALESCE(@iCourseID, SPC.I_Course_ID)  
 --AND SPC.I_Term_ID = COALESCE(@iTermID, SPC.I_Term_ID)  
 --AND SPC.B_PS_Flag = 0  
 AND SPC.I_Student_Detail_ID = COALESCE(@iStudentID, SPC.I_Student_Detail_ID)  
 AND CL.I_Status = 1  
 --END  
END
