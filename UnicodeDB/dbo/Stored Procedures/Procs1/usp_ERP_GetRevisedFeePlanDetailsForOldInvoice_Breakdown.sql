


CREATE PROCEDURE [dbo].[usp_ERP_GetRevisedFeePlanDetailsForOldInvoice_Breakdown] --uspGetFeePlanDetailsForOldInvoice 168864, 37602
( 
	@iOldInvoiceHeaderID INT,
	@Fee_Structure_ID int ,            
    @School_Session_ID int,          
    @PaymentType bit=Null      --- for insatllment 0 || lumsum 1
)
AS 
BEGIN      
    SET NOCOUNT ON  
	

	 Declare @sessionstDt date,                
            @sessionEndDt Date                
                
  select @sessionstDt = Convert(Date, Dt_Session_Start_Date),          
   --@sessionstDt = Convert(varchar, Dt_Session_Start_Date,107),            
  @sessionEndDt = Convert(Date, Dt_Session_End_Date)                
  from T_School_Academic_Session_Master                
  where I_School_Session_ID = @School_Session_ID and I_Current_Session=1


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



DECLARE @NewFeeStructureName varchar(max)=NULL


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
        Inner Join T_ERP_Fee_Structure_Installment_Component TEFSIC on TEFS.I_Fee_Structure_ID = TEFSIC.R_I_Fee_Structure_ID                
        Inner Join T_ERP_Fee_PaymentInstallment_Type TEFPT on TEFSIC.R_I_Fee_Pay_Installment_ID = TEFPT.I_Fee_Pay_Installment_ID             
  Inner Join T_Fee_Component_Master TEFC on TEFSIC.R_I_Fee_Component_ID = TEFC.I_Fee_Component_ID    
  Left Join #TempComponent_GST t2 On TEFS.I_Fee_Structure_ID=t2.I_Fee_Structure_ID    
   and TEFSIC.R_I_Fee_Component_ID=t2.I_Fee_Component_ID    
    where TEFS.I_Fee_Structure_ID = @Fee_Structure_ID  --  and TEFSIC.Is_OneTime= @PaymentType 

	select top 1 @NewFeeStructureName=S_Fee_Structure_Name from #Stud_Fee_Installment

	--select * from #Stud_Fee_Installment


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
					  IGST_Per Numeric(10,2) ,
					  Interval int
						)   
						

				insert into #FinalInstallment
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
					  IGST_Per ,
					  Interval 
				)

				select 
				FSSIB.I_Fee_Structure_Installment_Component_ID,
				FSSIB.I_Fee_Structure_ID,
				EFS.S_Fee_Structure_Name,
				FSSIB.R_I_Fee_Component_ID,
				NULL,
				FSSIB.I_Seq_No,
				FSSIB.Expected_Installment_Date,
				FSSIB.N_Component_Actual_Total_Annual_Amount,
				FSSIB.N_Component_Actual_Total_Annual_Amount+ISNULL(FSSIB.IGST_value,0),
				FSSIB.Is_OneTime,
				FSSIB.R_I_Fee_Pay_Installment_ID,
				FSSIB.CGST_value,
				FSSIB.SGST_value,
				FSSIB.IGST_value,
				FSSIB.CGST_Perc,
				FSSIB.SGST_Perc,
				FSSIB.IGST_Perc,
				NULL

				from T_ERP_Fee_Structure_Session_Installment_Breakup as FSSIB
				inner join
				T_ERP_Fee_Structure_AcademicSession_Map as FSAM on FSSIB.I_Fee_Structure_AcademicSession_Map_ID=FSAM.I_Fee_Structure_AcademicSession_Map_ID
				inner join
				T_School_Academic_Session_Master as SASM on FSAM.I_School_Session_ID=SASM.I_School_Session_ID
				inner join
				T_ERP_Fee_Structure as EFS on EFS.I_Fee_Structure_ID=FSSIB.I_Fee_Structure_ID
				--inner join
				--T_Fee_Component_Master as FCM2 on FSSIB.R_I_Fee_Component_ID=FCM2.I_Fee_Component_ID
				where SASM.I_School_Session_ID=@School_Session_ID and FSSIB.I_Fee_Structure_ID=@Fee_Structure_ID


				select 'new Feeschedule' as newfee
				select * from #FinalInstallment

				SELECT * INTO #FinalRemainingReviseInstallment FROM #FinalInstallment;


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


						
--- Start: Fee paid

