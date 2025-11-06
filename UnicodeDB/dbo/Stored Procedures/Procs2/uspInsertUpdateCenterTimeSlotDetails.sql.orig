CREATE PROCEDURE [dbo].[uspInsertUpdateCenterTimeSlotDetails]   
    (  
      @ITimeSlotID INT = NULL ,  
      @IBrandID INT ,
      @ICenterID INT ,   
      @DtStartTime DATETIME ,
      @DtEndTime DATETIME ,  
      @IStatus INT ,  
      @SCrtdBy VARCHAR(20) ,  
      @DtCrtdOn DATETIME , 
      @SUpdtBy VARCHAR(20) ,  
      @DtUpdtOn DATETIME,  
      @IFlag INT
      
    )  
AS   
    BEGIN TRY 
		IF (SELECT  count(*)
			 FROM    dbo.T_Center_Timeslot_Master
			 WHERE   (DATEADD(ss,1,@DtStartTime) between Dt_Start_Time and Dt_End_Time or DATEADD(ss,-1,@DtEndTime) between Dt_Start_Time and Dt_End_Time)  and 
			 I_Brand_ID=@IBrandID and I_Center_ID=@ICenterID  
			 AND I_Status=1--akash 6.6.2017
			 AND I_TimeSlot_ID not in (ISNULL(@ITimeSlotID,0))) = 0
		BEGIN
			IF @IFlag = 1   
			BEGIN
				 INSERT  INTO dbo.T_Center_Timeslot_Master  
						( I_Brand_ID ,
						  I_Center_ID ,  
						  Dt_Start_Time ,
						  Dt_End_Time ,   
						  I_Status ,  
						  S_Crtd_by ,  
						  Dt_Crtd_On ,
						  S_Updt_By ,
						  Dt_Updt_On 
						)  
				 VALUES  ( @IBrandID ,      -- I_Brand_ID - int  
						  @ICenterID ,     --I_Center_ID - int   
						  @DtStartTime ,   --Dt_Start_Time - datetime 
						  @DtEndTime,      --Dt_End_Time - datetime    
						  @IStatus ,       --I_Status - int   
						  @SCrtdBy ,       --S_Crtd_by - varchar(20)   
						  @DtCrtdOn ,      --Dt_Crtd_On - datetime 
						  @SUpdtBy ,       --S_Updt_By - varchar(20) 
						  @DtUpdtOn        --Dt_Updt_On - datetime 
						)      
				 SELECT  @@IDENTITY
			END     
			ELSE   
			BEGIN
				 UPDATE  dbo.T_Center_Timeslot_Master  
				 SET    I_Brand_ID= @IBrandID , 
						I_Center_ID = @ICenterID ,  
						Dt_Start_Time= @DtStartTime , 
						Dt_End_Time = @DtEndTime ,   
						I_Status = @IStatus ,   
						S_Updt_By = @SCrtdby ,  
						Dt_Updt_On = @DtCrtdOn  
				 WHERE  I_TimeSlot_ID = @ITimeSlotID
			END
		END
		ELSE 
		BEGIN
			RAISERROR('Entry with the same time slot already exists',11,1)
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
