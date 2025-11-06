  
  CREATE PROCEDURE dbo.usp_ERP_OracleSync_Update
    @ID INT,
    @SyncBy INT,
    @dtStartDate DATETIME = NULL,
    @dtEndDate   DATETIME = NULL
AS
BEGIN
SET NOCOUNT ON;


-- Validate input
IF @dtStartDate IS NULL OR @dtEndDate IS NULL
BEGIN
RAISERROR('Both @dtStartDate and @dtEndDate must be supplied.', 16, 1);
RETURN;
END


IF @dtStartDate > @dtEndDate
BEGIN
RAISERROR('@dtStartDate must be less than or equal to @dtEndDate.', 16, 1);
RETURN;
END


DECLARE @date DATETIME;
DECLARE @iBrandID INT = 107;


-- mark started
UPDATE dbo.Oracle_Reports
SET Is_Synced_Started = 1,
Sync_StartDate = GETDATE(),
Sync_By = @SyncBy
WHERE ID = @ID;


BEGIN TRY
SET @date = @dtStartDate;
WHILE (DATEDIFF(dd, @date, @dtEndDate) >= 0)
BEGIN
-- Call original proc exactly as before, for brand 107
EXEC ERP.uspPrepareStudentFinancialData @date, @iBrandID = @iBrandID;


SET @date = DATEADD(dd, 1, @date);
END


-- mark complete on success
UPDATE dbo.Oracle_Reports
SET Is_Sync_Complete = 1
WHERE ID = @ID;
END TRY
BEGIN CATCH
DECLARE @ErrMsg Nnvarchar(max) = ERROR_MESSAGE();
DECLARE @ErrNumber INT = ERROR_NUMBER();


-- mark failed (adjust as per your schema)
UPDATE dbo.Oracle_Reports
SET Is_Sync_Complete = 0
WHERE ID = @ID;


-- rethrow or raise detailed error
RAISERROR('Error %d: %s', 16, 1, @ErrNumber, @ErrMsg);
END CATCH
END
