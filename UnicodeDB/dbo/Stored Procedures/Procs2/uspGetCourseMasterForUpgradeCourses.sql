CREATE PROCEDURE [dbo].[uspGetCourseMasterForUpgradeCourses]   
 -- Add the parameters for the stored procedure here        
 @iBrandID int = null,        
 @iCourseFamilyID int = null,         
 @iCenterID INT = NULL         
AS        
BEGIN        
 -- SET NOCOUNT ON added to prevent extra result sets from        
 -- interfering with SELECT statements.        
 SET NOCOUNT ON;        
        
    -- Insert statements for procedure here        
 SELECT DISTINCT E.I_Course_ID,        
   E.I_CourseFamily_ID,        
   E.I_Brand_ID,        
   E.S_Course_Code,        
   E.S_Course_Name,        
   E.S_Course_Desc,        
   E.I_Document_ID,        
   E.S_Crtd_By,        
   E.S_Upd_By,        
   E.Dt_Crtd_On,        
   E.Dt_Upd_On,        
   E.I_Is_Editable,        
   E.I_Status,        
   E.I_Grading_Pattern_ID,        
   E.I_Certificate_ID,        
   E.C_AptitudeTestReqd,    
   ISNULL(E.[I_Is_Upgrade_Course],0) AS I_Is_Upgrade_Course,        
   G.S_Document_Name,        
   G.S_Document_Type,        
   G.S_Document_Path,        
   G.S_Document_URL,        
   BM.S_Brand_Code,        
   BM.S_Brand_Name,        
   ( SELECT COUNT(B.I_Session_ID)         
    FROM dbo.T_Session_Module_Map A        
    INNER JOIN dbo.T_Session_Master B        
    ON A.I_Session_ID = B.I_Session_ID        
    INNER JOIN dbo.T_Module_Term_Map C        
    ON A.I_Module_ID = C.I_Module_ID        
    INNER JOIN dbo.T_Term_Course_Map D           
    ON C.I_Term_ID = D.I_Term_ID        
    AND D.I_Course_ID = E.I_Course_ID        
    AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())        
    AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())        
    AND A.I_Status <> 0        
    AND B.I_Status <> 0        
    AND C.I_Status <> 0        
    AND D.I_Status <> 0) AS I_No_Of_Session,        
   F.S_CourseFamily_Name        
 FROM dbo.T_Course_Master E        
 LEFT OUTER JOIN dbo.T_Upload_Document G        
 ON E.I_Document_ID = G.I_Document_ID        
 INNER JOIN T_CourseFamily_Master F        
 ON E.I_CourseFamily_ID = F.I_CourseFamily_ID        
 INNER JOIN dbo.T_Brand_Master BM        
 ON E.I_Brand_ID = BM.I_Brand_ID        
 LEFT OUTER JOIN dbo.T_Course_Center_Detail CCD        
 ON E.I_Course_ID = CCD.I_Course_ID        
 AND CCD.I_Centre_Id = ISNULL(@iCenterID,CCD.I_Centre_Id)        
 AND CCD.I_Status = 1        
 WHERE BM.I_Status <> 0        
 AND E.I_Brand_ID = ISNULL(@iBrandID,E.I_Brand_ID)        
 AND E.I_CourseFamily_ID = ISNULL(@iCourseFamilyID,E.I_CourseFamily_ID)        
 AND E.I_Status = 1        
 AND F.I_Status = 1      
-- AND E.I_Is_Upgrade_Course = 1        
 ORDER BY E.S_Course_Name        
           
         
        
         
END 

--------------------------------------------------------------------------------------------------------------------------------------------------
