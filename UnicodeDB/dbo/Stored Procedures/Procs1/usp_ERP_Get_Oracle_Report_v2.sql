CREATE PROCEDURE dbo.usp_ERP_Get_Oracle_Report_v2  
    @Mode NVARCHAR(max)  
AS  
BEGIN  
    SET NOCOUNT ON;  

    IF @Mode IS NULL  
    BEGIN  
        SELECT  
              ID,  
              FORMAT(Start_Date, 'MMM d yyyy') + ' - ' + FORMAT(End_Date, 'MMM d yyyy') AS [Date],  
              Start_Date AS MonthStartDate,  
              End_Date   AS MonthEndDate,  
              Is_Synced_Started,  
              Sync_StartDate,  
              Is_Sync_Complete,  
              Sync_By,  
              Reports_for_Sync_Reconcile,  
              Is_Reconcile_Checked,  
              Reconcile_Checked_By,  
              Reconcile_Check_Date,  
              Is_GLPush_Done,  
              GLPush_Date,  
              GLPush_By,  
              GST_Reports,  
              Action  
        FROM dbo.Oracle_Reports  
        ORDER BY  
            CASE 
                WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                     AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, DATEADD(MONTH, -1, GETDATE())) THEN 1  -- Previous month
                WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                     AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, GETDATE()) THEN 2  -- Current month
                WHEN Start_Date > EOMONTH(GETDATE()) THEN 3  -- Future months
                ELSE 4  -- Older past months
            END,
            Start_Date;  
        RETURN;  
    END;  

    DECLARE @realMode nvarchar(max) = LTRIM(RTRIM(ISNULL(@Mode, '')));  

    IF @realMode NOT IN ('none','sync','reconcile','all')  
    BEGIN  
        RAISERROR(  
            'Invalid @Mode. Allowed values: ''none'', ''sync'', ''reconcile'', ''all'' (case-insensitive).',  
            16, 1  
        );  
        RETURN;  
    END;  

    BEGIN TRY  
        IF @realMode = 'none'  
        BEGIN  
            SELECT  
                  ID,  
                  FORMAT(Start_Date, 'MMM d yyyy') + ' - ' + FORMAT(End_Date, 'MMM d yyyy') AS [Date],  
                  Start_Date AS MonthStartDate,  
                  End_Date   AS MonthEndDate,  
                  Is_Synced_Started,  
                  Sync_StartDate,  
                  Is_Sync_Complete,  
                  Sync_By,  
                  Reports_for_Sync_Reconcile,  
                  Is_Reconcile_Checked,  
                  Reconcile_Checked_By,  
                  Reconcile_Check_Date,  
                  Is_GLPush_Done,  
                  GLPush_Date,  
                  GLPush_By,  
                  GST_Reports,  
                  Action  
            FROM dbo.Oracle_Reports  
            WHERE ISNULL(Is_Synced_Started, 0) = 0  
              AND ISNULL(Is_Sync_Complete, 0) = 0  
              AND ISNULL(Is_Reconcile_Checked,0) = 0  
              AND ISNULL(Is_GLPush_Done,0) = 0  
            ORDER BY  
                CASE 
                    WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                         AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, DATEADD(MONTH, -1, GETDATE())) THEN 1  
                    WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                         AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, GETDATE()) THEN 2  
                    WHEN Start_Date > EOMONTH(GETDATE()) THEN 3  
                    ELSE 4  
                END,
                Start_Date;  
            RETURN;  
        END;  

        IF @realMode = 'sync'  
        BEGIN  
            SELECT  
                  ID,  
                  FORMAT(Start_Date, 'MMM d yyyy') + ' - ' + FORMAT(End_Date, 'MMM d yyyy') AS [Date],  
                  Start_Date AS MonthStartDate,  
                  End_Date   AS MonthEndDate,  
                  Is_Synced_Started,  
                  Sync_StartDate,  
                  Is_Sync_Complete,  
                  Sync_By,  
                  Reports_for_Sync_Reconcile,  
                  Is_Reconcile_Checked,  
                  Reconcile_Checked_By,  
                  Reconcile_Check_Date,  
                  Is_GLPush_Done,  
                  GLPush_Date,  
                  GLPush_By,  
                  GST_Reports,  
                  Action  
            FROM dbo.Oracle_Reports  
            WHERE ISNULL(Is_Synced_Started,0) = 1  
              AND ISNULL(Is_Reconcile_Checked,0) = 0  
              AND ISNULL(Is_GLPush_Done,0) = 0  
            ORDER BY  
                CASE 
                    WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                         AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, DATEADD(MONTH, -1, GETDATE())) THEN 1  
                    WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                         AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, GETDATE()) THEN 2  
                    WHEN Start_Date > EOMONTH(GETDATE()) THEN 3  
                    ELSE 4  
                END,
                Start_Date;  
            RETURN;  
        END;  

        IF @realMode = 'reconcile'  
        BEGIN  
            SELECT  
                  ID,  
                  FORMAT(Start_Date, 'MMM d yyyy') + ' - ' + FORMAT(End_Date, 'MMM d yyyy') AS [Date],  
                  Start_Date AS MonthStartDate,  
                  End_Date   AS MonthEndDate,  
                  Is_Synced_Started,  
                  Sync_StartDate,  
                  Is_Sync_Complete,  
                  Sync_By,  
                  Reports_for_Sync_Reconcile,  
                  Is_Reconcile_Checked,  
                  Reconcile_Checked_By,  
                  Reconcile_Check_Date,  
                  Is_GLPush_Done,  
                  GLPush_Date,  
                  GLPush_By,  
                  GST_Reports,  
                  Action  
            FROM dbo.Oracle_Reports  
            WHERE ISNULL(Is_Synced_Started, 0) = 1  
              AND ISNULL(Is_Sync_Complete, 0) = 1  
              AND ISNULL(Is_Reconcile_Checked, 0) = 1  
              AND ISNULL(Is_GLPush_Done,0) = 0  
            ORDER BY  
                CASE 
                    WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                         AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, DATEADD(MONTH, -1, GETDATE())) THEN 1  
                    WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                         AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, GETDATE()) THEN 2  
                    WHEN Start_Date > EOMONTH(GETDATE()) THEN 3  
                    ELSE 4  
                END,
                Start_Date;  
            RETURN;  
        END;  

        IF @realMode = 'all'  
        BEGIN  
            SELECT  
                  ID,  
                  FORMAT(Start_Date, 'MMM d yyyy') + ' - ' + FORMAT(End_Date, 'MMM d yyyy') AS [Date],  
                  Start_Date AS MonthStartDate,  
                  End_Date   AS MonthEndDate,  
                  Is_Synced_Started,  
                  Sync_StartDate,  
                  Is_Sync_Complete,  
                  Sync_By,  
                  Reports_for_Sync_Reconcile,  
                  Is_Reconcile_Checked,  
                  Reconcile_Checked_By,  
                  Reconcile_Check_Date,  
                  Is_GLPush_Done,  
                  GLPush_Date,  
                  GLPush_By,  
                  GST_Reports,  
                  Action  
            FROM dbo.Oracle_Reports  
            WHERE ISNULL(Is_Synced_Started, 0) = 1  
              AND ISNULL(Is_Sync_Complete, 0) = 1  
              AND ISNULL(Is_Reconcile_Checked, 0) = 1  
              AND ISNULL(Is_GLPush_Done, 0) = 1  
            ORDER BY  
                CASE 
                    WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                         AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, DATEADD(MONTH, -1, GETDATE())) THEN 1  
                    WHEN DATEPART(YEAR, Start_Date) = DATEPART(YEAR, GETDATE()) 
                         AND DATEPART(MONTH, Start_Date) = DATEPART(MONTH, GETDATE()) THEN 2  
                    WHEN Start_Date > EOMONTH(GETDATE()) THEN 3  
                    ELSE 4  
                END,
                Start_Date;  
            RETURN;  
        END;  
    END TRY  
    BEGIN CATCH  
        DECLARE @ErrMsg NVARCHAR(max) = ERROR_MESSAGE();  
        RAISERROR('Error in usp_ERP_Get_Oracle_Report_v2: %s', 16, 1, @ErrMsg);  
        THROW;  
    END CATCH;  
END;

