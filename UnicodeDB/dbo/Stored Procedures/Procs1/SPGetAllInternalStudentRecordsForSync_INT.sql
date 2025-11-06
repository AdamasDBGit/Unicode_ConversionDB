 
--SPGetAllInternalStudentRecordsForSync_INT   '2018-08-22 14:35:34'
-- =============================================
CREATE  PROCEDURE [dbo].[SPGetAllInternalStudentRecordsForSync_INT]
(
		--@RegistrationID			nvarchar(max)=null
		@RegistrationID			nvarchar(100)=null  --'2018-08-09 21:35:58'
)
AS
BEGIN
	--select * INTO #tempRegistrationIDS from [dbo].[Split](',',@RegistrationID)

	DECLARE @VarDate	DATE;

	IF @RegistrationID='' OR @RegistrationID IS NULL
	BEGIN
		SET @VarDate=NULL
	END
	ELSE
	BEGIN
		SET @VarDate=CAST(@RegistrationID AS DATE)
	END




	--Student Details Query with Active Status
	SELECT 
		[S_Student_ID]				AS [RegistrationNumber],
		[S_Title]					AS [Title],
		[S_First_Name]				AS [FirstName],
		[S_Middle_Name]				AS [MiddleName],
		[S_Last_Name]				AS [LastName],
		[S_Guardian_Name]			AS [GuardianName],
		CASE WHEN LTRIM(RTRIM(LEN(S_Guardian_Phone_No))) >12  THEN '0' ELSE S_Guardian_Phone_No END AS GuardianMobileNumber,
		--[S_Guardian_Phone_No]		AS [GuardianMobileNumber],
		[Dt_Birth_Date]				AS [BirthDate],
		[S_Email_ID]				AS [Email],
		--[S_Mobile_No]				AS [MobileNumber],
		CASE WHEN LTRIM(RTRIM(LEN(S_Mobile_No))) >12  THEN '0' ELSE S_Mobile_No END AS [MobileNumber],
		--LEFT(S_Mobile_No,13)        AS  [MobileNumber], 
		--[S_Phone_No]				AS [AlternateMobileNumber],
		CASE WHEN LTRIM(RTRIM(LEN(S_Phone_No))) >12  THEN '0' ELSE S_Phone_No END AS AlternateMobileNumber,
		[S_Curr_Address1]			AS [CurrentAddress],
		(case when [I_Curr_Country_ID] > 0 then [I_Curr_Country_ID] else null end	)		AS [CurrentCountryId],
		(case when [I_Curr_State_ID]	 > 0 then [I_Curr_State_ID] else null end	)		AS [CurrentStateId],
		(case when [I_Curr_City_ID]	> 0 then [I_Curr_City_ID] else null end	    )	AS [CurrentCityId],
	--[S_Curr_Pincode] 			AS [CurrentPinCode],
	   --CONVERT(bigint,S_Curr_Pincode)  AS [CurrentPinCode], 
	   --cast(NULLIF(S_Curr_Pincode,'') as Int) AS [CurrentPinCode], 
	  -- LEFT(S_Curr_Pincode,6)        AS [CurrentPinCode], 
	  CASE WHEN LTRIM(RTRIM(LEN(S_Curr_Pincode))) >6  THEN '0' ELSE S_Curr_Pincode END AS CurrentPinCode,
		[S_Perm_Address1]			AS [PermanentAddress],
	   (case when	[I_Perm_Country_ID]	> 0 then [I_Perm_Country_ID]  else null end) 	AS [PermanentCountryId],
	   (case when	[I_Perm_State_ID] > 0 then [I_Perm_State_ID] else null end)	 AS [PermanentStateId],
	   ( case when	[I_Perm_City_ID]	> 0 then [I_Perm_City_ID] else null end)	AS [PermanentCityId],
		
		-- CONVERT(bigint,S_Perm_Pincode)  AS [PermanentPinCode] 
		--[S_Perm_Pincode]			AS [PermanentPinCode]
	  -- cast(S_Perm_Pincode as Int)   AS [PermanentPinCode]
		-- LEFT(S_Perm_Pincode,6)        AS [PermanentPinCode]
		  CASE WHEN LTRIM(RTRIM(LEN(S_Perm_Pincode))) >6  THEN '0' ELSE S_Perm_Pincode END AS PermanentPinCode
		
	FROM
		T_Student_Detail
	--LEFT JOIN #tempRegistrationIDS ON T_Student_Detail.[S_Student_ID]= #tempRegistrationIDS.Item
	WHERE I_Status=1 
	and S_Student_ID LIKE '%/RICE/%' AND LEN(S_Student_ID)<=16
	and (CAST(Dt_Crtd_On AS DATE) >=  ISNULL( @VarDate,CAST(Dt_Crtd_On AS DATE))   or CAST(Dt_Upd_On AS DATE) >=ISNULL( @VarDate,CAST(Dt_Upd_On AS DATE))  ) 

	--and CAST(Dt_Crtd_On AS DATE) > @VarDate  
	--and  CAST(Dt_Upd_On AS DATE) <=@VarDate
	
	
		 
		 --AND
		 --#tempRegistrationIDS.Item IS NULL
	
	--Qualification----------

	--SELECT 
	--	[S_Name_Of_Exam]    AS [QualificationName],
	--	[S_Year_To]			AS [PassingYear],		
	--	[S_Institution]		AS [SchoolName],
	--	[S_University_Name]	AS [BoardUniversity],
	--	[S_Subject_Name]	AS [SubjectStream],
	--	[N_Percentage]		AS [Percentage],
	--	CAST(0 AS INT)		AS [QualificationNameId],
	--	[S_Student_ID]		AS [ResigtrationID]
	--FROM
	--	[T_Enquiry_Qualification_Details]
	--INNER JOIN
	--T_Student_Detail ON T_Student_Detail.I_Enquiry_Regn_ID=[T_Enquiry_Qualification_Details].I_Enquiry_Regn_ID
	----LEFT JOIN #tempRegistrationIDS ON T_Student_Detail.[S_Student_ID]= #tempRegistrationIDS.Item
	--WHERE
	--T_Student_Detail.I_Status=1
	--AND
	--#tempRegistrationIDS.Item IS NULL

	--Student Batch Mapping



	


