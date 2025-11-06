CREATE PROCEDURE [dbo].[uspGetUserVideoContentdtl] --292488 --291572           
(                    
 -- Add the parameters for the stored procedure here                    
 @iUserID INT                  
)                    
AS                    
BEGIN        
  
SELECT tbcd.I_Batch_ID,S_Batch_Code,S_Batch_Name,I_Content_Emp_Dtl_ID,tced.I_User_ID,tbcd.I_Batch_Content_Details_ID,tced.I_Brand_ID,tced.I_User_ID,Dt_Expiry_Date,I_Folder_Id,tbcd.I_Term_ID,B.S_Term_Name,tbcd.I_Module_ID,C.S_Module_Name,I_Session_ID
,S_Session_Name,S_Session_Topic,S_Session_Alias,S_Session_Chapter,S_Session_Description,S_Content_URL,
S_Batch_Name,tcm.I_Course_ID,I_CourseFamily_ID,S_Course_Code,S_Course_Desc,S_Course_Name,tced.I_Status_Id,tbcd.B_IsActive FROM dbo.T_Content_Employee_Dtl AS tced  
INNER JOIN dbo.T_Batch_Content_Details AS tbcd  
ON tced.I_Batch_Content_Details_ID = tbcd.I_Batch_Content_Details_ID  
INNER JOIN dbo.T_Student_Batch_Master AS tsbm  
ON tbcd.I_Batch_ID = tsbm.I_Batch_ID  
INNER JOIN dbo.T_Course_Master AS tcm  
ON tsbm.I_Course_ID = tcm.I_Course_ID  
INNER JOIN dbo.T_Term_Master B                              
ON tbcd.I_Term_ID = B.I_Term_ID                              
INNER JOIN dbo.T_Module_Master C                              
ON tbcd.I_Module_ID = C.I_Module_ID      
WHERE tced.I_User_ID = @iUserID  
AND tced.I_Status_Id = 1  
AND tbcd.B_IsActive = 1  
  
END
