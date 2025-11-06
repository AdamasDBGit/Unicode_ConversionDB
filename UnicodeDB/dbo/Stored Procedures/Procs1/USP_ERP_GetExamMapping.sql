CREATE PROCEDURE [dbo].[USP_ERP_GetExamMapping]  
    @unExamScheduleDetailId UNIQUEIDENTIFIER,  
 @inSubjectID INT,  
 @inSubjectTypeID INT,  
 @inSubjectComponentID INT,  
 @inSectionId INT,  
 @inStreamId INT = NULL  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    BEGIN TRY  
         
        SELECT  
            DISTINCT  
            EMD.inMapWithExamId AS inMapExamDetailId,  
            SD.stExamName,  
            EMD.dcFullMarks,  
            EMD.dcAvgClassMarks,  
            EMD.dcWeightageInMainExam,  
   ETM.stExamTypeName +' '+ECM.stExamCategoryName AS stExamTypeCategory  
        FROM   
            T_ERP_Exam_MapExamDetails EMD  
   LEFT JOIN T_ERP_Exam_SchedulesDetails SD ON SD.inExamScheduleDetailId = EMD.inMapWithExamId  
   LEFT JOIN T_ERP_Exam_ScheduleSubjectDetails SSD ON SSD.inExamScheduleDetailId =  EMD.inMapWithExamId  
   LEFT JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID = SD.inExamTypeId  
   LEFT JOIN T_ERP_Exam_Category ECM ON ECM.inExamCategoryId = SD.inExamCategoryId  
        WHERE   
     
            EMD.inExamScheduleDetailId IN (SELECT inExamScheduleDetailId FROM T_ERP_Exam_SchedulesDetails WHERE unExamScheduleDetailId =  @unExamScheduleDetailId)  
   AND EMD.inSubjectID = @inSubjectID  
   AND EMD.inSubjectTypeID = @inSubjectTypeID  
   AND EMD.inSubjectComponentID = @inSubjectComponentID  
   AND EMD.inSectionId =  @inSectionId  
   AND (EMD.inStreamId = @inStreamId OR @inStreamId IS NULL)  
              
    END TRY  
    BEGIN CATCH  
        SELECT   
            ERROR_NUMBER() AS ErrorNumber,  
            ERROR_SEVERITY() AS ErrorSeverity,  
            ERROR_STATE() AS ErrorState,  
            ERROR_PROCEDURE() AS ErrorProcedure,  
            ERROR_LINE() AS ErrorLine,  
            ERROR_MESSAGE() AS ErrorMessage;  
    END CATCH  
END  