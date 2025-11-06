CREATE PROCEDURE [ASSESSMENT].[uspGetStudentAssessmentExamDetails] --1212,338338,0            
(        
 @iEnquiryID INT            
)        
AS               
BEGIN     
DECLARE @UserResponseXML XML           
SELECT  @UserResponseXML = S_Answer_XML        
        FROM EOS.T_Employee_Exam_Result WHERE I_Enquiry_Regn_ID = 338345 AND I_Exam_Component_ID = 1212        
        
DECLARE @docHandle int         
EXEC sp_xml_preparedocument @docHandle OUTPUT, @UserResponseXML         
        
   SELECT * INTO #temp         
   FROM          
  (SELECT I_Question_ID,I_User_Response_ID        
       FROM OPENXML(@docHandle, '/QuestionList/Question/Response/Answer', 1)         
       WITH (I_Question_ID INT '@QuestionID',I_User_Response_ID INT '@QuestionChoiceID')) T

SELECT * FROM #temp AS t

SELECT I_Exam_Component_ID,SUM(N_Marks) AS N_Total_Marks,SUM(N_Marks_Obtained) AS N_Marks_Obtained FROM         
(SELECT DISTINCT A.I_Question_ID ,
		TD.I_Exam_Component_ID,        
        A.I_Pool_ID ,     
        A.I_Complexity_ID ,        
        B.I_Question_Choice_ID,        
        C.N_Marks,        
        D.I_User_Response_ID,        
        N_Marks_Obtained =        
        CASE WHEN B.I_Question_Choice_ID = D.I_User_Response_ID THEN  C.N_Marks        
    ELSE 0         
     END         
        FROM EXAMINATION.T_Question_Pool A        
  INNER JOIN EXAMINATION.T_Question_Choices B        
  ON A.I_Question_ID = B.I_Question_ID        
  AND B_Is_Answer = 1        
  INNER JOIN EXAMINATION.T_Test_Design_Pattern C        
  ON A.I_Pool_ID = C.I_Pool_ID        
  AND A.I_Complexity_ID = C.I_Complexity_ID        
  INNER JOIN #temp D        
  ON A.I_Question_ID = D.I_Question_ID 
  INNER JOIN EXAMINATION.T_Test_Design TD WITH(NOLOCK)          
  ON TD.I_Test_Design_ID = C.I_Test_Design_ID     
  WHERE TD.I_Status_ID = 1          
  AND TD.I_Exam_Component_ID = 1212)T
  GROUP BY T.I_Exam_Component_ID  
  
  DROP TABLE #temp
  
  END
