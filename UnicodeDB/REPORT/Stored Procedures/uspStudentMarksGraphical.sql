
--EXEC REPORT.uspStudentMarksGraphical @iBatchID = 783, @iStudentID = 4695,@iTermID =NULL
--EXEC REPORT.uspStudentMarksGraphical @iBatchID = 783, @iStudentID = 4695,@iTermID =12
--EXEC REPORT.uspStudentMarksGraphical @iBatchID = 1656, @iStudentID = 26115,@iTermID =NULL
--EXEC REPORT.uspStudentMarksGraphical @iBatchId = 1057, @iStudentId = 4399, @iTermId = 370
--EXEC REPORT.uspStudentMarksGraphical @iBatchId = 8058, @iStudentId = 6077, @iTermId = NULL, @iReportType = 2
--EXEC REPORT.uspStudentMarksGraphical @iBatchId = 8058, @iStudentId = 6077, @iTermId = 1252, @iReportType = 2

CREATE PROCEDURE [REPORT].[uspStudentMarksGraphical] 
	@iBatchID INT
	,@iStudentID INT
	,@iTermID INT = NULL
	,@bUptoTerm BIT = NULL
	,@iReportType INT = NULL
AS
BEGIN	
   IF ISNULL(@iReportType,1) = 1
	   BEGIN
			IF @iTermId IS NULL
				EXEC REPORT.uspStudentWeightageGraphicalAllTerms @iBatchID = @iBatchID, @iStudentID = @iStudentID
			ELSE IF @iTermId IS NOT NULL AND @bUptoTerm = 1
				EXEC REPORT.uspStudentWeightageGraphicalAllTerms @iBatchID = @iBatchID, @iStudentID = @iStudentID,@iTermID = @iTermID
			ELSE
				EXEC REPORT.uspStudentWeightageGraphicalForTerm @iBatchID = @iBatchID, @iStudentID = @iStudentID, @iTermID = @iTermID
		END
	ELSE 
		BEGIN
			IF @iTermId IS NULL
				EXEC REPORT.uspStudentMarksGraphicalAllTerms @iBatchID = @iBatchID, @iStudentID = @iStudentID
			ELSE IF @iTermId IS NOT NULL AND @bUptoTerm = 1
				EXEC REPORT.uspStudentMarksGraphicalAllTerms @iBatchID = @iBatchID, @iStudentID = @iStudentID,@iTermID = @iTermID
			ELSE
				EXEC REPORT.uspStudentMarksGraphicalForTerm @iBatchID = @iBatchID, @iStudentID = @iStudentID, @iTermID = @iTermID

		END

END
