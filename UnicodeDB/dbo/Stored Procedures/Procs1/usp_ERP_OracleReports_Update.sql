-- ===========================================================
-- Author : Surya Narayan Chakraborty.
-- Created On : 15/09/2025
-- ===========================================================

CREATE PROCEDURE dbo.usp_ERP_OracleReports_Update    
    @ID INT,    
    @Reconcile_Checked_By INT = NULL,    
    @GLPush_By INT = NULL    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    BEGIN TRY    
        BEGIN TRANSACTION;    
    
        IF @Reconcile_Checked_By IS NULL AND @GLPush_By IS NULL    
        BEGIN    
            ROLLBACK TRANSACTION;    
            SELECT 0 AS StatusFlag, 'No input parameters provided. Provide at least Reconcile_Checked_By or GLPush_By.' AS Message;    
            RETURN;    
        END    
    
        DECLARE @UpdatedIDs TABLE (ID INT PRIMARY KEY);    
    
        -- Update Reconcile-related columns (allow update regardless of other rows)    
        IF @Reconcile_Checked_By IS NOT NULL    
        BEGIN    
            UPDATE dbo.Oracle_Reports    
            SET    
                Reconcile_Checked_By = @Reconcile_Checked_By,    
                Is_Reconcile_Checked = CAST(1 AS BIT),    
                Reconcile_Check_Date = GETDATE()  
            OUTPUT inserted.ID INTO @UpdatedIDs(ID)    
            WHERE ID = @ID;    
        END    
    
        -- Update GLPush-related columns (allow update regardless of other rows)    
        IF @GLPush_By IS NOT NULL    
        BEGIN    
            UPDATE dbo.Oracle_Reports    
            SET    
                GLPush_By = @GLPush_By,    
                Is_GLPush_Done = CAST(1 AS BIT),    
                GLPush_Date = GETDATE()  
            OUTPUT inserted.ID INTO @UpdatedIDs(ID)    
            WHERE ID = @ID;    
        END    
    
        IF NOT EXISTS (SELECT 1 FROM @UpdatedIDs)    
        BEGIN    
            ROLLBACK TRANSACTION;    
            SELECT 0 AS StatusFlag, 'No rows qualified for update' AS Message;    
            RETURN;    
        END    
    
        COMMIT TRANSACTION;    
    
        SELECT 1 AS StatusFlag, 'Updated Successfully' AS Message;    
    
        SELECT r.*    
        FROM dbo.Oracle_Reports r    
        INNER JOIN (SELECT DISTINCT ID FROM @UpdatedIDs) u ON r.ID = u.ID;    
    
    END TRY    
    BEGIN CATCH    
        IF XACT_STATE() <> 0    
            ROLLBACK TRANSACTION;    
    
        SELECT 0 AS StatusFlag, ERROR_MESSAGE() AS Message;    
    END CATCH    
END;