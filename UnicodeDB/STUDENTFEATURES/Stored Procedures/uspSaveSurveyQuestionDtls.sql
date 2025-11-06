CREATE PROCEDURE [STUDENTFEATURES].[uspSaveSurveyQuestionDtls]                
(              
 @iStudentDetailID INT,                
 @sStudentFeedback VARCHAR(MAX),  
 @iRecommended INT,  
 @iStatusID INT,  
 @sStudentRatingIds VARCHAR(MAX),  
 @sCrtdBy VARCHAR(20)=NULL,                
 @dtCrtdOn DATETIME=NULL    
)              
AS                 
BEGIN TRY                
 BEGIN TRANSACTION    
  
 DECLARE @iStudentSurveyID INT  
   
  BEGIN  
  INSERT INTO STUDENTFEATURES.T_Student_Survey_Details  
   (   
      I_Student_Detail_ID,  
      S_Student_Feedback,  
      I_Recommended_Rating,
      S_Crtd_BY ,  
      Dt_Crtd_On ,  
      S_Upd_By ,  
      Dt_Upd_On ,  
      I_Status  
  )  
  VALUES  
  (   
      @iStudentDetailID , -- I_Student_ID - int  
      @sStudentFeedback , -- S_Student_Feedback - varchar(1000)  
      @iRecommended , -- S_IsRecommended - varchar(50)  
      @sCrtdBy , -- S_CreatedBY - varchar(50)  
      @dtCrtdOn , -- DT_CreatedOn - datetime  
      NULL, -- S_UpdatedBy - varchar(50)  
      NULL , -- DT_UpdatedOn - datetime  
      @iStatusID  -- I_Status - int  
    )  
      
 SELECT @iStudentSurveyID = @@IDENTITY    
 PRINT  @iStudentSurveyID  
    
    DELETE FROM STUDENTFEATURES.T_Student_Survey_Ratings WHERE I_Student_Survey_ID = @iStudentSurveyID  
       
 DECLARE @xml_hndl INT      
        
  --prepare the XML Document by executing a system stored procedure      
 EXEC sp_xml_preparedocument @xml_hndl OUTPUT, @sStudentRatingIds      
        
 INSERT INTO STUDENTFEATURES.T_Student_Survey_Ratings  
  (   
     I_Student_Survey_ID ,  
     I_Survey_Question_ID ,  
     I_Weightage ,  
     I_Status ,  
     S_Crtd_By ,  
     S_Upd_By ,  
     Dt_Crtd_On ,  
     Dt_Upd_On  
  )  
  SELECT @iStudentSurveyID,IDtoInsert,Weightage,@iStatusID,@sCrtdBy,NULL,@dtCrtdOn,NULL  
   From      
   OPENXML(@xml_hndl, '/Root/SurveyWeightage', 1)      
   With      
    (      
  IDToInsert INT '@ID',    
  Weightage INT '@WEIGHTAGE'      
   )      
             
  END  
    
  COMMIT TRANSACTION    
    
END TRY      
            
BEGIN CATCH      
  
  ROLLBACK TRANSACTION      
            
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int                
 SELECT @ErrMsg = ERROR_MESSAGE(),                
 @ErrSeverity = ERROR_SEVERITY()                
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
               
END CATCH
