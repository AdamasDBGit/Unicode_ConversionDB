CREATE PROCEDURE [dbo].[uspGetCourseDtlForRegStudent]   
(  
  @iEnquiryId INT = NULL  
)      
  
AS  
  
BEGIN  
   
SELECT I_Registration_ID,I_Enquiry_Regn_ID,TSBM.I_Batch_ID,TCM.I_Course_ID,TCM.S_Course_Name,TCM.S_Course_Code,tcfm.I_CourseFamily_ID,tcfm.S_CourseFamily_Name  
FROM [dbo].[T_Student_Registration_Details] AS TSRD  
INNER JOIN   [dbo].[T_Student_Batch_Master] AS TSBM   
ON TSRD.I_Batch_ID=TSBM.I_Batch_ID  
INNER JOIN [dbo].[T_Course_Master] AS TCM  
ON TSBM.I_Course_ID=TCM.I_Course_ID  
INNER JOIN dbo.T_CourseFamily_Master AS tcfm   
ON TCM.I_CourseFamily_ID = tcfm.I_CourseFamily_ID  
WHERE TSRD.I_Enquiry_Regn_ID = COALESCE(@iEnquiryId ,TSRD.I_Enquiry_Regn_ID)  
AND TSRD.I_Status = 1  
END
