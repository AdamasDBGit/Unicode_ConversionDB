CREATE PROCEDURE [dbo].[USP_ERP_SaveGuardMaster]
(
    @I_Guard_ID INT = NULL,      -- If NULL or 0 ? Insert, else Update
    @I_Brand_ID INT,
    @S_Name     Nnvarchar(max),
    @S_Phone    Nnvarchar(max) = NULL,
    @S_Type     Nnvarchar(max) = NULL,
    @S_Token    Nnvarchar(max) = NULL,
    @S_Emp_No   Nnvarchar(max) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF (@I_Guard_ID IS NULL OR @I_Guard_ID = 0)
        BEGIN
            -- INSERT
            INSERT INTO T_ERP_GuardMaster
            (
                I_Brand_ID,
                S_Name,
                S_Phone,
                S_Type,
                S_Token,
                S_Emp_No,
                Created_At
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

            SET @I_Guard_ID = SCOPE_IDENTITY();

            SELECT
                1 AS StatusFlag,
                'Guard saved successfully.' AS Message,
                @I_Guard_ID AS I_Guard_ID;
        END
        ELSE
        BEGIN
            -- UPDATE
            UPDATE T_ERP_GuardMaster
            SET
                S_Name     = @S_Name,
                S_Phone    = @S_Phone,
                S_Type     = @S_Type,
                S_Token    = @S_Token,
                S_Emp_No   = @S_Emp_No,
                Updated_At = GETDATE()
            WHERE
                I_Guard_ID = @I_Guard_ID
                AND I_Brand_ID = @I_Brand_ID;

            SELECT
                1 AS StatusFlag,
                'Guard updated successfully.' AS Message,
                @I_Guard_ID AS I_Guard_ID;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT
            0 AS StatusFlag,
            ERROR_MESSAGE() AS Message,
            @I_Guard_ID AS I_Guard_ID;
    END CATCH
END;
