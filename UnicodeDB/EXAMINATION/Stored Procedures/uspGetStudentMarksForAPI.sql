CREATE PROCEDURE [EXAMINATION].[uspGetStudentMarksForAPI](@BrandID INT, @CentreID INT, @CourseID INT, @StudentDetailID INT, @TermID INT=NULL)
AS
BEGIN

--EXEC EXAMINATION.uspGetStudentMarksForAPI @BrandID = 107,@CentreID = 1,@BatchID = 9677, @StudentDetailID=44354-- int

if(@BrandID=107)
begin

	exec EXAMINATION.uspGetAISStudentMarksForAPI @BrandID,@CentreID,@CourseID,@StudentDetailID,@TermID

end
else if (@BrandID=110)
begin

	exec EXAMINATION.uspGetAWSStudentMarksForAPI @BrandID,@CentreID,@CourseID,@StudentDetailID,@TermID

end





END
