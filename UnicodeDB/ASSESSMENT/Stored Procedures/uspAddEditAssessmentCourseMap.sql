CREATE PROCEDURE [ASSESSMENT].[uspAddEditAssessmentCourseMap]    
(  
 @iAssessmentTestID int,  
 @sCrtdBy varchar(20),  
 @dtCrtdOn datetime,  
 @sCourseIds varchar(MAX)   
)   
AS   
BEGIN  
 declare @xml_hndl int  
   
 --prepare the XML Document by executing a system stored procedure  
 exec sp_xml_preparedocument @xml_hndl OUTPUT, @sCourseIds  
   
 DELETE FROM ASSESSMENT.T_Assessment_Course_Map WHERE I_PreAssessment_ID = @iAssessmentTestID  
 
 INSERT INTO ASSESSMENT.T_Assessment_Course_Map  
         ( 
           I_PreAssessment_ID ,  
           I_Course_ID ,  
           S_Ctrd_by ,  
           Dt_Crtd_On  
         )  
 SELECT  @iAssessmentTestID,IDToInsert,@sCrtdBy,@dtCrtdOn  
   From  
            OPENXML(@xml_hndl, '/Root/Course', 1)  
            With  
                        (  
                        IDToInsert int '@ID'  
                        )  
END
