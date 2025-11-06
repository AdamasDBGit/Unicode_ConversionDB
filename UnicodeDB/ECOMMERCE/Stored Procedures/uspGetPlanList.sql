
CREATE PROCEDURE [ECOMMERCE].[uspGetPlanList](@sBrandID VARCHAR(MAX), @ExamCategoryIDs VARCHAR(MAX)=NULL, @CategoryID INT=NULL, @CouponID INT=0, @ExamGroupIDs VARCHAR(MAX)=NULL, @ProductID INT=0, @CustomerID  VARCHAR(MAX)=NULL)  
AS  
BEGIN  
  
IF(@CategoryID=0)  
 SET @CategoryID=NULL  
  
IF(@ProductID=0)  
 set @ProductID=NULL  
  
  
create table #Plans  
(  
 PlanID INT  
)  
  
create table #EG  
(  
 ExamGroupID INT  
)  

---exteneded plan table : susmita : 2023-jan-24
create table #ExtendedPlans
(
ExtendedPlanID INT
)

  
if(@ExamGroupIDs IS NULL)  
BEGIN  
  
 insert into #EG  
 select ExamGroupID from ECOMMERCE.T_ExamGroup_Master where BrandID in  
 (  
  select CAST(Val as INT) from fnString2Rows(@sBrandID,',')  
 )  
 and StatusID=1  
  
END  
ELSE  
BEGIN  
  
 insert into #EG  
 select ExamGroupID from ECOMMERCE.T_ExamGroup_Master where BrandID in  
 (  
  select CAST(Val as INT) from fnString2Rows(@sBrandID,',')  
 )  
 and StatusID=1  
 and ExamGroupID in  
 (  
  select CAST(Val as INT) from fnString2Rows(@ExamGroupIDs,',')  
 )  
  
  
  
END  
  
  
IF (@ExamCategoryIDs is not null)  
begin  
   
 IF(@CouponID=0)  
 BEGIN  
  
  insert into #Plans  
  select DISTINCT A.PlanID from ECOMMERCE.T_Plan_Product_Map A  
  inner join ECOMMERCE.T_Product_ExamCategory_Map B on A.ProductID=B.ProductID --and B.StatusID=1  
  inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID  
  inner join ECOMMERCE.T_Category_Master D on C.CategoryID=D.ID  
  inner join ECOMMERCE.T_ExamGroup_ExamCategory_Map E on B.ExamCategoryID=E.ExamCategoryID and E.StatusID=1  
  inner join #EG F on F.ExamGroupID=E.ExamGroupID  
  where  
  A.StatusID=1 and B.StatusID=1 and B.ExamCategoryID in  
  (  
   select CAST(Val as INT) from fnString2Rows(@ExamCategoryIDs,',')  
  )  
  and D.StatusID=1  
  and C.CategoryID=ISNULL(@CategoryID,D.ID)  
  and A.ProductID=ISNULL(@ProductID,C.ProductID)  
  
 END  
 ELSE  
 BEGIN  
  
  insert into #Plans  
  select DISTINCT A.PlanID from ECOMMERCE.T_Plan_Product_Map A  
  inner join ECOMMERCE.T_Product_ExamCategory_Map B on A.ProductID=B.ProductID --and B.StatusID=1  
  inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID  
  inner join ECOMMERCE.T_Category_Master D on C.CategoryID=D.ID  
  inner join ECOMMERCE.T_ExamGroup_ExamCategory_Map E on B.ExamCategoryID=E.ExamCategoryID and E.StatusID=1  
  inner join #EG F on F.ExamGroupID=E.ExamGroupID  
  inner join  
  (  
   select DISTINCT T2.PlanID from  
   (  
    select DISTINCT A.CouponID,CAST(C.I_Centre_ID AS VARCHAR(MAX))+'#'+CAST(D.I_Course_ID AS VARCHAR(MAX)) as CenterCourse  
    from ECOMMERCE.T_Coupon_Master A  
    inner join T_Discount_Scheme_Master B on A.DiscountSchemeID=B.I_Discount_Scheme_ID  
    inner join T_Discount_Center_Detail C on B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID and C.I_Status=1  
    inner join T_Discount_Course_Detail D on C.I_Discount_Center_Detail_ID=D.I_Discount_Centre_Detail_ID and D.I_Status=1  
    where A.CouponID=@CouponID  
   ) T1  
   inner join  
   (  
    select DISTINCT A.PlanID,CAST(B.CenterID AS VARCHAR(MAX))+'#'+CAST(C.CourseID AS VARCHAR(MAX)) as CenterCourse   
    from ECOMMERCE.T_Plan_Product_Map A  
    inner join ECOMMERCE.T_Product_Center_Map B on A.ProductID=B.ProductID  
    inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID and C.StatusID=1  
    where  
    A.StatusID=1 and B.StatusID=1  
   ) T2 on T1.CenterCourse=T2.CenterCourse  
  ) CP on A.PlanID=CP.PlanID  
  where  
  A.StatusID=1 and B.StatusID=1 and B.ExamCategoryID in  
  (  
   select CAST(Val as INT) from fnString2Rows(@ExamCategoryIDs,',')  
  )  
  and D.StatusID=1  
  and C.CategoryID=ISNULL(@CategoryID,D.ID)  
  and A.ProductID=ISNULL(@ProductID,C.ProductID)  
  
 END  
  
