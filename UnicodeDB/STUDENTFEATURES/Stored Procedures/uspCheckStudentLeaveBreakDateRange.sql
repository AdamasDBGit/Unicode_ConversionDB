CREATE PROCEDURE [STUDENTFEATURES].[uspCheckStudentLeaveBreakDateRange]
(
	@iStudentDetailID INT,
	@dFromDate DATETIME,
	@dToDate DATETIME
)
AS
BEGIN

	CREATE TABLE #tblLeaveBreak
	(
		TYPE VARCHAR(20),
		StartDate DATETIME,
		EndDate DATETIME
	)

	DECLARE @dFromDateTable DATETIME
	DECLARE @dToDateTable DATETIME
	DECLARE @TYPE VARCHAR(200)

	SET @dFromDate=CAST(CAST(@dFromDate AS VARCHAR(11)) AS DATETIME)
	SET @dToDate=CAST(CAST(@dToDate AS VARCHAR(11)) AS DATETIME)

	DECLARE _CURSOR CURSOR FOR
	SELECT 
	[S_Leave_Type] AS TYPE ,
	[Dt_From_Date] AS StartDate,
	[Dt_To_Date] AS EndDate 
	FROM 
	[T_Student_Leave_Request] 
	WHERE 
	[I_Student_Detail_ID]=@iStudentDetailID
	AND [I_Status]=1

		OPEN _CURSOR
		FETCH NEXT FROM _CURSOR INTO @TYPE,@dFromDateTable,@dToDateTable

		WHILE @@FETCH_STATUS = 0
		BEGIN

			IF (@dFromDate BETWEEN @dFromDateTable AND @dToDateTable)
			BEGIN
				INSERT INTO #tblLeaveBreak
				SELECT @TYPE AS TYPE,@dFromDateTable AS StartDate,@dToDateTable AS EndDate
				BREAK;
			END

			IF (@dToDate BETWEEN @dFromDateTable AND @dToDateTable)
			BEGIN
				INSERT INTO #tblLeaveBreak
				SELECT @TYPE AS TYPE,@dFromDateTable AS StartDate,@dToDateTable AS EndDate
				BREAK;
			END

			IF (@dFromDate>=@dFromDateTable AND @dToDate<=@dToDateTable)
			BEGIN
				INSERT INTO #tblLeaveBreak
				SELECT @TYPE AS TYPE,@dFromDateTable AS StartDate,@dToDateTable AS EndDate
				BREAK;
			END

			IF (@dFromDate<=@dFromDateTable AND @dToDate>=@dToDateTable)
			BEGIN
				INSERT INTO #tblLeaveBreak
				SELECT @TYPE AS TYPE,@dFromDateTable AS StartDate,@dToDateTable AS EndDate
				BREAK;
			END
			
			FETCH NEXT FROM _CURSOR INTO @TYPE,@dFromDateTable,@dToDateTable
		END	
	
	CLOSE _CURSOR
	DEALLOCATE _CURSOR

	SELECT * FROM #tblLeaveBreak
	
	DROP TABLE #tblLeaveBreak

END
