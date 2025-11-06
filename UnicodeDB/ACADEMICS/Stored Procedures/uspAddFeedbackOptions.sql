CREATE PROCEDURE [ACADEMICS].[uspAddFeedbackOptions]    
(  
    @iFeedbackMasterID INT,  
    @sFeedbackOptionNames varchar(MAX) = NULL,  
    @iStatus INT = NULL,  
    @sCrtdBy varchar(20) = NULL,  
    @dtCrtdOn datetime = NULL  ,
    @sUpdtBy varchar(20) = NULL,    
    @dtUpdtOn datetime =  NULL       
     
)  
AS  
BEGIN  
DECLARE @xml_hndl INT

--prepare the XML Document by executing a system stored procedure    
 exec sp_xml_preparedocument @xml_hndl OUTPUT, @sFeedbackOptionNames    
 
       INSERT INTO ACADEMICS.T_Feedback_Option_Master
               ( 
                 I_Feedback_Master_ID ,
                 S_Feedback_Option_Name ,
                 I_Value ,
                 I_Status ,
                 S_Crtd_By ,
                 S_Upd_By ,
                 Dt_Crtd_On ,
                 Dt_Upd_On
               )
               Select 
               @iFeedbackMasterID,Question,value,1,@sCrtdBy,@sUpdtBy,@dtCrtdOn,@dtUpdtOn    
            From    
            OPENXML(@xml_hndl, '/Root/FeedbackOption', 1)    
            With    
                        (    
                        Question VARCHAR(250) '@QUESTION',  
                        value INT '@VALUE'    
                        )    
      
        SELECT @@IDENTITY  
END