end  
else  
begin  
  
 IF(@CouponID=0)  
 BEGIN  
  
  insert into #Plans  
  select DISTINCT A.PlanID from ECOMMERCE.T_Plan_Product_Map A  
  inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID  
  inner join ECOMMERCE.T_Category_Master D on C.CategoryID=D.ID  
  --inner join ECOMMERCE.T_Plan_Coupon_Map E on A.PlanID=E.PlanID and E.StatusID=1  
  inner join ECOMMERCE.T_Product_ExamCategory_Map B on A.ProductID=B.ProductID and B.StatusID=1  
  inner join ECOMMERCE.T_ExamGroup_ExamCategory_Map E on B.ExamCategoryID=E.ExamCategoryID and E.StatusID=1  
  inner join #EG F on F.ExamGroupID=E.ExamGroupID  
  where  
  A.StatusID=1  
  and D.StatusID=1  
  and C.CategoryID=ISNULL(@CategoryID,D.ID)  
  and A.ProductID=ISNULL(@ProductID,C.ProductID)  
  
 END  
 ELSE  
 BEGIN  
  
  insert into #Plans  
  select DISTINCT A.PlanID   
  from ECOMMERCE.T_Plan_Product_Map A  
  inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID  
  inner join ECOMMERCE.T_Category_Master D on C.CategoryID=D.ID  
  inner join ECOMMERCE.T_Product_ExamCategory_Map B on A.ProductID=B.ProductID and B.StatusID=1  
  inner join ECOMMERCE.T_ExamGroup_ExamCategory_Map E on B.ExamCategoryID=E.ExamCategoryID and E.StatusID=1  
  inner join #EG F on F.ExamGroupID=E.ExamGroupID  
  inner join  
  (  
   select DISTINCT T2.PlanID from  
   (  
    select DISTINCT A.CouponID,CAST(C.I_Centre_ID AS VARCHAR(MAX))+'#'+CAST(D.I_Course_ID AS VARCHAR(MAX)) as CenterCourse  
    from ECOMMERCE.T_Coupon_Master A  
    inner join T_Discount_Scheme_Master B on A.DiscountSchemeID=B.I_Discount_Scheme_ID  
    inner join T_Discount_Center_Detail C on B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID and C.I_Status=1  
    inner join T_Discount_Course_Detail D on C.I_Discount_Center_Detail_ID=D.I_Discount_Centre_Detail_ID and D.I_Status=1  
    where A.CouponID=@CouponID  
   ) T1  
   inner join  
   (  
    select DISTINCT A.PlanID,CAST(B.CenterID AS VARCHAR(MAX))+'#'+CAST(C.CourseID AS VARCHAR(MAX)) as CenterCourse   
    from ECOMMERCE.T_Plan_Product_Map A  
    inner join ECOMMERCE.T_Product_Center_Map B on A.ProductID=B.ProductID  
    inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID and C.StatusID=1  
    where  
    A.StatusID=1 and B.StatusID=1  
   ) T2 on T1.CenterCourse=T2.CenterCourse  
  ) CP on A.PlanID=CP.PlanID  
  where  
  A.StatusID=1  
  and D.StatusID=1  
  and C.CategoryID=ISNULL(@CategoryID,D.ID)  
  and A.ProductID=ISNULL(@ProductID,C.ProductID)  
  
 END  
  
