CREATE PROCEDURE [dbo].[ERP_uspGetWorkDetails]      
    (  
      --@Centre INT , 

	   @RoutineID int = NULL
	  ,@Date datetime
	 
    )  
AS   
 SET NOCOUNT ON        
    BEGIN TRY                    
                       
        BEGIN TRANSACTION     
		select S_ClassWork ClassWork from T_ERP_Student_Class_Routine_Work
		where  I_Student_Class_Routine_ID = @RoutineID and CAST(Dt_Date AS DATE) = CAST(@Date AS DATE)  
        COMMIT TRANSACTION        
                
    END TRY                    
    BEGIN CATCH                    
 --Error occurred:                      
        ROLLBACK TRANSACTION                     
        DECLARE @ErrMsg NVARCHAR(4000) ,  
				@ErrSeverity INT                    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()                    
                    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                    
    END CATCH
