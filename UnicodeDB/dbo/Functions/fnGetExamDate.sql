-- =============================================  
-- Author:  Shankha Roy  
-- Create date: '07/26/2007'  
-- Description: This Function return a date  
-- constains date of exam given student id for print PS  
-- Return: Table  
-- =============================================  
CREATE FUNCTION [dbo].[fnGetExamDate]
    (
      @iStudentId INT ,
      @iBatchID INT ,
      @iTermID INT = NULL  
    )
RETURNS DATETIME
AS 
    BEGIN  
        DECLARE @ExamDate DATETIME  
  
        SET @ExamDate = ( SELECT    MAX(TSM.Dt_Exam_Date) AS ExamDate
                          FROM      EXAMINATION.T_Batch_Exam_Map SM
                                    INNER JOIN dbo.T_Exam_Component_Master ECM ON SM.I_Exam_Component_ID = ECM.I_Exam_Component_ID
                                    INNER JOIN EXAMINATION.T_Student_Marks AS TSM ON SM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                          WHERE     ( TSM.I_Student_Detail_ID = @iStudentId )
                                    AND SM.I_Batch_ID = @iBatchID
                                    AND ECM.I_Exam_Type_Master_ID = 3 --SemEndExam Type  
                                    AND SM.I_Term_ID = COALESCE(@iTermID,
                                                              SM.I_Term_ID)
                        )  
  -- In case SemEnd Exam type is not present for course  
        IF @ExamDate IS NULL 
            BEGIN  
                SET @ExamDate = ( SELECT    MAX(TSM.Dt_Exam_Date) AS ExamDate
                                  FROM      EXAMINATION.T_Batch_Exam_Map SM
                                            INNER JOIN dbo.T_Exam_Component_Master ECM ON SM.I_Exam_Component_ID = ECM.I_Exam_Component_ID
                                            INNER JOIN EXAMINATION.T_Student_Marks TSM ON SM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                                  WHERE     ( TSM.I_Student_Detail_ID = @iStudentId )
                                            AND SM.I_Batch_ID = @iBatchID
                                            AND ECM.I_Exam_Type_Master_ID = 3 --SemEndExam Type  
                                            AND SM.I_Term_ID = COALESCE(@iTermID,
                                                              SM.I_Term_ID)
                                )     
            END  
    
-- For the course which don't have any exam that case date will be last    
-- attendance date of student  
        IF @ExamDate IS NULL 
            BEGIN  
                SET @ExamDate = ( SELECT    MAX(Dt_Attendance_Date)
                                  FROM      dbo.T_Student_Attendance_Details
                                  WHERE     I_Student_Detail_ID = @iStudentId
                                            AND I_Batch_ID = @iBatchID
                                )     
            END  
    
    
  
        RETURN @ExamDate ;  
    END