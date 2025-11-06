CREATE FUNCTION [dbo].[fnCalculateTaxAmountForFeeStructure]      
(      
 @CourseFeePlanID INT,
 @PaymentMode VARCHAR(2)
)      
RETURNS NUMERIC(18,2)      
AS      
BEGIN      
 DECLARE @nTotalTax NUMERIC(18,2)
 DECLARE @MinInst INT=1
     
 IF(@PaymentMode='L')
 BEGIN

 select @nTotalTax=T1.TaxAmount from
 (
	 select A.I_Course_Fee_Plan_ID,SUM(((A.I_Item_Value*B.N_Tax_Rate)/100)) as TaxAmount 
	 from T_Course_Fee_Plan_Detail A
	 inner join T_Tax_Country_Fee_Component B on A.I_Fee_Component_ID=B.I_Fee_Component_ID
	 where
	 A.I_Course_Fee_Plan_ID=@CourseFeePlanID and A.I_Installment_No=0 and A.I_Item_Value>0 and A.I_Status=1
	 and B.Dt_Valid_To>=GETDATE()
	 group by A.I_Course_Fee_Plan_ID
 ) T1

 END

  IF(@PaymentMode='IA')
BEGIN

select @nTotalTax=T1.TaxAmount from
(
	select A.I_Course_Fee_Plan_ID,SUM(((A.I_Item_Value*B.N_Tax_Rate)/100)) as TaxAmount 
	from T_Course_Fee_Plan_Detail A
	inner join T_Tax_Country_Fee_Component B on A.I_Fee_Component_ID=B.I_Fee_Component_ID
	where
	A.I_Course_Fee_Plan_ID=@CourseFeePlanID and A.I_Installment_No>0 and A.I_Item_Value>0 and A.I_Status=1
	and B.Dt_Valid_To>=GETDATE()
	group by A.I_Course_Fee_Plan_ID
) T1

END

 IF(@PaymentMode='I')
 BEGIN

 select @MinInst=MIN(I_Installment_No)
 from T_Course_Fee_Plan_Detail where I_Course_Fee_Plan_ID=@CourseFeePlanID and I_Installment_No>0

 select @nTotalTax=T1.TaxAmount from
 (
	 select A.I_Course_Fee_Plan_ID,SUM(((A.I_Item_Value*B.N_Tax_Rate)/100)) as TaxAmount 
	 from T_Course_Fee_Plan_Detail A
	 inner join T_Tax_Country_Fee_Component B on A.I_Fee_Component_ID=B.I_Fee_Component_ID
	 where
	 A.I_Course_Fee_Plan_ID=@CourseFeePlanID and A.I_Installment_No=@MinInst and A.I_Item_Value>0 and A.I_Status=1
	 and B.Dt_Valid_To>=GETDATE()
	 group by A.I_Course_Fee_Plan_ID
 ) T1

 END

       
 RETURN @nTotalTax      
END