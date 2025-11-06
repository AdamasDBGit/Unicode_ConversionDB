CREATE PROCEDURE [ASSESSMENT].[uspAddAssessmentExamComponentMapping]      
(    
 @iAssessmentId int,    
 @sExamComponentIds VARCHAR(MAX),  
 @sCrtdBy varchar(20) = NULL,    
 @dtCrtdOn datetime = NULL,    
 @sUpdtBy varchar(20) = NULL,    
 @dtUpdtOn datetime =  NULL      
)    
AS     
BEGIN    
 DELETE FROM ASSESSMENT.T_PreAssessment_ExamComponent_Mapping WHERE I_PreAssessment_ID = @iAssessmentId    
     
 declare @xml_hndl int    
     
 --prepare the XML Document by executing a system stored procedure    
 exec sp_xml_preparedocument @xml_hndl OUTPUT, @sExamComponentIds    
     
 Insert Into ASSESSMENT.T_PreAssessment_ExamComponent_Mapping    
            (    
    I_PreAssessment_ID,    
    I_Exam_Component_ID,   
    I_Total_Time,   
    I_Status,    
    S_Crtd_By,    
    Dt_Crtd_On    
            )    
   Select    
            @iAssessmentId,IDToInsert,TotalTime,1,@sCrtdBy,@dtCrtdOn    
From    
            OPENXML(@xml_hndl, '/Root/ExamComponent', 1)    
            With    
                        (    
                        IDToInsert int '@ID',  
                        TotalTime INT '@TIME'    
                        )    
END
