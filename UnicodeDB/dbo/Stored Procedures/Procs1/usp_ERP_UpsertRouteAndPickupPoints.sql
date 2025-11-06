CREATE PROCEDURE [dbo].[usp_ERP_UpsertRouteAndPickupPoints]  
    @I_Route_ID INT = NULL,  
    @S_Route_No NVARCHAR(MAX),  
    @S_Location NVARCHAR(MAX),  
    @ERP_User_ID INT,  
    @I_Brand_ID INT,  
    @start_latitude NVARCHAR(MAX),  
    @start_longitude NVARCHAR(MAX),  
    @pickup_points UT_Route_PickupMap READONLY  
AS  
BEGIN  
    BEGIN TRY  
        BEGIN TRANSACTION;  
  Create Table #RoutePickup(  
  ID Int identity(1,1),  
  I_route_ID int ,  
  I_Pickup_ID int,  
  IS_NewPickup bit,  
  Start_latitude varchar(50),  
  Start_lognitude varchar(50)  
  )  
  
        -- Insert or Update HeaderTable  
        IF @I_Route_ID IS NULL  
        BEGIN  
            -- Insert new record  
        INSERT Into T_BusRoute_Master(S_Route_No, S_Location, I_ERP_User_ID, I_Brand_ID, start_latitude, start_longitude,I_Status)  
        VALUES (@S_Route_No, @S_Location, @ERP_User_ID, @I_Brand_ID, @start_latitude, @start_longitude,1)  
  
  
            SET @I_Route_ID = SCOPE_IDENTITY(); -- Retrieve the generated HeaderID  
        END  
        ELSE  
        BEGIN  
            -- Update existing record  
            UPDATE T_BusRoute_Master SET  
             S_Route_No = @S_Route_No,  
            S_Location = @S_Location,  
            I_ERP_User_ID = @ERP_User_ID,  
            I_Brand_ID = @I_Brand_ID,  
            start_latitude = @start_latitude,  
            start_longitude = @start_longitude  
            WHERE I_Route_ID = @I_Route_ID;  
        END  
  
  Select IDENTITY(INT,1,1) AS ID, * INTO #pickup_points from @pickup_points  
  
       Declare @ID int=1,@lst int  
    Declare @PickupID int, @S_PickupPoint_Name Varchar(500),@PickPoint_Landmark Varchar(255),  
    @Pickup_Full_Address Varchar(500),@pickup_latitude Varchar(50),  
    @pickup_longitude Varchar(50),@pickup_index Int,@drop_index Int,@N_Fees Decimal(18,2)  
    SET @lst=(select MAX(ID) from #pickup_points)  
    While @ID <=@lst  
    Begin  
  
       Select @PickupID= I_PickupPoint_ID,@S_PickupPoint_Name=S_PickupPoint_Name  
    ,@PickPoint_Landmark=PickPoint_Landmark  
    ,@Pickup_Full_Address=Pickup_Full_Address,  
    @pickup_latitude=pickup_latitude  
    ,@pickup_longitude=pickup_longitude,@pickup_index=pickup_order,@drop_index=drop_order  
    ,@N_Fees=N_Fees  
    from #pickup_points where ID=@ID  
    ------------------------------------------------------  
      IF @PickupID IS NULL  
        BEGIN  
            -- Insert new record  
    INSERT Into T_Transport_Master(I_Brand_ID, S_PickupPoint_Name, PickPoint_Landmark, Pickup_Full_Address,   
                pickup_latitude, pickup_longitude, pickup_index, drop_index, N_Fees, I_Status)         
 VALUES (@I_Brand_ID, @S_PickupPoint_Name, @PickPoint_Landmark, @Pickup_Full_Address  
 , @pickup_latitude, @pickup_longitude,@pickup_index,@drop_index,@N_Fees, 1)  
  
  
            SET @PickupID = SCOPE_IDENTITY(); -- Retrieve the generated HeaderID  
   Insert Into #RoutePickup(  
   I_Pickup_ID,IS_NewPickup  
   )  
   Values(@PickupID,1)  
        END  
        ELSE  
        Begin  
            -- Update existing record  
            UPDATE T_Transport_Master SET  
            S_PickupPoint_Name = @S_PickupPoint_Name,  
            PickPoint_Landmark = @PickPoint_Landmark,  
            Pickup_Full_Address = @Pickup_Full_Address,  
            pickup_latitude = @pickup_latitude,  
            pickup_longitude = @pickup_longitude,  
            pickup_index = @pickup_index,  
            drop_index = @drop_index,  
            N_Fees = @N_Fees  
            WHERE I_PickupPoint_ID = @PickupID;  
   Insert Into #RoutePickup(  
   I_Pickup_ID,IS_NewPickup  
   )  
   Values(@PickupID,0)  
        END  
  SET @ID=@ID+1  
    End   
  
    Update #RoutePickup Set I_route_ID=@I_Route_ID  
    ,Start_latitude=@start_latitude,Start_lognitude=@start_longitude  
  
    If Not Exists( select 1 from T_Route_Transport_Map RTM Inner Join #RoutePickup tt  
    ON tt.I_route_ID=RTM.I_Route_ID and tt.I_Pickup_ID=RTM.I_PickupPoint_ID and RTM.I_Status=1)  
    Begin  
    Insert Into T_Route_Transport_Map(  
    I_PickupPoint_ID  
    ,I_Route_ID  
      ,I_Status  
      ,S_Crtd_By  
      ,Dt_Crtd_On  
      ,start_latitude  
      ,start_longitude  
    )  
    Select I_Pickup_ID,I_route_ID,1,1,GETDATE(),Start_latitude,Start_lognitude  
    from #RoutePickup   
    End  
    Else  
    Begin  
 update RTM set rtm.start_latitude=tt.Start_latitude,rtm.start_longitude=tt.Start_lognitude  
 from T_Route_Transport_Map RTM   
    Inner Join #RoutePickup tt  
    ON tt.I_route_ID=RTM.I_Route_ID and tt.I_Pickup_ID=RTM.I_PickupPoint_ID and RTM.I_Status=1  
    End  
 SELECT 
    I_route_ID,
    STUFF((
        SELECT ', ' + CAST(rp.I_Pickup_ID AS VARCHAR)
        FROM #RoutePickup rp
        WHERE rp.I_route_ID = r.I_route_ID
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS Pickup_IDs
FROM 
    #RoutePickup r
GROUP BY 
    I_route_ID;----OUTPUT table  
  Drop table #pickup_points  
  drop table #RoutePickup  
        COMMIT;  
    END TRY  
    BEGIN CATCH  
        IF @@TRANCOUNT > 0  
            ROLLBACK;  
  
        -- Handle the error as needed  
        THROW;  
    END CATCH;  
END;

