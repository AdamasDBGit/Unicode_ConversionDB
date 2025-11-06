CREATE PROCEDURE [ECOMMERCE].[uspGetScheduleForPlanProduct]
(
	@PlanID INT=0,
	@ProductID INT
)
AS
BEGIN

	CREATE TABLE #Course
	(
		CourseID INT,
		ProductID INT
	)

	IF(@PlanID=0)
		set @PlanID=NULL

	insert into #Course
	select DISTINCT A.CourseID,A.ProductID 
	from 
	ECOMMERCE.T_Product_Master A
	inner join ECOMMERCE.T_Plan_Product_Map B on A.ProductID=B.ProductID
	inner join ECOMMERCE.T_Plan_Master C on B.PlanID=C.PlanID
	where
	A.StatusID=1 and B.StatusID=1 and B.PlanID=ISNULL(@PlanID,C.PlanID)
	and A.ProductID=@ProductID


	select A.*,B.ProductID from ECOMMERCE.T_Schedule A
	inner join #Course B on A.CourseID=B.CourseID
	where
	CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
	order by ScheduleID


	select * from ECOMMERCE.T_Schedule_SM
	where
	ScheduleID in
	(
		select ScheduleID from ECOMMERCE.T_Schedule
		where
		CourseID in
		(
			select CourseID from #Course
		)
		and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
		and StatusID=1
	)



	select * from ECOMMERCE.T_Schedule_Subject
	where
	SMID in
	(
		select SMID from ECOMMERCE.T_Schedule_SM
		where
		ScheduleID in
		(
			select ScheduleID from ECOMMERCE.T_Schedule
			where
			CourseID in
			(
				select CourseID from #Course
			)
			and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
			and StatusID=1
		)
	)
	and StatusID=1
	order by SMID,SubjectID



	--select * from ECOMMERCE.T_Schedule_Chapter
	--where
	--SubjectID in
	--(
	--	select SubjectID from ECOMMERCE.T_Schedule_Subject
	--	where
	--	SMID in
	--	(
	--		select SMID from ECOMMERCE.T_Schedule_SM
	--		where
	--		ScheduleID in
	--		(
	--			select ScheduleID from ECOMMERCE.T_Schedule
	--			where
	--			CourseID in
	--			(
	--				select CourseID from #Course
	--			)
	--			and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
	--			and StatusID=1
	--		)
	--	)
	--	and StatusID=1
	--)
	--and StatusID=1
	--order by SubjectID,ChapterID



	select * from ECOMMERCE.T_Schedule_Topic
	where
	SubjectID in
	(
		select SubjectID from ECOMMERCE.T_Schedule_Subject
		where
		SMID in
		(
			select SMID from ECOMMERCE.T_Schedule_SM
			where
			ScheduleID in
			(
				select ScheduleID from ECOMMERCE.T_Schedule
				where
				CourseID in
				(
					select CourseID from #Course
				)
				and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
				and StatusID=1
			)
		)
		and StatusID=1
	)
	and StatusID=1
	order by ChapterID,TopicID



	select * from ECOMMERCE.T_Schedule_TopicBreakup
	where
	TopicID in
	(
		select TopicID from ECOMMERCE.T_Schedule_Topic
		where
		SubjectID in
		(
			select SubjectID from ECOMMERCE.T_Schedule_Subject
			where
			SMID in
			(
				select SMID from ECOMMERCE.T_Schedule_SM
				where
				ScheduleID in
				(
					select ScheduleID from ECOMMERCE.T_Schedule
					where
					CourseID in
					(
						select CourseID from #Course
					)
					and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
					and StatusID=1
				)
			)
			and StatusID=1
		)
		and StatusID=1
	)
	and StatusID=1
	order by TopicID,TopicBreakupID



	select A.ProductID,A.ConfigID,ISNULL(A.ConfigDisplayName,C.ConfigName) as ConfigName,ISNULL(A.ConfigValue,C.ConfigDefaultValue) as ConfigValue 
	from ECOMMERCE.T_Product_Config A
	inner join #Course B on A.ProductID=B.ProductID and A.StatusID=1
	inner join ECOMMERCE.T_Cofiguration_Property_Master C on A.ConfigID=C.ConfigID and C.StatusID=1
	where
	C.ConfigCode='TE'

	
	select B.ProductID, A.ExamCategoryID,C.ExamCategoryDesc
	from ECOMMERCE.T_Product_ExamCategory_Map A
	inner join #Course B on A.ProductID=B.ProductID
	inner join ECOMMERCE.T_ExamCategory_Master C on A.ExamCategoryID=C.ExamCategoryID
	where
	A.StatusID=1



END
