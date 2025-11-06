CREATE PROCEDURE USP_ERP_Exam_GetExamCategoryDropdownList  
(  
 @BrandID INT,  
 @SchoolGroupID INT,  
 @SessionID INT,  
 @inExamTypeId INT  
)  
As   
BEGIN  
 SELECT  
   EC.inExamCategoryId AS iExamCategoryId  
  ,ETM.inExamTypeID AS ExamTypeMasterID  
  ,ETM.stExamTypeName AS ExamTypeName  
  ,EC.stExamCategoryName AS ExamCategoryName  
  ,EC.unCategoryId AS ExamCategoryUniqueID  
 FROM  
  T_ERP_EXAM_CATEGORY EC  
  INNER JOIN T_ERP_Exam_Type_Master ETM  ON ETM.inExamTypeID=EC.inExamTypeID  
 WHERE  
  EC.inSchoolGroupID = @SchoolGroupID AND  
  EC.inSchoolSessionID = @SessionID AND  
  EC.inBrandID = @BrandID AND  
  EC.inExamTypeID= @inExamTypeId  
End