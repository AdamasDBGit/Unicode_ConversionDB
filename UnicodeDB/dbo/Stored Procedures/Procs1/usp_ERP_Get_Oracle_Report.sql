-- ==================================================================
-- Author : Surya Narayan Chakraborty.
-- Created on : 10/09/2025
-- ==================================================================

CREATE PROCEDURE [dbo].[usp_ERP_Get_Oracle_Report]  
@ID INT = NULL  
AS  
BEGIN  
SET NOCOUNT ON;  
  
SELECT   
      ID,  
      FORMAT(Start_Date, 'MMM d yyyy') + ' - ' + FORMAT(End_Date, 'MMM d yyyy') AS Date,  
   Start_Date as MonthStartDate,  
   End_Date as MonthEnddate,  
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
ORDER BY ID ASC;  
  
END