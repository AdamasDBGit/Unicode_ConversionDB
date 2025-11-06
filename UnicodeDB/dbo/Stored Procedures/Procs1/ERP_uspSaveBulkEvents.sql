-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ERP_uspSaveBulkEvents]
	-- Add the parameters for the stored procedure here
	(
		@BulkEvents UT_Bulk_Events readonly
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @EventID INT

	CREATE TABLE #TempEvent
	(
 		[I_Brand_ID]INT NOT NULL, --
		[I_Event_Category_ID]INT NOT NULL, --
		[S_Event_Name] VARCHAR(500) NOT NULL, --
		[Dt_StartDate]DATE NOT NULL, --
		[Dt_EndDate]DATE NOT NULL, --
		[I_Status]INT NOT NULL, --
		[I_School_Group_ID]INT NOT NULL, --
		[I_Class_ID]INT NOT NULL,
		ID INT IDENTITY(1,1)
	)
		
		INSERT INTO #TempEvent
		(
			[I_Brand_ID], --
			[I_Event_Category_ID], --
			[S_Event_Name] , --
			[Dt_StartDate], --
			[Dt_EndDate], --
			[I_Status], --
			[I_School_Group_ID], --
			[I_Class_ID]
		)
		SELECT 
			[I_Brand_ID], --
			[I_Event_Category_ID], --
			[S_Event_Name], --
			[Dt_StartDate], --
			[Dt_EndDate], --
			[I_Status], --
			[I_School_Group_ID], --
			[I_Class_ID]
		FROM @BulkEvents

		DECLARE @lst int,
		@ID int=1
		SET @lst = (select max (ID) from #TempEvent)
			WHILE @ID <= @lst
			BEGIN 

			IF EXISTS (
                SELECT 1
                FROM T_Event e
                INNER JOIN #TempEvent b ON e.I_Brand_ID = b.I_Brand_ID
                    AND e.I_Event_Category_ID = b.I_Event_Category_ID
                    AND e.S_Event_Name = b.S_Event_Name
                    AND e.Dt_StartDate = b.Dt_StartDate
                    AND e.Dt_EndDate = b.Dt_EndDate
                    AND e.I_Status = b.I_Status
					WHERE b.ID = @ID
            )
			BEGIN
				SET @EventID = (SELECT DISTINCT TOP 1 e.I_Event_ID FROM T_Event e
								INNER JOIN #TempEvent b ON e.I_Brand_ID = b.I_Brand_ID
                    AND e.I_Event_Category_ID = b.I_Event_Category_ID
                    AND e.S_Event_Name = b.S_Event_Name
                    AND e.Dt_StartDate = b.Dt_StartDate
                    AND e.Dt_EndDate = b.Dt_EndDate
                    AND e.I_Status = b.I_Status
					WHERE b.ID = @ID
					)
			END
			ELSE
     --       IF NOT EXISTS (
     --           SELECT 1
     --           FROM T_Event e
     --           INNER JOIN #TempEvent b ON e.I_Brand_ID = b.I_Brand_ID
     --               AND e.I_Event_Category_ID = b.I_Event_Category_ID
     --               AND e.S_Event_Name = b.S_Event_Name
     --               AND e.Dt_StartDate = b.Dt_StartDate
     --               AND e.Dt_EndDate = b.Dt_EndDate
     --               AND e.I_Status = b.I_Status
					--WHERE b.ID = @ID
     --       )
		BEGIN
            -- Data does not exist in T_Event, insert into T_Event
            INSERT INTO T_Event (
                I_Brand_ID,
                I_Event_Category_ID,
                S_Event_Name,
                Dt_StartDate,
                Dt_EndDate,
                I_Status
            )
            SELECT
                I_Brand_ID,
                I_Event_Category_ID,
                S_Event_Name,
                Dt_StartDate,
                Dt_EndDate,
                I_Status
            FROM #TempEvent 
			WHERE ID = @ID;

			SET @EventID = SCOPE_IDENTITY()
        END
		--DECLARE @EventID INT
		--SET @EventID = SCOPE_IDENTITY()

		-- Insert data into T_Event_Class table
        INSERT INTO T_Event_Class (
			I_Event_ID,
            I_School_Group_ID,
            I_Class_ID
        )
        SELECT
			@EventID,
            I_School_Group_ID,
            I_Class_ID
        FROM #TempEvent
		WHERE ID = @ID;
		Set @ID = @ID + 1

	END

	
END
