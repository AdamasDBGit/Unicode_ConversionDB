/*******************************************************  
Description : Gets the list of Modules which contains EProject as one of its Exam under the Term  
Author :     Soumya Sikder  
Date :   03/05/2007  
*********************************************************/  
--exec [uspGetClassWiseSubjects] 1,null,null  
CREATE PROCEDURE [dbo].[uspGetClassWiseSubjects]   
(  
 @iBrandID int = null,  
 @iClassID int = null,  
 @iSubjectID int = null,
 @iSubjectGroupID int = null,
 @iSchoolGroup int = null
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
 ,SGM.SubjectGroupID
 ,SGM.SubjectGroupName
  
  FROM T_Subject_Master TSM    
  inner join   
  T_Class TC ON TC.I_Class_ID = TSM.I_Class_ID  
  inner join   
  T_Subject_Type TST ON TST.I_Subject_Type_ID = TSM.I_Subject_Type  
  inner join   
  T_School_Group TSG ON TSG.I_School_Group_ID = TSM.I_School_Group_ID 
  left join
  T_ERP_Subject_Group_Master as SGM on SGM.SubjectGroupID=TSM.SubjectGroupID
  where TSM.I_Subject_ID = @iSubjectID  and ISNULL(@iSubjectGroupID,ISNULL(SGM.SubjectGroupID,0))=ISNULL(SGM.SubjectGroupID,0)
  and ISNULL(@iSchoolGroup,ISNULL(TSM.I_School_Group_ID,0))=ISNULL(TSM.I_School_Group_ID,0) 
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
  ,SGM.SubjectGroupID
 ,SGM.SubjectGroupName
  FROM T_Subject_Master TSM    
  inner join   
  T_Class TC ON TC.I_Class_ID = TSM.I_Class_ID  
  inner join   
  T_Subject_Type TST ON TST.I_Subject_Type_ID = TSM.I_Subject_Type  
  inner join   
  T_School_Group TSG ON TSG.I_School_Group_ID = TSM.I_School_Group_ID  
   left join
  T_ERP_Subject_Group_Master as SGM on SGM.SubjectGroupID=TSM.SubjectGroupID
  where TSM.I_Brand_ID = ISNULL(@iBrandID,TSM.I_Brand_ID) and TSM.I_Class_ID = ISNULL(@iClassID,TSM.I_Class_ID)  and ISNULL(@iSubjectGroupID,ISNULL(SGM.SubjectGroupID,0))=ISNULL(SGM.SubjectGroupID,0)
   and ISNULL(@iSchoolGroup,ISNULL(TSM.I_School_Group_ID,0))=ISNULL(TSM.I_School_Group_ID,0) 
  order by SubjectID desc  
END  
  
  
END TRY  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
