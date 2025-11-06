CREATE PROCEDURE [dbo].[USP_ERP_SaveBusMaster]  
(  
    @iBusID                INT = NULL,       -- if NULL ? Insert, else Update  
    @iBrandID              INT,              -- from client_id (hidden input)  
    @sBusNumber            Nnvarchar(max),     -- from bus_number input  
    @iTotalSeat            INT,              -- from total_seat input  
    @sTrackingDeviceID     Nnvarchar(max),     -- from tracking_device dropdown  
    @iUserID               INT               -- created/updated by  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    BEGIN TRY  
        BEGIN TRANSACTION;  
  
        IF @iBusID IS NULL OR @iBusID = 0  
        BEGIN  
            -- Insert new bus  
            INSERT INTO T_ERP_BusMaster  
            (  
                I_Brand_ID,  
                S_Bus_Number,  
                I_Total_Seat,  
                S_Tracking_Device_ID,  
                Dt_CreatedAt,  
                I_Flag  
            )  
            VALUES  
            (  
                @iBrandID,  
                @sBusNumber,  
                @iTotalSeat,  
                @sTrackingDeviceID,  
                GETDATE(),  
                0 -- default active  
            );  
  
            SET @iBusID = SCOPE_IDENTITY();  
        END  
        ELSE  
        BEGIN  
            -- Update existing bus  
            UPDATE T_ERP_BusMaster  
            SET  
                S_Bus_Number         = @sBusNumber,  
                I_Total_Seat         = @iTotalSeat,  
                S_Tracking_Device_ID = @sTrackingDeviceID,  
                Dt_UpdatedAt         = GETDATE()  
            WHERE I_Bus_ID = @iBusID  
              AND I_Brand_ID = @iBrandID;  
        END  
  
        COMMIT TRANSACTION;  
  
        -- Return success response  
        SELECT   
            1 AS StatusFlag,  
            'Bus details saved successfully' AS Message,  
            @iBusID AS BusID;  
    END TRY  
    BEGIN CATCH  
        ROLLBACK TRANSACTION;  
  
        SELECT   
            0 AS StatusFlag,  
            ERROR_MESSAGE() AS Message,  
            @iBusID AS BusID;  
    END CATCH  
END;  