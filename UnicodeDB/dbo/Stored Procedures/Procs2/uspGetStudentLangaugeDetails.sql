
CREATE PROCEDURE [dbo].[uspGetStudentLangaugeDetails]  
	(
      @sStudentDetailID INT    
    )
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @LangaugeID INT

	if exists(select * from T_Student_Tags where I_Student_Detail_ID=@sStudentDetailID)
		BEGIN

			select @LangaugeID=I_Language_ID from T_Student_Tags where I_Student_Detail_ID=@sStudentDetailID

		END
	else

	  BEGIN
	   SET @LangaugeID=0
	  END

	SELECT @LangaugeID as I_Language_ID

    
END
