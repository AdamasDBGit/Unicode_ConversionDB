CREATE PROCEDURE [dbo].[uspInsertUpdateBusRouteDetails]   
    (  
      @IRouteID INT = NULL ,
      @SRouteNo VARCHAR(20) ,  
      @IBrandID INT ,
      @IStatus INT ,  
      @SCrtdby VARCHAR(20) ,  
      @DtCrtdOn DATETIME ,  
      @iFlag INT
    )  
AS   
    BEGIN TRY              
        SET NOCOUNT ON ;
        
			IF @iFlag = 1   
			BEGIN 
				 IF ( SELECT  COUNT(*)
				 FROM    dbo.T_BusRoute_Master
				 WHERE   S_Route_No = @SRouteNo AND I_Brand_ID = @IBrandID) = 0 
				 BEGIN
					INSERT  INTO dbo.T_BusRoute_Master  
							( S_Route_No ,  
							  I_Status ,  
							  S_Crtd_by ,  
							  Dt_Crtd_On,
							  I_Brand_ID  
							)  
					VALUES  ( @SRouteNo , 
							  @IStatus ,
							  @SCrtdby , 
							  @DtCrtdOn ,
							  @IBrandID   
							)      
					SELECT  @@IDENTITY
				 END
				 ELSE 
				 BEGIN
					 RAISERROR('Entry with the same bus route no. already exists',11,1)
				 END
			END     
			ELSE   
			BEGIN
				 IF ( SELECT  COUNT(*)
				 FROM    dbo.T_BusRoute_Master
				 WHERE   S_Route_No = @SRouteNo
				 AND I_Brand_ID = @IBrandID
				 AND I_Route_ID not in(@IRouteID)) = 0
				 BEGIN
					 UPDATE  dbo.T_BusRoute_Master 
					 SET    S_Route_No= @SRouteNo , 
							I_Brand_ID = @IBrandID , 
							S_Updt_By = @SCrtdby ,  
							Dt_Updt_On = Dt_Crtd_On						
					 WHERE  I_Route_ID = @IRouteID
				 END
				 ELSE 
				 BEGIN
					 RAISERROR('Entry with the same bus route no. already exists',11,1)
				 END
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
