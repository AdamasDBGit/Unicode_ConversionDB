CREATE PROCEDURE [SMManagement].[uspUpdateDeliveryStatusTracking]
    (
      @TrackingID VARCHAR(20)
    )
AS
    BEGIN
    
    
        UPDATE  SMManagement.T_Stock_Master
        SET     StatusID = 3,UpdatedBy='rice-group-admin',UpdatedOn=GETDATE()
        WHERE   StockID IN (
                SELECT  TSDSD.StockID
                FROM    SMManagement.T_Stock_Dispatch_Student_Details AS TSDSD
                        INNER JOIN SMManagement.T_Stock_Dispatch_Student_Header
                        AS TSDSH ON TSDSH.StockDispatchStudentHeaderID = TSDSD.StockDispatchStudentHeaderID
                WHERE   --TSDSH.StockDispatchStudentHeaderID = @StudentDispatchHeader
                        TSDSH.TrackingID = @TrackingID
                        AND TSDSH.IsDispatched = 1
                        AND ISNULL(TSDSH.IsDelivered, 0) = 0 )
                AND StatusID<>3        

        UPDATE  SMManagement.T_Student_Eligibity_Details
        SET     IsDelivered = 1
        WHERE   EligibilityDetailID IN (
                SELECT  TSDSD.EligibilityDetailID
                FROM    SMManagement.T_Stock_Dispatch_Student_Details AS TSDSD
                        INNER JOIN SMManagement.T_Stock_Dispatch_Student_Header
                        AS TSDSH ON TSDSH.StockDispatchStudentHeaderID = TSDSD.StockDispatchStudentHeaderID
                WHERE   --TSDSH.StockDispatchStudentHeaderID = @StudentDispatchHeader
                        TSDSH.TrackingID = @TrackingID
                        AND TSDSH.IsDispatched = 1
                        AND ISNULL(TSDSH.IsDelivered, 0) = 0 )
                AND ISNULL(IsDelivered,0)<>1       


        UPDATE  SMManagement.T_Stock_Dispatch_Student_Header
        SET     IsDelivered = 1 ,
                DeliveryDate = GETDATE()
        WHERE   --StockDispatchStudentHeaderID = @StudentDispatchHeader
                TrackingID = @TrackingID
                AND ISNULL(IsDelivered,0)<>1
                
        UPDATE SMManagement.T_Courier_TrackingID SET StatusID=2 WHERE TrackingID=@TrackingID        

    END
