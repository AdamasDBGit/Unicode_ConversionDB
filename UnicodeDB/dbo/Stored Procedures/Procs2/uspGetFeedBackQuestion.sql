CREATE PROCEDURE [dbo].[uspGetFeedBackQuestion]     
(        
 @iFeedBackMasterID INT         
)         
AS         
BEGIN       
   
 --Table[1] for the list of Feedback Master  
 SELECT tfm.I_Feedback_Master_ID,S_Feedback_Question FROM ACADEMICS.T_Feedback_Master AS tfm  
 WHERE tfm.I_Status=1 AND tfm.I_Feedback_Master_ID =  @iFeedBackMasterID  
   
   --Table[2] for the list of Feedback Option Master 
 SELECT S_Feedback_Option_Name,I_Value FROM ACADEMICS.T_Feedback_Option_Master AS tfom
 WHERE I_Feedback_Master_ID IN(SELECT tfm.I_Feedback_Master_ID FROM ACADEMICS.T_Feedback_Master AS tfm  
 WHERE tfm.I_Status=1 AND tfm.I_Feedback_Master_ID =  @iFeedBackMasterID ) AND tfom.I_Status=1      
   
END
