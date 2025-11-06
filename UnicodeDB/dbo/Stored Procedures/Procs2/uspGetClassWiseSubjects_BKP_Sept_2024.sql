
/*******************************************************  
Description : Gets the list of Modules which contains EProject as one of its Exam under the Term  
Author :     Soumya Sikder  
Date :   03/05/2007  
*********************************************************/  
--exec [uspGetClassWiseSubjects] 1,null,null  
CREATE PROCEDURE [dbo].[uspGetClassWiseSubjects_BKP_Sept_2024]   
(  
 @iBrandID int = null,  
 @iClassID int = null,  
 @iSubjectID int = null  
)  
AS  
BEGIN TRY   
IF(@iSubjectID>0)  
BEGIN  
SELECT   
  TSM.I_Subject_ID SubjectID   
 ,TC.S_Class_Name ClassName  
 ,TC.I_Class_ID ClassID  
 ,TSM.S_Subject_Code  SubjectCode  
 ,TSM.S_Subject_Name SubjectName   
 ,TSM.I_Status Status  
 ,TSM.I_Brand_ID BrandID  
 ,TST.I_Subject_Type_ID SubjectTypeID  
 ,TST.S_Subject_Type SubjectType  
 ,TSM.I_School_Group_ID AS SchoolGroupID  
 ,TSG.S_School_Group_Name AS SchoolGroupName  
 ,TSM.I_TotalNoOfClasses AS TotalNumberOfLecturesRequired  
 ,TSM.I_Stream_ID AS StreamID  
  
  FROM T_Subject_Master TSM    
  inner join   
  T_Class TC ON TC.I_Class_ID = TSM.I_Class_ID  
  inner join   
  T_Subject_Type TST ON TST.I_Subject_Type_ID = TSM.I_Subject_Type  
  inner join   
  T_School_Group TSG ON TSG.I_School_Group_ID = TSM.I_School_Group_ID  
  where TSM.I_Subject_ID = @iSubjectID  
  order by SubjectID desc  
END  
ELSE  
BEGIN  
 SELECT   
  TSM.I_Subject_ID SubjectID   
 ,TC.S_Class_Name ClassName  
 ,TC.I_Class_ID ClassID  
 ,TSM.S_Subject_Code  SubjectCode  
 ,TSM.S_Subject_Name SubjectName   
 ,TSM.I_Status Status  
 ,TSM.I_Brand_ID BrandID  
 ,TST.I_Subject_Type_ID SubjectTypeID  
 ,TST.S_Subject_Type SubjectType  
 ,TSM.I_School_Group_ID AS SchoolGroupID  
 ,TSG.S_School_Group_Name AS SchoolGroupName  
 ,TSM.I_TotalNoOfClasses AS TotalNumberOfLecturesRequired  
  
  FROM T_Subject_Master TSM    
  inner join   
  T_Class TC ON TC.I_Class_ID = TSM.I_Class_ID  
  inner join   
  T_Subject_Type TST ON TST.I_Subject_Type_ID = TSM.I_Subject_Type  
  inner join   
  T_School_Group TSG ON TSG.I_School_Group_ID = TSM.I_School_Group_ID  
  where TSM.I_Brand_ID = ISNULL(@iBrandID,TSM.I_Brand_ID) and TSM.I_Class_ID = ISNULL(@iClassID,TSM.I_Class_ID)  
  order by SubjectID desc  
END  
  
  
END TRY  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
