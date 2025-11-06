CREATE PROCEDURE [LMS].[uspSaveStudentIssue]
(
	@Issue NVARCHAR(MAX),
	@IssueCategoryID INT,
	@Name VARCHAR(MAX)='',
	@StudentID VARCHAR(MAX)='',
	@CustomerID VARCHAR(MAX)='',
	@ContactNo VARCHAR(MAX)='',
	@EmailID VARCHAR(MAX)=''
)
AS
BEGIN

	insert into LMS.T_Student_Issues
	(
		Issue,
		IssueCategoryID,
		Name,
		StudentID,
		CustomerID,
		ContactNo,
		EmailID,
		StatusID,
		CreatedOn
	)
	VALUES
	(
		@Issue,
		@IssueCategoryID,
		@Name,
		@StudentID,
		@CustomerID,
		@ContactNo,
		@EmailID,
		1,
		GETDATE()
	)

	select SCOPE_IDENTITY() as IssueID


END
