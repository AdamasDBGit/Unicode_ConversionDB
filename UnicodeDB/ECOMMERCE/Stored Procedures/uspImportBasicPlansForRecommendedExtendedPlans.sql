




/*******************************************************
Description : Get Basic Plans Recommended Extended Plans using for paid users
Author	:     Susmita Paul
Date	:	  2023-March-22
*********************************************************/

CREATE  PROCEDURE [ECOMMERCE].[uspImportBasicPlansForRecommendedExtendedPlans] 
(
	@sCustomerID Nvarchar(20)=null
)

AS

		Create Table #Batch_Course
		(
		S_Student_ID varchar(max),
		I_Course_ID INT,
		I_Batch_ID INT,
		S_Batch_Code varchar(max),
		S_Batch_Name varchar(max),
		Dt_BatchStartDate datetime,
		Dt_Valid_From datetime,
		Course_Expected_End datetime,
		Course_Actual_End datetime
		)

		insert into #Batch_Course
		select SD.S_Student_ID,SBM.I_Course_ID,SBM.I_Batch_ID,SBM.S_Batch_Code,SBM.S_Batch_Name,SBM.Dt_BatchStartDate,SBD.Dt_Valid_From,
		SBM.Dt_Course_Expected_End_Date,SBM.Dt_Course_Actual_End_Date
		from 
		ECOMMERCE.T_Registration A
		inner join ECOMMERCE.T_Registration_Enquiry_Map B on A.RegID=B.RegID and B.StatusID=1
		inner join T_Enquiry_Regn_Detail C on B.EnquiryID=C.I_Enquiry_Regn_ID
		inner join T_Student_Detail SD on SD.I_Enquiry_Regn_ID=C.I_Enquiry_Regn_ID
		inner join T_Student_Batch_Details as SBD on SBD.I_Student_ID=SD.I_Student_Detail_ID
		inner join T_Student_Batch_Master as SBM on SBM.I_Batch_ID=SBD.I_Batch_ID
		inner join T_Center_Batch_Details as CBD on CBD.I_Batch_ID=SBM.I_Batch_ID 
		where A.CustomerID=@sCustomerID and A.StatusID=1 
		and SBD.I_Status in (0,1,2,3) 
		
		--select * from #Batch_Course
		
		--select A.* from 
		--#Batch_Course as A
		--inner join 
		--(select I_Course_ID,Max(Dt_Valid_From) 
		--as LastEnrollDate from #Batch_Course  GROUP BY I_Course_ID) as B 
		--on B.I_Course_ID=A.I_Course_ID and B.LastEnrollDate=A.Dt_Valid_From

		--select count(*) from #Batch_Course

		--select * from #Batch_Course

		if Exists(select * from #Batch_Course)
		begin
			insert into ECOMMERCE.T_RICE_Student_Extended_Details
			(
			Customer_ID,
			I_Course_ID,
			I_Course_Name,
			I_Batch_ID,
			S_Batch_Code,
			S_Batch_Name,
			Dt_BatchStartDate,
			Dt_Valid_From,
			PlanId,
			S_Student_ID,
			Course_Expected_End,
			Course_Actual_End
			)
			select @sCustomerID,A.I_Course_ID,CM.S_Course_Name,A.I_Batch_ID,
			A.S_Batch_Code,A.S_Batch_Name,A.Dt_BatchStartDate,A.Dt_Valid_From,PM2.PlanID,A.S_Student_ID,
			A.Course_Expected_End,A.Course_Actual_End
			--,A.*,PM2.PlanName,DATEDIFF(MONTH,CONVERT(DATE,A.Dt_BatchStartDate),CONVERT(DATE,GETDATE())) 
			from 
			#Batch_Course as A
			inner join 
			(select I_Course_ID,Max(Dt_Valid_From) 
			as LastEnrollDate from #Batch_Course  GROUP BY I_Course_ID) as B 
			on B.I_Course_ID=A.I_Course_ID and B.LastEnrollDate=A.Dt_Valid_From
			inner join
			ECOMMERCE.T_Plan_Master as PM2 on ISNULL(PM2.ExtendedParentCourse,0)=A.I_Course_ID
			inner join
			T_Course_Master as CM on CM.I_Course_ID=A.I_Course_ID
			where PM2.StatusID=1 and PM2.IsExtendedPlan=1 and PM2.IsPublished=1
			and 
			DATEDIFF(MONTH,CONVERT(DATE,A.Dt_BatchStartDate),CONVERT(DATE,GETDATE())) >= PM2.ExtendedMonthRangeFrom
			and DATEDIFF(MONTH,CONVERT(DATE,A.Dt_BatchStartDate),CONVERT(DATE,GETDATE())) <= PM2.ExtendedMonthRangeTo
		end
