CREATE PROCEDURE [LMS].[uspGetStudentDetailsForSync]
(
	@StudentID VARCHAR(MAX)=NULL,
	@BatchCode VARCHAR(MAX)=NULL
)
AS
BEGIN


	DECLARE @StudentDetailID INT=0


	if(@StudentID IS NULL and @BatchCode IS NULL)
	BEGIN

	select * from T_Student_Detail where S_Student_ID like '%RICE%'

	select DISTINCT A.I_Student_ID,B.* from T_Student_Batch_Details A
	inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
	inner join T_Student_Detail C on A.I_Student_ID=C.I_Student_Detail_ID
	where
	A.I_Status=1 and C.S_Student_ID like '%RICE%'


	END


	if(@StudentID IS NOT NULL)
	BEGIN

	select @StudentDetailID=I_Student_Detail_ID from T_Student_Detail where S_Student_ID=@StudentID


	select * from T_Student_Detail where I_Student_Detail_ID=@StudentDetailID

	select DISTINCT A.I_Student_ID,B.* from T_Student_Batch_Details A
	inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
	where
	A.I_Status=1 and A.I_Student_ID=@StudentDetailID

	END

	IF(@BatchCode IS NOT NULL)
	BEGIN

	select C.* 
	from 
	T_Student_Batch_Details A
	inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
	inner join T_Student_Detail C on A.I_Student_ID=C.I_Student_Detail_ID
	where
	A.I_Status=1 and B.S_Batch_Code=@BatchCode

	select DISTINCT A.I_Student_ID,B.* from T_Student_Batch_Details A
	inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
	where
	A.I_Status=1 and B.S_Batch_Code=@BatchCode

	END

END
