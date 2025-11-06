
CREATE PROCEDURE [dbo].[KPMG_uspGetCourseList]  
AS   
    BEGIN TRY 
    	
        SELECT Distinct cm.I_Course_ID as CourseId,
			   cm.S_Course_Code as CourseCode 
		FROM   dbo.T_Course_Master cm INNER JOIN Tbl_KPMG_SM_List sl ON cm.I_Course_ID = sl.Fld_KPMG_CourseId
		WHERE sl.Fld_KPMG_I_Installment_No = 1;
        
       
        
        
    END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH

