CREATE PROCEDURE [dbo].[USP_ERP_SaveDriverEscortMaster]
(
    @I_Driver_Escort_ID INT = NULL,     -- If NULL or 0 ? Insert, else Update
    @I_Brand_ID         INT,
    @S_Name             Nnvarchar(max),
    @S_Phone            Nnvarchar(max) = NULL,
    @S_Type             Nnvarchar(max) = NULL,      -- Optional
    @S_Token            Nnvarchar(max) = NULL,     -- Optional
    @S_Emp_No           Nnvarchar(max) = NULL     -- Optional
    -- @I_UserID           INT                     -- For audit (like bus SP)
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        IF (@I_Driver_Escort_ID IS NULL OR @I_Driver_Escort_ID = 0)
        BEGIN
            -- INSERT NEW
            INSERT INTO T_ERP_DriverEscortMaster
            (
                I_Brand_ID,
                S_Name,
                S_Phone,
                S_Type,
                S_Token,
                S_Emp_No,
                created_at
            )
            VALUES
            (
                @I_Brand_ID,
                @S_Name,
                @S_Phone,
                @S_Type,
                @S_Token,
                @S_Emp_No,
                GETDATE()
            );

            SET @I_Driver_Escort_ID = SCOPE_IDENTITY();

            SELECT
                1 AS StatusFlag,
                'Driver/Escort saved successfully.' AS Message,
                @I_Driver_Escort_ID AS I_Driver_Escort_ID;
        END
        ELSE
        BEGIN
            -- UPDATE EXISTING
            UPDATE T_ERP_DriverEscortMaster
            SET
                S_Name     = @S_Name,
                S_Phone    = @S_Phone,
                S_Type     = @S_Type,
                S_Token    = @S_Token,
                S_Emp_No   = @S_Emp_No,
                updated_at = GETDATE()
            WHERE
                I_Driver_Escort_ID = @I_Driver_Escort_ID
                AND I_Brand_ID = @I_Brand_ID;  -- brand-level security

            SELECT
                1 AS StatusFlag,
                'Driver/Escort updated successfully.' AS Message,
                @I_Driver_Escort_ID AS I_Driver_Escort_ID;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT
            0 AS StatusFlag,
            ERROR_MESSAGE() AS Message,
            @I_Driver_Escort_ID AS I_Driver_Escort_ID;
    END CATCH
END;

