CREATE PROCEDURE [STUDENTFEATURES].[uspSaveStudentExamResult]          
(          
 @iEnquiryID INT ,       
 @iExamComponentID INT,         
 @iStatus INT,          
 @sFeedbackDetails XML,          
 @sCrtdBy VARCHAR(50),        
 @dtCrtdOn DATETIME        
)          
          
AS          
          
BEGIN TRY           
           
 DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT          
 DECLARE @iFeedbackID INT, @iFeedbackOptionID INT          
 DECLARE @FeedbackOptionXML XML          
 DECLARE @iMarksObtained INT        
           
 BEGIN TRAN T1          
          
 ---Inserting the Student Feedback Table          
 INSERT INTO STUDENTFEATURES.T_Student_Feedback          
 (          
  I_Student_Module_Detail_ID,        
  I_Employee_ID,        
  I_Enquiry_Regn_ID,        
  I_Status,          
  S_Crtd_By,         
  S_Upd_By,        
  Dt_Crtd_On,        
  Dt_Upd_On,         
  I_User_ID          
 )          
 VALUES          
 (          
  NULL,          
  NULL,        
  @iEnquiryID,        
  @iStatus,            
  @sCrtdBy,          
  NULL,          
  @dtCrtdOn,        
  NULL,        
  NULL          
 )          
          
 SET @iFeedbackID = SCOPE_IDENTITY()          
           
 SET @AdjPosition = 1          
 SET @AdjCount = @sFeedbackDetails.value('count((FeedbackType/FeedbackOption))','int')          
 WHILE(@AdjPosition<=@AdjCount)           
 BEGIN          
  SET @FeedbackOptionXML = @sFeedbackDetails.query('FeedbackType/FeedbackOption[position()=sql:variable("@AdjPosition")]')          
  SELECT @iFeedbackOptionID = T.a.value('@I_Feedback_Option_Master_ID','int')          
  FROM @FeedbackOptionXML.nodes('/FeedbackOption') T(a)          
          
  ---Inserting into Training Feedback Option Deatails          
  INSERT INTO STUDENTFEATURES.T_Student_Feedback_Details          
  (          
   I_Student_Feedback_ID,          
   I_Feedback_Option_Master_ID          
  )          
  VALUES          
  (          
   @iFeedbackID,          
   @iFeedbackOptionID          
  )          
           
  SET @AdjPosition=@AdjPosition+1          
 END           
       
     SELECT @iMarksObtained = SUM(I_Value)  FROM STUDENTFEATURES.T_Student_Feedback AS tsf      
  INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details AS tsfd      
  ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID      
  INNER JOIN ACADEMICS.T_Feedback_Option_Master AS tfom      
  ON tsfd.I_Feedback_Option_Master_ID = tfom.I_Feedback_Option_Master_ID      
  INNER JOIN ACADEMICS.T_Feedback_Master AS tfm      
  ON tfom.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID      
  WHERE I_Enquiry_Regn_ID = @iEnquiryID      
  AND I_Exam_Component_ID = @iExamComponentID      
  group BY I_Enquiry_Regn_ID,I_Exam_Component_ID      
  
 UPDATE ASSESSMENT.T_Student_Assessment_Map SET B_Is_Complete = 1 ,Total_Marks = @iMarksObtained WHERE I_Enquiry_Regn_ID = @iEnquiryID AND I_Exam_Component_ID = @iExamComponentID      
   
 COMMIT TRAN T1      
          
END TRY          
BEGIN CATCH          
 --Error occurred:            
 ROLLBACK TRAN T1         
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int          
 SELECT @ErrMsg = ERROR_MESSAGE(),          
   @ErrSeverity = ERROR_SEVERITY()          
          
 RAISERROR(@ErrMsg, @ErrSeverity, 1)          
END CATCH
