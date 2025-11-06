

CREATE PROCEDURE [dbo].[usp_ERP_GetFeePlanDetailsForOldInvoice_Jan_Before_NewFeeStructure] --uspGetFeePlanDetailsForOldInvoice 168864, 37602
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
    where TEFS.I_Fee_Structure_ID = @Fee_Structure_ID    and TEFSIC.Is_OneTime= @PaymentType 

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
				   CEILING(N_Component_Actual_Total_Annual_Amount+ISNULL(IGST_Amt,0)) as Installment_Amt_IncludeTAX  ,    
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
      
				  -- Select * from #OneTimePaymentDetails      
    
				 --  Select SUM(N_Installment_Amount) as Total_AMt,
				 --  SUM(CGST_Amt) as Total_CGST_AMt,    
				 --  SUM(SGST_Amt) as Total_SGST_AMt,    
				 --  SUM(IGST_Amt) as Total_IGST_AMt   
				 --  ,1 as DateWiseInstallmentSequenceNo,      
				 --  Dt_Payment_Installment_Dt  As Dt_Payment_Installment_Dt      
				 --  from #OneTimePaymentDetails      
				 --  Group by Dt_Payment_Installment_Dt     
       
				 --  Select SUM(N_Installment_Amount) as ComponentTotalAmount,
				 --  --SUM( IGST_Amt) Total_TAXAmount  
					--SUM(CGST_Amt) as Total_CGSt,    
					--SUM(SGST_Amt) as Total_SGST,    
					--SUM(IGST_Amt) as Total_IGSt 
				 --  from #OneTimePaymentDetails 
				 

				 	--	Create Table #FinalInstallment                
						--(                
						--	ID int Identity(1, 1),             
						-- I_Fee_Structure_Installment_Component_ID int,          
						--	Fee_Structure_ID int,           
						-- S_Fee_Structure_Name VARCHAR(MAX),          
						--	Fee_ComponentID int,           
						-- S_Fee_Component_Name VARCHAR(MAX),          
						--	Seq int,              
						--	Installmentdt date,                
						--	Installment_Amt Numeric(18, 2),    
					 -- Installment_Amt_IncludeTAX Numeric(18,2),    
						--	Is_OneTime int,            
					 -- PaymentInstallmentID int,    
					 -- CGST_Amt Numeric(18,2),    
					 -- SGST_Amt Numeric(18,2),    
					 -- IGST_Amt Numeric(18,2),    
					 -- CGST_Per Numeric(10,2),    
					 -- SGST_Per Numeric(10,2),    
					 -- IGST_Per Numeric(10,2) ,
					 -- Interval int
						--)    
	



						--Declare @FeeStructureInstallmentComponentID int,          
					 --  @FeeStrucID int,              
					 --  @FeeStrucName VARCHAR(MAX),          
						--		@Fee_ComponentID int,           
					 --  @Fee_ComponentName VARCHAR(MAX),          
						--		@seq int,              
						--		@ComponentAmt Numeric(18, 2),    
					 --  @ComponentAmt_IncludeTAX numeric(18,2),    
						--		@installno int,                
						--		@interval int,                   
						--		@status Int,                
						--		@lst int,                
						--		@ID int = 1,            
						--		@Is_OneTime int,          
						--		@PaymentInstallmentID int,    
					 --  @CGSTVal Numeric(18,2),    
					 --  @SGSTVal Numeric(18,2),    
					 --  @IGSTval Numeric(18,2),    
					 --  @CGST_Per Numeric(10,2),    
					 --  @SGST_Per Numeric(10,2),    
					 --  @IGST_Per Numeric(10,2)    
					   --@DateWiseInstallmentSequenceNo int          
						SET @lst =                
						(                
							select max(ID) from #Stud_Fee_Installment            )    
		
						print @lst

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
									Into #IntervalInstallmentLumpsum                
									FROM dbo.GetInstallmentDatesInFinancialYear(@sessionstDt, @sessionEndDt, @sessionstDt, @interval);                
									
									--select * from #IntervalInstallment


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
						 IGST_Per ,
						 Interval
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
							IGST_Per  ,
							ii.Interval
							   --DENSE_RANK() OVER (ORDER BY ii.InstallmentDate)          
									from #IntervalInstallmentLumpsum  ii                
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
										 IGST_Per,
										 Interval
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
											   @ComponentAmt+ISNULL(@IGSTval,0),    
														   @Is_OneTime,          
											   @PaymentInstallmentID,    
											@CGSTVal,    
											@SGSTVal,    
											@IGSTval,    
											@CGST_Per,    
											@SGST_Per,    
											@IGST_Per,
											@interval
						   End                
                
							IF OBJECT_ID(N'tempdb..#IntervalInstallmentLumpsum') IS NOT NULL                
							BEGIN                
								DROP TABLE #IntervalInstallmentLumpsum                 
							END                
							Set @ID = @ID + 1                
						END 


		  End      
  Else      
		  Begin      
						--Create Table #FinalInstallment                
						--(                
						--	ID int Identity(1, 1),             
						-- I_Fee_Structure_Installment_Component_ID int,          
						--	Fee_Structure_ID int,           
						-- S_Fee_Structure_Name VARCHAR(MAX),          
						--	Fee_ComponentID int,           
						-- S_Fee_Component_Name VARCHAR(MAX),          
						--	Seq int,              
						--	Installmentdt date,                
						--	Installment_Amt Numeric(18, 2),    
					 -- Installment_Amt_IncludeTAX Numeric(18,2),    
						--	Is_OneTime int,            
					 -- PaymentInstallmentID int,    
					 -- CGST_Amt Numeric(18,2),    
					 -- SGST_Amt Numeric(18,2),    
					 -- IGST_Amt Numeric(18,2),    
					 -- CGST_Per Numeric(10,2),    
					 -- SGST_Per Numeric(10,2),    
					 -- IGST_Per Numeric(10,2) ,
					 -- Interval int
						--)    
	



						--Declare @FeeStructureInstallmentComponentID int,          
					 --  @FeeStrucID int,              
					 --  @FeeStrucName VARCHAR(MAX),          
						--		@Fee_ComponentID int,           
					 --  @Fee_ComponentName VARCHAR(MAX),          
						--		@seq int,              
						--		@ComponentAmt Numeric(18, 2),    
					 --  @ComponentAmt_IncludeTAX numeric(18,2),    
						--		@installno int,                
						--		@interval int,                   
						--		@status Int,                
						--		@lst int,                
						--		@ID int = 1,            
						--		@Is_OneTime int,          
						--		@PaymentInstallmentID int,    
					 --  @CGSTVal Numeric(18,2),    
					 --  @SGSTVal Numeric(18,2),    
					 --  @IGSTval Numeric(18,2),    
					 --  @CGST_Per Numeric(10,2),    
					 --  @SGST_Per Numeric(10,2),    
					 --  @IGST_Per Numeric(10,2)    
					   --@DateWiseInstallmentSequenceNo int          
						SET @lst =                
						(                
							select max(ID) from #Stud_Fee_Installment            )    
		
						print @lst

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
									
									--select * from #IntervalInstallment


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
						 IGST_Per ,
						 Interval
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
							IGST_Per  ,
							ii.Interval
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
										 IGST_Per,
										 Interval
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
											   @ComponentAmt+ISNULL(@IGSTval,0),    
														   @Is_OneTime,          
											   @PaymentInstallmentID,    
											@CGSTVal,    
											@SGSTVal,    
											@IGSTval,    
											@CGST_Per,    
											@SGST_Per,    
											@IGST_Per,
											@interval
						   End                
                
							IF OBJECT_ID(N'tempdb..#IntervalInstallment') IS NOT NULL                
							BEGIN                
								DROP TABLE #IntervalInstallment                
							END                
							Set @ID = @ID + 1                
						END             
           
          

          
					 --  Select I_Fee_Structure_Installment_Component_ID as I_Fee_Component_InstallmentID,          
					 -- Fee_Structure_ID as R_I_Fee_Structure_ID,          
					 -- S_Fee_Structure_Name,          
					 -- Fee_ComponentID,          
					 -- S_Fee_Component_Name,          
					 -- Seq,          
					 -- --Installmentdt,          
					 -- CONVERT(varchar,Installmentdt,107) as Dt_Payment_Installment_Dt,          
					 -- Installment_Amt as N_Installment_Amount,     
					 -- Installment_Amt_IncludeTAX,    
					 -- Is_OneTime,          
					 -- DENSE_RANK() OVER (ORDER BY Installmentdt) as DateWiseInstallmentSequenceNo,          
					 -- PaymentInstallmentID,    
					 -- CGST_Amt,    
					 -- SGST_Amt,    
					 -- IGST_Amt,    
					 -- CGST_Per,    
					 -- SGST_Per,    
					 -- IGST_Per    
					 --from #FinalInstallment          
					 --where Is_OneTime = @PaymentType          
					 --order by Seq          
          
          
					           
					 -- select SUM(Installment_Amt)as Total_AMt, SUM(CGST_Amt) as Total_CGST_AMt ,    
					 -- SUM(SGST_Amt) as Total_SGST_AMt,    
					 -- SUM(IGST_Amt) as Total_IGST_AMt,    
					 ----Select SUM() as total          
					 --DENSE_RANK() OVER (ORDER BY Installmentdt) as DateWiseInstallmentSequenceNo,          
					 --CONVERT(varchar,Installmentdt,107) as Dt_Payment_Installment_Dt 
					 --Into #TotalFinalAMt          
					 --from #FinalInstallment     
					 --Where Is_OneTime = @PaymentType          
					 --Group by Installmentdt          
					 --order by Installmentdt 
					 
					 --Select * from #TotalFinalAMt     
					 

					 --Select Sum(Total_AMt) as ComponentTotalAmount,    
					 --SUM(Total_CGST_AMt) as Total_CGSt,    
					 --SUM(Total_SGST_AMt) as Total_SGST,    
					 --SUM(Total_IGST_AMt) as Total_IGSt    
					 --from #TotalFinalAMt          
          
					-- Drop table #TotalFinalAMt        
      

    
		 End    

		-- select * from #FinalInstallment
    
    CREATE TABLE #CFPD -- fee Schedule
    (
		I_Course_Fee_Plan_Detail_ID int
	   ,I_Fee_Component_ID int
       ,I_Course_Fee_Plan_ID int
       ,I_Item_Value numeric(18,2)
       ,N_CompanyShare numeric(18,2)
       ,I_Sequence int
       ,I_Installment_No int
       ,C_Is_LumpSum char(1)
       ,I_Display_Fee_Component_ID int
	   ,Interval int
	    ,CGSTVal Numeric(18,2)    
		,SGSTVal Numeric(18,2)    
		,IGSTval Numeric(18,2)    
		,CGST_Per Numeric(10,2)    
		,SGST_Per Numeric(10,2)    
		,IGST_Per Numeric(10,2)
		,Installment_Amt_IncludeTAX Numeric(18,2)
    ) 
    
    CREATE TABLE #CFPDR
    (
		ID INT IDENTITY(1,1)
	   ,I_Course_Fee_Plan_Detail_ID int
	   ,I_Fee_Component_ID int
       ,I_Course_Fee_Plan_ID int
       ,I_Item_Value numeric(18,2)
       ,N_CompanyShare numeric(18,2)
       ,I_Sequence int
       ,I_Installment_No int
       ,Dt_Installment_Date DATETIME
       ,C_Is_LumpSum char(1)
       ,I_Display_Fee_Component_ID int
	   ,Interval Int
	   ,CGSTVal Numeric(18,2)    
		,SGSTVal Numeric(18,2)    
		,IGSTval Numeric(18,2)    
		,CGST_Per Numeric(10,2)    
		,SGST_Per Numeric(10,2)    
		,IGST_Per Numeric(10,2)
		,Installment_Amt_IncludeTAX Numeric(18,2)
    ) 
    
    CREATE TABLE #IWFPD
    (
		ID INT IDENTITY(1,1),
		I_Invoice_Detail_ID int, 
		I_Invoice_Child_Header_ID int, 
		I_Course_Fee_Plan_ID int,
		I_Fee_Component_ID int, 
		I_Installment_No int, 
		Dt_Installment_Date DATETIME, 
		N_Amount_Due numeric(18,2)
    ) 
    
    CREATE TABLE #IWFPI
    (
		ID INT IDENTITY(1,1),
		I_Installment_No int, 
		Dt_Installment_Date DATETIME
    )
	
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

   --select * from #FinalInstallment

	INSERT INTO #CFPD
	(
		I_Course_Fee_Plan_Detail_ID ,
        I_Fee_Component_ID ,
        I_Course_Fee_Plan_ID ,
        I_Item_Value ,
        N_CompanyShare ,
        I_Installment_No ,
        I_Sequence ,
        C_Is_LumpSum ,
        I_Display_Fee_Component_ID,
		Interval,
		CGSTVal,    
		SGSTVal,    
		IGSTval,    
		CGST_Per,    
		SGST_Per,    
		IGST_Per,
		Installment_Amt_IncludeTAX
	)   
   select 0,
   Fee_ComponentID,
   @CourseFeePlanID, 
    Installment_Amt as N_Installment_Amount,
	NULL,
	DENSE_RANK() OVER (ORDER BY Installmentdt) as DateWiseInstallmentSequenceNo,   
	Seq,  
	CASE WHEN @PaymentType = 1 THEN 'Y' 
	ELSE 'N' END as C_Is_LumpSum,
	Fee_ComponentID,
	Interval,
	CGST_Amt,    
	SGST_Amt,    
	IGST_Amt,    
	CGST_Per,    
	SGST_Per,    
	IGST_Per,
	Installment_Amt_IncludeTAX
	from #FinalInstallment          
	where Is_OneTime = @PaymentType          
	order by Seq          
          
    

	----- Start :  Pending Dues Master ------

	DECLARE @OldInvoiceAmount numeric(8,2)=0
	DECLARE @OldFeeStructureName varchar(max)=NULL


    INSERT INTO #IWFPD    -----------------Pending Dues
    (
		I_Invoice_Detail_ID, 
		I_Invoice_Child_Header_ID, 
		I_Course_Fee_Plan_ID,
		I_Fee_Component_ID, 
		I_Installment_No, 
		Dt_Installment_Date, 
		N_Amount_Due
    )     
    SELECT B.I_Invoice_Detail_ID, B.I_Invoice_Child_Header_ID, B.I_Course_FeePlan_ID, B.I_Fee_Component_ID, B.I_Installment_No, B.Dt_Installment_Date, 
    --(ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) N_Amount_Due  --Before Discount Akash 5.10.2021
	(ISNULL(B.N_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) N_Amount_Due
	FROM 
	(SELECT ICD.I_Invoice_Detail_ID, ICD.I_Invoice_Child_Header_ID, ICH.I_Course_FeePlan_ID, 
	ICD.I_Fee_Component_ID, ICD.I_Installment_No, ICD.Dt_Installment_Date, ICD.N_Amount_Due,ICD.N_Due,ICD.N_Discount_Amount
	FROM T_Invoice_Child_Detail ICD 
	INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
	INNER JOIN T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID 
	WHERE IP.I_Invoice_Header_ID = @iOldInvoiceHeaderID
	AND ISNULL(ICD.Flag_IsAdvanceTax,'N') <> 'Y') B
	LEFT JOIN 
	(SELECT RCD.I_Invoice_Detail_ID, SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Amount_Paid
	FROM T_Receipt_Header RH
	INNER JOIN T_Receipt_Component_Detail RCD ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
	WHERE RH.I_Invoice_Header_ID = @iOldInvoiceHeaderID
	AND ISNULL(RH.I_Status,0) <> 0
	GROUP BY RCD.I_Invoice_Detail_ID) A	ON B.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
	INNER JOIN T_Invoice_Child_Header ICH1 ON B.I_Invoice_Child_Header_ID = ICH1.I_Invoice_Child_Header_ID
	AND (ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) > 0
	ORDER BY B.I_Installment_No
	
	

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
        T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID 
    WHERE 
        IP.I_Invoice_Header_ID = @iOldInvoiceHeaderID
        AND ISNULL(ICD.Flag_IsAdvanceTax, 'N') <> 'Y'
) B
LEFT JOIN
T_Course_Fee_Plan CFP ON B.I_Course_FeePlan_ID = CFP.I_Course_Fee_Plan_ID
GROUP BY CFP.S_Fee_Plan_Name;


	----- End :  Pending Dues Master ------



	----- Start :  Pending Dues Instalment dates with Sequence No ------


	INSERT INTO #IWFPI  ------------------ Pending Dues Instalment dates with Sequence No
    (
		I_Installment_No, 
		Dt_Installment_Date
    ) 
	SELECT DISTINCT I_Installment_No, Dt_Installment_Date
	FROM #IWFPD
	----- End :  Pending Dues Installment dates with Sequence No ------




	
	IF EXISTS
	(
		SELECT 1 FROM #IWFPI
	)
	BEGIN
	
		DECLARE @row INT = 1
		DECLARE @count INT
		
		DECLARE @I_Invoice_Detail_ID int
		DECLARE @I_Invoice_Child_Header_ID int
		DECLARE @I_Fee_Component_ID int
		DECLARE @I_Installment_No int
		DECLARE @Dt_Installment_Date DATETIME
		DECLARE @N_Amount_Due numeric(18,2)	
		DECLARE @N_Amount_Paid numeric(18,2)
		
		DECLARE @I_Course_Fee_Plan_Detail_ID int
		DECLARE @I_Course_Fee_Plan_ID int
		DECLARE @I_Item_Value numeric(18,2)
		DECLARE @N_CompanyShare numeric(18,2)
		DECLARE @I_Sequence int
		DECLARE @C_Is_LumpSum char(1)
		DECLARE @I_Display_Fee_Component_ID int
		
		SELECT @count = COUNT(*) FROM #IWFPI
		
		WHILE (@row<=@count)
		BEGIN
			SELECT @I_Installment_No = I_Installment_No
				  ,@Dt_Installment_Date = Dt_Installment_Date
			FROM #IWFPI
			WHERE ID = @row
			
			INSERT INTO #CFPDR
			(
				I_Course_Fee_Plan_Detail_ID
			   ,I_Fee_Component_ID
			   ,I_Course_Fee_Plan_ID 
			   ,I_Item_Value
			   ,N_CompanyShare
			   ,I_Sequence
			   ,I_Installment_No
			   ,Dt_Installment_Date
			   ,C_Is_LumpSum
			   ,I_Display_Fee_Component_ID
			   ,Interval
			   ,CGSTVal    
			   ,SGSTVal   
				,IGSTval   
				,CGST_Per    
				,SGST_Per   
				,IGST_Per
				,Installment_Amt_IncludeTAX
			)
			SELECT  CF.I_Course_Fee_Plan_Detail_ID
					,CF.I_Fee_Component_ID 
					,CF.I_Course_Fee_Plan_ID
					,ISNULL((SELECT IW.N_Amount_Due FROM #IWFPD IW WHERE IW.I_Course_Fee_Plan_ID = CF.I_Course_Fee_Plan_ID 
											  AND IW.I_Installment_No = CF.I_Installment_No AND IW.I_Fee_Component_ID = CF.I_Fee_Component_ID),0) AS I_Item_Value
					,CF.N_CompanyShare
					,CF.I_Sequence				
					,@I_Installment_No
					,@Dt_Installment_Date
					,CF.C_Is_LumpSum
					,CF.I_Display_Fee_Component_ID
					,CF.Interval
					,CGSTVal    
			   ,SGSTVal   
				,IGSTval    
					,CGST_Per   
					,SGST_Per   
					,IGST_Per
					,Installment_Amt_IncludeTAX
			FROM #CFPD CF
			WHERE I_Installment_No = @I_Installment_No
			
			SET @row = @row + 1
		END
		

		--select * from #CFPDR


		-- Actual Fee Schedule   
		
		select SUM(Installment_Amt)as Total_AMt, SUM(CGST_Amt) as Total_CGST_AMt ,    
		  SUM(SGST_Amt) as Total_SGST_AMt,    
		  SUM(IGST_Amt) as Total_IGST_AMt,    
		 --Select SUM() as total          
		 DENSE_RANK() OVER (ORDER BY Installmentdt) as DateWiseInstallmentSequenceNo,          
		 CONVERT(varchar,Installmentdt,107) as Dt_Payment_Installment_Dt          
          
          
		 Into #TotalFinalAMtForPartial          
		 from #FinalInstallment           
           
		 Where Is_OneTime = @PaymentType          
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
		 

		 insert into #FinalFeeSchedule
		(
		I_Course_Fee_Plan_Detail_ID
		,I_Fee_Component_ID
		,I_Course_Fee_Plan_ID
		,I_Item_Value 
		,N_CompanyShare 
		,I_Sequence 
		,I_Installment_No 			
		,C_Is_LumpSum 
		,I_Display_Fee_Component_ID 
		,Interval 
		,CGSTVal    
			   ,SGSTVal   
				,IGSTval    
					,CGST_Per   
					,SGST_Per   
					,IGST_Per
					,Installment_Amt_IncludeTAX
		)
		SELECT	0 AS I_Course_Fee_Plan_Detail_ID
				,CF.I_Fee_Component_ID 
				,CF.I_Course_Fee_Plan_ID 
				,A.I_Item_Value 
				,CF.N_CompanyShare
				,CF.I_Sequence  
				,CF.I_Installment_No 			
				,CF.C_Is_LumpSum 
				,CF.I_Display_Fee_Component_ID
				,CF.Interval
				,CF.CGSTVal    
			   ,CF.SGSTVal   
				,CF.IGSTval    
					,CF.CGST_Per   
					,CF.SGST_Per   
					,CF.IGST_Per
					,CF.Installment_Amt_IncludeTAX
		FROM #CFPD CF
		INNER JOIN (SELECT  CFR.I_Fee_Component_ID
						   ,SUM(ISNULL(CFR.I_Item_Value,0)) AS I_Item_Value
					FROM #CFPDR CFR
					GROUP BY CFR.I_Fee_Component_ID) A ON CF.I_Fee_Component_ID = A.I_Fee_Component_ID
		WHERE CF.I_Installment_No = 0 AND CF.C_Is_LumpSum = 'Y'
		UNION ALL
		SELECT 0 AS I_Course_Fee_Plan_Detail_ID
			   ,A.I_Fee_Component_ID
			   ,A.I_Course_Fee_Plan_ID 
			   ,SUM(ISNULL(A.I_Item_Value,0)) AS I_Item_Value
			   ,A.N_CompanyShare
			   ,A.I_Sequence
			   ,A.I_Installment_No
			   ,A.C_Is_LumpSum
			   ,A.I_Display_Fee_Component_ID
			   ,A.Interval
			   ,A.CGSTVal    
			   ,A.SGSTVal   
				,A.IGSTval    
					,A.CGST_Per   
					,A.SGST_Per   
					,A.IGST_Per
					,A.Installment_Amt_IncludeTAX
		FROM(
		SELECT  I_Fee_Component_ID
			   ,I_Course_Fee_Plan_ID 
			   ,I_Item_Value
			   ,N_CompanyShare
			   ,I_Sequence
			   ,CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, Dt_Installment_Date) THEN 1
					 ELSE I_Installment_No
				END I_Installment_No
			   ,CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, Dt_Installment_Date) THEN DATEADD(d,DATEDIFF(d,0,getdate()),0)
					 ELSE Dt_Installment_Date
				END Dt_Installment_Date
			   ,C_Is_LumpSum
			   ,I_Display_Fee_Component_ID
			   ,Interval
			   ,CGSTVal    
			   ,SGSTVal   
				,IGSTval    
					,CGST_Per   
					,SGST_Per   
					,IGST_Per
					,Installment_Amt_IncludeTAX
		FROM #CFPDR) A
		GROUP BY A.I_Installment_No, A.I_Fee_Component_ID, A.N_CompanyShare, A.I_Sequence, A.C_Is_LumpSum, A.I_Display_Fee_Component_ID, A.I_Course_Fee_Plan_ID,A.Interval
		 ,A.CGSTVal    
			   ,A.SGSTVal   
				,A.IGSTval    
					,A.CGST_Per   
					,A.SGST_Per   
					,A.IGST_Per
					,A.Installment_Amt_IncludeTAX
		ORDER BY I_Installment_No ASC

		--select * from #FinalFeeSchedule

	END
	ELSE
	BEGIN
		     
			-- Actual Fee Schedule   
		
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
 
		--Select * from #TotalFinalAMt 
		
		-- Actual Fee Schedule Amount
		 Select Sum(Total_AMt) as ComponentTotalAmount,    
		 SUM(Total_CGST_AMt) as Total_CGSt,    
		 SUM(Total_SGST_AMt) as Total_SGST,    
		 SUM(Total_IGST_AMt) as Total_IGSt    
		 from #TotalFinalAMt 

		 --Drop table #TotalFinalAMt

		insert into #FinalFeeSchedule
		(
		I_Course_Fee_Plan_Detail_ID
		,I_Fee_Component_ID
		,I_Course_Fee_Plan_ID
		,I_Item_Value 
		,N_CompanyShare 
		,I_Sequence 
		,I_Installment_No 			
		,C_Is_LumpSum 
		,I_Display_Fee_Component_ID 
		,Interval 
		,CGSTVal    
			   ,SGSTVal   
				,IGSTval    
					,CGST_Per   
					,SGST_Per   
					,IGST_Per
					,Installment_Amt_IncludeTAX
		)		
		SELECT 
		I_Course_Fee_Plan_Detail_ID,
		I_Fee_Component_ID,
		I_Course_Fee_Plan_ID,
		I_Item_Value,
		N_CompanyShare,
		I_Sequence,
		I_Installment_No,
		C_Is_LumpSum,
		I_Display_Fee_Component_ID,
		Interval
		,CGSTVal    
			   ,SGSTVal   
				,IGSTval    
					,CGST_Per   
					,SGST_Per   
					,IGST_Per
					,Installment_Amt_IncludeTAX
		FROM #CFPD

		--select * from #FinalFeeSchedule


	END




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
	,No_Installment int
	)

	If   @PaymentType =1 
	begin

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
    No_Installment
)
SELECT DISTINCT
    B.I_Fee_Component_ID,
    B.I_Course_Fee_Plan_ID,
    A.I_Item_Value,
    B.N_CompanyShare,
    B.I_Sequence,
    B.C_Is_LumpSum,
    B.I_Display_Fee_Component_ID,
    A.Interval,
    A.CGSTVal,
    A.SGSTVal,
    A.IGSTval,
    B.CGST_Per,
    B.SGST_Per,
    B.IGST_Per,
    B.Installment_Amt_IncludeTAX,
    A.No_Installment
