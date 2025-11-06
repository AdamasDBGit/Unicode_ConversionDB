-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <22-09-2023>
-- Description:	<to add session>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddSession] 
    @iSchoolSessionID int = null,
    @iBrandID int,
    @sSessionLabel nvarchar(50),
    @dtStartDate datetime,
    @dtEndDate datetime,
    @iSessionStatus int,
    @iCurresntSession int, -- Updated: Now used in the procedure
    @sUpdatedBy NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        SET NOCOUNT ON;

        -- Check if there's already a current session for the BrandID
        IF (@iCurresntSession = 1)
        BEGIN
            IF EXISTS (SELECT 1 
                       FROM [dbo].[T_School_Academic_Session_Master]
                       WHERE I_Brand_ID = @iBrandID
                         AND I_Current_Session = 1
                         AND I_School_Session_ID <> @iSchoolSessionID) -- Exclude current record if updating
            BEGIN
                -- Restrict the update or insert if another current session exists
                SELECT 0 AS StatusFlag, 'Another current session is already exists for this brand' AS Message;
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END

        -- Update if @iSchoolSessionID > 0 (existing record)
        IF (@iSchoolSessionID > 0)
        BEGIN
            IF EXISTS (SELECT 1 
                       FROM [dbo].[T_School_Academic_Session_Master]
                       WHERE I_Brand_ID = @iBrandID
                         AND ((@dtStartDate >= Dt_Session_Start_Date AND @dtStartDate <= Dt_Session_End_Date)
                           OR (@dtEndDate >= Dt_Session_Start_Date AND @dtEndDate <= Dt_Session_End_Date)))
            BEGIN
                UPDATE [dbo].[T_School_Academic_Session_Master]
                SET 
                    S_Label = @sSessionLabel,
                    I_Status = @iSessionStatus,
                    I_Current_Session = @iCurresntSession, -- Updated: Set current session value
                    S_UpdatedBy = @sUpdatedBy,
                    Dt_UpdatedOn = GETDATE(),
					Dt_Session_Start_Date = @dtStartDate,
					Dt_Session_End_Date = @dtEndDate
                WHERE I_School_Session_ID = @iSchoolSessionID;

                SELECT 1 AS StatusFlag, 'Session updated' AS Message;
            END
        END
        ELSE -- Insert new record
        BEGIN
            INSERT INTO [dbo].[T_School_Academic_Session_Master]
            (
                I_Brand_ID,
                Dt_Session_Start_Date,
                Dt_Session_End_Date,
                S_Label,
                I_Status,
                I_Current_Session, -- Updated: Set current session value
                S_CreatedBy,
                Dt_CreatedOn
            )
            VALUES
            (
                @iBrandID,
                @dtStartDate,
                @dtEndDate,
                @sSessionLabel,
                @iSessionStatus,
                @iCurresntSession, -- Updated: Set current session value
                @sUpdatedBy,
                GETDATE()
            );

            SELECT 1 AS StatusFlag, 'New Session added' AS Message;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
        SELECT 0 AS StatusFlag, @ErrMsg AS Message;
    END CATCH
END


