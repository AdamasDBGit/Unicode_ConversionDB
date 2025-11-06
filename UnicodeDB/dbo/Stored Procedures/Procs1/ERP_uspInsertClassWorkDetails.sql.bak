CREATE PROCEDURE [dbo].[ERP_uspInsertClassWorkDetails]      
    (  
      --@Centre INT , 

	   @RoutineID int = NULL
	  ,@Date datetime
	  ,@FacultyID int
	  ,@ClassWork nvarchar(MAX)
	  ,@CreatedBy nvarchar(50) = null
	  
    )  
AS   
 SET NOCOUNT ON        
    BEGIN TRY                    
                       
        BEGIN TRANSACTION     
		IF NOT EXISTS(select * from T_ERP_Student_Class_Routine_Work 
		where I_Student_Class_Routine_ID=@RoutineID 
		and CAST(Dt_Date AS DATE) = CAST(@Date AS DATE) 
		and I_Faculty_Master_ID = @FacultyID)
		BEGIN
        INSERT INTO T_ERP_Student_Class_Routine_Work
		(
		I_Student_Class_Routine_ID
		,I_Faculty_Master_ID
		,Dt_Date
		,S_CreatedBy
		,D_CreatedAt
		,S_ClassWork
		)
		VALUES
		(
		@RoutineID
		,@FacultyID
		,@Date
		,'dba'
		,GETDATE()
		,@ClassWork
		)
		select 1 StatusFlag,'Class work saved succesfully!' Message
              END
			  ELSE
			  BEGIN
			  update T_ERP_Student_Class_Routine_Work
			  set S_ClassWork = @ClassWork
			  where I_Student_Class_Routine_ID=@RoutineID 
		and CAST(Dt_Date AS DATE) = CAST(@Date AS DATE) 
		and I_Faculty_Master_ID = @FacultyID
		select 1 StatusFlag,'Class work updated succesfully!' Message
			  END
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
