-- =============================================                              
--Procedure: usp_ERP_Fee_InstallmentPayment                                  
-- Author:      Abhik Porel                              
-- Create date: 02.01.2024                              
-- Description: Generate FEE Installment                 
              
-- exec [dbo].[usp_ERP_Fee_InstallmentPayable] 1153, 35, 0                
-- =============================================                         
 --exec [dbo].[usp_ERP_GetAdmissionFeesDetails] 234926,107,1                 
CREATE PROCEDURE [dbo].[usp_ERP_Fee_InstallmentPayable]                  
(                  
    @Fee_Structure_ID int ,              
    @School_Session_ID int,            
    @PaymentType NVARCHAR(MAX)=Null      --- for insatllment 0 || lumsum 1            
)                  
As                  
Begin                  
    SET NOCOUNT ON;                  
    --Drop  table #Stud_Fee_Installment              
 --Drop table #FinalInstallment              
    --Declare                       
    --@Fee_Structure_ID int ,@School_Session_ID int,@PaymentType int                      
    --SET @Fee_Structure_ID=44                      
    --SET @School_Session_ID=2                      
    --SET @PaymentType=1                  
    ---------------------------------------------------------                    
    Declare @sessionstDt date,                  
            @sessionEndDt Date                  
                  
   -- select @sessionstDt = Convert(Date, Dt_Session_Start_Date),            
   ----@sessionstDt = Convert(varchar, Dt_Session_Start_Date,107),              
   --        @sessionEndDt = Convert(Date, Dt_Session_End_Date)                  
   -- from T_School_Academic_Session_Master                  
   -- where I_School_Session_ID = @School_Session_ID  
	select @sessionstDt=Convert(date,Dt_StartDt)
	,@sessionEndDt=convert(date,Dt_EndDt )
	from T_ERP_Fee_Structure where I_Fee_Structure_ID=@Fee_Structure_ID
	Declare @MonthDiff int
	SET @MonthDiff=(SELECT DATEDIFF(MONTH, @sessionstDt, @sessionEndDt) + 1 )
	
   -- Select @sessionstDt,@sessionEndDt                      
      --Select * from T_School_Academic_Session_Master            
 ------------------------------------------------------------------------------------             
 -------Create Temp table Store GST Details Component wise-----------      
 Create Table #TempComponent_GST (      
 I_ID int Identity(1,1),      
 I_Fee_Structure_ID int,      
 I_Fee_Component_ID int,      
 CGST_Amt Numeric(18,2),      
 SGST_Amt Numeric(18,2),      
 IGST_Amt Numeric(18,2),      
 CGST_Per Numeric(10,2),      
 SGST_Per Numeric(10,2),      
 IGST_Per numeric(10,2)      
      
 )      
Insert Into #TempComponent_GST (I_Fee_Structure_ID,I_Fee_Component_ID,CGST_Amt,SGST_Amt,IGST_Amt,      
CGST_Per,SGST_Per,IGST_Per)      
EXEC ERP_get_FEE_Structure_GST_Generation @Fee_Structure_ID,@PaymentType      
-----------     -----------------------------------------------------------      
        SELECT IDENTITY(INT, 1, 1) AS ID,                  
     TEFS.I_Fee_Structure_ID,              
     TEFS.S_Fee_Structure_Name,              
     --TEFS.N_Total_OneTime_Amount,              
     TEFS.I_Currency_Type_ID,              
     --TEFS.N_Total_Installment_Amount,              
     TEFSIC.I_Fee_Structure_Installment_Component_ID,              
     TEFSIC.N_Component_Actual_Total_Annual_Amount,        
  --(TEFSIC.N_Component_Actual_Total_Annual_Amount+t2.IGST_Amt) as  ComponentAmt_IncludeTAX,      
     TEFSIC.R_I_Fee_Component_ID,              
     TEFC.S_Component_Name,              
     TEFSIC.R_I_Fee_Pay_Installment_ID,              
     TEFPT.I_Pay_InstallmentNo,              
     TEFPT.S_Installment_Frequency,              
     TEFPT.I_Interval,              
     TEFSIC.I_Seq_No,              
     TEFSIC.Is_OneTime,      
  t2.CGST_Amt,      
     t2.SGST_Amt,      
     t2.IGST_Amt,      
  t2.CGST_Per,      
  t2.SGST_Per,      
  t2.IGST_Per      
             
    Into #Stud_Fee_Installment                  
    from T_ERP_Fee_Structure TEFS                  
    Inner Join T_ERP_Fee_Structure_Installment_Component TEFSIC 
