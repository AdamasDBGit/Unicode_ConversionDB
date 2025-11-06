
CREATE PROCEDURE [LMS].[uspInsertStudentBatchDetailsForInterfaceMigration]
(
@StudentDetailID INT,
@BatchID INT,
@EntryType VARCHAR(MAX)=NULL
)
AS
BEGIN

	IF EXISTS(select S_Student_ID from T_Student_Detail where I_Student_Detail_ID=@StudentDetailID and S_Student_ID LIKE '%RICE%')
	BEGIN

				IF(@EntryType='NEW')
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
				SecondaryLanguage
			)

			select DISTINCT @StudentDetailID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,''),TSD.S_Last_Name,
			ISNULL(TSD.S_Email_ID,''),TSD.S_Mobile_No,'','',TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			NULL,NULL,'ADD STUDENT',0,0,1,GETDATE(),NULL,NULL,TSD.S_OrgEmailID,
			CASE WHEN TERD.S_Second_Language_Opted IS NULL OR TERD.S_Second_Language_Opted='' THEN 'Bengali' ELSE TERD.S_Second_Language_Opted END as SecondLanguage
			from T_Student_Detail TSD
			inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
			inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
			inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
			where
			TSD.I_Student_Detail_ID=@StudentDetailID and TSBD.I_Batch_ID=@BatchID

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
				SecondaryLanguage
			)

			select DISTINCT @StudentDetailID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,''),TSD.S_Last_Name,
			ISNULL(TSD.S_Email_ID,''),TSD.S_Mobile_No,'','',TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			NULL,NULL,'UPDATE STUDENT BATCH',0,0,1,GETDATE(),NULL,NULL,TSD.S_OrgEmailID,
			CASE WHEN TERD.S_Second_Language_Opted IS NULL OR TERD.S_Second_Language_Opted='' THEN 'Bengali' ELSE TERD.S_Second_Language_Opted END as SecondLanguage
			from T_Student_Detail TSD
			inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
			inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
			inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
			where
			TSD.I_Student_Detail_ID=@StudentDetailID and TSBD.I_Batch_ID=@BatchID

		END

		ELSE IF (@EntryType='ADD')
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
				SecondaryLanguage
			)

			select DISTINCT @StudentDetailID,TSD.S_Student_ID,TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,''),TSD.S_Last_Name,
			ISNULL(TSD.S_Email_ID,''),TSD.S_Mobile_No,'','',TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			NULL,NULL,'ADD STUDENT BATCH',0,0,1,GETDATE(),NULL,NULL,TSD.S_OrgEmailID,
			CASE WHEN TERD.S_Second_Language_Opted IS NULL OR TERD.S_Second_Language_Opted='' THEN 'Bengali' ELSE TERD.S_Second_Language_Opted END as SecondLanguage
			from T_Student_Detail TSD
			inner join T_Student_Batch_Details TSBD on TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			inner join T_Student_Batch_Master TSBM on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
			inner join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID and TSCD.I_Status=1
			inner join T_Center_Hierarchy_Name_Details TCHND on TSCD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			inner join T_Enquiry_Regn_Detail TERD on TSD.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
			where
			TSD.I_Student_Detail_ID=@StudentDetailID and TSBD.I_Batch_ID=@BatchID

		END



	END
END
