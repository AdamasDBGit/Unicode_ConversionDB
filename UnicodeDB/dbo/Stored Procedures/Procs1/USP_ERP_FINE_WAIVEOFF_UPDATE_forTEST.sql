
        
 --Alter Table T_Invoice_Child_Detail        
 --Add s_finewaieveoff_remarks varchar(100)     
    -- EXEC [USP_ERP_FINE_WAIVEOFF_UPDATE_forTEST] 421112,'2025-08-01',550,'Partial_Test1'
CREATE PROC [dbo].[USP_ERP_FINE_WAIVEOFF_UPDATE_forTEST](          
@INVHEADERID int,@InstallmentDate DATE ,@FineAmount Numeric(12,2)=null    
,@FineWaieveoffRemarks NVARCHAR(100),@FineAmountPerc int=NULL       
)          
AS           
BEGIN   
Declare @s_studentID varchar(100),@I_brandID int,@F_paymentdate Date=Convert(date,Getdate()),
@CurrFineAmount Numeric(12,2)

Select top 1 @s_studentID=sd.S_Student_ID,@I_brandID=bcd.I_Brand_ID 
from T_Invoice_Parent ivp
Inner Join T_Student_Detail sd on sd.I_Student_Detail_ID=ivp.I_Student_Detail_ID
Inner Join T_Brand_Center_Details bcd on bcd.I_Centre_Id=ivp.I_Centre_Id
where I_Invoice_Header_ID=@INVHEADERID

IF OBJECT_ID('tempdb..#StudentFine') IS NOT NULL          
BEGIN          
    DROP TABLE #StudentFine;          
END;          
Create Table #StudentFine(          
          
StudentID Varchar(20),          
InvoiceID Bigint,          
--T_Invoice_Child_Header bigint,          
Dt_Installment_Date date,          
InstallmentNo int,  
ActualFineAmount Numeric(12,2),
FineAmount numeric(18,2),
is_waiveoff bit,
Temp_Inv_No Varchar(100)
)          
Insert Into #StudentFine(          
StudentID,InvoiceID,Dt_Installment_Date,InstallmentNo,ActualFineAmount,FineAmount,is_waiveoff,Temp_Inv_No         
)          
   EXEC usp_ERP_Fine_CalculateBased_On_Frequency_TEST @I_brandID,@s_studentID,@F_paymentdate  
   ----Fetch Current Fine amount------
   select top 1 @CurrFineAmount=FineAmount 
   from #StudentFine where InvoiceID=@INVHEADERID 
   and Dt_Installment_Date=@InstallmentDate
--DECLARE @INVHEADERID int,@InstallmentDate DATE  
Print @CurrFineAmount
Print @FineAmount
Declare @TotalFinewaieveAmt Numeric(12,2)
Insert Into T_ERP_FineWaiver_History_Captured(

I_Invoice_Header_ID
,Dt_Installment_Date
,S_Invoice_No
,dt_Finewaiveroff
,Fine_waiveroff_Amt
,FineWaieveoffRemarks
)
Values(@INVHEADERID,@InstallmentDate,null,Getdate(),@FineAmount,@FineWaieveoffRemarks)
Set @TotalFinewaieveAmt=(
Select SUM(Fine_waiveroff_Amt) from T_ERP_FineWaiver_History_Captured where I_Invoice_Header_ID=@INVHEADERID
and Dt_Installment_Date=@InstallmentDate
)
UPDATE ICD SET ICD.Is_Fine_waiveroff=Case when @FineAmount=@CurrFineAmount Then 1
When @FineAmount<@CurrFineAmount Then 0 end 

,dt_Finewaiveroff=Getdate(), Fine_waiveroff_Amt= @TotalFinewaieveAmt    
, s_finewaieveoff_remarks=@FineWaieveoffRemarks       
from T_Invoice_Child_Header ICH          
Inner Join T_Invoice_Child_Detail ICD ON ICD.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID          
where ICH.I_Invoice_Header_ID=@INVHEADERID and ICD.Dt_Installment_Date=@InstallmentDate          
      SELECT 1 StatusFlag, 'Fine waiver off updated successfully.' AS Message;          
        
END    