FROM 
(
    SELECT 
        FF.I_Fee_Component_ID,
        -- Using @RemainingMonth as the interval
        @RemainingMonth AS Interval,
        1 AS No_Installment,
        SUM(I_Item_Value) AS I_Item_Value,  -- Correct aggregation
        SUM(CGSTVal) AS CGSTVal,
        SUM(SGSTVal) AS SGSTVal,
        SUM(IGSTval) AS IGSTval
    FROM 
        #FinalFeeSchedule AS FF
    GROUP BY 
        FF.I_Fee_Component_ID
) A
INNER JOIN
#FinalFeeSchedule AS B ON A.I_Fee_Component_ID = B.I_Fee_Component_ID;


	end
	else
	begin

	insert into #RemaingFeePayable
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
	No_Installment
	)
	select  DISTINCT
	B.I_Fee_Component_ID,
	B.I_Course_Fee_Plan_ID,
	B.I_Item_Value,
	B.N_CompanyShare,
	B.I_Sequence,
	B.C_Is_LumpSum,
	B.I_Display_Fee_Component_ID,
	A.Interval,
	B.CGSTVal,
	B.SGSTVal,
	B.IGSTval,
	B.CGST_Per,
	B.SGST_Per,
	B.IGST_Per,
	B.Installment_Amt_IncludeTAX,
	A.No_Installment
	from 
	(
	select FF.I_Fee_Component_ID,
	--CASE WHEN COUNT(*) = 0 THEN @RemainingMonth
 --   ELSE @RemainingMonth / (COUNT(*) - 1) END as Interval,
	@RemainingMonth / COUNT(*) as Interval,
	count(*) as No_Installment
	from 
	#FinalFeeSchedule as FF
	group by FF.I_Fee_Component_ID
	) A
	inner join
	#FinalFeeSchedule as B on A.I_Fee_Component_ID=B.I_Fee_Component_ID
	
	end
	--select * from #RemaingFeePayable

	--select * from #FinalFeeSchedule

	delete from #FinalFeeSchedule



	DECLARE @MaxFinalFeeSchedule INT=0
	DECLARE @InstallmentDate datetime=GETDATE()
	DECLARE @firstInstallmentDate datetime

	SELECT @firstInstallmentDate =
    CASE
        WHEN MONTH(GETDATE()) = 12
        THEN DATEFROMPARTS(YEAR(GETDATE()) + 1, 1, 1)  -- Handle December separately to roll over to the next year
        ELSE DATEADD(DAY, 1, EOMONTH(GETDATE()))       -- Get the first day of the next month
    END;

	DECLARE @CurrentDate datetime=@firstInstallmentDate;
	DECLARE @NoInstallment int=0;

	SET @MaxFinalFeeSchedule =                
						( select max(ID) from #RemaingFeePayable)    
		
		DECLARE  @IDFinal INT=1;

						WHILE @IDFinal <= @MaxFinalFeeSchedule                
						Begin                
                
							--select * from #Stud_Fee_Installment                    
							select Top 1        
								@interval = Interval ,
								@NoInstallment=No_Installment
							from #RemaingFeePayable                
							where ID = @IDFinal  

							set @CurrentDate=@firstInstallmentDate

							--select @interval,@NoInstallment,@IDFinal,@CurrentDate

							If @interval <> 0                
							Begin 
		
									--SELECT @interval As Interval,                
									--	   InstallmentDate                
									--Into #FinalIntervalInstallment                
									--FROM dbo.GetInstallmentDatesInFinancialYear(@firstInstallmentDate, @sessionEndDt, @firstInstallmentDate, @interval);                
									
									create table #FinalIntervalInstallment
									(
									InstallmentNumber int,
									InstallmentDate datetime,
									)

									

									DECLARE @InstallmentNumber INT = 1
									 -- Loop to calculate each installment date
										WHILE @InstallmentNumber <= @NoInstallment --AND @CurrentDate <= @sessionEndDt
										BEGIN
											-- Insert the installment date into the result table
											INSERT INTO #FinalIntervalInstallment
											(InstallmentNumber, InstallmentDate)
											 values(@NoInstallment, @CurrentDate)

											-- Increment the current date by the interval
											SET @CurrentDate = DATEADD(MONTH, @interval, @CurrentDate)
        
											-- Increment the installment number
											SET @InstallmentNumber = @InstallmentNumber + 1
										END

									--select * from #FinalIntervalInstallment

									
									insert into #FinalFeeSchedule
									(
									I_Course_Fee_Plan_Detail_ID
									,I_Fee_Component_ID
									,I_Course_Fee_Plan_ID
									,I_Item_Value 
									,N_CompanyShare 
									,I_Sequence 
									,I_Installment_No 			
									,C_Is_LumpSum 
									,I_Display_Fee_Component_ID 
									,Interval 
									,CGSTVal    
								    ,SGSTVal   
									,IGSTval    
									,CGST_Per   
									,SGST_Per   
									,IGST_Per
									,Installment_Amt_IncludeTAX
									,Dt_Installment
									)
									select 
									0,
									FFS.I_Fee_Component_ID,
									FFS.I_Course_Fee_Plan_ID,
									FFS.I_Item_Value,
									FFS.N_CompanyShare,
									FFS.I_Sequence,
									DENSE_RANK() OVER (ORDER BY II.InstallmentDate) as DateWiseInstallmentSequenceNo,
									FFS.C_Is_LumpSum,
									FFS.I_Display_Fee_Component_ID,
									FFS.Interval,
									FFS.CGSTVal,
									FFS.SGSTVal,
									FFS.IGSTval,
									FFS.CGST_Per,
									FFS.SGST_Per,
									FFS.IGST_Per,
									FFS.Installment_Amt_IncludeTAX,
									II.InstallmentDate
									from									
									#RemaingFeePayable as FFS
									left join
									#FinalIntervalInstallment as II on FFS.No_Installment=II.InstallmentNumber
									where FFS.ID=@IDFinal
               
                
							End                
							IF OBJECT_ID(N'tempdb..#FinalIntervalInstallment') IS NOT NULL                
							BEGIN                
								DROP TABLE #FinalIntervalInstallment                
							END           
							Set @IDFinal = @IDFinal + 1                
						END 

	
	--select * from #CFPD  --choosen fee schedule 
	--select * from #IWFPD --Pending Dues
	--select * from #CFPDR -- Updated Fee Schedule
	--select * from #IWFPI --Pending Dues Instalment dates with Sequence No

	

	select I_Item_Value as BaseAmount,No_Installment as NoOfInstallment,
	(I_Item_Value*No_Installment) as CurrentInvoiceComponentBaseAmount,@OldInvoiceAmount as OldInvoiceBaseAmount
	,@OldFeeStructureName as OldFeeStructureName ,@NewFeeStructureName NewFeeStructureName
	from 
	#RemaingFeePayable


	DECLARE @SGST_Tax_ID int,@CGST_Tax_ID int,@IGST_Tax_ID int  
set @SGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='SGST')  
set @CGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='CGST')  
set @IGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='IGST') 

	select FF.*,FCM.S_Component_Name as FeeComponentName,FCM.S_Component_Code as FeeComponentCode
	,@SGST_Tax_ID as I_SGST_Tax_ID,@CGST_Tax_ID I_CGST_Tax_ID,@IGST_Tax_ID I_IGST_Tax_ID
	from #FinalFeeSchedule as FF
	inner join
	T_Fee_Component_Master as FCM on FF.I_Fee_Component_ID=FCM.I_Fee_Component_ID
                   
	IF OBJECT_ID(N'tempdb..#FinalInstallment') IS NOT NULL                
	BEGIN                
		DROP TABLE #FinalInstallment                
	END   
		
	DROP TABLE #CFPD
	DROP TABLE #IWFPD
	DROP TABLE #CFPDR
	DROP TABLE #IWFPI
END
