/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/06/2007
-- Description: This procedure update Complaint Record in T_Complaint_Request_Detail 
--		and make a histroy entry in T_Complaint_Audit_Trail table
-- Parameter : @I_Complaint_Req_ID,
--		@I_Root_Cause_ID,
--		@I_Center_ID,
--		@I_Course_ID,
--		@I_Status_ID,
--		@I_Complaint_Category_ID,
--		@I_Student_Detail_ID,
--		@Dt_Complaint_Date,
--		@S_Complaint_Details,
--		@I_Document_ID,
---		@I_User_ID,
--		@I_User_Hierarchy_detail_ID,
--		@I_Complaint_Mode_ID,
--		@S_Crtd_By,
--		@S_Contact_Number,
--		@S_Upd_By,
--		@S_Email_ID,
--		@I_Current_Escalation_level,
--		@Dt_Crtd_On,
--		@Dt_Upd_On,
--		@S_Remarks
-- 	
-- =================================================================
*/

CREATE PROCEDURE [CUSTOMERCARE].[uspUpdateComplaint]
-- Input parameter
(
	@iComplaintReqID		INT,
	@iRootCauseID		INT = null,
	--@iCenterID			INT,
	@iCourseID			INT = null,
	@iStatusID			INT = null,
	@iComplaintCategoryID	INT = null,
	@sStudentID		VARCHAR(500) = null,
	@sComplaintDetails		VARCHAR(2000) = null,
	@iDocumentID			INT =null,
	@iUserID			INT =null,	
	@iUserHierarchyDetailID	INT = null,
	@iComplaintModeID		INT = null,
	@sContactNumber		VARCHAR(20)= null,
	@sUpdBy			VARCHAR(20) = null,
	@sEmailID			VARCHAR(50) = null,
	@iCurrentEscalationLevel	INT = null,
	@dtUpdOn			DATETIME,
	@sRemarks			VARCHAR(2000) = null
	
)
AS
BEGIN TRY
DECLARE @iStudentDetailID		INT 
DECLARE	@S_Name				VARCHAR(50)
DECLARE	@S_Address			VARCHAR(100)
--SET @iStudentDetailID = 0	

IF (@sStudentID IS NOT NULL)
	BEGIN
		-- Check Student S_Student_ID  present  or not
			IF EXISTS (SELECT I_Student_Detail_ID FROM T_Student_Detail WHERE S_Student_ID = @sStudentID)
				BEGIN
				-- set student id
				SET @iStudentDetailID =(SELECT I_Student_Detail_ID FROM T_Student_Detail WHERE S_Student_ID = @sStudentID)
				END
	END
DECLARE @iComplaintHistoryID INT
SET @iComplaintHistoryID = 0 
	BEGIN TRANSACTION TrnsAddComplaintAuditTrail
		UPDATE    [CUSTOMERCARE].T_Complaint_Request_Detail
			SET	I_Root_Cause_ID =COALESCE(@iRootCauseID,I_Root_Cause_ID), 
				I_Course_ID =COALESCE(@iCourseID,I_Course_ID), 
				I_Status_ID =COALESCE(@iStatusID,I_Status_ID), 
				I_Complaint_Category_ID =COALESCE(@iComplaintCategoryID,I_Complaint_Category_ID), 
				S_Complaint_Details =COALESCE(@sComplaintDetails,S_Complaint_Details), 
				I_Document_ID =COALESCE(@iDocumentID,I_Document_ID), 
				I_User_ID =COALESCE(@iUserID,I_User_ID), 				
				I_User_Hierarchy_detail_ID =COALESCE(@iUserHierarchyDetailID,I_User_Hierarchy_detail_ID), 
				I_Complaint_Mode_ID =COALESCE(@iComplaintModeID,I_Complaint_Mode_ID), 
				S_Contact_Number =COALESCE(@sContactNumber,S_Contact_Number), 
				S_Upd_By =COALESCE(@sUpdBy,S_Upd_By), 
				S_Email_ID =COALESCE(@sEmailID,S_Email_ID), 
				I_Current_Escalation_level =COALESCE(@iCurrentEscalationLevel,I_Current_Escalation_level), 
				Dt_Upd_On =COALESCE(@dtUpdOn,Dt_Upd_On), 
				S_Remarks =COALESCE(@sRemarks,S_Remarks)
		WHERE  I_Complaint_Req_ID =@iComplaintReqID;
		
		INSERT INTO [CUSTOMERCARE].T_Complaint_Audit_Trail
			(
			I_Complaint_Req_ID, 
			I_Center_ID, 
			I_Course_ID, 
			I_Status_ID, 
			I_Complaint_Category_ID, 
			I_Student_Detail_ID, 
			Dt_Complaint_Date, 
			S_Complaint_Details, 
			I_Document_ID, 
			I_User_ID, 
			S_Complaint_Code, 
			I_User_Hierarchy_detail_ID, 
			I_Complaint_Mode_ID, 
			S_Crtd_By, 
			S_Contact_Number, 
			S_Upd_By, 
			S_Email_ID, 
			I_Current_Escalation_level, 
			Dt_Crtd_On, 
			Dt_Upd_On, 
			S_Remarks,
			I_Root_Cause_ID,
			S_Name,		
			S_Address	
			) (
			SELECT I_Complaint_Req_ID, 
			I_Center_ID, 
			I_Course_ID, 
			I_Status_ID, 
			I_Complaint_Category_ID, 
			I_Student_Detail_ID, 
			Dt_Complaint_Date, 
			S_Complaint_Details, 
			I_Document_ID, 
			I_User_ID, 
			S_Complaint_Code, 
			I_User_Hierarchy_detail_ID, 
			I_Complaint_Mode_ID, 
			S_Crtd_By, 
			S_Contact_Number, 
			S_Upd_By, 
			S_Email_ID, 
			I_Current_Escalation_level, 
			Dt_Crtd_On, 
			Dt_Upd_On, 
			S_Remarks,
			I_Root_Cause_ID,
			S_Name,		
			S_Address				
			FROM [CUSTOMERCARE].T_Complaint_Request_Detail
			WHERE  I_Complaint_Req_ID =@iComplaintReqID)
			
		COMMIT TRANSACTION TrnsAddComplaintAuditTrail
END TRY
BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
	ROLLBACK TRANSACTION TrnsAddComplaintAuditTrail
END CATCH
