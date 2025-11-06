  
  
--EXEC [USP_ERP_FINE_WAIVEOFF_UPDATE_TEST] 370872,'2025-04-01',null,'TESt1',null,30,  
--1  
  
CREATE  PROC [dbo].[USP_ERP_FINE_WAIVEOFF_UPDATE](            
@INVHEADERID int,@InstallmentDate DATE ,@FineAmount Numeric(12,2)=null      
,@FineWaieveoffRemarks NVARCHAR(100)=null,  
@fixedamount Numeric(12,2)=null, @perceamount Numeric(5,2)=null  
,@iswaiverpartial bit  
)            
AS             
BEGIN     
Declare @s_studentID varchar(100),@I_brandID int,@F_paymentdate Date=Convert(date,Getdate()),  
@CurrFineAmount Numeric(12,2),@tempinvNo Varchar(50),@ActualFineAmount Numeric(12,2)  
  
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
Dt_Installment_Date date,            
InstallmentNo int,    
ActualFineAmount Numeric(12,2),  
FineDiscAmount Numeric(12,2),  
FineAmount numeric(18,2),  
is_waiveoff bit,  
Temp_Inv_No Varchar(100)  
)            
Insert Into #StudentFine(            
StudentID,InvoiceID,Dt_Installment_Date,InstallmentNo,ActualFineAmount,FineDiscAmount,FineAmount,is_waiveoff,Temp_Inv_No           
)            
   EXEC usp_ERP_Fine_CalculateBased_On_Frequency @I_brandID,@s_studentID,@F_paymentdate    
   ----Fetch Current Fine amount------  
   select top 1 @CurrFineAmount=FineAmount ,@tempinvNo=Temp_Inv_No  
   ,@ActualFineAmount=ActualFineAmount  
   from #StudentFine where InvoiceID=@INVHEADERID   
   and Dt_Installment_Date=@InstallmentDate  
  
   ----calculate percentage---  
   IF @iswaiverpartial = 1 and @FineAmount IS NULL  
   Begin  
  IF (@perceamount IS NULL  and @FixedAmount IS NOT NULL)  
  Begin  
SET @perceamount = CAST((@FixedAmount * 100.0 / @ActualFineAmount) AS INT)  
  End  
 IF (@FixedAmount IS NULL and @perceamount IS NOT NULL)  
 Begin  
 SET @FixedAmount=CAST((@ActualFineAmount * @PerceAmount / 100.0) as int)  
 End   
--DECLARE @INVHEADERID int,@InstallmentDate DATE    
  
PRINT   
  CAST(@FixedAmount AS VARCHAR(20)) + ' as FixedAmount & ' +  
  CAST(@PerceAmount AS VARCHAR(20)) + ' as Percentage';  
Print @CurrFineAmount  
Print @FineAmount  
Declare @TotalFinewaieveAmt Numeric(12,2)  
  
UPDATE ICD SET ICD.Is_Fine_waiveroff=0  
--,Is_Fine_waiveroff=Case when @ActualFineAmount=@fixedamount  
--Then 1 else 0 end  
  
,Dt_partialwaeve_off=convert(date,Getdate())--, Fine_waiveroff_Amt= @TotalFinewaieveAmt      
, s_finewaieveoff_remarks=@FineWaieveoffRemarks ,is_Partial_finewaiver= @iswaiverpartial  
,Actual_FineAmount=@ActualFineAmount,FineDiscountPerc=@perceamount,FineDiscountAmount=@fixedamount  
from T_Invoice_Child_Header ICH            
Inner Join T_Invoice_Child_Detail ICD ON ICD.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID            
where ICH.I_Invoice_Header_ID=@INVHEADERID and ICD.Dt_Installment_Date=@InstallmentDate            
      SELECT 1 StatusFlag, 'Fine waiver off Partially Updated.' AS Message;   
  
      End  
      -----Code to be add if partialwaieve is false-----  
      Else  
      IF @iswaiverpartial = 0 and @FineAmount IS NOT NULL  
      Begin  
      UPDATE ICD SET ICD.Is_Fine_waiveroff=1   
      ,dt_Finewaiveroff=Getdate()  
      , Fine_waiveroff_Amt= @FineAmount  
      , s_finewaieveoff_remarks=@FineWaieveoffRemarks     
   from T_Invoice_Child_Header ICH        
   Inner Join T_Invoice_Child_Detail ICD ON ICD.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID        
   where ICH.I_Invoice_Header_ID=@INVHEADERID and ICD.Dt_Installment_Date=@InstallmentDate        
      SELECT 1 StatusFlag, 'Fine waiver off updated successfully.' AS Message;   
      End  
          
END 