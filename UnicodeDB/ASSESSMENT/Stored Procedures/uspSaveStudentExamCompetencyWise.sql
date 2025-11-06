CREATE PROCEDURE [ASSESSMENT].[uspSaveStudentExamCompetencyWise]   --1198
(    
	@sQuestionXML VARCHAR(max),
	@iExamComponentID INT,
	@iEnquiryID int   
)    
AS    
BEGIN TRY
	
	declare @xml_hndl int 
	exec sp_xml_preparedocument @xml_hndl OUTPUT, @sQuestionXML        
		        
   	INSERT INTO ASSESSMENT.T_Student_Competency_Marks_Details
	        ( I_Enquiry_Regn_ID ,
	          I_Exam_Component_ID ,
	          I_Competency_ID ,
	          N_Marks_Obtained ,
	          N_Total_Marks ,
	          S_Crtd_By ,
	          Dt_Crtd_On
	        )
	SELECT @iEnquiryID,@iExamComponentID,CompetencyID,SUM(MarksObtained),SUM(TotalMarks),'dba',GETDATE()  FROM 	        
   (SELECT   CompetencyID,TotalMarks,MarksObtained       
			FROM        
            OPENXML(@xml_hndl, '/Root/Question', 1)            
            With            
                        (            
						   CompetencyID INT '@CompetencyID',
						   TotalMarks DECIMAL(8,2) '@TotalMarks',
						   MarksObtained DECIMAL(8,2) '@MarksObtained'            
                       ) )T
                       GROUP BY CompetencyID
	
	
	
	
END TRY
BEGIN CATCH  
--Error occurred:    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
