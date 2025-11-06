


/*******************************************************
Description : Get Basic Plans Recommended Extended Plans using for paid users
Author	:     Susmita Paul
Date	:	  2022-Jan-24
*********************************************************/

CREATE PROCEDURE [ECOMMERCE].[uspGetBasicPlansForRecommendedExtendedPlans] 
(
	@sCustomerID Nvarchar(20)=null
)

AS

		Create Table #Batch_Course
		(
		I_Course_ID INT,
		I_Batch_ID INT,
		S_Batch_Code varchar(max),
		S_Batch_Name varchar(max),
		Dt_BatchStartDate datetime,
		Dt_Valid_From datetime
		)

		insert into #Batch_Course
		select SBM.I_Course_ID,SBM.I_Batch_ID,SBM.S_Batch_Code,SBM.S_Batch_Name,SBM.Dt_BatchStartDate,SBD.Dt_Valid_From from 
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
			select PM2.PlanID
			--,A.*,PM2.PlanName,DATEDIFF(MONTH,CONVERT(DATE,A.Dt_BatchStartDate),CONVERT(DATE,GETDATE())) 
			from 
			#Batch_Course as A
			inner join 
			(select I_Course_ID,Max(Dt_Valid_From) 
			as LastEnrollDate from #Batch_Course  GROUP BY I_Course_ID) as B 
			on B.I_Course_ID=A.I_Course_ID and B.LastEnrollDate=A.Dt_Valid_From
			inner join
			ECOMMERCE.T_Plan_Master as PM2 on ISNULL(PM2.ExtendedParentCourse,0)=A.I_Course_ID
			where PM2.StatusID=1 and PM2.IsExtendedPlan=1 and PM2.IsPublished=1
			and 
			DATEDIFF(MONTH,CONVERT(DATE,A.Dt_BatchStartDate),CONVERT(DATE,GETDATE())) >= PM2.ExtendedMonthRangeFrom
			and DATEDIFF(MONTH,CONVERT(DATE,A.Dt_BatchStartDate),CONVERT(DATE,GETDATE())) <= PM2.ExtendedMonthRangeTo
		end
		else
			begin
			select null
			end
