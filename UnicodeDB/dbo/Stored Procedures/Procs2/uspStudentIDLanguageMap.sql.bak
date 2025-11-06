

CREATE PROCEDURE [dbo].[uspStudentIDLanguageMap] 
(
@EnquiryID INT,
@StudentDetailID INT
)
AS
BEGIN
	
	if exists(select * from T_Student_Tags where I_Enquiry_Regn_ID=@EnquiryID)

		BEGIN

			DECLARE @S_Upd_By VARCHAR(20),@Dt_Upd_On DATETIME,@Enquiry_status INT

			select @S_Upd_By=SD.S_Crtd_By,@Dt_Upd_On=SD.Dt_Crtd_On,@Enquiry_status=ERD.I_Enquiry_Status_Code from 
			T_Student_Detail as SD
			inner join 
			T_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID
			where ERD.I_Enquiry_Regn_ID=@EnquiryID and SD.I_Student_Detail_ID=@StudentDetailID

			 if exists(select * from T_Student_Tags where I_Enquiry_Regn_ID=@EnquiryID and I_Student_Detail_ID=@StudentDetailID)
			
				BEGIN

				update T_Student_Tags set I_Enquiry_Status_Code=@Enquiry_status where I_Enquiry_Regn_ID=@EnquiryID and I_Student_Detail_ID=@StudentDetailID

				END

			else

				BEGIN

				update T_Student_Tags set I_Student_Detail_ID=@StudentDetailID,Dt_Upd_On=@Dt_Upd_On,S_Upd_By=@S_Upd_By,
				I_Enquiry_Status_Code=@Enquiry_status
				where I_Enquiry_Regn_ID=@EnquiryID

				END


		END

	ELSE
		BEGIN

		IF @StudentDetailID IS NOT NULL
			
			BEGIN

			insert into T_Student_Tags
			select TOP 1 TCM.I_Brand_ID,SD.I_Enquiry_Regn_ID,SD.I_Student_Detail_ID,ERD.I_Enquiry_Status_Code,TCM.I_Language_ID,
			TCM.I_Language_Name,ERD.S_Crtd_By,SD.S_Crtd_By as S_Upd_By,ERD.Dt_Crtd_On,SD.Dt_Crtd_On as Dt_Upd_On from
			T_Student_Detail as SD 
			inner join T_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID
			inner join T_Student_Batch_Details TSBD on SD.I_Student_Detail_ID=TSBD.I_Student_ID
			inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
			where SD.I_Student_Detail_ID=@StudentDetailID
			


			END

		END


END