end  

---storing Exteneded valid planids into Exteneded table : susmita : 2023-jan-24

insert into #ExtendedPlans
SELECT filteredPlan.PlanID from #Plans as filteredPlan
inner join
ECOMMERCE.T_Plan_Master as PM on filteredPlan.PlanID=PM.PlanID
where PM.IsExtendedPlan = 1


---start: Removing of Exteneded plan : 2023-jan-24 : susmita
	
delete filteredPlan from 
#Plans as filteredPlan
inner join
ECOMMERCE.T_Plan_Master as PM on filteredPlan.PlanID=PM.PlanID
where PM.IsExtendedPlan = 1

---end: Removing of Exteneded plan : 2023-jan-24 : susmita


---start 2022-11-10 start plan filter   
  
if(@CustomerID IS NOT NULL) ----  Coded by Soma  
	BEGIN  
  
	create table #RePlans  
	(  
	 PlanID INT  
	)  
	 declare @I_CourseCount int=null;  
  
	 --DECLARE @sCustomerID VARCHAR(MAX) = N'2223000508'  
	 DECLARE @tblCourseList table (I_Course_ID INT)  
	 insert into @tblCourseList  
	 EXEC [ECOMMERCE].[uspGetCustomerPaidStatus] @CustomerID  
	 --SELECT * from @tblCourseList  
   
	 DECLARE @tblRecommended_CourseList table (I_Course_ID INT ,Recommended_Course_ID INT)  
	 insert into @tblRecommended_CourseList  
	 select A.I_Course_ID,B.Recommended_Course_ID  
	 from @tblCourseList A  
	 inner join ECOMMERCE.T_Recommended_Course B on A.I_Course_ID=B.CourseID  
	 where B.I_Status=1  
	 --select * from @tblRecommended_CourseList  

	 

  
	 Select @I_CourseCount=count(I_Course_ID) from @tblCourseList   
  
	  IF (@I_CourseCount <>0)  
	  begin  
	   delete from #Plans where PlanID not in  -- logic changed after discussion with susmita  ( on 01-12-2022 in PROD)
	   (--insert into #Plans   
	   select C.PlanID  
	   from dbo.T_Course_Master A  
       
		 inner join ECOMMERCE.T_Product_Master B on A.I_Course_ID=B.CourseID  
		 inner join ECOMMERCE.T_Plan_Product_Map P on P.ProductID=B.ProductID  
		 inner join ECOMMERCE.T_Plan_Master C on P.PlanID=C.PlanID  
  
		 where A.I_Course_ID in (
		 SELECT A.Recommended_Course_ID from @tblRecommended_CourseList A where A.Recommended_Course_ID not in (SELECT I_Course_ID from @tblCourseList)
		 Union --added by susmita : 2023-feb-03 : include purchase courses also in recommeneded courses
		 SELECT I_Course_ID from @tblCourseList--added by susmita : 2023-feb-03 : include purchase courses also in recommeneded courses
		-- SELECT A.Recommended_Course_ID from @tblRecommended_CourseList A where A.Recommended_Course_ID not in (SELECT I_Course_ID from @tblCourseList) --commenet by susmita : 2023-Feb-3 : For adding purchased as well
		)  
	   )  


	  End 

--start of Exteneded Plan : Susmita : 2023-jan-24

	   --delete the Exteneded plan: susmita : 2023-jan-24
		delete filteredPlan from 
		#Plans as filteredPlan
		inner join
		ECOMMERCE.T_Plan_Master as PM on filteredPlan.PlanID=PM.PlanID
		where PM.IsExtendedPlan = 1

		--populate Exteneded plans
		DECLARE @ExtendedbulkPlan table (PlanID INT)
		DECLARE @PlanIDCount INT = NULL
		insert into @ExtendedbulkPlan  
		EXEC [ECOMMERCE].[uspGetBasicPlansForRecommendedExtendedPlans] @CustomerID 
		select @PlanIDCount=Count(PlanID) from @ExtendedbulkPlan
		IF(@PlanIDCount <> 0)
			BEGIN

				insert into #Plans
				select EP.ExtendedPlanID from 
				#ExtendedPlans EP
				inner join
				@ExtendedbulkPlan EBP on EBP.PlanID=EP.ExtendedPlanID
		
			END
		


