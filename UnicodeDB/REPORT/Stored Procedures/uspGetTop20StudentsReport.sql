/****************************************************************      
Author :     Swagatam Sarkar      
Date :   02/Jan/2008      
Description : This SP retrieves the Top 20 Students of a Term      
          
****************************************************************/      
      
      
CREATE PROCEDURE [REPORT].[uspGetTop20StudentsReport]      
(      
 -- Add the parameters for the stored procedure here      
 @sHierarchyList varchar(MAX),      
 @iBrandID int,      
 @DtFrmDate datetime,      
 @DtToDate datetime,      
 @iCourseFamilyID int,      
 @svCourseFamilyName varchar(50),      
 @iCourseID int      
 --@svCourseName varchar(50),      
 --@iTermID int,      
 --@svTermName varchar(50)      
)      
AS      
BEGIN TRY      
 BEGIN      
        
  DECLARE @sCourseFamilyName VARCHAR(50)      
  SET @sCourseFamilyName = (SELECT S_CourseFamily_Name FROM dbo.T_CourseFamily_Master WHERE I_CourseFamily_ID = @iCourseFamilyID)      
      
  IF (@DtToDate IS NOT NULL)      
  BEGIN      
   SET @DtToDate = DATEADD(dd,1,@DtToDate)      
  END      
      
      
  SELECT DISTINCT TOP(20) TCM2.S_Center_Name,@sCourseFamilyName AS S_Course_Family_Name,CM.S_Course_Name,TM.S_Term_Name,      
      SD.I_Student_Detail_ID,SD.S_Title,SD.S_First_Name,SD.S_Middle_Name,SD.S_Last_Name,      
      SM.I_Exam_Total,FN2.InstanceChain, sd.S_Mobile_No,sd.S_Email_ID,ISNULL(sd.S_Guardian_Mobile_No,S_Guardian_Phone_No) AS S_Guardian_Mobile_No     
          
      FROM EXAMINATION.T_Batch_Exam_Map AS tbem        
    INNER JOIN dbo.T_Exam_Component_Master ECM        
     ON tbem.I_Exam_Component_ID=ECM.I_Exam_Component_ID        
    INNER JOIN dbo.T_Student_Batch_Master AS tsbm        
     ON tbem.I_Batch_ID = tsbm.I_Batch_ID        
    INNER JOIN dbo.T_Course_Master CM        
     ON tsbm.I_Course_ID=CM.I_Course_ID        
    INNER JOIN dbo.T_Term_Master TM        
     ON tbem.I_Term_ID=TM.I_Term_ID        
    INNER JOIN dbo.T_Term_Course_Map TCM        
     ON tsbm.I_Course_ID=TCM.I_Course_ID        
     AND tbem.I_Term_ID=TCM.I_Term_ID        
    INNER JOIN EXAMINATION.T_Student_Marks SM        
     ON tbem.I_Batch_Exam_ID = SM.I_Batch_Exam_ID        
    INNER JOIN dbo.T_Student_Detail SD        
     ON SM.I_Student_Detail_ID=SD.I_Student_Detail_ID        
    INNER JOIN dbo.T_Student_Center_Detail AS tscd        
     ON SD.I_Student_Detail_ID = tscd.I_Student_Detail_ID        
    INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1        
     ON tscd.I_Centre_Id=FN1.CenterID        
    INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2    
     ON FN1.HierarchyDetailID=FN2.HierarchyDetailID      
     INNER JOIN dbo.T_Centre_Master AS tcm2      
     ON tscd.I_Centre_Id = TCM2.I_Centre_Id        
    WHERE --sm.I_Exam_Total IS NOT NULL AND sm.I_Exam_Total < 100    
    SM.Dt_Exam_Date BETWEEN @DtFrmDate AND @DtToDate        
   AND tsbm.I_Course_ID =ISNULL(@iCourseID,tsbm.I_Course_ID)         
   ORDER BY SM.I_Exam_Total DESC     
       
        
 END      
END TRY      
      
BEGIN CATCH      
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int      
 SELECT @ErrMsg = ERROR_MESSAGE(),      
   @ErrSeverity = ERROR_SEVERITY()      
 RAISERROR(@ErrMsg, @ErrSeverity, 1)      
END CATCH
