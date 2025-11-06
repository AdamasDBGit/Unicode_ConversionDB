CREATE PROCEDURE [LMS].[uspManualUpdateBatchII]
(
@BatchID INT,
@OfflineTimeSlot VARCHAR(MAX)='',
@OnlineTimeSlot VARCHAR(MAX)=''
)
AS
BEGIN

	DECLARE @availability VARCHAR(MAX)=''
	DECLARE @i INT=1
	DECLARE @c INT=0

	create table #temp
	(
	Val VARCHAR(MAX)
	)

	create table #final
	(
	ID INT IDENTITY(1,1),
	Val VARCHAR(MAX)
	)


	

		

		IF(@OfflineTimeSlot!='' and @OfflineTimeSlot is not null)
		BEGIN

			SET @availability=''
			SET @i=1
			SET @c=0


			TRUNCATE TABLE #temp
			TRUNCATE TABLE #final

			insert into #temp
			select Val from fnString2Rows(@OfflineTimeSlot,',')

			insert into #final
			select DISTINCT Val from #temp

			SELECT @c=COUNT(*) FROM #final

			WHILE(@i<=@c)
			BEGIN

				SELECT @availability=@availability+Val+',' FROM #final where ID=@i

				SET @i=@i+1

			END

			--select SUBSTRING(@availability,1,LEN(@availability)-1) as OfflineTimeSlot

			update T_Center_Batch_Details set S_OfflineClassTime=SUBSTRING(@availability,1,LEN(@availability)-1) where I_Batch_ID=@BatchID

		END

		IF(@OnlineTimeSlot!='' and @OnlineTimeSlot is not null)
		BEGIN

			SET @availability=''
			SET @i=1
			SET @c=0


			TRUNCATE TABLE #temp
			TRUNCATE TABLE #final

			insert into #temp
			select Val from fnString2Rows(@OnlineTimeSlot,',')

			insert into #final
			select DISTINCT Val from #temp

			SELECT @c=COUNT(*) FROM #final

			WHILE(@i<=@c)
			BEGIN

				SELECT @availability=@availability+Val+',' FROM #final where ID=@i

				SET @i=@i+1

			END

			--select SUBSTRING(@availability,1,LEN(@availability)-1) as OnlineTimeSlot

			update T_Center_Batch_Details set S_OnlineClassTime=SUBSTRING(@availability,1,LEN(@availability)-1) where I_Batch_ID=@BatchID

		END

	EXEC LMS.uspInsertBatchDetailsForInterface @BatchID,'UPDATE'

	drop table #temp
	drop table #final

END


--ALTER TABLE T_Employee_Dtls
--ADD S_CenterAvailability NVARCHAR(MAX)


--EXEC LMS.uspManualTeacherUpdate 'subhro.sahu@riceindia.org','','','14:00T15:15,15:15T16:30,15:20T16:35,16:40T17:55,09:30T11:00,11:10T12:40,13:15T14:45,14:55T16:25,16:35T18:05,18:15T19:45,09:00T10:00,17:30T18:30'
