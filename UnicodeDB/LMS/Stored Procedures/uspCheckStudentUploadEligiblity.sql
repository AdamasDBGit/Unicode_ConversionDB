CREATE PROCEDURE [LMS].[uspCheckStudentUploadEligiblity](@courseid INT)
AS
begin


	DECLARE @coursecategory VARCHAR(MAX)='Pro,Classic,'
	DECLARE @courseids VARCHAR(MAX)=''

	IF EXISTS
	(
		select * from T_Course_Master where 
		(
			S_Course_Category in (select Val from fnString2Rows(@coursecategory,','))
			OR
			I_Course_ID IN (select CAST(Val AS INT) from fnString2Rows(@courseids,','))
		)
		and I_Course_ID=@courseid
	)
	BEGIN

		SELECT 1

	END
	ELSE
	BEGIN

		SELECT 0

	END



end
