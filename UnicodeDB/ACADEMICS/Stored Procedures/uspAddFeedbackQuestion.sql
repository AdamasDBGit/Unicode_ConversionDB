CREATE PROCEDURE [ACADEMICS].[uspAddFeedbackQuestion]    
(  
    @iFeedbackGroupID INT,  
    @iFeedbackTypeID INT, 
    @iEaxmComponentID INT, 
    @sFeedbackQuestion varchar(Max) = NULL,  
    @iStatus int = NULL,  
    @sCrtdBy varchar(20) = NULL,  
    @dtCrtdOn datetime = NULL,  
    @sUpdtBy  varchar(20) = NULL,  
    @dtUpdtOn datetime = NULL  
)  
AS  
BEGIN  
       INSERT INTO ACADEMICS.T_Feedback_Master
               ( 
                 I_Feedback_Group_ID ,
                 I_Feedback_Type_ID ,
                 I_Exam_Component_ID,
                 S_Feedback_Question,
                 I_Status ,
                 S_Crtd_By ,
                 S_Upd_By ,
                 Dt_Crtd_On ,
                 Dt_Upd_On
               )
       VALUES  ( 
                 @iFeedbackGroupID ,
                 @iFeedbackTypeID , 
                 @iEaxmComponentID ,
                 @sFeedbackQuestion , 
                 @iStatus , 
                 @sCrtdBy , 
                 @sUpdtBy , 
                 @dtCrtdOn , 
                 @dtUpdtOn 
               )
        SELECT @@IDENTITY  
END
