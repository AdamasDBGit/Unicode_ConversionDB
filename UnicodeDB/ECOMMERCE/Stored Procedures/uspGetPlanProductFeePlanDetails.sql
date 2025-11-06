CREATE PROCEDURE [ECOMMERCE].[uspGetPlanProductFeePlanDetails](@PlanDetailID INT)
AS
begin

	select TPFP.*,TCFP.S_Fee_Plan_Name,TCFP.N_TotalLumpSum,TCFP.N_TotalInstallment,ISNULL(FPD.N_No_Of_Installments,0) as N_No_Of_Installments
	from ECOMMERCE.T_Product_FeePlan TPFP
	inner join T_Course_Fee_Plan TCFP on TPFP.CourseFeePlanID=TCFP.I_Course_Fee_Plan_ID
	left join
	(
		select I_Course_Fee_Plan_ID,COUNT(DISTINCT I_Installment_No) as N_No_Of_Installments 
		from T_Course_Fee_Plan_Detail
		where
		I_Installment_No>0 and I_Item_Value>0
		group by I_Course_Fee_Plan_ID
	) FPD on TCFP.I_Course_Fee_Plan_ID=FPD.I_Course_Fee_Plan_ID
	where
	TPFP.ProductCentreID in
	(
		select ProductCentreID from ECOMMERCE.T_Plan_Details where PlanDetailID=@PlanDetailID
	)
	and TPFP.StatusID=1 and TPFP.IsPublished=1 and (TPFP.ValidFrom<=GETDATE() and ISNULL(TPFP.ValidTo,GETDATE())>=GETDATE())

end
