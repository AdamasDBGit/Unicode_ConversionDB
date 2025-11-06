CREATE PROC [ASSESSMENT].[uspStudentCourseAssessmentTest] --338347      
(                  
 @sEnquiryID VARCHAR(500)             
)                  
AS                   
BEGIN           
          
SELECT tec.I_Enquiry_Regn_ID,tec.I_Course_ID,tcm.S_Course_Name FROM  dbo.T_Enquiry_Course AS tec           
INNER JOIN dbo.T_Course_Master AS tcm          
ON tec.I_Course_ID = tcm.I_Course_ID          
WHERE tec.I_Enquiry_Regn_ID=@sEnquiryID           
ORDER BY tcm.I_Course_ID          
        
INSERT INTO ASSESSMENT.T_Student_Assessment_Map(I_Enquiry_Regn_ID,I_PreAssessment_ID,I_Exam_Component_ID,B_Is_Complete )       
SELECT DISTINCT CAST(@sEnquiryID AS INT),C.I_PreAssessment_ID,D.I_Exam_Component_ID,0         
  FROM dbo.T_Enquiry_Course A          
  INNER JOIN ASSESSMENT.T_Assessment_Course_Map B          
  ON A.I_Course_ID = B.I_Course_ID          
  INNER JOIN ASSESSMENT.T_PreAssessment_Master C          
  ON B.I_PreAssessment_ID = C.I_PreAssessment_ID         
  INNER JOIN ASSESSMENT.T_PreAssessment_ExamComponent_Mapping D        
  ON C.I_PreAssessment_ID = D.I_PreAssessment_ID         
  WHERE I_Enquiry_Regn_ID =@sEnquiryID          
  AND C.I_Status = 1        
  AND D.I_Status = 1        
  AND C.I_PreAssessment_ID NOT IN (SELECT DISTINCT I_PreAssessment_ID         
           FROM ASSESSMENT.T_Student_Assessment_Map         
           WHERE I_Enquiry_Regn_ID = @sEnquiryID)        
        
SELECT DISTINCT A.I_PreAssessment_ID ,        
    S_PreAssessment_Name         
    FROM ASSESSMENT.T_Student_Assessment_Map A        
    INNER JOIN ASSESSMENT.T_PreAssessment_Master B        
    ON A.I_PreAssessment_ID = B.I_PreAssessment_ID        
    WHERE I_Enquiry_Regn_ID = @sEnquiryID         
    AND B_Is_Complete = 0        
          
END
