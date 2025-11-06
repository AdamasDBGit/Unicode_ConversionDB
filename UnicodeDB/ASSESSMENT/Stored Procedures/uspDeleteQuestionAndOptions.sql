CREATE PROCEDURE [ASSESSMENT].[uspDeleteQuestionAndOptions]        
(          
 @iFeedBackMasterID INT           
)           
AS           
BEGIN         
     
 --Update Table[1] for the list of Feedback Master    
 UPDATE ACADEMICS.T_Feedback_Master  
 SET I_Status=0   
 WHERE I_Feedback_Master_ID=@iFeedBackMasterID AND I_Status=1  
   
     
   --Update Table[2] for the list of Feedback Option Master   
     
   UPDATE ACADEMICS.T_Feedback_Option_Master  
   SET I_Status=0  
   WHERE I_Feedback_Master_ID IN (SELECT tfm.I_Feedback_Master_ID FROM ACADEMICS.T_Feedback_Master AS tfm    
   WHERE tfm.I_Feedback_Master_ID =  @iFeedBackMasterID) AND I_Status=1  
        
     
END
