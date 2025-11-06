CREATE PROCEDURE [dbo].[UAT_ERP_UpdateStudentSync]  
(  
    @studentInfoSyncTable UT_Student_Buzzed READONLY
    
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
        UPDATE esbs  
        SET   
            esbs.buzzed_student_id = sist.buzzed_student_id,  
            esbs.buzzed_parent_id = sist.buzzed_parent_id,
			esbs.is_Synced = 1,
			esbs.dt_Modified_dt = GETDATE()
        FROM T_ERP_Students_Buzzed_Sync esbs  
        INNER JOIN @studentInfoSyncTable sist   
        ON esbs.student_erp_id = sist.student_erp_id
		AND esbs.Erp_parent_id = sist.erp_parent_id
        WHERE esbs.is_Synced = 0;
  
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