CREATE TABLE #FeePaid
(I_Fee_Component_ID int
       ,I_Item_Value numeric(18,2)
    ) 

	
	insert into #FeePaid
	(
	I_Fee_Component_ID, 
    I_Item_Value
    
	)

	select ICD.I_Fee_Component_ID,
	SUM(RCD.N_Amount_Paid)
	from 
	T_Receipt_Header as RH
	inner join
	T_Receipt_Component_Detail as RCD on RH.I_Receipt_Header_ID=RCD.I_Receipt_Detail_ID
	inner join 
	T_invoice_Child_Detail as ICD on RCD.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
	inner join
	T_invoice_Child_Header as ICH on ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID and ICH.I_Course_FeePlan_ID IS NOT NULL
	inner join
	T_invoice_Parent as TIP2 on ICH.I_Invoice_Header_ID= TIP2.I_Invoice_Header_ID 
	where TIP2.I_Invoice_Header_ID=@iOldInvoiceHeaderID and RH.I_Status=1
	group by ICD.I_Fee_Component_ID

	select 'old #FeePaid' as newfee
	select * from #FeePaid


	select 'newonecomponentgroup' as newgroupwiseampount
	select Fee_ComponentID,SUM(Installment_Amt) as Amount  from #FinalInstallment group by Fee_ComponentID
	select I_Fee_Component_ID,I_Item_Value from #FeePaid as FP inner join 
	(select Fee_ComponentID,SUM(Installment_Amt) as Amount  from #FinalInstallment group by Fee_ComponentID )
	as newFee on FP.I_Fee_Component_ID=newFee.Fee_ComponentID where FP.I_Item_Value > newFee.Amount
	



	DECLARE @Eligible bit = 'true'


	IF exists (select I_Fee_Component_ID,I_Item_Value from #FeePaid as FP inner join 
	(select Fee_ComponentID,SUM(Installment_Amt) as Amount  from #FinalInstallment group by Fee_ComponentID )
	as newFee on FP.I_Fee_Component_ID=newFee.Fee_ComponentID where FP.I_Item_Value > newFee.Amount
	)
	BEGIN
		set @Eligible = 'false'
	END

	select 'eligible' as t , @Eligible as Estatus

	--select * from #FeePaid


--- end: Fee paid


--- Start: removing paid one 

-- Step 3: Declare a cursor for row-by-row processing
DECLARE @paidFee_ComponentID INT;
DECLARE @RemainingAmount DECIMAL(18, 2);
DECLARE @InstallmentID INT;
DECLARE @InstallmentAmt DECIMAL(18, 2);
DECLARE @InstallmentDates DATE;

DECLARE DeductionCursor CURSOR FOR
    SELECT t2.I_Fee_Component_ID, t2.I_Item_Value
    FROM #FeePaid t2;

-- Step 4: Open the cursor
OPEN DeductionCursor;

FETCH NEXT FROM DeductionCursor INTO @paidFee_ComponentID, @RemainingAmount;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Process each installment for the current Fee_ComponentID
    DECLARE InstallmentCursor CURSOR FOR
        SELECT Installment_Amt, Installmentdt
        FROM #FinalRemainingReviseInstallment
        WHERE Fee_ComponentID = @paidFee_ComponentID
        ORDER BY Installmentdt;

    OPEN InstallmentCursor;

    FETCH NEXT FROM InstallmentCursor INTO @InstallmentAmt, @InstallmentDates;

    WHILE @@FETCH_STATUS = 0 AND @RemainingAmount > 0
    BEGIN
        IF @RemainingAmount >= @InstallmentAmt
        BEGIN
            -- Fully deduct the installment amount
            UPDATE #FinalRemainingReviseInstallment
            SET Installment_Amt = 0
            WHERE Fee_ComponentID = @paidFee_ComponentID AND Installmentdt = @InstallmentDates;

            SET @RemainingAmount = @RemainingAmount - @InstallmentAmt;
        END
        ELSE
        BEGIN
            -- Partially deduct the remaining amount
            UPDATE #FinalRemainingReviseInstallment
            SET Installment_Amt = Installment_Amt - @RemainingAmount
            WHERE Fee_ComponentID = @paidFee_ComponentID AND Installmentdt = @InstallmentDates;

            SET @RemainingAmount = 0;
        END;

        FETCH NEXT FROM InstallmentCursor INTO @InstallmentAmt, @InstallmentDates;
    END;

    CLOSE InstallmentCursor;
    DEALLOCATE InstallmentCursor;

    FETCH NEXT FROM DeductionCursor INTO @paidFee_ComponentID, @RemainingAmount;
END;

-- Step 5: Close and deallocate the cursor
CLOSE DeductionCursor;
DEALLOCATE DeductionCursor;


select 'FinalRevised'

select * from #FinalRemainingReviseInstallment


--- End : Removing paid one

	
	Create Table #FinalFeeSchedule
	(
	ID int Identity(1,1)
	,I_Course_Fee_Plan_Detail_ID INT
	,I_Fee_Component_ID INT
	,I_Course_Fee_Plan_ID INT
	,I_Item_Value numeric(18,2)
	,N_CompanyShare numeric(18,2)
	,I_Sequence int
	,I_Installment_No int			
	,C_Is_LumpSum char(1)
	,I_Display_Fee_Component_ID int
	,Interval int
	,Dt_Installment datetime
	 ,CGSTVal Numeric(18,2)    
		,SGSTVal Numeric(18,2)    
		,IGSTval Numeric(18,2)    
		,CGST_Per Numeric(10,2)    
		,SGST_Per Numeric(10,2)    
		,IGST_Per Numeric(10,2)
		,Installment_Amt_IncludeTAX Numeric(18,2)
	)


   
  --Fee Component List      
  --Table [1] 

  DECLARE @CourseFeePlanID INT = NULL

  select @CourseFeePlanID=I_Course_Fee_Plan_ID from T_Course_Fee_Plan where I_New_I_Fee_Structure_ID=@Fee_Structure_ID

 
    

	----- Start :  Pending Dues Master ------

	DECLARE @OldInvoiceAmount numeric(8,2)=0
	DECLARE @OldFeeStructureName varchar(max)=NULL


SELECT 
    @OldInvoiceAmount = ISNULL(SUM(B.N_Due), 0.00),
    @OldFeeStructureName = MAX(CFP.S_Fee_Plan_Name)
FROM 
(
    SELECT 
        ICD.N_Due,
        ICH.I_Course_FeePlan_ID
    FROM 
        T_Invoice_Child_Detail ICD 
    INNER JOIN 
        T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
    INNER JOIN 
        T_Invoice_Parent TIP ON ICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID 
    WHERE 
        TIP.I_Invoice_Header_ID = @iOldInvoiceHeaderID
        AND ISNULL(ICD.Flag_IsAdvanceTax, 'N') <> 'Y'
) B
LEFT JOIN
T_Course_Fee_Plan CFP ON B.I_Course_FeePlan_ID = CFP.I_Course_Fee_Plan_ID
GROUP BY CFP.S_Fee_Plan_Name;


	----- End :  Pending Dues Master ------


	----- Actual Fee Schedule   
		
		select SUM(ISNULL(Installment_Amt,0))as Total_AMt, SUM(ISNULL(CGST_Amt,0)) as Total_CGST_AMt ,    
		  SUM(ISNULL(SGST_Amt,0)) as Total_SGST_AMt,    
		  SUM(ISNULL(IGST_Amt,0)) as Total_IGST_AMt,    
		 --Select SUM() as total          
		 DENSE_RANK() OVER (ORDER BY Installmentdt) as DateWiseInstallmentSequenceNo,          
		 CONVERT(varchar,Installmentdt,107) as Dt_Payment_Installment_Dt          
          
          
		 Into #TotalFinalAMtForPartial          
		 from #FinalRemainingReviseInstallment where ISNULL(Installment_Amt,0) > 0           
           
		 --Where Is_OneTime = @PaymentType          
		 Group by Installmentdt          
		 order by Installmentdt 
 
		--Select * from #TotalFinalAMtForPartial 
		
		-- Actual Fee Schedule Amount
		 Select Sum(Total_AMt) as ComponentTotalAmount,    
		 SUM(Total_CGST_AMt) as Total_CGSt,    
		 SUM(Total_SGST_AMt) as Total_SGST,    
		 SUM(Total_IGST_AMt) as Total_IGSt    
		 from #TotalFinalAMtForPartial          
          
		Drop table #TotalFinalAMtForPartial
		 


	DECLARE @RemainingMonth int = DATEDIFF(MONTH, CONVERT(DATE, GETDATE()), CONVERT(DATE, @sessionEndDt));

	SET @RemainingMonth = DATEDIFF(MONTH, CONVERT(DATE, GETDATE()), CONVERT(DATE, @sessionEndDt));

	print @RemainingMonth


	create table #RemaingFeePayable
	(
	ID INT IDENTITY(1,1)
	,I_Fee_Component_ID INT
	,I_Course_Fee_Plan_ID INT
	,I_Item_Value numeric(18,2)
	,N_CompanyShare numeric(18,2)
	,I_Sequence int			
	,C_Is_LumpSum char(1)
	,I_Display_Fee_Component_ID int
	,Interval int
	,CGSTVal Numeric(18,2)    
	,SGSTVal Numeric(18,2)    
	,IGSTval Numeric(18,2)    
	,CGST_Per Numeric(10,2)    
	,SGST_Per Numeric(10,2)    
	,IGST_Per Numeric(10,2)
	,Installment_Amt_IncludeTAX Numeric(10,2)
	,I_Installment_No int
	,Dt_Installment datetime
	)




			INSERT INTO #RemaingFeePayable
(
    I_Fee_Component_ID,
    I_Course_Fee_Plan_ID,
    I_Item_Value,
    N_CompanyShare,
    I_Sequence,
    C_Is_LumpSum,
    I_Display_Fee_Component_ID,
    Interval,
    CGSTVal,
    SGSTVal,
    IGSTval,
    CGST_Per,
    SGST_Per,
    IGST_Per,
    Installment_Amt_IncludeTAX,
    I_Installment_No,
	Dt_Installment
)
	select 
	FRRI.Fee_ComponentID,
	CFP.I_Course_Fee_Plan_ID,
	FRRI.Installment_Amt,
	NULL,
	FRRI.Seq,
	CASE WHEN FRRI.Is_OneTime = 1 THEN 'Y' ELSE 'N' END,
	FRRI.Fee_ComponentID,
	ISNULL(Interval,0),
	CGST_Amt,
	SGST_Amt,
	IGST_Amt,
	CGST_Per,
	SGST_Per,
	IGST_Per,
	ISNULL(FRRI.Installment_Amt,0)+ISNULL(IGST_Amt,0),--Installment_Amt_IncludeTAX,
	DENSE_RANK() OVER (PARTITION BY CFP.I_Course_Fee_Plan_ID ORDER BY FRRI.Installmentdt) AS No_Installment,
	FRRI.Installmentdt

	from #FinalRemainingReviseInstallment as FRRI
	inner join
	T_Course_Fee_Plan as CFP on FRRI.Fee_Structure_ID=CFP.I_New_I_Fee_Structure_ID
	where ISNULL(FRRI.Installment_Amt,0) > 0 

	--select '#RemaingFeePayable' as remaingfeepayable
	--select * from #RemaingFeePayable

	

	SELECT 
    I_Item_Value AS BaseAmount, 
    COUNT(*) AS NoOfInstallment,
    (I_Item_Value * COUNT(*)) AS CurrentInvoiceComponentBaseAmount,
    @OldInvoiceAmount AS OldInvoiceBaseAmount,
    @OldFeeStructureName AS OldFeeStructureName,
    @NewFeeStructureName AS NewFeeStructureName
FROM 
    #RemaingFeePayable
GROUP BY 
    I_Item_Value, I_Fee_Component_ID;



	DECLARE @SGST_Tax_ID int,@CGST_Tax_ID int,@IGST_Tax_ID int  
set @SGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='SGST')  
set @CGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='CGST')  
set @IGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='IGST') 

	select FF.*,FCM.S_Component_Name as FeeComponentName,FCM.S_Component_Code as FeeComponentCode
	,@SGST_Tax_ID as I_SGST_Tax_ID,@CGST_Tax_ID I_CGST_Tax_ID,@IGST_Tax_ID I_IGST_Tax_ID
	from #RemaingFeePayable as FF
	inner join
	T_Fee_Component_Master as FCM on FF.I_Fee_Component_ID=FCM.I_Fee_Component_ID
                   
	--IF OBJECT_ID(N'tempdb..#FinalInstallment') IS NOT NULL                
	--BEGIN                
	--	DROP TABLE #FinalInstallment                
	--END   
		
	--DROP TABLE #CFPD
	--DROP TABLE #IWFPD
	--DROP TABLE #CFPDR
	--DROP TABLE #IWFPI
END
