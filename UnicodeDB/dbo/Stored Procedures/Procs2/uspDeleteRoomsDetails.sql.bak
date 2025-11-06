CREATE PROCEDURE [dbo].[uspDeleteRoomsDetails]   
    (  
      @IRoomID INT ,       
      @IStatus INT ,       
      @iCenterID INT
    )  
AS   
    BEGIN TRY 
		 IF ( SELECT  COUNT(*) FROM T_TimeTable_Master WHERE I_Center_ID=@iCenterID and I_Room_ID=@IRoomID and I_Status=1) = 0 
		 BEGIN
			UPDATE  dbo.T_Room_Master  
			 SET    I_Status = @IStatus  
			 WHERE  I_Room_ID = @IRoomID 
		 END
		 ELSE 
		 BEGIN
			 RAISERROR('Time Table already been assigned to this room',11,1)
		 END
			
    END TRY             
    BEGIN CATCH              
 --Error occurred:                
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT              
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()              
              
        RAISERROR(@ErrMsg, @ErrSeverity, 1)              
    END CATCH
