-- =============================================
-- Author:		<Santanu Maity>
-- Create date: <07-06-2007>
-- Description:	Save Student Leave Request 
-- Used for Approval or Rejection of Leave Request
-- =============================================

CREATE PROCEDURE [STUDENTFEATURES].[uspStudentLeaveRequest] 
(
	-- Add the parameters for the stored procedure here
	@iStudentLeaveID		int = null,
	@iStudentDetailID		int,
	@sLeaveType				varchar(20)=null,
	@dFromDate				datetime = null,
	@dToDate				datetime = null,	
    @sReason				varchar(500) = null,
    @sComments				varchar(500) = null,
    @iStatus				int = null,
	@sUser					Varchar(20)=null,
	@dDate					datetime
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	BEGIN TRAN T1
    -- Insert statements for procedure here
	IF @iStudentLeaveID IS NULL 
	BEGIN
		
				
				IF(SELECT COUNT(*) FROM T_Student_Leave_Request 
				WHERE (I_Student_Detail_ID=@iStudentDetailID 
				AND((@dFromDate BETWEEN Dt_From_Date AND Dt_To_Date) OR (@dToDate BETWEEN Dt_From_Date AND Dt_To_Date)) AND I_Status<>0))= 0
				BEGIN
					INSERT INTO dbo.T_Student_Leave_Request
					(	I_Student_Detail_ID, 
						S_Leave_Type, 
						Dt_From_Date, 
						Dt_To_Date,
						S_Reason,
						I_Status,
						S_Crtd_By, 
						Dt_Crtd_On)
					VALUES
					(	@iStudentDetailID, 
						@sLeaveType,
						@dFromDate,
						@dToDate,
						@sReason,
						@iStatus,
						@sUser,
						@dDate)
				END
				ELSE
				BEGIN
					RAISERROR('The student has an approved leave/break during the selected period.',11,1)
				END	
		
		
		SET @iStudentLeaveID = SCOPE_IDENTITY()

		
	END	
	ELSE
	BEGIN
		IF EXISTS(SELECT I_Student_Detail_ID from dbo.T_Student_Leave_Request where I_Student_Leave_ID = @iStudentLeaveID)
		BEGIN
			INSERT INTO dbo.T_Student_Leave_Request_Audit
				(
					I_Student_Leave_ID,
					I_Student_Detail_ID, 
					S_Leave_Type, 
					Dt_From_Date, 
					Dt_To_Date,
					S_Reason,
					S_Comments,
					I_Status,
					S_Crtd_By, 
					S_Upd_By,
					Dt_Crtd_On,
					Dt_Upd_On
				)
			Select *
			from dbo.T_Student_Leave_Request 
			where I_Student_Leave_ID = @iStudentLeaveID

			UPDATE dbo.T_Student_Leave_Request
			SET S_Comments = @sComments,
				I_Status = @iStatus,
				S_Upd_By = @sUser,
				Dt_Upd_On = @dDate
				where I_Student_Leave_ID = @iStudentLeaveID

			IF(@iStatus=1)
			BEGIN

				EXEC LMS.uspInsertStudentLeaveDetailsForInterface @iStudentDetailID,@iStudentLeaveID,@dFromDate,@dToDate,'ADD'

			END
		END
	END
	
	SELECT @iStudentLeaveID LeaveID
	COMMIT TRAN T1	
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
