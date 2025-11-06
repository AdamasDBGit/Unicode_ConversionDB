CREATE PROCEDURE [dbo].[uspCheckForStudentPreassessmentTest]  --338345 --338366  --338318 --338567
(
  @iEnquiryID INT
)
AS                     
BEGIN    

SELECT DISTINCT @iEnquiryID,C.I_PreAssessment_ID,D.I_Exam_Component_ID
FROM dbo.T_Enquiry_Course A
INNER JOIN ASSESSMENT.T_Assessment_Course_Map B
ON A.I_Course_ID = B.I_Course_ID
INNER JOIN ASSESSMENT.T_PreAssessment_Master C
ON B.I_PreAssessment_ID = C.I_PreAssessment_ID
INNER JOIN ASSESSMENT.T_PreAssessment_ExamComponent_Mapping D
ON C.I_PreAssessment_ID = D.I_PreAssessment_ID
LEFT OUTER JOIN ASSESSMENT.T_Student_Assessment_Map AS TSAM
ON D.I_Exam_Component_ID = TSAM.I_Exam_Component_ID
WHERE A.I_Enquiry_Regn_ID =@iEnquiryID
AND C.I_Status = 1
AND D.I_Status = 1
AND ISNULL(TSAM.B_Is_Complete,0) = 0
--AND B.I_PreAssessment_ID  IN (SELECT DISTINCT I_PreAssessment_ID           
--           FROM ASSESSMENT.T_Student_Assessment_Map           
--           WHERE I_Enquiry_Regn_ID = @sEnquiryID AND B_Is_Complete=0) 
         
 END
