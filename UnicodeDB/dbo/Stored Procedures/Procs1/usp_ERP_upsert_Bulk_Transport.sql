CREATE PROCEDURE [dbo].[usp_ERP_upsert_Bulk_Transport]        
(        
    @str_route NVARCHAR(max),        
    @brandid int,        
    @Erp_Createdby int,        
    @response int  -- 0 for delete, 1 for new insert/update          
)        
AS        
BEGIN        
    -- Create temporary table      
    CREATE TABLE #Temp_T_Transport        
    (        
        [ID] [int] IDENTITY(1, 1) NOT NULL,        
        Routeid int,        
        routename nvarchar(max) NULL,        
        start_loc nvarchar(max) NULL,        
        Pickupid int,        
        Pickup_Name nvarchar(max) NULL,        
        Landmark nvarchar(max) NULL,        
        Fulladdress nvarchar(max) NULL,        
        Pickup_Order int NULL,        
        Drop_Order int NULL,      
        m_Fee decimal(18,2) NULL,      
        rowid int        
    );      
      
    -- Temporary table for row IDs      
    DECLARE @tbl_rowid TABLE        
    (        
        id int IDENTITY(1, 1),        
        rowid int        
    );      
      
    -- Insert values into @tbl_rowid from the split string function      
    INSERT INTO @tbl_rowid(rowid)      
    SELECT value        
    FROM dbo.fn_Split_comma_String(@str_route, ',');      
      
    IF @response = 0        
    BEGIN        
        DELETE tt        
        FROM T_ERP_SMS_GPS_Transport_SYNCLog tt        
        INNER JOIN @tbl_rowid t ON tt.Row_ID = t.rowid;      
      
        PRINT 'User has cancelled and deleted from log table';      
    END        
    ELSE        
    BEGIN        
        DECLARE @newrouteID int,        
                @newroutename nvarchar(max),        
                @newpickupID int,        
                @newpickup_name nvarchar(max),        
                @newstartlocation nvarchar(max),        
                @newlandmark nvarchar(max),        
                @Newfulladdress nvarchar(max),        
                @newpickup_order int,        
                @newdrop_order int,        
                @monthlyfee decimal(18, 2),        
                @row_id int,        
                @ID int = 1,        
                @lst int;      
              
        SET @lst = (SELECT MAX(id) FROM @tbl_rowid);      
      
        WHILE @ID <= @lst        
        BEGIN        
            PRINT 'Loop Start';      
            SET @row_id = (SELECT TOP 1 rowid FROM @tbl_rowid WHERE id = @ID);      
      
            SELECT TOP 1      
                @newrouteID = New_RouteID,        
                @newroutename = New_RouteName,        
                @newpickupID = New_PickupID,        
                @newpickup_name = New_PickupLocation_Name,        
                @newstartlocation = New_StartLocation,        
                @newlandmark = New_Landmark,        
                @Newfulladdress = New_FullAddress,        
                @newpickup_order = New_PickupOrder,        
                @newdrop_order = New_DropOrder,        
                @monthlyfee = New_Monthly_Fee        
            FROM T_ERP_SMS_GPS_Transport_SYNCLog        
            WHERE Row_ID = @row_id;      
      
            -- Insert or update route      
            IF @newrouteID IS NULL        
            BEGIN      
   IF Exists(select 1 from T_BusRoute_Master     
   where S_Route_No=@newroutename    
   and I_Status=1 and I_Brand_ID=@brandid)    
   BEGIN    
   SET @newrouteID=(select I_Route_ID     
   from T_BusRoute_Master where S_Route_No=@newroutename    
   and I_Status=1 and I_Brand_ID=@brandid    
   )     
   End     
   Else    
   BEGIN    
                INSERT INTO T_BusRoute_Master        
                (        
                    S_Route_No,        
                    I_Status,        
                    S_Crtd_By,        
                    Dt_Crtd_On,        
                    I_Brand_ID,        
                    I_ERP_User_ID,        
                    S_Location        
                )        
                VALUES        
                (      
                    @newroutename,       
                    1,       
               1,       
                    GETDATE(),       
                    @brandid,       
                    @Erp_Createdby,       
                    @newstartlocation      
                );      
      
                SET @newrouteID = SCOPE_IDENTITY();      
            END       
   End    
       
            ELSE        
            BEGIN        
                UPDATE T_BusRoute_Master        
                SET       
                    S_Route_No = @newroutename,        
                    S_Location = @newstartlocation        
                WHERE I_Route_ID = @newrouteID;      
            END      
      
            -- Insert or update pickup      
            IF @newpickupID IS NULL        
            BEGIN  
			If Exists (
			Select 1 from T_Transport_Master where S_PickupPoint_Name=@newpickup_name
			and I_Brand_ID=@brandid and I_Status=1)
		
			Begin
			SET @newpickupID=(Select  top 1 I_PickupPoint_ID from T_Transport_Master where S_PickupPoint_Name=@newpickup_name
			and I_Brand_ID=@brandid and I_Status=1

			)
	      End 
		  	Else
			Begin
                INSERT INTO T_Transport_Master        
                (        
                    I_Brand_ID,        
                    S_PickupPoint_Name,        
                    N_Fees,        
                    I_Status,        
                    S_Crtd_By,        
                    Dt_Crtd_On,        
                    pickup_index,        
                    drop_index,        
                    PickPoint_Landmark,        
                    Pickup_Full_Address        
                )        
                VALUES        
                (      
                    @brandid,        
                    @newpickup_name,        
                    @monthlyfee,        
                    1,        
                    1,        
                    GETDATE(),        
                    @newpickup_order,        
                    @newdrop_order,        
                    @newlandmark,        
                    @Newfulladdress      
                );      
      
                SET @newpickupID = SCOPE_IDENTITY();      
            END    
			End
            ELSE        
            BEGIN        
                UPDATE T_Transport_Master        
                SET       
                    S_PickupPoint_Name = @newpickup_name,        
                    N_Fees = @monthlyfee,        
                    pickup_index = @newpickup_order,        
                    drop_index = @newdrop_order,        
                    PickPoint_Landmark = @newlandmark,        
                    Pickup_Full_Address = @Newfulladdress        
                WHERE I_PickupPoint_ID = @newpickupID;      
            END      
      
            -- Insert route-transport mapping if it doesn't exist      
            IF NOT EXISTS        
            (        
                SELECT 1        
                FROM T_Route_Transport_Map        
                WHERE I_Route_ID = @newrouteID        
                AND I_PickupPoint_ID = @newpickupID        
                AND I_Status = 1        
            )        
            BEGIN        
                INSERT INTO T_Route_Transport_Map        
                (        
                    I_PickupPoint_ID,        
                    I_Route_ID,        
                    I_Status,        
                    S_Crtd_By,        
                    Dt_Crtd_On        
                )        
                VALUES        
                (      
                    @newpickupID,       
                    @newrouteID,       
                    1,       
                    1,       
                    GETDATE()      
                );      
            END      
    Update T_ERP_SMS_GPS_Transport_SYNCLog set erp_pickupid=@newpickupID  
 where row_id=@row_id  
            -- Insert into temporary table      
            INSERT INTO #Temp_T_Transport        
            (        
                Routeid,        
                routename,        
                start_loc,        
                Pickupid,        
                Pickup_Name,        
                Landmark,        
                Fulladdress,        
                Pickup_Order,        
                Drop_Order,       
                m_Fee,      
                rowid        
            )        
            VALUES        
            (      
             @newrouteID,        
                @newroutename,        
                @newstartlocation,        
                @newpickupID,        
                @newpickup_name,        
                @newlandmark,        
                @Newfulladdress,        
                @newpickup_order,        
                @newdrop_order,        
                @monthlyfee,        
                @row_id      
            );      
      
            SET @ID = @ID + 1;      
        END        
    END      
  
    -- Select from temporary table      
    SELECT *, @brandid AS BrandID FROM #Temp_T_Transport;      
END;   


