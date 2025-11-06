CREATE PROCEDURE [SelfService].[uspGetStudentType](@BrandID INT, @StudentID VARCHAR(MAX))
AS
BEGIN

	IF EXISTS(
			  select * from T_Student_Detail A
			  inner join T_Student_Center_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID
			  inner join T_Center_Hierarchy_Name_Details C on B.I_Centre_Id=C.I_Center_ID
			  inner join T_Student_Batch_Details D on A.I_Student_Detail_ID=D.I_Student_ID
			  where A.S_Student_ID=@StudentID and B.I_Status=1 and C.I_Brand_ID=@BrandID and D.I_Status=3
			)
	BEGIN

		SELECT 'Re-Admission'

	END
	ELSE
	BEGIN

		SELECT 'Due'

	END


END