--end of Exteneded Plan : Susmita : 2023-jan-24

	END
	
  
  
---soma 2022-11-10 end plan filter  
  
  
-----start 2022-11-10 start plan filter     Comment on 01-12-2022
  
--if(@CustomerID IS NOT NULL) ----  Coded by Soma  
--BEGIN  
  
--create table #RePlans  
--(  
-- PlanID INT  
--)  
-- declare @I_CourseCount int=null;  
  
-- --DECLARE @sCustomerID VARCHAR(MAX) = N'2223000508'  
-- DECLARE @tblCourseList table (I_Course_ID INT)  
-- insert into @tblCourseList  
-- EXEC [ECOMMERCE].[uspGetCustomerPaidStatus] @CustomerID  
-- --SELECT * from @tblCourseList  
   
-- DECLARE @tblRecommended_CourseList table (I_Course_ID INT ,Recommended_Course_ID INT)  
-- insert into @tblRecommended_CourseList  
-- select A.I_Course_ID,B.Recommended_Course_ID  
-- from @tblCourseList A  
-- left join ECOMMERCE.T_Recommended_Course B on A.I_Course_ID=B.CourseID  
-- where B.I_Status=1  
-- --select * from @tblRecommended_CourseList  
  
-- Select @I_CourseCount=count(I_Course_ID) from @tblCourseList   
  
--  IF (@I_CourseCount <>0)  
--  begin  
--   delete from #Plans  
--   insert into #Plans  
--   select C.PlanID  
--   from dbo.T_Course_Master A  
       
--     inner join ECOMMERCE.T_Product_Master B on A.I_Course_ID=B.CourseID  
--     inner join ECOMMERCE.T_Plan_Product_Map P on P.ProductID=B.ProductID  
--     inner join ECOMMERCE.T_Plan_Master C on P.PlanID=C.PlanID  
  
--     where A.I_Course_ID in (SELECT A.Recommended_Course_ID from @tblRecommended_CourseList A where A.Recommended_Course_ID not in (SELECT I_Course_ID from @tblCourseList) )  
  
  
--  End  
  
--END  
  
  
-----soma 2022-11-10 end plan filter   
  
  
  
  
  
  
  