/** --Student Batch mapping 
 In Rice SMS DB a student has multiple entry with same status .Currently we are fetching the student batch mapping data with status =1
 Filtering the assigned student batch only of those which start date is less than or equal to Current Date(Today's date) .
 No Future batch mapping is getting fetched .
 So to fetch the current active assigned batch we are checking  Dt_Valid_From (T_Student_Batch_Details) date which is max among the datarows of same status of a student
 and Dt_Valid_From date which is greater or equsl to assigned batch Start date to filter out old assigned batch mapping entry .

**/

	

	SELECT
	distinct	SD.[S_Student_ID]							AS [ResigtrationID],
	(case when	SBD.[I_Batch_ID] >0 then SBD.[I_Batch_ID] else null end)	AS [BatchID],
		SBM.S_Batch_Name	AS [BatchName],
		SBM.I_Status		AS [Status]
	FROM 
    	[T_Student_Batch_Details] SBD INNER JOIN T_Student_Detail SD
	ON SD.I_Student_Detail_ID=SBD.I_Student_ID
	INNER JOIN [T_Student_Batch_Master] SBM ON  SBM.I_Batch_ID=SBD.I_Batch_ID
	where SD.I_Status=1 and  SBD.I_Status=1 
	AND S_Student_ID LIKE '%/RICE/%' AND LEN(S_Student_ID)<=16 
	--AND  (CAST(SD.Dt_Crtd_On AS DATE) >  @VarDate  or CAST(SD.Dt_Upd_On AS DATE) <= @VarDate  )
    and (CAST(SBD.Dt_Valid_From AS DATE) >=  ISNULL( @VarDate,CAST(SBD.Dt_Valid_From AS DATE)))   --or CAST(SD.Dt_Upd_On AS DATE) >=ISNULL( @VarDate,CAST(SD.Dt_Upd_On AS DATE))  ) 
	--AND SBM.I_Batch_ID=8763
	AND SBM.Dt_BatchStartDate <= GETDATE() 
    AND SBD.Dt_Valid_From = (select max(Dt_Valid_From) from [T_Student_Batch_Details] a where a.I_Student_ID = SBD.I_Student_ID AND a.I_Status=1)
    --AND SBD.Dt_Valid_From >=SBM.Dt_BatchStartDate









	 -- and CAST(T_Student_Detail.Dt_Crtd_On AS DATE) > @VarDate  
	
	   --and  CAST(T_Student_Detail.Dt_Upd_On AS DATE) <=@VarDate

	 --order by  [BatchID] desc
	
	--and [T_Student_Batch_Master].I_Status=1

	--select * from T_Student_Batch_Master where I_Status=1
	
	----LEFT JOIN #tempRegistrationIDS ON T_Student_Detail.[S_Student_ID]= #tempRegistrationIDS.Item
	----WHERE
	----#tempRegistrationIDS.Item IS NULL



END
