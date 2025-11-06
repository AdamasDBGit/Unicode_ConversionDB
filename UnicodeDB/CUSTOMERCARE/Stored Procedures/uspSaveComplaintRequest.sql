-- =============================================
-- Author:		Shankha Roy
-- Create date: 12/06/2007
-- Description:	Inserts Complaint Request in T_Complaint_Request_details
-- =============================================
CREATE PROCEDURE [CUSTOMERCARE].[uspSaveComplaintRequest] 
(  
	@I_Center_ID				INT,
	@I_Course_ID				INT,
	@I_Status_ID				INT,
	@I_Complaint_Category_ID	INT,
	@sStudentID		VARCHAR(500),
	@Dt_Complaint_Date			DATETIME,
	@S_Complaint_Details		VARCHAR(2000),
	@I_Document_ID				INT,
	@S_Complaint_Code			VARCHAR(20),
	@I_Complaint_Mode_ID		INT,
	@S_Crtd_By					VARCHAR(20)			,
	@S_Contact_Number			VARCHAR(20)	,
	@S_Name						VARCHAR(50),
	@S_Address					VARCHAR(100),
	@S_Upd_By					VARCHAR(20)			,
	@S_Email_ID					VARCHAR(50)	,
	@Dt_Crtd_On					DATETIME,
	@Dt_Upd_On					DATETIME
			
)
AS
	BEGIN TRY      
			DECLARE @I_Complaint_Req_ID INT
			DECLARE @I_Student_Detail_ID INT
			SET @I_Complaint_Req_ID = 0

			-- Check Student S_Student_ID  present  or not
			IF EXISTS (SELECT I_Student_Detail_ID FROM T_Student_Detail WHERE S_Student_ID = @sStudentID)
				BEGIN

						-- Get I_Student_Detail_ID from T_Student_Detail TABLE 
						SET @I_Student_Detail_ID =(SELECT I_Student_Detail_ID FROM T_Student_Detail WHERE S_Student_ID = @sStudentID)


								INSERT INTO T_Complaint_Request_Detail
									( 			
									I_Center_ID,
									I_Course_ID,
									I_Status_ID,
									I_Complaint_Category_ID,
									I_Student_Detail_ID,
									Dt_Complaint_Date,
									S_Complaint_Details,
									I_Document_ID,			
									S_Complaint_Code,			
									I_Complaint_Mode_ID,
									S_Contact_Number,	
									S_Name,	
									S_Address,	
									S_Email_ID,			
									S_Crtd_By,
									S_Upd_By,			
									Dt_Crtd_On,
									Dt_Upd_On
										
									)
								VALUES
									(  			
									@I_Center_ID,
									@I_Course_ID,
									@I_Status_ID,
									@I_Complaint_Category_ID,
									@I_Student_Detail_ID,
									@Dt_Complaint_Date,
									@S_Complaint_Details,
									@I_Document_ID,
									@S_Complaint_Code,
									@I_Complaint_Mode_ID,
									@S_Contact_Number,
									@S_Name,
									@S_Address,
									@S_Email_ID,
									@S_Crtd_By,		
									@S_Upd_By,
									@Dt_Crtd_On,
									@Dt_Upd_On
									
									)
									-- Get the insert Complaint Request ID
									SET @I_Complaint_Req_ID=SCOPE_IDENTITY()
									
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
									) 
									(
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
									WHERE  I_Complaint_Req_ID = @I_Complaint_Req_ID)
									
				END
				SELECT @I_Complaint_Req_ID
			
	END TRY
			BEGIN CATCH
			--Error occurred:  
				DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
				SELECT	@ErrMsg = ERROR_MESSAGE(),
						@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END CATCH
