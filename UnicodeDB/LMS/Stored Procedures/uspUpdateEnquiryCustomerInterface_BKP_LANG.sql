
CREATE PROCEDURE [LMS].[uspUpdateEnquiryCustomerInterface_BKP_LANG]
(
	@ID INT,
	@CustomerID VARCHAR(MAX)=NULL,
	@Remarks VARCHAR(MAX)=NULL
)
AS
BEGIN


	DECLARE @dtCompletedOn DATETIME=NULL
	DECLARE @StatusID INT=1
	DECLARE @ActionStatus INT=1
	

	IF(@CustomerID IS NOT NULL)
	BEGIN
		SET @dtCompletedOn=GETDATE()
	END
	ELSE
	BEGIN
		
		SET @ActionStatus=0

	END


	if((select NoofAttempts+1 from LMS.T_Enquiry_Customer_Interface where ID=@ID)>=3)
		SET @StatusID=0



	DECLARE @EnquiryID INT=0

	select @EnquiryID=EnquiryID from LMS.T_Enquiry_Customer_Interface where ID=@ID



	update 	LMS.T_Enquiry_Customer_Interface set ActionStatus=@ActionStatus,NoofAttempts=NoofAttempts+1,StatusID=@StatusID,
													CompletedOn=@dtCompletedOn,Remarks=@Remarks,CustomerID=@CustomerID
	where ID=@ID

	
	IF((SELECT I_Enquiry_Status_Code FROM dbo.T_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID=@EnquiryID)=3)
	BEGIN

		UPDATE LMS.T_Student_Details_Interface_API SET CustomerID=@CustomerID WHERE (ActionType!='STATUS UPDATE' and ActionType!='UPDATE STUDENT') 
		AND ActionStatus=0 AND StatusID=1 AND (CustomerID='' OR CustomerID IS NULL)
		AND StudentDetailID IN
		(
			SELECT I_Student_Detail_ID FROM dbo.T_Student_Detail WHERE I_Enquiry_Regn_ID=@EnquiryID
		)


	END


	IF (@CustomerID IS NOT NULL)
	BEGIN

		DECLARE @MobileNo VARCHAR(MAX)=NULL

		IF NOT EXISTS(SELECT * FROM ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
		BEGIN

			select @MobileNo=ContactNo from LMS.T_Enquiry_Customer_Interface where ID=@ID and ContactNo IS NOT NULL
			

			IF(@MobileNo IS NOT NULL)
			BEGIN

				IF NOT EXISTS(select * from ECOMMERCE.T_Registration where MobileNo=@MobileNo)
				BEGIN

					DECLARE @RegID INT=0


					insert into ECOMMERCE.T_Registration
					(
						CustomerID,
						FirstName,
						MiddleName,
						LastName,
						DateofBirth,
						EmailID,
						MobileNo,
						[Address],
						Pincode,
						StatusID,
						RegistrationSource,
						CreatedOn,
						CreatedBy,
						Gender,
						HighestEducationQualification,
						City,
						[State],
						Country
					)
					select @CustomerID,
							A.S_First_Name,
							A.S_Middle_Name,
							A.S_Last_Name,
							A.Dt_Birth_Date,
							A.S_Email_ID,
							CASE WHEN LEN(ISNULL(@MobileNo,0))<=10 THEN ISNULL(@MobileNo,0) ELSE SUBSTRING(@MobileNo,LEN(@MobileNo)-10+1,10) END,
							--@MobileNo,
							A.S_Curr_Address1,
							A.S_Curr_Pincode,
							1,
							'SMS',
							GETDATE(),
							'rice-group-admin',
							G.S_Sex_Name,
							D.S_Education_CurrentStatus_Description,
							E.S_City_Name,
							F.S_State_Name,
							'India'
					from T_Enquiry_Regn_Detail A
					inner join LMS.T_Enquiry_Customer_Interface B on A.I_Enquiry_Regn_ID=B.EnquiryID
					left join T_Enquiry_Education_CurrentStatus C on A.I_Enquiry_Regn_ID=C.I_Enquiry_Regn_ID
					left join T_Education_CurrentStatus D on C.I_Education_CurrentStatus_ID=D.I_Education_CurrentStatus_ID
					left join T_City_Master E on A.I_Curr_City_ID=E.I_City_ID
					left join T_State_Master F on A.I_Curr_State_ID=F.I_State_ID
					left join T_User_Sex G on A.I_Sex_ID=G.I_Sex_ID
					where
					B.CustomerID=@CustomerID and B.ID=@ID

					SET @RegID=SCOPE_IDENTITY()
				END
				ELSE
				BEGIN

					SELECT @RegID=RegID FROM ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1 and MobileNo=@MobileNo

				END

			END

			if(@RegID>0)
			BEGIN
				if not exists(select * from ECOMMERCE.T_Registration_Enquiry_Map 
								where EnquiryID=(select EnquiryID from LMS.T_Enquiry_Customer_Interface where ID=@ID))
				BEGIN

					insert into ECOMMERCE.T_Registration_Enquiry_Map
					select @RegID,EnquiryID,1,GETDATE(),'rice-group-admin',NULL,NULL from LMS.T_Enquiry_Customer_Interface where ID=@ID



					update T_Enquiry_Regn_Detail set RegID=@RegID where I_Enquiry_Regn_ID=(select EnquiryID from LMS.T_Enquiry_Customer_Interface where ID=@ID) and RegID IS NULL

					insert into ECOMMERCE.T_Registration_Enquiry_Map
					(
						RegID,
						EnquiryID,
						StatusID,
						CreatedOn,
						CreatedBy
					)
					select @RegID,T1.I_Enquiry_Regn_ID,1,GETDATE(),'rice-group-admin'
					from
					(
						select A.I_Enquiry_Regn_ID,B.RegID 
						from 
						T_Enquiry_Regn_Detail A
						inner join T_Center_Hierarchy_Name_Details C on A.I_Centre_Id=C.I_Center_ID
						left join ECOMMERCE.T_Registration_Enquiry_Map B on A.I_Enquiry_Regn_ID=B.EnquiryID and B.StatusID=1 and B.RegID=@RegID
						where 
						A.I_Enquiry_Status_Code is not null and A.I_Enquiry_Status_Code IN (1,3) and 
						C.I_Brand_ID in (109)
						and CASE WHEN LEN(ISNULL(A.S_Mobile_No,0))<=10 THEN ISNULL(A.S_Mobile_No,0) ELSE SUBSTRING(A.S_Mobile_No,LEN(A.S_Mobile_No)-10+1,10) END=@MobileNo
					) T1
					where T1.RegID IS NULL

				END
			END

		END

	END

END
