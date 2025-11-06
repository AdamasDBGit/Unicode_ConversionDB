CREATE PROCEDURE [ECOMMERCE].[uspGetSyllabusForPlanProduct]
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

	--IF(@ProductID>0)
	--BEGIN

	--	insert into #Course
	--	select CourseID,ProductID from ECOMMERCE.T_Product_Master where ProductID=@ProductID and StatusID=1


	--END
	--ELSE
	--BEGIN

		insert into #Course
		select DISTINCT A.CourseID,A.ProductID 
		from 
		ECOMMERCE.T_Product_Master A
		inner join ECOMMERCE.T_Plan_Product_Map B on A.ProductID=B.ProductID
		inner join ECOMMERCE.T_Plan_Master C on B.PlanID=C.PlanID
		where
		A.StatusID=1 and B.StatusID=1 and c.StatusID=1 and B.PlanID=ISNULL(@PlanID,C.PlanID)
		and A.ProductID=@ProductID


	--END


	select A.*,B.ProductID from ECOMMERCE.T_Syllabus A
	inner join #Course B on A.CourseID=B.CourseID
	where A.StatusID=1 and  -- added by soma for Syllabus Status checking
	CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
	order by SyllabusID



	select * from ECOMMERCE.T_Syllabus_Subject
	where
	SyllabusID in
	(
		select SyllabusID from ECOMMERCE.T_Syllabus
		where
		CourseID in
		(
			select CourseID from #Course
		)
		and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
	)
	and StatusID=1
	order by SyllabusID,SubjectID



	select * from ECOMMERCE.T_Syllabus_Chapter
	where
	SubjectID in
	(
		select SubjectID from ECOMMERCE.T_Syllabus_Subject
		where
		SyllabusID in
		(
			select SyllabusID from ECOMMERCE.T_Syllabus
			where
			CourseID in
			(
				select CourseID from #Course
			)
			and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
		)
		and StatusID=1
	)
	and StatusID=1
	order by SubjectID,ChapterID



	select * from ECOMMERCE.T_Syllabus_Topic
	where
	ChapterID in
	(
		select ChapterID from ECOMMERCE.T_Syllabus_Chapter
		where
		SubjectID in
		(
			select SubjectID from ECOMMERCE.T_Syllabus_Subject
			where
			SyllabusID in
			(
				select SyllabusID from ECOMMERCE.T_Syllabus
				where
				CourseID in
				(
					select CourseID from #Course
				)
				and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
			)
			and StatusID=1
		)
		and StatusID=1
	)
	and StatusID=1
	order by ChapterID,TopicID


END