select DISTINCT A.*,
---2023Feb27: Susmita : added for include public and private coupon counts and plan type 
ISNULL(PrivateCP.PrivateCouponCount,0) as PrivateCouponCount,
ISNULL(PublicCP.PublicCouponCount,0) as PublicCouponCount,
PTM.PlanTypeID,PTM.PlanTypeName
--------------------------------------------------------------------------
from ECOMMERCE.T_Plan_Master A  
inner join ECOMMERCE.T_Plan_Brand_Map B on A.PlanID=B.PlanID and B.StatusID=1 
---2023Feb27: Susmita : added for include public and private coupon counts and plantype 
left join ECOMMERCE.PlanTypeMaster as PTM 
on ISNULL(A.PlanType,(select PlanTypeID from ECOMMERCE.PlanTypeMaster where PlanTypeName='General'))=PTM.PlanTypeID
left join
(
	select PC.PlanID,count(*) as PrivateCouponCount
	from ECOMMERCE.T_Plan_Coupon_Map as PC 
	inner join
	(	select DISTINCT TCM.* from ECOMMERCE.T_Coupon_Master TCM 
		inner join T_Discount_Scheme_Master B on TCM.DiscountSchemeID=B.I_Discount_Scheme_ID  
		inner join T_Discount_Center_Detail C on B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID and C.I_Status=1  
		inner join T_Discount_Course_Detail D on C.I_Discount_Center_Detail_ID=D.I_Discount_Centre_Detail_ID and D.I_Status=1
	)as CM  on PC.CouponID=CM.CouponID and CM.IsPrivate=1 and CM.CouponCount > CM.AssignedCount
	where ((CONVERT(DATE,PC.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(PC.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()))  )
	and PC.StatusID=1 and CM.StatusID=1
	and ((CONVERT(DATE,CM.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(CM.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()))  )
	and ((CM.CustomerID IS NULL ) or ISNULL(@CustomerID,'') = CM.CustomerID)
	group by PC.PlanID
) as PrivateCP on PrivateCP.PlanID=A.PlanID
left join
(
	select PC.PlanID,count(*) as PublicCouponCount
	from ECOMMERCE.T_Plan_Coupon_Map as PC 
	inner join
	(	select DISTINCT TCM.* from ECOMMERCE.T_Coupon_Master TCM 
		inner join T_Discount_Scheme_Master B on TCM.DiscountSchemeID=B.I_Discount_Scheme_ID  
		inner join T_Discount_Center_Detail C on B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID and C.I_Status=1  
		inner join T_Discount_Course_Detail D on C.I_Discount_Center_Detail_ID=D.I_Discount_Centre_Detail_ID and D.I_Status=1
	)as CM  on PC.CouponID=CM.CouponID and (CM.IsPrivate=0 or CM.IsPrivate IS NULL)and CM.CouponCount > CM.AssignedCount
	where ((CONVERT(DATE,PC.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(PC.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()))  )
	and PC.StatusID=1 and CM.StatusID=1
	and ((CONVERT(DATE,CM.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(CM.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()))  )
	and ((CM.CustomerID IS NULL ) or ISNULL(@CustomerID,'') = CM.CustomerID)
	group by PC.PlanID
) as PublicCP on PublicCP.PlanID=A.PlanID
---------------------------------------------------------------------------
where   
A.StatusID=1 and A.IsPublished=1 and B.BrandID in (select CAST(Val as INT) from fnString2Rows(@sBrandID,','))  
and (CONVERT(DATE,A.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()))  
and A.PlanID in  
(  
 select PlanID from #Plans  
) order by A.SequenceNo -- added by susmita 2022-09-28  
  
  
select TPC.PlanConfigID,TPC.PlanID,TPC.ConfigID,TCPM.ConfigCode,ISNULL(TPC.ConfigDisplayName,TCPM.ConfigName) as DisplayName,  
ISNULL(TPC.ConfigValue,TCPM.ConfigDefaultValue) as ConfigValue  
from ECOMMERCE.T_Plan_Config TPC  
inner join ECOMMERCE.T_Cofiguration_Property_Master TCPM on TPC.ConfigID=TCPM.ConfigID  
inner join ECOMMERCE.T_Plan_Master TPM on TPC.PlanID=TPM.PlanID  
where TPC.StatusID=1 and TPM.PlanID in  
(  
 select DISTINCT A.PlanID from ECOMMERCE.T_Plan_Master A  
 inner join ECOMMERCE.T_Plan_Brand_Map B on A.PlanID=B.PlanID and B.StatusID=1  
 where   
 A.StatusID=1 and A.IsPublished=1 and B.BrandID in (select CAST(Val as INT) from fnString2Rows(@sBrandID,','))   
 and (CONVERT(DATE,A.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()))  
 and A.PlanID in  
 (  
  select PlanID from #Plans  
 )  
  
)  
  
  
select B.PlanID,A.I_Brand_ID,A.S_Brand_Name from T_Brand_Master A  
inner join  
(  
 select A.PlanID,B.BrandID from ECOMMERCE.T_Plan_Master A  
 inner join ECOMMERCE.T_Plan_Brand_Map B on A.PlanID=B.PlanID and B.StatusID=1  
 where   
 A.StatusID=1 and A.IsPublished=1 and B.BrandID in (select CAST(Val as INT) from fnString2Rows(@sBrandID,','))  
 and (CONVERT(DATE,A.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()))  
 and A.PlanID in  
 (  
  select PlanID from #Plans  
 )  
) B on B.BrandID=A.I_Brand_ID  
  
  
select DISTINCT B.PlanID,A.CategoryID from ECOMMERCE.T_Product_Master A  
inner join ECOMMERCE.T_Plan_Product_Map B on A.ProductID=B.ProductID  
where  
B.StatusID=1 and B.PlanID in  
(  
 select DISTINCT A.PlanID from ECOMMERCE.T_Plan_Master A  
 inner join ECOMMERCE.T_Plan_Brand_Map B on A.PlanID=B.PlanID and B.StatusID=1  
 where   
 A.StatusID=1 and A.IsPublished=1 and B.BrandID in (select CAST(Val as INT) from fnString2Rows(@sBrandID,','))   
 and (CONVERT(DATE,A.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE()))  
 and A.PlanID in  
 (  
  select PlanID from #Plans  
 )  
)  
  
  
END  
