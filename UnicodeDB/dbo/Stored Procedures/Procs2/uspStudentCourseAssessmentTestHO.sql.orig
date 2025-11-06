CREATE PROC [dbo].[uspStudentCourseAssessmentTestHO]      
(            
 @sEnquiryID VARCHAR(50),  
 @dtDOB DATETIME  = NULL,  
 @sFirstName varchar(200)  = NULL,  
 @sMiddleName varchar(200)  = NULL,  
 @sLastName varchar(200) = NULL      
)            
AS             
BEGIN     
    
SELECT tec.I_Enquiry_Regn_ID,tec.I_Course_ID,tcm.S_Course_Name FROM  dbo.T_Enquiry_Course AS tec     
INNER JOIN dbo.T_Course_Master AS tcm    
ON tec.I_Course_ID = tcm.I_Course_ID    
INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd  
ON  tec.I_Enquiry_Regn_ID=terd.I_Enquiry_Regn_ID  
WHERE tec.I_Enquiry_Regn_ID=@sEnquiryID AND   
terd.Dt_Birth_Date = ISNULL(@dtDOB,terd.Dt_Birth_Date) AND  
terd.S_First_Name LIKE ISNULL(@sFirstName,terd.S_First_Name) + '%' AND            
terd.S_Middle_Name LIKE ISNULL(@sMiddleName,terd.S_Middle_Name) + '%'  AND            
terd.S_Last_Name LIKE ISNULL(@sLastName,terd.S_Last_Name) + '%'         
ORDER BY tcm.I_Course_ID    
    
SELECT DISTINCT C.I_PreAssessment_ID,C.S_PreAssessment_Name FROM dbo.T_Enquiry_Course A    
INNER JOIN dbo.T_Assessment_Course_Map B    
ON A.I_Course_ID = B.I_Course_ID    
INNER JOIN dbo.T_PreAssessment_Master C    
ON B.I_PreAssessment_ID = C.I_PreAssessment_ID    
INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd  
ON  A.I_Enquiry_Regn_ID=terd.I_Enquiry_Regn_ID  
WHERE A.I_Enquiry_Regn_ID =@sEnquiryID  AND  
terd.Dt_Birth_Date = ISNULL(@dtDOB,terd.Dt_Birth_Date) AND  
terd.S_First_Name LIKE ISNULL(@sFirstName,terd.S_First_Name) + '%' AND            
terd.S_Middle_Name LIKE ISNULL(@sMiddleName,terd.S_Middle_Name) + '%'  AND            
terd.S_Last_Name LIKE ISNULL(@sLastName,terd.S_Last_Name) + '%'         
    
END
