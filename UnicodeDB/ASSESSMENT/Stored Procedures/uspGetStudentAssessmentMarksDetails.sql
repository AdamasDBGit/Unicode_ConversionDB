CREATE PROCEDURE [ASSESSMENT].[uspGetStudentAssessmentMarksDetails]  --338347           
(            
 @iEnquiryID INT                
)            
AS                   
BEGIN     
    
SELECT * INTO #temp1    
  FROM    
   (SELECT tsam.I_Enquiry_Regn_ID,tpam.I_PreAssessment_ID,tpam.S_PreAssessment_Name,tecm.I_Exam_Component_ID,tecm.S_Component_Name,tecm.I_Exam_Type_Master_ID,tetm.S_Exam_Type_Name FROM ASSESSMENT.T_Student_Assessment_Map AS tsam    
INNER JOIN ASSESSMENT.T_PreAssessment_Master AS tpam    
ON tsam.I_PreAssessment_ID = tpam.I_PreAssessment_ID    
INNER JOIN dbo.T_Exam_Component_Master AS tecm    
ON  tsam.I_Exam_Component_ID=tecm.I_Exam_Component_ID    
INNER JOIN dbo.T_Exam_Type_Master AS tetm    
ON tecm.I_Exam_Type_Master_ID = tetm.I_Exam_Type_Master_ID    
WHERE tsam.I_Enquiry_Regn_ID = @iEnquiryID    
AND B_Is_Complete =1  
) T1    
        
      --SELECT * FROM #temp1 AS t1    
  
SELECT * INTO #temp2    
FROM    
(    
		SELECT I_Exam_Component_ID AS ECompId,N_Marks FROM EOS.T_Employee_Exam_Result AS teer  
		WHERE I_Enquiry_Regn_ID = @iEnquiryID 
		AND I_Exam_Component_ID IN (SELECT I_Exam_Component_ID from #temp1 WHERE I_Enquiry_Regn_ID = @iEnquiryID )
 ) T2    
      
      
      
  --SELECT * FROM #temp2 AS t2    
      
SELECT * INTO #temp3             
 FROM              
  (    
  SELECT I_Exam_Component_ID ,        
        SUM(I_Value) AS Rating FROM STUDENTFEATURES.T_Student_Feedback AS tsf        
INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details AS tsfd        
ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID        
INNER JOIN ACADEMICS.T_Feedback_Option_Master AS tfom        
ON tsfd.I_Feedback_Option_Master_ID = tfom.I_Feedback_Option_Master_ID        
INNER JOIN ACADEMICS.T_Feedback_Master AS tfm        
ON tfom.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID        
WHERE I_Enquiry_Regn_ID =  @iEnquiryID    
group BY I_Enquiry_Regn_ID,I_Exam_Component_ID) T3        
    
--SELECT * FROM #temp3 AS t3    
    
 SELECT * INTO #tempMarks           
  FROM    
  (    
    SELECT *  FROM #temp1 AS t1     
    LEFT OUTER JOIN #temp2 AS t2    
    ON t1.I_Exam_Component_ID = t2.ECompId    
     
  ) AS T4    
      
 ---SELECT * FROM #tempMarks    
     
     
   SELECT I_Enquiry_Regn_ID,I_PreAssessment_ID,S_PreAssessment_Name,tm1.I_Exam_Component_ID,S_Component_Name,I_Exam_Type_Master_ID,S_Exam_Type_Name,N_Marks,Rating from #tempMarks  AS tm1    
   LEFT OUTER JOIN #temp3 AS t3    
   ON tm1.I_Exam_Component_ID = t3.I_Exam_Component_ID    
      
      
  DROP TABLE #tempMarks        
  DROP TABLE #temp3    
  DROP TABLE #temp2    
  DROP TABLE #temp1    

      
  END
