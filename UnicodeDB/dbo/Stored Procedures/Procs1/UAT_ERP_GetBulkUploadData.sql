CREATE PROCEDURE [dbo].[UAT_ERP_GetBulkUploadData]
    @I_BrandID INT,
    @Is_For_Save INT
AS
BEGIN
    IF @Is_For_Save = 1
    BEGIN
        SELECT 
            Row_ID,
            I_BrandID,
            New_RouteName,
            New_StartLocation,
            New_PickupLocation_Name,
            New_Landmark,
            New_FullAddress,
            New_PickupOrder,
            New_DropOrder,
            New_Monthly_Fee,
            Old_RouteName,
            Old_PickupLocation_Name,
            Old_StartLocation,
            Old_Monthly_Fee
        FROM T_ERP_SMS_GPS_Transport_SYNCLog
        WHERE Is_Upadted_FromBuzz = 0
          AND I_BrandID = @I_BrandID;
    END
    ELSE
    BEGIN
        SELECT 
            Row_ID,
            I_BrandID,
            New_RouteName,
            New_StartLocation,
            New_PickupLocation_Name,
            New_Landmark,
            New_FullAddress,
            New_PickupOrder,
            New_DropOrder,
            New_Monthly_Fee,
            Old_RouteName,
            Old_PickupLocation_Name,
            Old_StartLocation,
            Old_Monthly_Fee,
			Is_Upadted_FromBuzz
        FROM T_ERP_SMS_GPS_Transport_SYNCLog
		WHERE I_BrandID = @I_BrandID;
    END
END;
