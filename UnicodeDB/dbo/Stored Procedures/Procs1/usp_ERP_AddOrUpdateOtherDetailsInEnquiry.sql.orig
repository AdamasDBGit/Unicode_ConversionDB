-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddOrUpdateOtherDetailsInEnquiry]
(
	@iEnquiryRegnID int = null,
	@iEnquiryTypeID int = null,
	@iSchoolGroupID int = null,
	@iCourseAppliedFor int = null,

	@iIsPrevAcademy bit = null,
	@sPrevSchoolName varchar(100) = null,
	@sPrevSchoolAddress varchar(255) = null,
	@sPrevBoard varchar(100) = null,
	@iPrevClassID int = null,
	@iIsMarksInput bit = null,
	@sPrevGrade char(3) = null,
	@dPrevTotalMarks numeric(6,2) = null,
	@dPrevObtainedMarks numeric(6,2) = null,
	@dPrevPercentage numeric(4,2) = null,



	@iIsSibling bit = null,
	@sSiblingStudentID varchar(100) = null,
	@sSiblingStudentName varchar(100) = null,
	@iSiblingIsRunningStudent bit = null,
	@sSiblingPassoutYear varchar(12) = null,

	@iEnquiryStatusCode int = NULL,
	@iApplicationPaymentStatus bit = null,
	@iUpdatedBy int = null
)
AS
begin transaction
BEGIN
	BEGIN TRY	
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Insert statements for procedure here
		UPDATE [dbo].[T_ERP_Enquiry_Regn_Detail]
		SET	
			I_Enquiry_Type_ID = @iEnquiryTypeID,
			I_School_Group_ID = @iSchoolGroupID,
			I_Course_Applied_For = @iCourseAppliedFor,
			Is_Prev_Academy = @iIsPrevAcademy,
			Is_Sibling = @iIsSibling,
			I_Enquiry_Status_Code = @iEnquiryStatusCode,
			App_Payment_Status = @iApplicationPaymentStatus
		WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID


		IF EXISTS (SELECT R_I_Enquiry_Regn_ID FROM T_ERP_EnquiryReg_Prev_Details WHERE R_I_Enquiry_Regn_ID = @iEnquiryRegnID)
		BEGIN
			UPDATE [dbo].[T_ERP_EnquiryReg_Prev_Details]
			SET	
				R_I_Prev_Class_ID = @iPrevClassID,
				Is_Marks_Input = @iIsMarksInput,
				N_TotalMarks = @dPrevTotalMarks,
				N_Obtain_Marks = @dPrevObtainedMarks,
				S_Grade = @sPrevGrade,
				N_Percentage = @dPrevPercentage,
				S_School_Name = @sPrevSchoolName,
				S_School_Board = @sPrevBoard,
				S_Address = @sPrevSchoolAddress,
				I_Modified_By = @iUpdatedBy,
				Dtt_Modified_At = GETDATE()
			WHERE R_I_Enquiry_Regn_ID = @iEnquiryRegnID
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[T_ERP_EnquiryReg_Prev_Details]
			(
				R_I_Prev_Class_ID,
				R_I_Enquiry_Regn_ID,
				Is_Marks_Input,
				N_TotalMarks,
				N_Obtain_Marks,
				S_Grade,
				N_Percentage,
				S_School_Name,
				S_School_Board,
				S_Address,
				I_Created_By
			)
			VALUES
			(
				 @iPrevClassID,
				 @iEnquiryRegnID,
				 @iIsMarksInput,
				 @dPrevTotalMarks,
				 @dPrevObtainedMarks,
				 @sPrevGrade,
				 @dPrevPercentage,
				 @sPrevSchoolName,
				 @sPrevBoard,
				 @sPrevSchoolAddress,
				 @iUpdatedBy
			);
		END



		IF EXISTS (SELECT R_I_Enquiry_Regn_ID FROM T_ERP_PreEnq_Siblings WHERE R_I_Enquiry_Regn_ID = @iEnquiryRegnID)
		BEGIN
			UPDATE [dbo].[T_ERP_PreEnq_Siblings]
			SET	
				S_StudentID = @sSiblingStudentID,
				S_Stud_Name = @sSiblingStudentName,
				Is_Running_Stud = @iSiblingIsRunningStudent,
				S_Passout_Year = @sSiblingPassoutYear,
				I_Modified_By = @iUpdatedBy,
				Dtt_Modified_At = GETDATE()
			WHERE R_I_Enquiry_Regn_ID = @iEnquiryRegnID
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[T_ERP_PreEnq_Siblings]
			(
				R_I_Enquiry_Regn_ID,
				S_StudentID,
				S_Stud_Name,
				Is_Running_Stud,
				S_Passout_Year,
				I_Created_By
			)
			VALUES
			(
				 @iEnquiryRegnID,
				 @sSiblingStudentID,
				 @sSiblingStudentName,
				 @iSiblingIsRunningStudent,
				 @sSiblingPassoutYear,
				 @iUpdatedBy
			);
		END


		select 1 StatusFlag,'Details saved succesfully' Message

	END TRY
	BEGIN CATCH
		rollback transaction
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		select 0 StatusFlag,@ErrMsg Message
	END CATCH
commit transaction
END
