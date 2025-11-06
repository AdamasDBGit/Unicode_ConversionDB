CREATE PROCEDURE [dbo].[uspCopyCourse]  
(  
 @iSourceBrandID AS INT,  
 @iSourceCourseFamilyID AS INT,  
 @iSourceCourseID AS INT,  
 @sSourceCourseCode AS VARCHAR(500),  
  
 @iDestinationBrandID AS INT,  
 @iDestinationCourseFamilyID AS INT,  
 @sDestinationCourseCode AS VARCHAR(500),  
 @sDestinationCourseName AS VARCHAR(500),  
 @sDestinationCourseDescription AS VARCHAR(800),  
  
 @sUpdatedBy AS VARCHAR(100),  
 @dUpdatedOn AS DATETIME  
)  
   
AS  
BEGIN TRY  
  
 SET NoCount ON;  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  
 DECLARE @I_Course_Id_New INT  
   
 BEGIN TRANSACTION  
 ---------------------Copying Course Master----------------------------------  
 INSERT INTO [dbo].[T_Course_Master]  
    (  
  [I_Brand_ID]  
       ,[I_CourseFamily_ID]  
       ,[S_Course_Code]  
       ,[S_Course_Name]  
       ,[S_Course_Desc]  
       ,[I_Grading_Pattern_ID]  
       ,[I_No_Of_Session]  
       ,[I_Certificate_ID]  
       ,[I_Document_ID]  
       ,[C_AptitudeTestReqd]  
       ,[C_IsCareerCourse]  
       ,[C_IsShortTermCourse]  
       ,[C_IsPlacementApplicable]  
       ,[I_Is_Editable]  
       ,[I_Status]  
       ,[S_Crtd_By]  
       ,[S_Upd_By]  
       ,[Dt_Crtd_On]  
       ,[Dt_Upd_On]  
 )  
 SELECT   
  @iDestinationBrandID  
 ,@iDestinationCourseFamilyID  
 ,@sDestinationCourseCode  
 ,@sDestinationCourseName  
 ,@sDestinationCourseDescription  
 ,[I_Grading_Pattern_ID]  
 ,[I_No_Of_Session]  
 ,[I_Certificate_ID]  
 ,[I_Document_ID]  
 ,[C_AptitudeTestReqd]  
 ,ISNULL([C_IsCareerCourse],'N') AS C_IsCareerCourse  
 ,[C_IsShortTermCourse]  
 ,[C_IsPlacementApplicable]  
 ,[I_Is_Editable]  
 ,[I_Status]  
 ,@sUpdatedBy  
 ,NULL  
 ,@dUpdatedOn  
 ,NULL  
 FROM [dbo].[T_Course_Master]   
 WHERE I_Course_Id=@iSourceCourseID  
  
 SET @I_Course_Id_New=SCOPE_IDENTITY()  
 -------------------End of Copying Course-------------------------------------------------  
  
 ---------Inserting Delivery Pattern--------------------------  
 INSERT INTO [dbo].[T_Course_Delivery_Map]  
 (  
  [I_Delivery_Pattern_ID]  
  ,[I_Course_ID]  
  ,[S_Crtd_By]  
  ,[N_Course_Duration]  
  ,[S_Upd_By]  
  ,[I_Status]  
  ,[Dt_Crtd_On]  
  ,[Dt_Upd_On]  
 )  
 SELECT   
 [I_Delivery_Pattern_ID]  
 ,@I_Course_Id_New  
 ,[S_Crtd_By]  
 ,[N_Course_Duration]  
 ,@sUpdatedBy  
 ,[I_Status]  
 ,@dUpdatedOn  
 ,NULL  
 FROM [dbo].[T_Course_Delivery_Map]  
 WHERE I_Course_Id=@iSourceCourseID  
 ---End of Inserting Delivery Pattern------------------------------------  
  
 -------------Copying Course-Term Mapping--------------------  
 INSERT INTO [dbo].[T_Term_Course_Map]  
    (  
  [I_Certificate_ID]  
  ,[I_Course_ID]  
  ,[I_Term_ID]  
  ,[I_Sequence]  
  ,[C_Examinable]  
  ,[S_Crtd_By]  
  ,[S_Upd_By]  
  ,[Dt_Crtd_On]  
  ,[Dt_Upd_On]  
  ,[Dt_Valid_From]  
  ,[Dt_Valid_To]  
  ,[I_Status]  
 )  
 SELECT  
 [I_Certificate_ID]  
 ,@I_Course_Id_New  
 ,[I_Term_ID]  
 ,[I_Sequence]  
 ,[C_Examinable]  
 ,@sUpdatedBy  
 ,NULL  
 ,@dUpdatedOn  
 ,NULL  
 ,@dUpdatedOn  
 ,NULL  
 ,[I_Status]  
 FROM [dbo].[T_Term_Course_Map]   
 WHERE I_Course_Id=@iSourceCourseID  
 -------------End of Copying Course-Term Mapping--------------------  
  
 -------------Inserting Term Level Evaluation Strategy--------------------  
 INSERT INTO [dbo].[T_Term_Eval_Strategy]  
 (  
  [I_Course_ID]  
  ,[I_Term_ID]  
  ,[I_Exam_Component_ID]  
  ,[I_Exam_Type_Master_ID]  
  ,[I_TotMarks]  
  ,[N_Weightage]  
  ,[S_Remarks]  
  ,[I_IsPSDate]  
  ,[I_Template_ID]  
  ,[I_Status]  
  ,[S_Crtd_By]  
  ,[S_Upd_By]  
  ,[Dt_Crtd_On]  
  ,[Dt_Upd_On]  
  ,[I_Exam_Duration]  
 )  
 SELECT  
  @I_Course_Id_New  
 ,TES.I_Term_ID  
 ,TES.I_Exam_Component_ID  
 ,TES.I_Exam_Type_Master_ID  
 ,TES.I_TotMarks  
 ,TES.N_Weightage  
 ,TES.S_Remarks  
 ,TES.I_IsPSDate  
 ,TES.I_Template_ID  
 ,TES.I_Status  
 ,@sUpdatedBy  
 ,NULL  
 ,@dUpdatedOn  
 ,NULL  
 ,I_Exam_Duration  
 FROM [dbo].[T_Term_Eval_Strategy] TES  
 INNER JOIN [dbo].[T_Term_Course_Map] TCM ON TES.I_Course_Id=TCM.I_Course_Id   
 AND TES.I_Term_Id=TCM.I_Term_Id   
 WHERE TES.I_Course_Id=@iSourceCourseID  
 -------------End of Inserting Term Level Evaluation Strategy--------------------  
  
 --------Inserting Module Level Eval Strategy---------------------------  
 INSERT INTO [dbo].[T_Module_Eval_Strategy]  
 (  
  [I_Course_ID]  
  ,[I_Term_ID]  
  ,[I_Module_ID]  
  ,[I_Exam_Component_ID]  
  ,[I_TotMarks]  
  ,[N_Weightage]  
  ,[S_Remarks]  
  ,[I_Status]  
  ,[S_Crtd_By]  
  ,[S_Upd_By]  
  ,[Dt_Crtd_On]  
  ,[Dt_Upd_On]  
  ,[I_Exam_Duration]  
 )  
 SELECT   
 @I_Course_Id_New  
 ,T_Module_Eval_Strategy.I_Term_ID  
 ,T_Module_Eval_Strategy.I_Module_ID  
 ,T_Module_Eval_Strategy.I_Exam_Component_ID  
 ,T_Module_Eval_Strategy.I_TotMarks  
 ,T_Module_Eval_Strategy.N_Weightage  
 ,T_Module_Eval_Strategy.S_Remarks  
 ,T_Module_Eval_Strategy.I_Status  
 ,@sUpdatedBy  
 ,NULL  
 ,@dUpdatedOn  
 ,NULL  
 ,T_Module_Eval_Strategy.I_Exam_Duration  
 FROM T_Term_Course_Map INNER JOIN  
 T_Module_Term_Map ON T_Term_Course_Map.I_Term_ID = T_Module_Term_Map.I_Term_ID INNER JOIN  
 T_Module_Eval_Strategy ON T_Term_Course_Map.I_Course_ID = T_Module_Eval_Strategy.I_Course_ID AND   
 T_Module_Term_Map.I_Term_ID = T_Module_Eval_Strategy.I_Term_ID AND   
 T_Module_Term_Map.I_Module_ID = T_Module_Eval_Strategy.I_Module_ID  
 WHERE T_Term_Course_Map.I_Course_ID=@iSourceCourseID  
 --------End of Inserting Module Level Eval Strategy---------------------------  
 COMMIT TRANSACTION  
END TRY  
BEGIN CATCH      
  ROLLBACK TRANSACTION     
  DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int      
  SELECT @ErrMsg = ERROR_MESSAGE(),      
    @ErrSeverity = ERROR_SEVERITY()      
       
  RAISERROR(@ErrMsg, @ErrSeverity, 1)      
END CATCH
