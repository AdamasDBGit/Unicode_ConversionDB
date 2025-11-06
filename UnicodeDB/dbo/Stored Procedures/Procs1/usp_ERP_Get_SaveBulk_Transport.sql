    
-- =============================================            
CREATE PROCEDURE [dbo].[usp_ERP_Get_SaveBulk_Transport]    
          
(    
    @Is_Through_Bulk_upload INT = NULL,    
    @I_Barnd_Id INT,    
    @BulkUploadTransportTables UT_Bulk_Transport readonly    
)    
AS    
Begin    
       BEGIN TRY     
      BEGIN TRANSACTION               
    SET NOCOUNT ON;    
    
    CREATE TABLE #Temp_T_Transport    
    (    
        [ID] [int] IDENTITY(1, 1) NOT NULL,    
        --[I_Brand_Id] [int] NOT NULL,          
        U_Old_Route_No Varchar(255) Null,    
        U_New_Route_No Varchar(255) Null,    
        U_Start_Location [varchar](500) NULL,    
        U_Pickup_Name [varchar](500) NULL,    
        U_Landmark [varchar](500) NULL,    
        U_Fulladdress [varchar](500) NULL,    
        U_Pickup_Order INT NULL,    
        U_Drop_Order INT NULL,    
        U_Monthly_Fee decimal(18, 2)    
    )    
    
    INSERT INTO #Temp_T_Transport    
    (    
        U_Old_Route_No,    
        U_New_Route_No,    
        U_Start_Location,    
        U_Pickup_Name,    
        U_Landmark,    
        U_Fulladdress,    
        U_Pickup_Order,    
        U_Drop_Order,    
        U_Monthly_Fee    
    )    
    SELECT U_Old_Route_No,    
           U_New_Route_No,    
           U_Start_Location,    
           U_Pickup_Name,    
           U_Landmark,    
           U_Fulladdress,    
           U_Pickup_Order,    
           U_Drop_Order,    
           U_Monthly_Fee    
    FROM @BulkUploadTransportTables    
    
    DECLARE @ID INT = 1,    
            @lst INT -----------Declare var for loop          
         Declare @U_Old_Route_No Varchar(255),    
                @U_New_Route_No Varchar(255),    
                @U_Pickup_Name Varchar(200),    
                @U_Monthly_Fee Decimal(18, 2),    
    @Startloc Varchar(100),    
    @Fulladdress varchar(100),    
    @Landmark Varchar(100),    
    @Pickup_Order Int,    
    @Drop_Order Int       
    SET @lst =    
    (    
        SELECT Max(ID) from #Temp_T_Transport    
    ) -------setting the last element to @lst   
 --Select @lst as TotalCount  
 --Select * from #Temp_T_Transport   
    while @ID <= @lst    
    Begin    
      
    
        Select @U_Old_Route_No = LTRIM(RTRIM(U_Old_Route_No)),    
               @U_New_Route_No = LTRIM(RTRIM(U_New_Route_No)),    
               @U_Pickup_Name = LTRIM(RTRIM(U_Pickup_Name)),    
               @U_Monthly_Fee = U_Monthly_Fee,    
      @Startloc=U_Start_Location,    
      @Fulladdress=U_Fulladdress,    
      @Landmark=U_Landmark,    
      @Pickup_Order=U_Pickup_Order,    
      @Drop_Order=U_Drop_Order    
    
        from #Temp_T_Transport    
        where ID = @ID    
    
        Declare @U_Old_RouteID INT,    
                @U_New_RouteID INT,    
                @U_Old_PickupID INT,    
                @MonthlyFeesOLD Decimal(18, 2),    
                @U_New_PickupID INT    
    
        SET @U_Old_RouteID =    
        (    
            Select TOP 1    
                I_Route_ID    
            from T_BusRoute_Master    
            where S_Route_No = @U_Old_Route_No    
                  and I_Brand_ID = @I_Barnd_Id    
                  and I_Status = 1    
        )    
    
        SET @U_New_RouteID =    
        (    
            Select TOP 1    
                I_Route_ID    
            from T_BusRoute_Master    
            where S_Route_No = @U_New_Route_No    
                  and I_Brand_ID = @I_Barnd_Id    
                  and I_Status = 1    
        )    
    
        SET @U_Old_PickupID =    
        (    
            select TOP 1    
                TM.I_PickupPoint_ID    
            from T_Transport_Master TM    
                Inner Join T_Route_Transport_Map RTM    
                    ON RTM.I_Route_ID = @U_Old_RouteID    
            where TM.S_PickupPoint_Name = @U_Pickup_Name    
                  and I_Brand_ID = @I_Barnd_Id    
                  and tm.I_Status = 1    
                  and RTM.I_Status =1    
        )    
        SET @MonthlyFeesOLD =    
        (    
        select N_Fees    
            from T_Transport_Master TM    
                Inner Join T_Route_Transport_Map RTM    
                    ON RTM.I_PickupPoint_ID = TM.I_PickupPoint_ID    
            where TM.I_PickupPoint_ID = @U_Old_PickupID    
                  and TM.I_Status = 1    
   and RTM.I_Status = 1    
        )    
        Insert Into T_ERP_SMS_GPS_Transport_SYNCLog    
        (    
            
            Old_RouteID,    
            Old_RouteName,    
            Old_PickupID,    
            Old_PickupLocation_Name,    
            Old_Monthly_Fee,    
            New_RouteID,    
            New_RouteName,    
            New_PickupID,    
            New_PickupLocation_Name,    
            New_Monthly_Fee,    
            Is_Upadted_FromBuzz,    
            dt_CreateDt,    
            dt_UpdateDt,    
            I_BrandID,    
   New_StartLocation,    
   New_Landmark,    
   New_PickupOrder,    
   New_DropOrder    
    
        )    
        Select  
               @U_Old_RouteID,    
               @U_Old_Route_No,    
               @U_Old_PickupID,    
               @U_Pickup_Name,    
               @MonthlyFeesOLD,    
               @U_New_RouteID,    
               @U_New_Route_No,    
               @U_New_PickupID,    
               @U_Pickup_Name,    
               @U_Monthly_Fee,    
               0,    
               GETDATE(),    
               Null,    
               @I_Barnd_Id,    
      @Startloc,    
      @Landmark,    
      @Pickup_Order,    
      @Drop_Order    
          
    
          
    
        --Select * from T_BusRoute_Master where S_Route_No='28'      
        --select * from T_Transport_Master      
        --select * from T_ERP_SMS_GPS_Transport_SYNCLog      
        Print 1    
    --End --------------End of both-------------          
    
    SET @id = @id + 1   
 End  
  SELECT 1 AS StatusFlag,    
       'Route Pickup Successfully Mapped' AS Message    
   COMMIT TRANSACTION                        
    END TRY                        
    BEGIN CATCH                        
--Error occurred:                          
        ROLLBACK TRANSACTION                        
        DECLARE @ErrMsg NVARCHAR(4000) ,              
            @ErrSeverity INT                        
        SELECT  @ErrMsg = ERROR_MESSAGE() + ' occurred at Line_Number: ' + CAST(ERROR_LINE() AS VARCHAR(50)),              
                @ErrSeverity = ERROR_SEVERITY()                        
                        
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                        
    END CATCH   
    
  
    End
