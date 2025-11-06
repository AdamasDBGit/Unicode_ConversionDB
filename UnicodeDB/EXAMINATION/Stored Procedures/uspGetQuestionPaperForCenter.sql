CREATE PROCEDURE [EXAMINATION].[uspGetQuestionPaperForCenter]  
 @iExamID int,  
 @iUserID int = NULL  
AS  
  
BEGIN  
 SET NOCOUNT ON;   
 DECLARE @iExamComponentID INT  
 SELECT @iExamComponentID = I_Exam_Component_ID FROM EXAMINATION.T_Examination_Detail  
  WHERE I_Exam_ID = @iExamID  
  
 CREATE TABLE #tempTable  
 (  
  I_Pool_ID int  
 )  
  
 CREATE TABLE #TEMPBANK  
 (   
  ID_Identity int identity(1,1),  
  S_Question_Bank_ID varchar(500)  
 )  
  
 INSERT INTO #TEMPBANK  
 select distinct S_Question_Bank_ID from T_Test_Design WHERE I_Exam_Component_ID = @iExamComponentID AND I_Status_ID = 1  
  
  
 DECLARE @iCount INT  
 DECLARE @iRowCount INT  
 DECLARE @sQuestionBankIDs VARCHAR(500)  
 SELECT @iRowCount = count(ID_Identity) FROM #TEMPBANK  
 SET @iCount = 1  
  
 WHILE (@iCount <= @iRowCount)  
 BEGIN   
  select @sQuestionBankIDs = S_Question_Bank_ID from #TEMPBANK where ID_Identity = @iCount  
  
  INSERT INTO #tempTable  
  SELECT distinct I_Pool_ID FROM EXAMINATION.T_Bank_Pool_Mapping BPM,EXAMINATION.T_Test_Design TD  
  WHERE TD.I_Exam_Component_ID = @iExamComponentID  
    AND BPM.I_Question_Bank_ID in (select * from dbo.fnString2Rows(@sQuestionBankIDs,','))  
    AND I_Status_ID = 1  
    
  SET @iCount = @iCount + 1  
 END   
  
  
 SELECT QP.I_Question_ID,QP.I_Pool_ID,TPM.S_Pool_Desc,QP.I_Answer_Type_ID,  
   QP.S_Question,ISNULL(S_Question_Options,'') AS S_Question_Options,QP.I_Question_Type,QP.I_Complexity_ID,  
   QP.I_Document_ID,UD.S_Document_Name,UD.S_Document_Type,  
   UD.S_Document_Path,UD.S_Document_URL  
 FROM EXAMINATION.T_Question_Pool QP  
 INNER JOIN EXAMINATION.T_Pool_Master TPM WITH(NOLOCK)  
 ON QP.I_Pool_ID = TPM.I_Pool_ID  
 LEFT OUTER JOIN dbo.T_Upload_Document UD  
 ON QP.I_Document_ID = UD.I_Document_ID  
 AND UD.I_Status = 1  
 WHERE QP.I_Pool_ID IN  
 (SELECT distinct I_Pool_ID FROM #tempTable)  
  
 SELECT QP.I_Question_ID, QC.I_Question_Choice_ID,QC.S_Answer_Desc,  
  QC.B_Is_Answer,ISNULL(QC.N_Answer_Marks,0) AS N_Answer_Marks  
 FROM EXAMINATION.T_Question_Choices QC  
 INNER JOIN EXAMINATION.T_Question_Pool QP  
 ON QP.I_Question_ID = QC.I_Question_ID  
 WHERE QP.I_Pool_ID IN  
 (SELECT distinct I_Pool_ID FROM #tempTable)  
  
 SELECT QP.I_Question_ID, SQ.I_SubQuestion_ID,SQ.I_SubQuestion_Type,  
  SQ.S_SubQuestion_Desc,SQ.S_SubQuestion_Value,SQ.I_Document_ID,  
   UD.S_Document_Name,UD.S_Document_Type,  
   UD.S_Document_Path,UD.S_Document_URL  
 FROM EXAMINATION.T_SubQuestion SQ  
 INNER JOIN EXAMINATION.T_Question_Pool QP   
 ON QP.I_Question_ID = SQ.I_Question_ID  
 LEFT OUTER JOIN dbo.T_Upload_Document UD  
 ON SQ.I_Document_ID = UD.I_Document_ID  
 WHERE QP.I_Pool_ID IN  
 (SELECT distinct I_Pool_ID FROM #tempTable)  
  
 SELECT SQ.I_SubQuestion_ID , SQC.I_SubQuestion_Choice_ID,SQC.I_SubQuestion_Choice_Type,  
  SQC.S_SubAnswer_Value,SQC.S_SubAnswer_Desc,  
  SQC.B_Is_Answer,SQC.I_Document_ID,UD.S_Document_Name,UD.S_Document_Type,  
   UD.S_Document_Path,UD.S_Document_URL  
 FROM EXAMINATION.T_SubQuestion_Choice SQC  
 INNER JOIN EXAMINATION.T_SubQuestion SQ  
 ON SQC.I_SubQuestion_ID = SQ.I_SubQuestion_ID  
 INNER JOIN EXAMINATION.T_Question_Pool QP  
 ON SQ.I_Question_ID = QP.I_Question_ID  
 LEFT OUTER JOIN dbo.T_Upload_Document UD  
 ON SQC.I_Document_ID = UD.I_Document_ID  
 WHERE QP.I_Pool_ID IN  
 (SELECT distinct I_Pool_ID FROM #tempTable)  
   
 DECLARE @iCourseID INT, @iTermID INT, @iModuleID INT, @nTotalMarks NUMERIC(8,2),   
   @sCourseCode VARCHAR(50), @sCourseName VARCHAR(250),  
   @sTermCode VARCHAR(50), @sTermName VARCHAR(250),  
   @sModuleCode VARCHAR(50), @sModuleName VARCHAR(250)  
 SET @nTotalMarks = 0  
 SET @sCourseCode = ''  
 SET @sTermCode = ''  
 SET @sModuleCode = ''  
 SET @sCourseName = ''  
 SET @sTermName = ''  
 SET @sModuleName = ''  
   
 SELECT @iCourseID = I_Course_ID,  
   @iTermID = I_Term_ID,  
   @iModuleID = I_Module_ID  
 FROM  
   EXAMINATION.T_Examination_Detail  
 WHERE  
   I_Exam_ID = @iExamID  
     
 SELECT @sCourseCode = S_Course_Code, @sCourseName = S_Course_Name  
 FROM dbo.T_Course_Master WHERE I_Course_ID = @iCourseID  
   
 SELECT @sTermCode = S_Term_Code, @sTermName = S_Term_Name  
 FROM dbo.T_Term_Master WHERE I_Term_ID = @iTermID  
     
 IF (@iModuleID IS NULL OR @iModuleID = 0)  
 BEGIN  
  SELECT @nTotalMarks = I_TotMarks  
  FROM dbo.T_Term_Eval_Strategy  
  WHERE I_Course_ID = @iCourseID  
   AND I_Term_ID = @iTermID  
   AND I_Exam_Component_ID = @iExamComponentID     
 END  
 BEGIN  
  SELECT @nTotalMarks = I_TotMarks  
  FROM dbo.T_Module_Eval_Strategy  
  WHERE I_Course_ID = @iCourseID  
   AND I_Term_ID = @iTermID  
   AND I_Module_ID = @iModuleID  
   AND I_Exam_Component_ID = @iExamComponentID   
     
  SELECT  @sModuleCode = S_Module_Code, @sModuleName = S_Module_Name   
  FROM dbo.T_Module_Master WHERE I_Module_ID = @iModuleID  
 END  
 
 DECLARE @iExamDuration INT, @SExamComponentType VARCHAR(10)
 SET @iExamDuration = 0
 SET @SExamComponentType = ''
 
 SELECT @SExamComponentType = TECM.S_Component_Type
 FROM dbo.T_Exam_Component_Master TECM WHERE TECM.I_Exam_Component_ID = @iExamComponentID
 
 IF (@SExamComponentType = 'T')
 BEGIN
	SELECT @iExamDuration = I_Exam_Duration FROM dbo.T_Term_Eval_Strategy
	WHERE I_Exam_Component_ID = @iExamComponentID
	AND I_Course_ID = @iCourseID
	AND I_Term_ID = @iTermID
 END
 ELSE IF (@SExamComponentType = 'M')
 BEGIN
	SELECT @iExamDuration = I_Exam_Duration FROM dbo.T_Module_Eval_Strategy
	WHERE I_Exam_Component_ID = @iExamComponentID
	AND I_Course_ID = @iCourseID
	AND I_Term_ID = @iTermID
	AND I_Module_ID = @iModuleID
 END
    
 SELECT TED.I_Exam_Component_ID,TECM.S_Component_Name,TED.Dt_Exam_Date,  
   TED.Dt_Exam_Start_Time,TED.Dt_Exam_End_Time, @nTotalMarks AS N_Total_Marks,  
   @sCourseCode AS S_Course_Code, @sCourseName AS S_Course_Name,  
   @sTermCode AS S_Term_Code, @sTermName AS S_Term_Name,  
   @sModuleCode AS S_Module_Code, @sModuleName AS S_Module_Name,   
   ISNULL(@iExamDuration,0) AS I_Exam_Duration  
 FROM EXAMINATION.T_Examination_Detail TED WITH(NOLOCK)  
 INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)  
  ON TED.I_Exam_Component_ID = TECM.I_Exam_Component_ID  
 WHERE I_Exam_ID = @iExamID  
  
 TRUNCATE TABLE #tempTable  
 DROP TABLE #tempTable  
  
 TRUNCATE TABLE #TEMPBANK  
 DROP TABLE #TEMPBANK  
END
