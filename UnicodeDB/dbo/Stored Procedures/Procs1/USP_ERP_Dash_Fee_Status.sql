--EXEC USP_ERP_Dash_Fee_Status 107,35
CREATE Proc [dbo].[USP_ERP_Dash_Fee_Status](  
@brandID int,
@SessionID int
)  
as  
begin  
--Declare @brandID int,@SessionID int
--SET @brandID=107
--SET @SessionID=35

DECLARE @SessionInv TABLE
(Inv_HeaderID bigint, 
 N_Amount Numeric(18,2)
 ,Inv_Dt date
)
Declare @FYStartdt date,@FYEndDt date
select @FYStartdt=Convert(date,Dt_Session_Start_Date)
,@FYEndDt=Convert(date,Dt_Session_End_Date)
from T_School_Academic_Session_Master where I_School_Session_ID=@SessionID

Insert Into @SessionInv(Inv_HeaderID,N_Amount,Inv_Dt)
select INVP.I_Invoice_Header_ID,INVP.N_Invoice_Amount,convert(date,INVP.Dt_Invoice_Date )   
from T_Invoice_Parent INVP  
Inner Join T_Brand_Center_Details BCD on BCD.I_Centre_Id=INVP.I_Centre_Id  
where BCD.I_Brand_ID=@brandID 
and convert(date,Dt_Invoice_Date) between @FYStartdt and @FYEndDt

--Select * From @SessionInv


Declare @TotalInvamt Numeric(18,2)  

select @TotalInvamt= ISNULL(SUM(N_Amount),0) from  @SessionInv
--Select @TotalInvamt

Declare @ReceiptAMt Numeric(18,2)  ,@TodaysReceiptamt Numeric(18,2)

Select @ReceiptAMt=SUM(N_Receipt_Amount)  from T_Receipt_Header RH  
Inner Join T_Brand_Center_Details BCD on BCD.I_Centre_Id=RH.I_Centre_Id  
Inner Join @SessionInv DT on DT.Inv_HeaderID=RH.I_Invoice_Header_ID
where BCD.I_Brand_ID=@brandID 
--and convert(date,Dt_Receipt_Date)=CONVERT(date,Getdate()) 

Select @TodaysReceiptamt=ISNULL(SUM(N_Receipt_Amount),0)  
from T_Receipt_Header RH  
Inner Join T_Brand_Center_Details BCD on BCD.I_Centre_Id=RH.I_Centre_Id  
where BCD.I_Brand_ID=@brandID 
and convert(date,Dt_Receipt_Date)=CONVERT(date,Getdate())  
  -----Final Output------------------
--Select 
--@TotalInvamt as Yearly_Inv_Amt 
--,@ReceiptAMt as Yearly_Collected_Amt
--,(@TotalInvamt-@ReceiptAMt) as Yearly_Due_Amt
--,@TodaysReceiptamt as Today_Collection

SELECT 
    Yearly_Inv_Amt,
    Yearly_Collected_Amt,
    Yearly_Due_Amt,
    Today_Collection,
    CAST(ROUND((Yearly_Collected_Amt * 100.0 / NULLIF(Yearly_Inv_Amt, 0)), 0) AS INT) AS CollectionPercent
FROM (
    SELECT 
        @TotalInvamt AS Yearly_Inv_Amt,
        @ReceiptAMt AS Yearly_Collected_Amt,
        (@TotalInvamt - @ReceiptAMt) AS Yearly_Due_Amt,
        @TodaysReceiptamt AS Today_Collection
) AS subquery;

End

