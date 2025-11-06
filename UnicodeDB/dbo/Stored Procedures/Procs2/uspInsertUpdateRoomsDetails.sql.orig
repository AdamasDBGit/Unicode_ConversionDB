CREATE PROCEDURE [dbo].[uspInsertUpdateRoomsDetails]   
    (  
      @IRoomID INT = NULL ,  
      @IBrandID INT ,  
      @SBuildingName VARCHAR(255) ,  
      @SBlockName VARCHAR(255) ,  
      @SFloorName VARCHAR(255) ,  
      @SRoomNo VARCHAR(50) ,  
      @IRoomType INT ,  
      @NRoomRate INT ,  
      @INoOfBeds INT ,  
      @IStatus INT ,  
      @SCrtdby VARCHAR(50) ,  
      @DtCrtdOn DATETIME ,  
      @iFlag INT,
      @iCenterID INT  = null
    )  
AS   
    BEGIN TRY              
        SET NOCOUNT ON ;    
 -- Insert the Enquiry Details              
        
        IF @iCenterID IS NULL
        BEGIN
			IF @iFlag = 1   
			BEGIN 
				 IF ( SELECT  COUNT(*)
				 FROM    dbo.T_Room_Master
				 WHERE   S_Building_Name = @SBuildingName and S_Block_Name=@SBlockName and 
				 S_Floor_Name=@SFloorName and S_Room_No=@SRoomNo and I_Centre_Id is NULL) = 0 
				 BEGIN
					INSERT  INTO dbo.T_Room_Master  
							( I_Brand_ID ,  
							  S_Building_Name ,  
							  S_Block_Name ,  
							  S_Floor_Name ,  
							  S_Room_No ,  
							  I_Room_Type ,  
							  N_Room_Rate ,  
							  I_No_Of_Beds ,  
							  I_Status ,  
							  S_Crtd_by ,  
							  Dt_Crtd_On,
							  I_Centre_Id  
							)  
					VALUES  ( @IBrandID , -- I_Brand_ID - int  
							  @SBuildingName , -- S_Building_Name - varchar(255)  
							  @SBlockName , -- S_Block_Name - varchar(255)  
							  @SFloorName , -- S_Floor_Name - varchar(255)  
							  @SRoomNo , -- S_Room_No - varchar(50)  
							  @IRoomType , -- I_Room_Type - int  
							  @NRoomRate , -- N_Room_Rate - numeric  
							  @INoOfBeds , -- I_No_Of_Beds - int  
							  @IStatus , -- I_Status - int  
							  @SCrtdby , -- S_Crtd_by - varchar(50)  
							  @DtCrtdOn , -- Dt_Crtd_On - datetime
							  @iCenterID  
							)      
					SELECT  @@IDENTITY
				 END
				 ELSE 
				 BEGIN
					 RAISERROR('Entry with the same room no. already exists',11,1)
				 END
			END     
			ELSE   
			BEGIN 
				 UPDATE  dbo.T_Room_Master  
				 SET    S_Room_No= @SRoomNo ,
						I_Room_Type = @IRoomType ,  
						N_Room_Rate = @NRoomRate ,
						I_No_Of_Beds = @INoOfBeds,  
						S_Updt_By = @SCrtdby ,  
						Dt_Updt_On = Dt_Crtd_On,
						I_Centre_Id = @iCenterID  
				 WHERE  I_Room_ID = @IRoomID 
			END 
        END 
        ELSE
        BEGIN
			IF @iFlag = 1   
			BEGIN 
				 IF ( SELECT  COUNT(*)
				 FROM    dbo.T_Room_Master
				 WHERE   S_Building_Name = @SBuildingName and S_Block_Name=@SBlockName and 
				 S_Floor_Name=@SFloorName and S_Room_No=@SRoomNo and I_Centre_Id = @iCenterID) = 0 
				 BEGIN
					INSERT  INTO dbo.T_Room_Master  
							( I_Brand_ID ,  
							  S_Building_Name ,  
							  S_Block_Name ,  
							  S_Floor_Name ,  
							  S_Room_No ,  
							  I_Room_Type ,  
							  N_Room_Rate ,  
							  I_No_Of_Beds ,  
							  I_Status ,  
							  S_Crtd_by ,  
							  Dt_Crtd_On,
							  I_Centre_Id  
							)  
					VALUES  ( @IBrandID , -- I_Brand_ID - int  
							  @SBuildingName , -- S_Building_Name - varchar(255)  
							  @SBlockName , -- S_Block_Name - varchar(255)  
							  @SFloorName , -- S_Floor_Name - varchar(255)  
							  @SRoomNo , -- S_Room_No - varchar(50)  
							  @IRoomType , -- I_Room_Type - int  
							  @NRoomRate , -- N_Room_Rate - numeric  
							  @INoOfBeds , -- I_No_Of_Beds - int  
							  @IStatus , -- I_Status - int  
							  @SCrtdby , -- S_Crtd_by - varchar(50)  
							  @DtCrtdOn , -- Dt_Crtd_On - datetime
							  @iCenterID  
							)      
					SELECT  @@IDENTITY
				 END
				 ELSE 
				 BEGIN
					 RAISERROR('Entry with the same room no. already exists',11,1)
				 END
			END     
			ELSE   
			BEGIN  
				 IF ( SELECT  COUNT(*)
				 FROM    dbo.T_Room_Master
				 WHERE   S_Building_Name = @SBuildingName and S_Block_Name=@SBlockName and 
				 S_Floor_Name=@SFloorName and S_Room_No=@SRoomNo 
				 and I_Centre_Id = @iCenterID and I_Status=@IStatus
				 and I_Room_ID not in(@IRoomID)) = 0
				 BEGIN
					 UPDATE  dbo.T_Room_Master  
					 SET    S_Room_No= @SRoomNo ,
							I_Room_Type = @IRoomType ,  
							N_Room_Rate = @NRoomRate ,
							I_No_Of_Beds = @INoOfBeds,  
							S_Updt_By = @SCrtdby ,  
							Dt_Updt_On = Dt_Crtd_On,
							I_Centre_Id = @iCenterID,
							I_Status = @IStatus  
					 WHERE  I_Room_ID = @IRoomID 
				 END
				 ELSE 
				 BEGIN
					 RAISERROR('Entry with the same room no. already exists',11,1)
				 END 
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
