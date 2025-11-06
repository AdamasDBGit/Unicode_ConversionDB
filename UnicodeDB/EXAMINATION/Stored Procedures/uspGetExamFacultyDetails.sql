--------------------------------------------------------------------------------------------  
--Issue No 278  
--------------------------------------------------------------------------------------------  
  
CREATE PROCEDURE [EXAMINATION].[uspGetExamFacultyDetails] -- [EXAMINATION].[uspGetExamFacultyDetails] 20,31,null,3
    (
      @iBatchID INT ,
      @iTermID INT ,
      @iModuleID INT = NULL  ,
      @iExamComponentID INT
    )
AS 
    BEGIN  
		IF(@iModuleID IS NULL)
		BEGIN
			SELECT I_Batch_Exam_ID FROM EXAMINATION.T_Batch_Exam_Map 
			WHERE I_Batch_ID= @iBatchID AND I_Term_ID=@iTermID 
			AND I_Exam_Component_ID=@iExamComponentID
			AND I_Status=1
			
			SELECT STUFF(( SELECT  ', ' + CAST(I_Employee_ID AS VARCHAR(20))
							FROM    EXAMINATION.T_Batch_Exam_Faculty_Map
							WHERE   ( I_Batch_Exam_ID = (SELECT I_Batch_Exam_ID FROM EXAMINATION.T_Batch_Exam_Map 
														 WHERE I_Batch_ID= @iBatchID AND I_Term_ID=@iTermID
														 AND I_Exam_Component_ID=@iExamComponentID AND I_Status=1))
						  FOR
							XML PATH('')
						  ), 1, 2, '') AS EmployeeIDs
        END
        ELSE
        BEGIN
			SELECT I_Batch_Exam_ID FROM EXAMINATION.T_Batch_Exam_Map 
			WHERE I_Batch_ID= @iBatchID AND I_Term_ID=@iTermID AND
			I_Module_ID=ISNULL(@iModuleID,I_Module_ID) AND I_Exam_Component_ID=@iExamComponentID
			AND I_Status=1
			
			SELECT STUFF(( SELECT  ', ' + CAST(I_Employee_ID AS VARCHAR(20))
							FROM    EXAMINATION.T_Batch_Exam_Faculty_Map
							WHERE   ( I_Batch_Exam_ID = (SELECT I_Batch_Exam_ID FROM EXAMINATION.T_Batch_Exam_Map 
														 WHERE I_Batch_ID= @iBatchID AND I_Term_ID=@iTermID AND
														 I_Module_ID=@iModuleID AND I_Exam_Component_ID=@iExamComponentID AND I_Status=1))
						  FOR
							XML PATH('')
						  ), 1, 2, '') AS EmployeeIDs
        END
    END
