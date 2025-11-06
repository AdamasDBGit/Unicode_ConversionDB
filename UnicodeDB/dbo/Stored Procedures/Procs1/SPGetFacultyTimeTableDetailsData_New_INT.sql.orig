-- =============================================

-- =============================================
--SPGetFacultyTimeTableDetailsData_New null,354064,'2015/08/01'
CREATE  PROCEDURE [dbo].[SPGetFacultyTimeTableDetailsData_New_INT]
(
	@UpdateON			         Varchar(20) =NULL,
	@MaxID				         INT		 =NULL,
	@RecordFetchStartDate        nvarchar(10) =null
)
AS
BEGIN
	DECLARE @VarDate	DATE;

	IF @UpdateON='' OR @UpdateON IS NULL
	BEGIN
		SET @VarDate=NULL
	END
	ELSE
	BEGIN
		SET @VarDate=CAST(@UpdateON AS DATE)
	END


	IF @RecordFetchStartDate ='' OR @RecordFetchStartDate IS NULL
	BEGIN
	 SET  @RecordFetchStartDate=null
	END
	ELSE
	 BEGIN
	  SET @RecordFetchStartDate=CAST(@RecordFetchStartDate AS DATE)
	 END



	IF @MaxID<>0  AND @VarDate IS NULL
	BEGIN

	PRINT('A')
		SELECT 
		TFM.[I_TimeTable_ID],
		TFM.[I_Employee_ID],
		TFM.[B_Is_Actual]
		
		FROM
		[dbo].[T_TimeTable_Faculty_Map] TFM
		INNER JOIN  [dbo].[T_TimeTable_Master] T ON TFM.I_TimeTable_ID=T.I_TimeTable_ID
		WHERE
		T.[I_TimeTable_ID]<=@MaxID
		AND CAST(T.Dt_Crtd_On AS DATE)>=@RecordFetchStartDate
		AND T.[I_Batch_ID] IS NOT NULL
	END
	ELSE IF @MaxID<>0 AND @VarDate IS NOT NULL
	BEGIN

	PRINT('B')
		SELECT DISTINCT
		[I_TimeTable_ID],						
		[I_Employee_ID],	
		[B_Is_Actual]						
		 
		 
		FROM
		(
			SELECT 
			TFM.[I_TimeTable_ID] AS I_TimeTable_ID,
			TFM.[I_Employee_ID] AS I_Employee_ID,
			TFM.[B_Is_Actual] AS B_Is_Actual
		
			FROM
			[dbo].[T_TimeTable_Faculty_Map] TFM
			INNER JOIN  [dbo].[T_TimeTable_Master] T ON TFM.I_TimeTable_ID=T.I_TimeTable_ID

			WHERE CAST(T.[Dt_Updt_On] AS DATE)<=@VarDate
			AND CAST(T.Dt_Crtd_On AS DATE)>=@RecordFetchStartDate
	     	AND T.[I_Batch_ID] IS NOT NULL
		UNION
	
	
			SELECT 
			TFM.[I_TimeTable_ID] AS I_TimeTable_ID,
			TFM.[I_Employee_ID] AS I_Employee_ID,
			TFM.[B_Is_Actual] AS B_Is_Actual
		
			FROM
			[dbo].[T_TimeTable_Faculty_Map] TFM
			INNER JOIN  [dbo].[T_TimeTable_Master] T ON TFM.I_TimeTable_ID=T.I_TimeTable_ID
	
		WHERE
		T.[I_TimeTable_ID]<=@MaxID
		AND CAST(Dt_Crtd_On AS DATE)>=@RecordFetchStartDate
		AND [I_Batch_ID] IS NOT NULL
		)AS A


	END
	
	
END
