CREATE PROCEDURE [LMS].[uspInsertEnquiryDataForInterface]
(
	@EnquiryID INT,
	@ActionType VARCHAR(MAX)
)
AS
BEGIN

	IF NOT EXISTS(select * from ECOMMERCE.T_Registration_Enquiry_Map where StatusID=1 and EnquiryID=@EnquiryID)
	BEGIN
		
		insert into LMS.T_Enquiry_Customer_Interface
		select A.I_Enquiry_Regn_ID,A.S_First_Name+' '+ISNULL(A.S_Middle_Name,'')+' '+A.S_Last_Name,A.S_Mobile_No,A.S_Email_ID,@ActionType,0,0,1,GETDATE(),NULL,NULL,NULL
		from T_Enquiry_Regn_Detail A
		inner join T_Center_Hierarchy_Name_Details B on A.I_Centre_Id=B.I_Center_ID
		where
		A.I_Enquiry_Regn_ID=@EnquiryID and B.I_Brand_ID=109

	END

	
	IF NOT EXISTS(select * from T_Student_Tags where I_Enquiry_Regn_ID=@EnquiryID)
		BEGIN

			 ---- Start Of Added instructions For language Details before CustomerId & Admission: By Susmita  

				 DECLARE @LanguageName VARCHAR(200),@LanguageID INT,@BrandID INT
				 DECLARE @IEnquiryStatusCode INT,@CrtdBy VARCHAR(20),@DtCrtdOn DATETIME
				 SELECT TOP 1 @LanguageName=I_Language_Name,@LanguageID=I_Language_ID,@BrandID=I_Brand_ID from T_Course_Master 
				 where I_Course_ID = (select TOP 1 I_Course_ID from dbo.T_Enquiry_Course where I_Enquiry_Regn_ID=@EnquiryID)

				 SELECT TOP 1 @IEnquiryStatusCode=I_Enquiry_Status_Code,@CrtdBy=S_Crtd_By,@DtCrtdOn=Dt_Crtd_On from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@EnquiryID

				 IF(@BrandID = 109)
					BEGIN
					 INSERT INTO dbo.T_Student_Tags
							( I_Brand_ID,
							I_Enquiry_Regn_ID,
							I_Enquiry_Status_Code,
							I_Language_ID,
							I_Language_Name,
							S_Crtd_By,
							Dt_Crtd_On					
							)
					 VALUES (
							 @BrandID,
							 @EnquiryID,
							 @IEnquiryStatusCode,
							 @LanguageID,
							 @LanguageName,
							 @CrtdBy,
							 @DtCrtdOn
							 )
					END


				 ---- End Of Added instructions For language Details before CustomerId & Admission : By Susmita 


		END


END
