


CREATE  PROCEDURE [LMS].[uspInsertBatchDetailsForInterface]
(
	@BatchID INT,
	@EntryType VARCHAR(MAX)=NULL
)
AS
BEGIN

	if (@EntryType is not null)
	begin
		

		IF(@EntryType='ADD')
		begin

			insert into [LMS].[T_Batch_Details_Interface_API]
			select TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			0 as StudentStrength,ISNULL(TCBD.S_ClassDays,''),TSBM.Dt_BatchStartDate,TSBM.Dt_Course_Expected_End_Date,
			CASE WHEN TCBD.I_Status in (0,5) THEN 'INACTIVE' ELSE 'ACTIVE' END,
			ISNULL(TCBD.S_OfflineClassTime,''),ISNULL(TCBD.S_OnlineClassTime,''),ISNULL(TCBD.S_HandoutClassTime,''),
			@EntryType,
			0,0,1,
			---Add By Susmita : 2023-March-19 : All Eligible centers based on intermediate table ---
			--closed for ALL Center Flow for RICE : Sept 2023 : By Susmita--
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 0 ELSE 1 END,
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 0 ELSE 3 END,
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 1 ELSE 0 END,
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 1 END, --added / modify by Susmita : 2022-11-28 : For Set Executed in ActionStatus for all the center except Pro to not to make reflect LMS except PRO
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 3 END,--added / modify by Susmita : 2022-11-28 : For Set NoOfAttempt To 3 for all the center except Pro to not to make reflect LMS except PRO
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 1 ELSE 0 END,--added / modify by Susmita : 2022-11-28 : For Set Status To 0 for all the center except Pro to not to make reflect LMS except PRO
			---- --------------------------------------------------------------------------------- ---
			GETDATE(),NULL,
			NULL,
			---Add By Susmita : 2023-March-19 : All Eligible centers based on intermediate table ---
			--closed for ALL Center Flow for RICE : Sept 2023 : By Susmita--
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN NULL ELSE 'Classic Batch will not enter into LMS' END,
			--CASE WHEN TCHND.I_Center_ID in (132) THEN NULL ELSE 'Classic Batch will not enter into LMS' END,--added / modify by Susmita : 2022-11-28 : For Set Remarks to Error Msg for all the center except Pro to not to make reflect LMS except PRO
			---------------------------------------------------------------------------------
			ISNULL(TCBD.S_ClassMode,''),ISNULL(TCBD.I_Min_Strength,1)
			,TSBM.I_Language_ID,TSBM.I_Language_Name,TSBM.I_Category_ID --added by susmita for language 28-07-2022
			,NULL--,TSBM.Is_Cyclic_Batch --Susmita Paul : 2023June27 : Is cyclic status
			from T_Student_Batch_Master TSBM
			inner join T_Center_Batch_Details TCBD on TSBM.I_Batch_ID=TCBD.I_Batch_ID
			inner join T_Center_Hierarchy_Name_Details TCHND on TCBD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Course_Master TCM on TCM.I_Course_ID=TSBM.I_Course_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			--where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID=109
			---Add By Susmita : 2023-March-19 : All Eligible Brand based on intermediate table ---
			--where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID=113
			where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID in (109)
			--------------------------------------------------------------------------------

		end

		IF(@EntryType='UPDATE')
		begin

			insert into [LMS].[T_Batch_Details_Interface_API]
			select TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			ISNULL(TSBD.StdStrength,0) as StudentStrength,ISNULL(TCBD.S_ClassDays,''),TSBM.Dt_BatchStartDate,TSBM.Dt_Course_Expected_End_Date,
			CASE WHEN TCBD.I_Status in (0,5) THEN 'INACTIVE' ELSE 'ACTIVE' END,
			ISNULL(TCBD.S_OfflineClassTime,''),ISNULL(TCBD.S_OnlineClassTime,''),ISNULL(TCBD.S_HandoutClassTime,''),
			@EntryType,
			0,0,1,
			---Add By Susmita : 2023-March-19 : All Eligible centers based on intermediate table ---
			--closed for ALL Center Flow for RICE : Sept 2023 : By Susmita--
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 0 ELSE 1 END,
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 0 ELSE 3 END,
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 1 ELSE 0 END,
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 1 END, --added / modify by Susmita : 2022-11-28 : For Set Executed in ActionStatus for all the center except Pro to not to make reflect LMS except PRO
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 3 END,--added / modify by Susmita : 2022-11-28 : For Set NoOfAttempt To 3 for all the center except Pro to not to make reflect LMS except PRO
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 1 ELSE 0 END,--added / modify by Susmita : 2022-11-28 : For Set Status To 0 for all the center except Pro to not to make reflect LMS except PRO
			---- --------------------------------------------------------------------------------- ---
			GETDATE(),NULL,
			NULL,
			---Add By Susmita : 2023-March-19 : All Eligible centers based on intermediate table ---
			--closed for ALL Center Flow for RICE : Sept 2023 : By Susmita--
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN NULL ELSE 'Classic Batch will not enter into LMS' END,
			--CASE WHEN TCHND.I_Center_ID in (132) THEN NULL ELSE 'Classic Batch will not enter into LMS' END,--added / modify by Susmita : 2022-11-28 : For Set Remarks to Error Msg for all the center except Pro to not to make reflect LMS except PRO
			---------------------------------------------------------------------------------			
			ISNULL(TCBD.S_ClassMode,''),ISNULL(TCBD.I_Min_Strength,1)
			,TSBM.I_Language_ID,TSBM.I_Language_Name,TSBM.I_Category_ID --added by susmita for language 28-07-2022
			,NULL--,TSBM.Is_Cyclic_Batch --Susmita Paul : 2023June27 : Is cyclic status
			from T_Student_Batch_Master TSBM
			inner join T_Center_Batch_Details TCBD on TSBM.I_Batch_ID=TCBD.I_Batch_ID
			inner join T_Center_Hierarchy_Name_Details TCHND on TCBD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Course_Master TCM on TCM.I_Course_ID=TSBM.I_Course_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			left join
			(
				select A.I_Batch_ID,COUNT(DISTINCT A.I_Student_ID) as StdStrength from T_Student_Batch_Details A 
				where A.I_Batch_ID=@BatchID and A.I_Status=1
				group by A.I_Batch_ID
			) TSBD on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			--where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID=109
			---Add By Susmita : 2023-March-19 : All Eligible Brand based on intermediate table ---
			--where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID=113
			where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID in (109)
			--------------------------------------------------------------------------------
		end

		IF(@EntryType='UPDATE STATUS')
		begin

			insert into [LMS].[T_Batch_Details_Interface_API]
			select TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID,TCM2.S_Center_Code,
			TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Code,TSBM.S_Batch_Name,TCM.I_Course_ID,TCM.S_Course_Name,
			ISNULL(TSBD.StdStrength,0) as StudentStrength,ISNULL(TCBD.S_ClassDays,''),TSBM.Dt_BatchStartDate,TSBM.Dt_Course_Expected_End_Date,
			CASE WHEN TCBD.I_Status in (0,5) THEN 'INACTIVE' ELSE 'ACTIVE' END,
			ISNULL(TCBD.S_OfflineClassTime,''),ISNULL(TCBD.S_OnlineClassTime,''),ISNULL(TCBD.S_HandoutClassTime,''),
			@EntryType,
			0,0,1,
			---Add By Susmita : 2023-March-19 : All Eligible centers based on intermediate table ---
			--closed for ALL Center Flow for RICE : Sept 2023 : By Susmita--
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 0 ELSE 1 END,
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 0 ELSE 3 END,
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN 1 ELSE 0 END,
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 1 END, --added / modify by Susmita : 2022-11-28 : For Set Executed in ActionStatus for all the center except Pro to not to make reflect LMS except PRO
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 0 ELSE 3 END,--added / modify by Susmita : 2022-11-28 : For Set NoOfAttempt To 3 for all the center except Pro to not to make reflect LMS except PRO
			--CASE WHEN TCHND.I_Center_ID in (132) THEN 1 ELSE 0 END,--added / modify by Susmita : 2022-11-28 : For Set Status To 0 for all the center except Pro to not to make reflect LMS except PRO
			---- --------------------------------------------------------------------------------- ---
			GETDATE(),NULL,
			NULL,
			---Add By Susmita : 2023-March-19 : All Eligible centers based on intermediate table ---
			--closed for ALL Center Flow for RICE : Sept 2023 : By Susmita--
				--CASE WHEN TCHND.I_Center_ID in (select distinct ISNULL(CenterID,0) from LMS.SMSLMSSyncBrandCenterLists where ISBrandEligible=1 and ISCenterEligible=1) THEN NULL ELSE 'Classic Batch will not enter into LMS' END,
			--CASE WHEN TCHND.I_Center_ID in (132) THEN NULL ELSE 'Classic Batch will not enter into LMS' END,--added / modify by Susmita : 2022-11-28 : For Set Remarks to Error Msg for all the center except Pro to not to make reflect LMS except PRO
			---------------------------------------------------------------------------------			
			ISNULL(TCBD.S_ClassMode,''),ISNULL(TCBD.I_Min_Strength,1)
			,TSBM.I_Language_ID,TSBM.I_Language_Name,TSBM.I_Category_ID --added by susmita for language 28-07-2022
			,NULL--,TSBM.Is_Cyclic_Batch --Susmita Paul : 2023June27 : Is cyclic status
			from T_Student_Batch_Master TSBM
			inner join T_Center_Batch_Details TCBD on TSBM.I_Batch_ID=TCBD.I_Batch_ID
			inner join T_Center_Hierarchy_Name_Details TCHND on TCBD.I_Centre_Id=TCHND.I_Center_ID
			inner join T_Course_Master TCM on TCM.I_Course_ID=TSBM.I_Course_ID
			inner join T_Centre_Master TCM2 on TCHND.I_Center_ID=TCM2.I_Centre_Id
			left join
			(
				select A.I_Batch_ID,COUNT(DISTINCT A.I_Student_ID) as StdStrength from T_Student_Batch_Details A 
				where A.I_Batch_ID=@BatchID and A.I_Status=1
				group by A.I_Batch_ID
			) TSBD on TSBD.I_Batch_ID=TSBM.I_Batch_ID
			--where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID=109
			---Add By Susmita : 2023-March-19 : All Eligible Brand based on intermediate table ---
			--where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID=113
			where TSBM.I_Batch_ID=@BatchID and TCHND.I_Brand_ID in (109)
			--------------------------------------------------------------------------------

		end


		--select * from T_Center_Batch_Details

	end

END
