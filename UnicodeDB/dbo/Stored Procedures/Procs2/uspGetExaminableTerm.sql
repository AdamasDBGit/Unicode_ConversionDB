CREATE PROCEDURE [dbo].[uspGetExaminableTerm]   
(  
 @iTermID int  
)  
AS  
BEGIN  
 SET NOCOUNT ON  
   
 SELECT * FROM T_TERM_COURSE_MAP   
  WHERE C_Examinable = 'Y'   
  AND I_Term_ID = @iTermID   
  AND I_Status <> 0   
  
END
