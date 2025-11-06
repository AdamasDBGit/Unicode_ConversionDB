CREATE PROCEDURE [dbo].[UAT_ERP_UpdateRouteSync]  
(  
    @I_Barnd_Id INT,  
    @BulkUploadSyncResponseTable UT_Buzzed_Pickup_Update READONLY
    --@StatusFlag INT OUTPUT,  
    --@Message NVARCHAR(100) OUTPUT,  
    --@ErrorMessage NVARCHAR(100) OUTPUT  
)  
AS  
BEGIN  
    -- Start a transaction  
    BEGIN TRANSACTION;  
  
    BEGIN TRY  
        -- Select statement for debugging or verification purposes (optional)  
--        SELECT *   
--        FROM T_ERP_SMS_GPS_Transport_SYNCLog esgt   
--        INNER JOIN @BulkUploadSyncResponseTable bpu   
--        ON esgt.erp_pickupid = bpu.SMS_ERP_PickupID;  
  
        -- Update statement  
        UPDATE esgt  
        SET   
            esgt.buzzed_pickupid = bpu.BUZZED_ERP_PickupID,  
            esgt.Is_Upadted_FromBuzz = 1  
        FROM T_ERP_SMS_GPS_Transport_SYNCLog esgt  
        INNER JOIN @BulkUploadSyncResponseTable bpu   
        ON esgt.erp_pickupid = bpu.SMS_ERP_PickupID  
        WHERE esgt.I_BrandID = @I_Barnd_Id;  
  
        -- Commit the transaction  
        COMMIT TRANSACTION;  
  
 SELECT 1 AS StatusFlag,      
       'Updated Successfully' AS Message  
    END TRY  
    BEGIN CATCH  
        -- Rollback the transaction on error  
        ROLLBACK TRANSACTION;  
  
        SELECT 0 AS StatusFlag,      
       'Update Failed' AS Message  
    END CATCH;  
END;  
