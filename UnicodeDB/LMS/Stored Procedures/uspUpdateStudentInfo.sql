CREATE PROCEDURE [LMS].[uspUpdateStudentInfo]
(
	@StudentDetailID INT,
	@ContactNo VARCHAR(MAX),
	@UpdatedBy VARCHAR(MAX)=NULL
)
AS
BEGIN

	IF(@StudentDetailID IS NOT NULL and @StudentDetailID>0 and @ContactNo IS NOT NULL and @ContactNo!='')
	BEGIN

		DECLARE @EnquiryID INT
		DECLARE @RegID INT


		select @EnquiryID=I_Enquiry_Regn_ID from T_Student_Detail where I_Student_Detail_ID=@StudentDetailID
		select @RegID=RegID from ECOMMERCE.T_Registration_Enquiry_Map where EnquiryID=@EnquiryID and StatusID=1


		update T_Student_Detail set S_Mobile_No=@ContactNo,S_Upd_By=@UpdatedBy,Dt_Upd_On=GETDATE() 
		where I_Enquiry_Regn_ID in
		(
			select EnquiryID from ECOMMERCE.T_Registration_Enquiry_Map where RegID=@RegID and StatusID=1 and EnquiryID!=@EnquiryID
		)

		update T_Enquiry_Regn_Detail set S_Mobile_No=@ContactNo,S_Upd_By=@UpdatedBy,Dt_Upd_On=GETDATE() 
		where I_Enquiry_Regn_ID in
		(
			select EnquiryID from ECOMMERCE.T_Registration_Enquiry_Map where RegID=@RegID and StatusID=1 and EnquiryID!=@EnquiryID
		)


		insert into LMS.T_Student_Details_Interface_API
		(
			StudentDetailID,
			StudentID,
			ContactNo,
			ActionStatus,
			ActionType,
			NoofAttempts,
			StatusID,
			CreatedOn
		)
		select
			B.I_Student_Detail_ID,
			B.S_Student_ID,
			@ContactNo,
			0,
			'UPDATE STUDENT',
			0,
			1,
			GETDATE()
		from 
		ECOMMERCE.T_Registration_Enquiry_Map A
		inner join T_Student_Detail B on A.EnquiryID=B.I_Enquiry_Regn_ID and A.StatusID=1
		where
		A.RegID=@RegID

		update ECOMMERCE.T_Registration set MobileNo=@ContactNo,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE() 
		where RegID=@RegID and StatusID=1

	END

END
