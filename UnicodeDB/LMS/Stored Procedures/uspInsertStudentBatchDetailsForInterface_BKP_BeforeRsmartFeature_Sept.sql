


CREATE PROCEDURE [LMS].[uspInsertStudentBatchDetailsForInterface_BKP_BeforeRsmartFeature_Sept]
(
@StudentDetailID INT,
@BatchID INT,
@EntryType VARCHAR(MAX)=NULL,
@SourceBatchID INT=NULL
)
AS
BEGIN

	PRINT @StudentDetailID
	PRINT @BatchID
	PRINT @EntryType

	--ADDED ON 16.7.2021

	DECLARE @CourseID INT
	DECLARE @CentreID INT
	DECLARE @SourceBatchCode VARCHAR(MAX)=NULL
	DECLARE @EnquiryID INT
	
	select @CourseID=I_Course_ID from T_Student_Batch_Master where I_Batch_ID=@BatchID
	select @CentreID=I_Centre_Id from T_Center_Batch_Details where I_Batch_ID=@BatchID

	SELECT @EnquiryID=I_Enquiry_Regn_ID FROM dbo.T_Student_Detail WHERE I_Student_Detail_ID=@StudentDetailID

	if(@SourceBatchID IS NOT NULL)
	BEGIN
		select @SourceBatchCode=S_Batch_Code from T_Student_Batch_Master where I_Batch_ID=@SourceBatchID
	END

	--ADDED ON 16.7.2021

	IF (@EntryType IS NULL)
	BEGIN

		IF EXISTS(select S_Student_ID from T_Student_Detail where I_Student_Detail_ID=@StudentDetailID and S_Student_ID LIKE '%RICE%')
		BEGIN

			--IF (
			--		(select count(*) from T_Student_Batch_Details where I_Student_ID=@StudentDetailID and I_Status=1)>1

			--		--ADDED ON 16.7.2021
			--		and
			--		(
			--			select count(*) from T_Student_Batch_Details A
			--			inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
			--			where 
			--			A.I_Student_ID=@StudentDetailID and B.I_Course_ID=@CourseID
			--		)=1
			--		and
			--		(
			--			select I_Centre_Id from T_Student_Center_Detail where I_Student_Detail_ID=@StudentDetailID and I_Status=1
			--		)=@CentreID

			--		--ADDED ON 16.7.2021
			--)
			--BEGIN

			--	SET @EntryType='ADD'

			--END

			IF((select count(*) from T_Student_Batch_Details where I_Student_ID=@StudentDetailID)=1)
			BEGIN

				SET @EntryType='NEW'

			END
			--ELSE IF ((select count(*) from T_Student_Batch_Details where I_Student_ID=@StudentDetailID)>1)
			--BEGIN

			--	SET @EntryType='UPDATE'

			--END
			ELSE IF ((select count(*) from T_Student_Batch_Details where I_Student_ID=@StudentDetailID)>1)
			BEGIN

				SET @EntryType='ADD'

			END

		END
	END

		IF(@EntryType='NEW')
		BEGIN

			EXEC [LMS].[uspInsertEnquiryDataForInterface] @EnquiryID,'ADD'

			EXEC uspStudentIDLanguageMap @EnquiryID,@StudentDetailID --added by susmita on 03-08-2022
			

			INSERT INTO LMS.T_Student_Details_Interface_API
			(
				StudentDetailID,
				StudentID,
				FirstName,
				MiddleName,
				LastName,
				Email,
				ContactNo,
				CurrAddress,
				Country,
				BrandID,
				BrandName,
				CentreID,
				CentreCode,
				CentreName,
				BatchID,
				BatchCode,
				BatchName,
				CourseID,
				CourseName,
				StudentStatus,
				StatusFlag,
				ActionType,
				ActionStatus,
				NoofAttempts,
				StatusID,
				CreatedOn,
				CompletedOn,
				Remarks,
				OrgEmailID,
				SecondaryLanguage,
				SourceBatchID,
				CustomerID,
				I_Language_ID,--added by susmita
				I_Language_Name --added by susmita
			)

			select DISTINCT @StudentDetailID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,''),TSD.S_Last_Name,
			ISNULL(TSD.S_Email_ID,''),TSD.S_Mobile_No,'','',TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			NULL,NULL,'ADD STUDENT',
			CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 1 END, --added / modify by Susmita : 2022-11-28 : For Set Executed in ActionStatus for all the center except Pro to not to make reflect LMS except PRO
			CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 3 END,--added / modify by Susmita : 2022-11-28 : For Set NoOfAttempt To 3 for all the center except Pro to not to make reflect LMS except PRO
			CASE WHEN TCHND.I_Center_ID in (132) THEN 1 ELSE 0 END,--added / modify by Susmita : 2022-11-28 : For Set Status To 0 for all the center except Pro to not to make reflect LMS except PRO
			GETDATE(),NULL,
			CASE WHEN TCHND.I_Center_ID in (132) THEN NULL ELSE 'Classic Students will not enter into LMS' END,--added / modify by Susmita : 2022-11-28 : For Set Remarks to Error Msg for all the center except Pro to not to make reflect LMS except PRO
			TSD.S_OrgEmailID,
			CASE WHEN TERD.S_Second_Language_Opted IS NULL OR TERD.S_Second_Language_Opted='' THEN 'Bengali' ELSE TERD.S_Second_Language_Opted END as SecondLanguage,
			@SourceBatchCode,ISNULL(TR.CustomerID,''),
			ISNULL(TST.I_Language_ID,0),ISNULL(TST.I_Language_Name,'') --added by susmita
			from T_Student_Detail TSD
			inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
			inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
			inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
			left join T_Student_Tags TST on TST.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID --added by susmita
			left join ECOMMERCE.T_Registration_Enquiry_Map TREM on TREM.EnquiryID=TSD.I_Enquiry_Regn_ID and TREM.StatusID=1
			left join ECOMMERCE.T_Registration TR on TR.RegID=TREM.RegID
			where
			TSD.I_Student_Detail_ID=@StudentDetailID and TSBD.I_Batch_ID=@BatchID
			and TCHND.I_Brand_ID=109

		END
		ELSE IF (@EntryType='UPDATE')
		BEGIN

			INSERT INTO LMS.T_Student_Details_Interface_API
			(
				StudentDetailID,
				StudentID,
				FirstName,
				MiddleName,
				LastName,
				Email,
				ContactNo,
				CurrAddress,
				Country,
				BrandID,
				BrandName,
				CentreID,
				CentreCode,
				CentreName,
				BatchID,
				BatchCode,
				BatchName,
				CourseID,
				CourseName,
				StudentStatus,
				StatusFlag,
				ActionType,
				ActionStatus,
				NoofAttempts,
				StatusID,
				CreatedOn,
				CompletedOn,
				Remarks,
				OrgEmailID,
				SecondaryLanguage,
				SourceBatchID,
				I_Language_ID,--added by susmita
				I_Language_Name --added by susmita
			)

			select DISTINCT @StudentDetailID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,''),TSD.S_Last_Name,
			ISNULL(TSD.S_Email_ID,''),TSD.S_Mobile_No,'','',TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			NULL,NULL,'UPDATE STUDENT BATCH',
			--0,--commented by susmita for below modification: 2022-11-28
			--0,--commented by susmita for below modification: 2022-11-28
			--1,--commented by susmita for below modification: 2022-11-28
			CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 1 END, --added / modify by Susmita : 2022-11-28 : For Set Executed in ActionStatus for all the center except Pro to not to make reflect LMS except PRO
			CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 3 END,--added / modify by Susmita : 2022-11-28 : For Set NoOfAttempt To 3 for all the center except Pro to not to make reflect LMS except PRO
			CASE WHEN TCHND.I_Center_ID in (132) THEN 1 ELSE 0 END,--added / modify by Susmita : 2022-11-28 : For Set Status To 0 for all the center except Pro to not to make reflect LMS except PRO
			GETDATE(),NULL,
			--NULL,--commented by susmita for below modification: 2022-11-28
			CASE WHEN TCHND.I_Center_ID in (132) THEN NULL ELSE 'Classic Students will not make any reflect into LMS' END,--added / modify by Susmita : 2022-11-28 : For Set Remarks to Error Msg for all the center except Pro to not to make reflect LMS except PRO
			TSD.S_OrgEmailID,
			CASE WHEN TERD.S_Second_Language_Opted IS NULL OR TERD.S_Second_Language_Opted='' THEN 'Bengali' ELSE TERD.S_Second_Language_Opted END as SecondLanguage,
			@SourceBatchCode,
			ISNULL(TST.I_Language_ID,0),ISNULL(TST.I_Language_Name,'') --added by susmita
			from T_Student_Detail TSD
			inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
			inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
			inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
			inner join T_Student_Tags TST on TST.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID --added by susmita
			where
			TSD.I_Student_Detail_ID=@StudentDetailID and TSBD.I_Batch_ID=@BatchID
			and TCHND.I_Brand_ID=109

		END

		ELSE IF (@EntryType='ADD')
		BEGIN

			EXEC uspStudentIDLanguageMap @EnquiryID,@StudentDetailID --added by susmita on 11-09-2022

			INSERT INTO LMS.T_Student_Details_Interface_API
			(
				StudentDetailID,
				StudentID,
				FirstName,
				MiddleName,
				LastName,
				Email,
				ContactNo,
				CurrAddress,
				Country,
				BrandID,
				BrandName,
				CentreID,
				CentreCode,
				CentreName,
				BatchID,
				BatchCode,
				BatchName,
				CourseID,
				CourseName,
				StudentStatus,
				StatusFlag,
				ActionType,
				ActionStatus,
				NoofAttempts,
				StatusID,
				CreatedOn,
				CompletedOn,
				Remarks,
				OrgEmailID,
				SecondaryLanguage,
				SourceBatchID,
				CustomerID,
				I_Language_ID,--added by susmita
				I_Language_Name --added by susmita
			)

			select DISTINCT @StudentDetailID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,''),TSD.S_Last_Name,
			ISNULL(TSD.S_Email_ID,''),TSD.S_Mobile_No,'','',TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			NULL,NULL,'ADD STUDENT BATCH',
			--0,0,1,--commented by susmita for below modification: 2022-11-28
			CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 1 END, --added / modify by Susmita : 2022-11-28 : For Set Executed in ActionStatus for all the center except Pro to not to make reflect LMS except PRO
			CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 3 END,--added / modify by Susmita : 2022-11-28 : For Set NoOfAttempt To 3 for all the center except Pro to not to make reflect LMS except PRO
			CASE WHEN TCHND.I_Center_ID in (132) THEN 1 ELSE 0 END,--added / modify by Susmita : 2022-11-28 : For Set Status To 0 for all the center except Pro to not to make reflect LMS except PRO
			GETDATE(),NULL,
			--NULL,--commented by susmita for below modification: 2022-11-28
			CASE WHEN TCHND.I_Center_ID in (132) THEN NULL ELSE 'Classic Students will not make any reflect into LMS' END,--added / modify by Susmita : 2022-11-28 : For Set Remarks to Error Msg for all the center except Pro to not to make reflect LMS except PRO
			TSD.S_OrgEmailID,
			CASE WHEN TERD.S_Second_Language_Opted IS NULL OR TERD.S_Second_Language_Opted='' THEN 'Bengali' ELSE TERD.S_Second_Language_Opted END as SecondLanguage,
			@SourceBatchCode,ISNULL(TR.CustomerID,''),
			ISNULL(TST.I_Language_ID,0),ISNULL(TST.I_Language_Name,'') --added by susmita
			from T_Student_Detail TSD
			inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
			inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
			inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
			left join T_Student_Tags TST on TST.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID --added by susmita
			left join ECOMMERCE.T_Registration_Enquiry_Map TREM on TREM.EnquiryID=TSD.I_Enquiry_Regn_ID and TREM.StatusID=1
			left join ECOMMERCE.T_Registration TR on TR.RegID=TREM.RegID
			where
			TSD.I_Student_Detail_ID=@StudentDetailID and TSBD.I_Batch_ID=@BatchID
			and TCHND.I_Brand_ID=109

		END

		ELSE IF (@EntryType='DELETE')
		BEGIN

			PRINT 'DELETE BLOCK'

			INSERT INTO LMS.T_Student_Details_Interface_API
			(
				StudentDetailID,
				StudentID,
				FirstName,
				MiddleName,
				LastName,
				Email,
				ContactNo,
				CurrAddress,
				Country,
				BrandID,
				BrandName,
				CentreID,
				CentreCode,
				CentreName,
				BatchID,
				BatchCode,
				BatchName,
				CourseID,
				CourseName,
				StudentStatus,
				StatusFlag,
				ActionType,
				ActionStatus,
				NoofAttempts,
				StatusID,
				CreatedOn,
				CompletedOn,
				Remarks,
				OrgEmailID,
				SecondaryLanguage,
				SourceBatchID,
				I_Language_ID,--added by susmita
				I_Language_Name --added by susmita
			)

			select DISTINCT @StudentDetailID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,''),TSD.S_Last_Name,
			ISNULL(TSD.S_Email_ID,''),TSD.S_Mobile_No,'','',TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			NULL,NULL,'DELETE STUDENT BATCH',
			--0,0,1,--commented by susmita for below modification: 2022-11-28
			CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 1 END, --added / modify by Susmita : 2022-11-28 : For Set Executed in ActionStatus for all the center except Pro to not to make reflect LMS except PRO
			CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 3 END,--added / modify by Susmita : 2022-11-28 : For Set NoOfAttempt To 3 for all the center except Pro to not to make reflect LMS except PRO
			CASE WHEN TCHND.I_Center_ID in (132) THEN 1 ELSE 0 END,--added / modify by Susmita : 2022-11-28 : For Set Status To 0 for all the center except Pro to not to make reflect LMS except PRO
			GETDATE(),NULL,
			--NULL,--commented by susmita for below modification: 2022-11-28
			CASE WHEN TCHND.I_Center_ID in (132) THEN NULL ELSE 'Classic Students will not make any reflect into LMS' END,--added / modify by Susmita : 2022-11-28 : For Set Remarks to Error Msg for all the center except Pro to not to make reflect LMS except PRO
			TSD.S_OrgEmailID,
			CASE WHEN TERD.S_Second_Language_Opted IS NULL OR TERD.S_Second_Language_Opted='' THEN 'Bengali' ELSE TERD.S_Second_Language_Opted END as SecondLanguage,
			@SourceBatchCode,
			ISNULL(TST.I_Language_ID,0),ISNULL(TST.I_Language_Name,'') --added by susmita
			from T_Student_Detail TSD
			inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
			inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
			inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
			inner join T_Student_Tags TST on TST.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID --added by susmita
			where
			TSD.I_Student_Detail_ID=@StudentDetailID and TSBD.I_Batch_ID=@BatchID
			and TCHND.I_Brand_ID=109

		END
END

