CREATE PROCEDURE [dbo].[uspInsertMSTeamStudentDetails]
(
@StudentID NVARCHAR(max),
@EmailID NVARCHAR(max)
)
AS
BEGIN

	IF NOT EXISTS(SELECT * FROM dbo.T_MSTeam_Student_Details AS TMTSD WHERE TMTSD.S_Student_ID=@StudentID)
	BEGIN

		INSERT INTO dbo.T_MSTeam_Student_Details
		(
		    S_Student_ID,
		    S_MS_Email_ID
		)
		VALUES
		(   @StudentID, -- S_Student_ID - nvarchar(max)
		    @EmailID  -- S_MS_Email_ID - nvarchar(max)
		    )

	END
	ELSE
	BEGIN

		UPDATE dbo.T_MSTeam_Student_Details SET S_MS_Email_ID=@EmailID WHERE S_Student_ID=@StudentID

	END


END


