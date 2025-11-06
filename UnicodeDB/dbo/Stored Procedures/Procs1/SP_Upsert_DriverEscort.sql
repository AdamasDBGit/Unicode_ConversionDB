CREATE PROCEDURE SP_Upsert_DriverEscort
    @I_Driver_Escort_ID INT = NULL,   -- If NULL or 0 = Insert, else Update
    @I_Brand_ID INT,
    @S_Name NVARCHAR(MAX),
    @S_Phone NVARCHAR(MAX) = NULL,
    @S_Type NVARCHAR(MAX) = NULL,
    @S_Token NVARCHAR(MAX) = NULL,
    @S_Emp_No NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF (@I_Driver_Escort_ID IS NULL OR @I_Driver_Escort_ID = 0)
    BEGIN
        -- INSERT NEW RECORD
        INSERT INTO T_ERP_DriverEscortMaster
        (I_Brand_ID, S_Name, S_Phone, S_Type, S_Token, S_Emp_No, created_at)
        VALUES
        (@I_Brand_ID, @S_Name, @S_Phone, @S_Type, @S_Token, @S_Emp_No, GETDATE());

        -- Return new ID
        SELECT SCOPE_IDENTITY() AS I_Driver_Escort_ID, 'Inserted' AS Action;
    END
    ELSE
    BEGIN
        -- UPDATE EXISTING RECORD
        UPDATE T_ERP_DriverEscortMaster
        SET I_Brand_ID = @I_Brand_ID,
            S_Name = @S_Name,
            S_Phone = @S_Phone,
            S_Type = @S_Type,
            S_Token = @S_Token,
            S_Emp_No = @S_Emp_No,
            updated_at = GETDATE()
        WHERE I_Driver_Escort_ID = @I_Driver_Escort_ID;

        SELECT @I_Driver_Escort_ID AS I_Driver_Escort_ID, 'Updated' AS Action;
    END
END;