on TEFS.I_Fee_Structure_ID = TEFSIC.R_I_Fee_Structure_ID                  
   Inner Join T_ERP_Fee_PaymentInstallment_Type TEFPT 
   on TEFSIC.R_I_Fee_Pay_Installment_ID = TEFPT.I_Fee_Pay_Installment_ID               
  Inner Join T_Fee_Component_Master TEFC on TEFSIC.R_I_Fee_Component_ID = TEFC.I_Fee_Component_ID      
  Left Join #TempComponent_GST t2 On TEFS.I_Fee_Structure_ID=t2.I_Fee_Structure_ID      
   and TEFSIC.R_I_Fee_Component_ID=t2.I_Fee_Component_ID      
    where TEFS.I_Fee_Structure_ID = @Fee_Structure_ID   
	and TEFSIC.Is_OneTime= @PaymentType       
   -- select * from  #Stud_Fee_Installment  
  --Print 12            
    --Select * from #Stud_Fee_Installment      
   --Drop table #Stud_Fee_Installment      
   --drop table #TempComponent_GST 
   If @MonthDiff <12
	Begin 
	update  #Stud_Fee_Installment set I_Pay_InstallmentNo=@MonthDiff
	where I_Interval=1
	End 
  --------------------------------------------------------------------------------------              
     If   @PaymentType =1        
  Begin        
     select  I_Fee_Structure_Installment_Component_ID As I_Fee_Component_InstallmentID,        
   t1.I_Fee_Structure_ID As R_I_Fee_Structure_ID,        
   S_Fee_Structure_Name As S_Fee_Structure_Name,        
   t1.R_I_Fee_Component_ID As Fee_ComponentID,        
   S_Component_Name as S_Fee_Component_Name,        
   I_Seq_No as I_Seq_No,        
   CONVERT(varchar,@sessionstDt,107) As Dt_Payment_Installment_Dt ,        
  -- @sessionstDt as Dt_Payment_Installment_Dt,        
   CEILING(N_Component_Actual_Total_Annual_Amount) as N_Installment_Amount,      
   CEILING(N_Component_Actual_Total_Annual_Amount+IGST_Amt) as Installment_Amt_IncludeTAX  ,      
   Is_OneTime as Is_OneTime,        
   1 As DateWiseInstallmentSequenceNo,        
   Case When Is_OneTime=1 Then (Select top 1 I_Fee_Pay_Installment_ID         
   from T_ERP_Fee_PaymentInstallment_Type Where I_Pay_InstallmentNo=1)         
   End AS I_Fee_Pay_Installment_ID ,      
   CEILING(CGST_Amt) as CGST_Amt,      
   CEILING(SGST_Amt) as SGST_Amt,      
   CEILING(IGST_Amt) as IGST_Amt ,      
   CGST_Per,      
   SGST_Per,      
   IGST_Per      
   Into #OneTimePaymentDetails        
   from #Stud_Fee_Installment t1      
   where Is_OneTime=@PaymentType         
        
   Select * from #OneTimePaymentDetails        
      
   Select SUM(N_Installment_Amount) as Total_AMt,  
   SUM(CGST_Amt) as Total_CGST_AMt,      
   SUM(SGST_Amt) as Total_SGST_AMt,      
   SUM(IGST_Amt) as Total_IGST_AMt     
   ,1 as DateWiseInstallmentSequenceNo,        
   Dt_Payment_Installment_Dt  As Dt_Payment_Installment_Dt        
   from #OneTimePaymentDetails        
   Group by Dt_Payment_Installment_Dt       
         
   Select SUM(N_Installment_Amount) as ComponentTotalAmount,  
   --SUM( IGST_Amt) Total_TAXAmount    
    SUM(CGST_Amt) as Total_CGSt,      
 SUM(SGST_Amt) as Total_SGST,      
 SUM(IGST_Amt) as Total_IGSt   
   from #OneTimePaymentDetails        
  End        
  Else        
  Begin        
    Create Table #FinalInstallment                  
    (                  
        ID int Identity(1, 1),               
     I_Fee_Structure_Installment_Component_ID int,            
        Fee_Structure_ID int,             
     S_Fee_Structure_Name VARCHAR(MAX),            
        Fee_ComponentID int,             
     S_Fee_Component_Name VARCHAR(MAX),            
        Seq int,                
        Installmentdt date,                  
        Installment_Amt Numeric(18, 2),      
  Installment_Amt_IncludeTAX Numeric(18,2),      
        Is_OneTime int,              
  PaymentInstallmentID int,      
  CGST_Amt Numeric(18,2),      
  SGST_Amt Numeric(18,2),      
  IGST_Amt Numeric(18,2),      
  CGST_Per Numeric(10,2),      
  SGST_Per Numeric(10,2),      
  IGST_Per Numeric(10,2)      
    )                  
    Declare @FeeStructureInstallmentComponentID int,            
   @FeeStrucID int,                
   @FeeStrucName VARCHAR(MAX),            
            @Fee_ComponentID int,             
   @Fee_ComponentName VARCHAR(MAX),            
            @seq int,                
            @ComponentAmt Numeric(18, 2),      
   @ComponentAmt_IncludeTAX numeric(18,2),      
            @installno int,                  
            @interval int,     
            @status Int,                  
            @lst int,                  
            @ID int = 1,              
            @Is_OneTime int,            
            @PaymentInstallmentID int,      
   @CGSTVal Numeric(18,2),      
   @SGSTVal Numeric(18,2),      
   @IGSTval Numeric(18,2),      
   @CGST_Per Numeric(10,2),      
   @SGST_Per Numeric(10,2),      
   @IGST_Per Numeric(10,2)      
   --@DateWiseInstallmentSequenceNo int            
    SET @lst =                  
    (                  
        select max(ID) from #Stud_Fee_Installment            )                  
    WHILE @ID <= @lst                  
    Begin                  
                  
        --select * from #Stud_Fee_Installment                      
        select Top 1                
   @FeeStructureInstallmentComponentID = I_Fee_Structure_Installment_Component_ID,            
            @FeeStrucID = I_Fee_Structure_ID,             
   @FeeStrucName = S_Fee_Structure_Name,            
            @Fee_ComponentID = R_I_Fee_Component_ID,              
   @Fee_ComponentName = S_Component_Name,            
            @seq=I_Seq_No,                
            @ComponentAmt = N_Component_Actual_Total_Annual_Amount,       
   --@ComponentAmt_IncludeTAX=ComponentAmt_IncludeTAX,      
            @installno = I_Pay_InstallmentNo,                  
            @interval = I_Interval,                  
            @Is_OneTime = Is_OneTime,            
   @PaymentInstallmentID = R_I_Fee_Pay_Installment_ID  ,      
   @CGSTVal=CGST_Amt,      
   @SGSTVal=SGST_Amt,      
   @IGSTval=IGST_Amt,      
   @CGST_Per=CGST_Per,      
   @SGST_Per=SGST_Per,      
   @IGST_Per=IGST_Per      
   --@DateWiseInstallmentSequenceNo = 1            
                 
        from #Stud_Fee_Installment                  
        where ID = @ID                  
              
                  
        If @interval <> 0                  
        Begin                  
            SELECT @interval As Interval,                  
                   InstallmentDate                  
            Into #IntervalInstallment                  
            FROM dbo.GetInstallmentDatesInFinancialYear(@sessionstDt, @sessionEndDt, @sessionstDt, @interval);                  
            Insert Into #FinalInstallment                  
            (                  
    I_Fee_Structure_Installment_Component_ID,            
                Fee_Structure_ID,             
    S_Fee_Structure_Name,            
                Fee_ComponentID,              
    S_Fee_Component_Name,            
                Seq,               
                Installmentdt,                  
                Installment_Amt,       
    Installment_Amt_IncludeTAX,      
                Is_OneTime,            
    PaymentInstallmentID   ,      
 CGST_Amt,      
 SGST_Amt,      
 IGST_Amt,      
 CGST_Per,      
 SGST_Per,      
 IGST_Per      
    --DateWiseInstallmentSequenceNo            
      )                  
            Select fi.I_Fee_Structure_Installment_Component_ID,            
                   fi.I_Fee_Structure_ID,              
       fi.S_Fee_Structure_Name,            
                   fi.R_I_Fee_Component_ID,            
       fi.S_Component_Name,            
                   FI.I_Seq_No,              
                   ii.InstallmentDate,              
       --CONVERT(varchar,ii.InstallmentDate,107),            
                   CEILING((Convert(Numeric(18, 2), (fi.N_Component_Actual_Total_Annual_Amount / fi.I_Pay_InstallmentNo)))) as InstallmentAmount,                  
                  CEILING(( Convert(Numeric(18, 2), (fi.N_Component_Actual_Total_Annual_Amount / fi.I_Pay_InstallmentNo))+(fi.IGST_Amt / fi.I_Pay_InstallmentNo)))  ,      
       Is_OneTime,            
       fi.R_I_Fee_Pay_Installment_ID,      
    CEILING(fi.CGST_Amt / fi.I_Pay_InstallmentNo) As CGSTAmount,      
    CEILING(fi.SGST_Amt / fi.I_Pay_InstallmentNo) As SGSTAmount,      
    CEILING(fi.IGST_Amt / fi.I_Pay_InstallmentNo) As IGSTAmount,      
    CGST_Per,      
 SGST_Per,      
    IGST_Per      
       --DENSE_RANK() OVER (ORDER BY ii.InstallmentDate)            
            from #IntervalInstallment ii                  
                Left Join #Stud_Fee_Installment fi                  
                    on ii.Interval = fi.I_Interval                  
            where fi.ID = @ID                  
                  
        End                  
        Else                  
        Begin                  
            Insert Into #FinalInstallment                  
            (                     
     I_Fee_Structure_Installment_Component_ID,            
            Fee_Structure_ID,               
     S_Fee_Structure_Name,            
                 Fee_ComponentID,               
     S_Fee_Component_Name,            
                Seq,              
                Installmentdt,                  
                Installment_Amt,      
    Installment_Amt_IncludeTAX,      
                Is_OneTime,            
    PaymentInstallmentID,      
 CGST_Amt,      
 SGST_Amt,      
 IGST_Amt,      
 CGST_Per,      
 SGST_Per,      
 IGST_Per      
    --DateWiseInstallmentSequenceNo            
            )                  
            Select                   
       @FeeStructureInstallmentComponentID,            
                   @FeeStrucID,              
       @FeeStrucName,            
        @Fee_ComponentID,             
       @Fee_ComponentName,            
                   @seq,              
                   @sessionstDt,                  
                   @ComponentAmt,       
       @ComponentAmt+@IGSTval,      
                   @Is_OneTime,            
       @PaymentInstallmentID,      
    @CGSTVal,      
    @SGSTVal,      
    @IGSTval,      
    @CGST_Per,      
    @SGST_Per,      
    @IGST_Per      
       End                  
                  
        IF OBJECT_ID(N'tempdb..#IntervalInstallment') IS NOT NULL                  
        BEGIN                  
            DROP TABLE #IntervalInstallment                  
        END                  
        Set @ID = @ID + 1                  
    END               
             
            
            
   Select I_Fee_Structure_Installment_Component_ID as I_Fee_Component_InstallmentID,            
  Fee_Structure_ID as R_I_Fee_Structure_ID,            
  S_Fee_Structure_Name,            
  Fee_ComponentID,            
  S_Fee_Component_Name,            
  Seq,            
  --Installmentdt,            
  CONVERT(varchar,Installmentdt,107) as Dt_Payment_Installment_Dt,            
  Installment_Amt as N_Installment_Amount,       
  Installment_Amt_IncludeTAX,      
  Is_OneTime,            
  DENSE_RANK() OVER (ORDER BY Installmentdt) as DateWiseInstallmentSequenceNo,            
  PaymentInstallmentID,      
  CGST_Amt,      
  SGST_Amt,      
  IGST_Amt,      
  CGST_Per,      
  SGST_Per,      
  IGST_Per      
 from #FinalInstallment            
 where Is_OneTime = @PaymentType            
 order by Seq            
            
            
 --select SUM(Installment_Amt)as Total_AMt,            
 ----Select SUM() as total            
 --DENSE_RANK() OVER (ORDER BY Installmentdt) as DateWiseInstallmentSequenceNo,            
 --CONVERT(varchar,Installmentdt,107) as Dt_Payment_Installment_Dt            
            
            
            
 --from #FinalInstallment             
             
 --Where Is_OneTime = @PaymentType            
 --Group by Installmentdt            
 --order by Installmentdt             
  select SUM(Installment_Amt)as Total_AMt, SUM(CGST_Amt) as Total_CGST_AMt ,      
  SUM(SGST_Amt) as Total_SGST_AMt,      
  SUM(IGST_Amt) as Total_IGST_AMt,      
 --Select SUM() as total            
 DENSE_RANK() OVER (ORDER BY Installmentdt) as DateWiseInstallmentSequenceNo,            
 CONVERT(varchar,Installmentdt,107) as Dt_Payment_Installment_Dt            
            
            
 Into #TotalFinalAMt            
 from #FinalInstallment             
             
 Where Is_OneTime = @PaymentType            
 Group by Installmentdt            
 order by Installmentdt             
 Select * from #TotalFinalAMt            
 Select Sum(Total_AMt) as ComponentTotalAmount,      
 SUM(Total_CGST_AMt) as Total_CGSt,      
 SUM(Total_SGST_AMt) as Total_SGST,      
 SUM(Total_IGST_AMt) as Total_IGSt      
 from #TotalFinalAMt            
            
 Drop table #TotalFinalAMt          
        
            
                     
    IF OBJECT_ID(N'tempdb..#FinalInstallment') IS NOT NULL                  
    BEGIN                  
        DROP TABLE #FinalInstallment                  
    END         
 End        
    IF OBJECT_ID(N'tempdb..#Stud_Fee_Installment') IS NOT NULL                  
    BEGIN                  
        DROP TABLE #Stud_Fee_Installment                  
    END                  
--END              
END    -----          
                  
--EXEC usp_ERP_Fee_InstallmentPayment 1,1,1

