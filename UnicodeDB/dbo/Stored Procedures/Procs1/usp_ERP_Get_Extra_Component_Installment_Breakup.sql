

-- =============================================                                                
--Procedure: usp_ERP_insert_Update_Fee_Structure_Component                                                
-- Ref Used: UT_Student_Fee_Add                                               
-- Author:      Abhik Porel                                                
-- Create date: 27.12.2023                                  
-- Modified date:12.02.2023                                  
-- Reason: Integrate Payment Installment Process                                  
-- Description: Savings Fee on Admission   and Installment generation                                             
-- =============================================                
CREATE  PROCEDURE [dbo].[usp_ERP_Get_Extra_Component_Installment_Breakup]                                
    @h_I_Stud_Fee_Struct_CompMap_ID INT = NULL,                                
    @I_Enquiry_Regn_ID int,                                
    @I_Fee_Structure_ID int,                                
    @I_School_Session_ID int,                                
    @I_Brand_ID int,                                
    @p_Is_Active bit = null,                                
    @p_I_CreatedBy int,                          
    @PaymentType int,                          
    @Fee_Details_On_Admission [UT_Student_Fee_Add] READONLY                                
AS                                
Begin                                
    SET NOCOUNT ON;                                
    BEGIN TRY                                
        BEGIN TRANSACTION;           
            
  DECLARE @OutputInvNo Varchar(20),                                
                @Inv_DT Date                                
            SET @Inv_DT = Convert(Date, Getdate())         
   Declare @Currency_ID int      
   SET @Currency_ID=(select top 1 I_Currency_Type_ID from T_ERP_Fee_Structure       
   where I_Fee_Structure_ID=@I_Fee_Structure_ID) 
   
  -- select * from @Fee_Details_On_Admission
              --Select @Currency_ID                         
   ----Fetching Fee Structure Component Details-----------  
   Select distinct 0 As I_Fee_Structure_ID ,                        
       R_I_Fee_Component_ID as R_I_Fee_Component_ID,                        
       Comp_Seq I_Seq_No,                        
       N_Component_Actual_Amount N_Component_Actual_Total_Annual_Amount,                        
       I_Fee_Pay_Installment_ID R_I_Fee_Pay_Installment_ID,                   
       Is_Active Is_Active,                        
       h_I_Stud_Fee_Struct_CompMap_ID I_Stud_Fee_Struct_CompMap_ID,                        
       I_Stud_Fee_Struct_CompMap_Details_ID I_Stud_Fee_Struct_CompMap_Details_ID,          
    I_ExtracomponentRef_ID I_ExtracomponentRef_ID,          
    I_ExtracomponentRef__Type I_ExtracomponentRef_Type
              
       Into #tempFeeStructure 
       from                       
       @Fee_Details_On_Admission    
	   
     ------Fine Implement----------    
	 Declare @Is_Fine_Applicable int,@FineTagID int
	 Set @Is_Fine_Applicable=(
	 Select top 1 isnull(Is_Late_Fine_Applicable ,0)
	 from T_ERP_Fee_Structure with(Nolock) where I_Fee_Structure_ID=@I_Fee_Structure_ID
	 )
	  Set @FineTagID=(
	 Select top 1 isnull(R_I_FineRangeTagID ,0)
	 from T_ERP_Fee_Structure with(Nolock) where I_Fee_Structure_ID=@I_Fee_Structure_ID
	 )

	 ------- Individual extra component ---------


	 Create Table #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra                                
            (     
				I_Stud_Fee_Struct_CompMap_ID int IDENTITY(1,1),
                R_I_Enquiry_Regn_ID int,                                
                R_I_Fee_Structure_ID int,                                
                R_I_School_Session_ID int,                                
                I_Brand_ID int,                                
                N_Comp_Total_Amount decimal(8,2),                                
                N_Component_Wise_TotalAmt decimal(8,2),                                
                S_Invoice_No varchar(max),                                
                Dtt_Created_At datetime,                                
                Dtt_Modified_At datetime,                                
                I_Created_By int,                                
                I_Modified_By int,                                
                Is_Active bit,                          
                Is_LumpSum bit,
				I_Currency_ID int,
				Is_Fine_Applicable bit,
				I_FineTagID int
            ) 





			create table #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra                        
            (      
				I_Stud_Fee_Struct_CompMap_Details_ID int identity(1,1),
				CGST_per numeric,
				SGST_per numeric,
				IGST_per numeric,
				IGST_value numeric(8,2),
				CGST_value numeric(8,2),
				SGST_value numeric(8,2),
                R_I_Stud_Fee_Struct_CompMap_ID int,                                
                R_I_Fee_Structure_ID int,                                
                R_I_Fee_Component_ID int,                                
                N_Component_Actual_Amount decimal(8,2),                        
                Seq int,                      
                Dtt_Created_At datetime,                                
                Dtt_Modified_At datetime,                                
                I_Created_By int,                                
                I_Modified_By int,                                
                Is_Active bit,                                
                R_I_Fee_Pay_Installment_ID int,          
                I_ExtracomponentRef_ID int,          
                I_ExtracomponentRef_Type int        
            )






	 ----------------------------------------------------------------------------------
    --drop table #tempFeeStructure                    
    --Select * from #tempFeeStructure                    
        IF @h_I_Stud_Fee_Struct_CompMap_ID IS NULL                                
        Begin                           
    ------Generate Invoice Number---------                                
        EXEC USP_Stud_InvNo_Generate_and_Update @Inv_DT,                                
              @I_Brand_ID,                                
               @I_School_Session_ID,                            
                                                @type='INV',                            
              @Inv_No_Out = @OutputInvNo OUTPUT;                                
            ---------------------------------                            
                               
           INSERT INTO #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra                                
            (                                
                R_I_Enquiry_Regn_ID,                                
                R_I_Fee_Structure_ID,                                
                R_I_School_Session_ID,                                
                I_Brand_ID,                                
                N_Comp_Total_Amount,                                
                N_Component_Wise_TotalAmt,                                
                S_Invoice_No,                                
                Dtt_Created_At,                                
                Dtt_Modified_At,                                
                I_Created_By,                                
                I_Modified_By,                                
                Is_Active ,                          
                Is_LumpSum 
	
              
            )                                
            values                                
            (   @I_Enquiry_Regn_ID,                                
                @I_Fee_Structure_ID,                                
                @I_School_Session_ID,                                
                @I_Brand_ID,                                
                Null,                                
                Null,                                
                @OutputInvNo, -----For Inv No generation                                               
                @Inv_DT,                                
                Null,                                
                @p_I_CreatedBy,                                
                Null,                                
                @p_Is_Active ,                          
                @PaymentType
				
            )                                
            SET @h_I_Stud_Fee_Struct_CompMap_ID = SCOPE_IDENTITY();                                
        END                          
                                     
           --   select * from #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra

           
-----Inserting Data into Student mapping Details----            
INSERT  Into    #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra                           
            (                                
                R_I_Stud_Fee_Struct_CompMap_ID,                                
                R_I_Fee_Structure_ID,                                
                R_I_Fee_Component_ID,                                
                N_Component_Actual_Amount,                        
                Seq,                      
                Dtt_Created_At,                                
                Dtt_Modified_At,                                
                I_Created_By,                                
                I_Modified_By,                                
                Is_Active,                                
                R_I_Fee_Pay_Installment_ID ,          
                I_ExtracomponentRef_ID,          
                I_ExtracomponentRef_Type          
            )                                
             Select                       
             @h_I_Stud_Fee_Struct_CompMap_ID,                                
             I_Fee_Structure_ID,                                
             R_I_Fee_Component_ID,                                
             N_Component_Actual_Total_Annual_Amount,                            
             I_Seq_No,                            
             getdate(),                                
             Null,                                
             @p_I_CreatedBy,                                
             Null,                                
             [Is_Active],                                
             R_I_Fee_Pay_Installment_ID,          
             I_ExtracomponentRef_ID,          
             I_ExtracomponentRef_Type          
             From #tempFeeStructure   
			 

			-- select * from #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra
      -----------------------------------------------------------------            
    ------------------GST Implementation----------------------------   
	
				Create Table #GST_Component_Amount(
				ID Int Identity(1,1),
				R_I_Stud_Fee_Struct_CompMap_ID int,
				R_I_Fee_Component_ID int,
				N_Component_Actual_Amount Numeric(18,2),
				I_GST_FeeComponent_Catagory_ID int,
				I_Stud_Fee_Struct_CompMap_Details_ID bigint
				)
				Insert Into #GST_Component_Amount(
				R_I_Stud_Fee_Struct_CompMap_ID,R_I_Fee_Component_ID,N_Component_Actual_Amount,
				I_GST_FeeComponent_Catagory_ID,I_Stud_Fee_Struct_CompMap_Details_ID
				)
				Select a.R_I_Stud_Fee_Struct_CompMap_ID,a.R_I_Fee_Component_ID,a.N_Component_Actual_Amount,
				b.I_GST_FeeComponent_Catagory_ID,a.I_Stud_Fee_Struct_CompMap_Details_ID
				from #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra a
				Inner Join T_ERP_GST_Item_Category b on a.R_I_Fee_Component_ID=b.I_Fee_Component_ID
				Inner Join #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra c 
				on c.I_Stud_Fee_Struct_CompMap_ID=a.R_I_Stud_Fee_Struct_CompMap_ID

				where  c.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and c.R_I_School_Session_ID=@I_School_Session_ID
				and c.I_Brand_ID=@I_Brand_ID and b.Is_Active=1

				--Select * from #GST_Component_Amount
				--Drop table #GST_Component_Amount


				Declare @GSTCategoryID int,@Fee_Component_Amount Numeric(18,2),
				@SGST_Per numeric(10,2), @SGST_Value numeric(18,2),
				@CGST_Per numeric(10,2), @CGST_Value numeric(18,2),
				@IGST_Per numeric(10,2), @IGST_Value numeric(18,2),
				@Stud_Fee_Struct_CompMap_Details_ID bigint

				Declare @ID int=1
				Declare @Lst Int
				SET @Lst=(SElect MAX(ID) from #GST_Component_Amount)

				While @ID<=@Lst
				Begin 
				SET @GSTCategoryID=(
				Select I_GST_FeeComponent_Catagory_ID from #GST_Component_Amount where ID=@ID
				)
				SET @Fee_Component_Amount=(
				Select N_Component_Actual_Amount from #GST_Component_Amount where ID=@ID
				)
				SET @Stud_Fee_Struct_CompMap_Details_ID=(
				Select I_Stud_Fee_Struct_CompMap_Details_ID from #GST_Component_Amount where ID=@ID
				)

				SET @IGST_Per =(
				Select Top 1 N_IGST from T_ERP_GST_Configuration_Details where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID
				and @Fee_Component_Amount between N_Start_Amount and N_End_Amount
				)

				SET @CGST_Per =(
				Select Top 1 N_CGST from T_ERP_GST_Configuration_Details where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID
				and @Fee_Component_Amount between N_Start_Amount and N_End_Amount
				)

				SET @SGST_Per =(
				Select Top 1 N_SGST from T_ERP_GST_Configuration_Details where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID
				and @Fee_Component_Amount between N_Start_Amount and N_End_Amount
				)

				SET @SGST_Value=(@Fee_Component_Amount * @SGST_Per / 100) 
				SET @CGST_Value=(@Fee_Component_Amount * @CGST_Per / 100) 
				SET @IGST_Value=(@Fee_Component_Amount * @IGST_Per / 100) 

				--Select @GSTCategoryID
				--Select @Fee_Component_Amount
				--Select @IGST_Per,@CGST_Per,@SGST_Per
				--Select @IGST_Value,@SGST_Value,@CGST_Value

				Update #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra set 
				 CGST_per=@CGST_Per
				,SGST_per=@SGST_Per
				,IGST_per=@IGST_Per
				,IGST_value=@IGST_Value
				,CGST_value=@CGST_Value
				,SGST_value=@SGST_Value
				Where I_Stud_Fee_Struct_CompMap_Details_ID=@Stud_Fee_Struct_CompMap_Details_ID and Is_Active=1

				SET @ID=@ID+1



				End
				
				Drop Table #GST_Component_Amount
				


  -- EXEC ERP_FEE_GST_Generation @I_Enquiry_Regn_ID,@I_School_Session_ID,@I_Brand_ID        
  ---------------------------------------------------------------------        
             
        ----Generate Installment Payment Process----------                                  
        --EXEC usp_ERP_Fee_InstallmentPayment @Enquiry_Regn_ID = @I_Enquiry_Regn_ID,                                
        --                                    @School_Session_ID = @I_School_Session_ID,                                
        --                                    @I_Brand_ID = @I_Brand_ID  ,                    
        --                                    @PaymentType1=@PaymentType 
		

		--- ***** ---


		  Declare @sessionstDt date,                  
            @sessionEndDt Date                  
                  
    select @sessionstDt = Convert(Date, Dt_Session_Start_Date),                  
           @sessionEndDt = Convert(Date, Dt_Session_End_Date)                  
    from T_School_Academic_Session_Master                  
    where I_School_Session_ID = @I_School_Session_ID
	


	DECLARE @CurrentYearFirstDay DATE = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);
DECLARE @NextMonth DATE = DATEADD(MONTH, MONTH(GETDATE()), @CurrentYearFirstDay);
--select @NextMonth

--select * from #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra
	-------

	CREATE TABLE #T_ERP_Fee_Payment_Installment_For_Revise
	(
	[I_Fee_Component_InstallmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[TempInv] [varchar](100) NULL,
	[R_I_Enquiry_Regn_ID] [int] NULL,
	[I_Stud_Fee_Struct_CompMap_Details_ID] [bigint] NULL,
	[R_I_Fee_Structure_ID] [int] NULL,
	[R_I_Fee_Component_ID] [int] NULL,
	[Seq] [int] NULL,
	[Dt_Payment_Installment_Dt] [date] NULL,
	[N_Installment_Amount] [numeric](18, 2) NULL,
	[I_Installment_Status] [tinyint] NULL,
	[N_Received_Amt] [numeric](18, 2) NULL,
	[Adv_Amt] [numeric](12, 2) NULL,
	[Dt_Payment_Dt] [date] NULL,
	[Is_Active] [bit] NULL,
	[Dt_LateFine_Due_Dt] [date] NULL,
	[Dtt_Created_At] [datetime] NULL,
	[Dtt_Modified_At] [datetime] NULL,
	[Is_Cancelled] [bit] NULL,
	[Is_Moved] [bit] NULL,
	[DT_Moved_Dt] [datetime] NULL,
	[N_CGST_Per] [numeric](10, 2) NULL,
	[N_SGST_Per] [numeric](10, 2) NULL,
	[N_IGST_Per] [numeric](10, 2) NULL,
	[N_CGST_Value] [numeric](10, 2) NULL,
	[N_SGST_Value] [numeric](10, 2) NULL,
	[N_IGST_Value] [numeric](10, 2) NULL
	)

	-----

 --   Select @sessionstDt as sessiondt,@sessionEndDt sessionenddt
--	select * from #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra
	--select * from #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra

	DECLARE @RemainingMonth int = DATEDIFF(MONTH, CONVERT(DATE, GETDATE()), CONVERT(DATE, @sessionEndDt));

	--print @RemainingMonth
	
    If   @PaymentType=1        
		 Begin        
		 Insert Into #T_ERP_Fee_Payment_Installment_For_Revise                  
			(                  
				R_I_Enquiry_Regn_ID,                  
				I_Stud_Fee_Struct_CompMap_Details_ID,                  
				R_I_Fee_Structure_ID,                  
				R_I_Fee_Component_ID,                
				Seq,              
				TempInv,              
				Dt_Payment_Installment_Dt,                  
				N_Installment_Amount,                  
				I_Installment_Status,                  
				Is_Active,                  
				Dt_LateFine_Due_Dt,                  
				Dtt_Created_At,                  
				Dtt_Modified_At  ,    
				N_CGST_Value,      
				N_SGST_Value,      
				N_IGST_Value      
			)          
		 Select         
		 cm.R_I_Enquiry_Regn_ID,        
		 cd.I_Stud_Fee_Struct_CompMap_Details_ID,        
		 cm.R_I_Fee_Structure_ID,        
		 cd.R_I_Fee_Component_ID,        
		 cd.Seq,        
		 Null ,        
		 @sessionstDt,        
		 N_Component_Actual_Amount,        
		 0,        
		 1,        
		 Null,        
		 GETDATE(),        
		 Null  ,    
		 Isnull(CGST_value,0) as CGST_value ,      
		 Isnull(SGST_value,0) as SGST_value ,  
		 Isnull((CGST_value+SGST_value),0) as IGST_value  
		 --IGST_value     
        
		 from #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra cd        
		 Inner Join #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra cm        
		 on cm.I_Stud_Fee_Struct_CompMap_ID=cd.R_I_Stud_Fee_Struct_CompMap_ID        
		 and cm.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID         
		 and cm.I_Brand_ID=@I_Brand_ID and cm.R_I_School_Session_ID=@I_School_Session_ID        
		 End         
		 Else        
		 Begin 
	--	select @PaymentType
			SELECT IDENTITY(INT, 1, 1) AS ID,                  
				   a.R_I_Stud_Fee_Struct_CompMap_ID,                  
				   a.I_Stud_Fee_Struct_CompMap_Details_ID,                  
				   a.R_I_Fee_Structure_ID,                  
				   a.R_I_Fee_Component_ID,                  
				   a.N_Component_Actual_Amount,                
				   a.Seq,                
				   b.I_Pay_InstallmentNo,  
				   CASE when b.I_Pay_InstallmentNo > @RemainingMonth THEN @RemainingMonth/@RemainingMonth 
				   ELSE @RemainingMonth/b.I_Pay_InstallmentNo END I_Interval,
				   --b.I_Interval,                  
				   @sessionstDt as StartDt,                  
				   b.I_Fee_Pay_Installment_ID,                  
				   a.Is_Active ,    
			 CGST_value,      
			 SGST_value,      
			 CGST_value+SGST_value   as IGST_value  
			Into #Stud_Fee_Installment                  
			from #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra a                  
				Inner Join T_ERP_Fee_PaymentInstallment_Type b                  
					on a.R_I_Fee_Pay_Installment_ID = b.I_Fee_Pay_Installment_ID                  
				Inner Join #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra c                  
					on c.I_Stud_Fee_Struct_CompMap_ID = a.R_I_Stud_Fee_Struct_CompMap_ID                  
			where c.R_I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID                  
				  and c.R_I_School_Session_ID = @I_School_Session_ID                
				  and c.I_Brand_ID = @I_Brand_ID    and a.Is_Active=1  and c.Is_Active=1            ----Drop table #Stud_Fee_Installment                      
		   
		--   select * from #Stud_Fee_Installment 
		   
			Create Table #FinalInstallment                  
			(                  
				ID int Identity(1, 1),                  
				Stud_Enquiry_ID int,                  
				Stud_CompMapID int,                  
				Stud_Comp_MapDetailID bigint,              
		  TempInvNo Varchar(20),              
				Fee_Structure_ID int,                  
				Fee_ComponentID int,                
				Seq int,                
				Installmentdt date,                  
				Installment_Amt Numeric(18, 2),                  
				Status bit ,    
			CGST_ Numeric(18,2),      
		  SGST_ Numeric(18,2),      
		  IGST_ numeric(18,2)    
			)                  
			Declare @FeeStrucID int,                  
					@Fee_ComponentID int,                 
					@seq int,                
					@ComponentAmt Numeric(18, 2),                  
					@installno int,                  
					@interval int,                  
					@Stud_Comp_MapDetailID bigint,                  
					@Stud_CompMapID int,                  
					@status Int,@CGSTVal Numeric(18,2),@SGSTVal Numeric(18,2),@IGSTVal Numeric(18,2) ,                 
					@ilst int,                  
					@iID int = 1                  
			SET @ilst =                  
			(                  
				select max(ID) from #Stud_Fee_Installment                  
			)                  
			WHILE @iID <= @ilst                  
			BEGIN                  
                  
				--select * from #Stud_Fee_Installment                      
				select Top 1                  
					@Stud_CompMapID = R_I_Stud_Fee_Struct_CompMap_ID,                  
					@Stud_Comp_MapDetailID = I_Stud_Fee_Struct_CompMap_Details_ID,                  
					@FeeStrucID = R_I_Fee_Structure_ID,                  
					@Fee_ComponentID = R_I_Fee_Component_ID,                
					@seq=Seq,                
					@ComponentAmt = N_Component_Actual_Amount,                  
					@installno = I_Pay_InstallmentNo,                  
					@interval = I_Interval,                  
					@status = Is_Active ,    
		   @CGSTVal=CGST_value,    
		   @SGSTVal=SGST_value,    
		   @IGSTVal=IGST_value    
				from #Stud_Fee_Installment                  
				where ID = @iID                  
              
                  
				If @interval <> 0                  
				Begin                  
					SELECT @interval As Interval,                  
						   InstallmentDate                  
					Into #IntervalInstallment                  
					FROM dbo.GetInstallmentDatesInFinancialYear(@NextMonth, @sessionEndDt, @NextMonth, @interval);                  
					
					--select * from #IntervalInstallment
					
					Insert Into #FinalInstallment                  
					(                  
						Stud_Enquiry_ID,                  
						Stud_CompMapID,                  
						Stud_Comp_MapDetailID,                  
						Fee_Structure_ID,                  
						Fee_ComponentID,                
						Seq,               
						TempInvNo,              
						Installmentdt,                  
						Installment_Amt,                  
						Status ,    
			CGST_,    
			SGST_,    
			IGST_    
			  )                  
					Select @I_Enquiry_Regn_ID,                  
						   fi.R_I_Stud_Fee_Struct_CompMap_ID,                  
						   fi.I_Stud_Fee_Struct_CompMap_Details_ID,                  
						   fi.R_I_Fee_Structure_ID,                  
						   fi.R_I_Fee_Component_ID,                
						   FI.Seq,              
						   Null,              
						   ii.InstallmentDate,                  
						ceiling(Convert(Numeric(18, 2),     
			   (fi.N_Component_Actual_Amount / fi.I_Pay_InstallmentNo))) as InstallmentAmount,                  
						   @status,    
			   ceiling(Convert(Numeric(18, 2),(fi.CGST_value /fi.I_Pay_InstallmentNo))) as CGST_Val,    
			   ceiling(Convert(Numeric(18, 2),(fi.SGST_value /fi.I_Pay_InstallmentNo))) as SGST_Val,    
			   --ceiling(Convert(Numeric(18, 2),(fi.IGST_value /fi.I_Pay_InstallmentNo))) as IGST_Val   
			ceiling(Convert(Numeric(18, 2),(fi.CGST_value /fi.I_Pay_InstallmentNo)))+ceiling(Convert(Numeric(18, 2),(fi.SGST_value /fi.I_Pay_InstallmentNo))) as IGST_Val  
						   from #IntervalInstallment ii                  
						Left Join #Stud_Fee_Installment fi                  
							on ii.Interval = fi.I_Interval                  
					where fi.ID = @iID  
					

                  
				End                  
				Else                  
				Begin                  
					Insert Into #FinalInstallment                  
					(                  
						Stud_Enquiry_ID,                  
						Stud_CompMapID,                  
						Stud_Comp_MapDetailID,                  
						Fee_Structure_ID,                  
						Fee_ComponentID,                
						Seq,              
						TempInvNo,              
						Installmentdt,                  
						Installment_Amt,                  
						Status  ,    
			CGST_,    
			SGST_,    
			IGST_    
					)               
					Select @I_Enquiry_Regn_ID,                  
						   @Stud_CompMapID,                  
						   @Stud_Comp_MapDetailID,                  
						   @FeeStrucID,                  
						   @Fee_ComponentID,                
						   @seq,              
						   Null,              
						   @sessionstDt,                  
						   @ComponentAmt,                  
						   @status ,    
			   ceiling(@CGSTVal),    
			   ceiling(@SGSTVal),    
			   ceiling(@CGSTVal+@SGSTVal)    
				End                  
                  
				IF OBJECT_ID(N'tempdb..#IntervalInstallment') IS NOT NULL                  
				BEGIN                  
					DROP TABLE #IntervalInstallment                  
				END                  
				Set @iID = @iID + 1                  
			END                  
           
          
			Insert Into #T_ERP_Fee_Payment_Installment_For_Revise                  
			(                  
				R_I_Enquiry_Regn_ID,                  
				I_Stud_Fee_Struct_CompMap_Details_ID,                  
				R_I_Fee_Structure_ID,                  
				R_I_Fee_Component_ID,                
				Seq,              
				TempInv,              
				Dt_Payment_Installment_Dt,                  
				N_Installment_Amount,                  
				I_Installment_Status,                  
				Is_Active,                  
				Dt_LateFine_Due_Dt,                  
				Dtt_Created_At,                  
				Dtt_Modified_At ,    
		  N_CGST_Value,    
		  N_SGST_Value,    
		  N_IGST_Value    
			)                  
			Select @I_Enquiry_Regn_ID,                  
				   Stud_Comp_MapDetailID,                  
				   Fee_Structure_ID,                  
				   Fee_ComponentID,                
				   Seq,              
				   TempInvNo,              
				   Installmentdt,                  
				   Installment_Amt,                  
				   0,                  
				   Status,                  
				   null,                  
				   GETDATE(),                  
				   Null ,    
			 Isnull((ceiling(CGST_)),0) as CGST_ ,    
			 Isnull((ceiling(SGST_)),0) as SGST_ ,    
			 Isnull((ceiling(CGST_+SGST_)),0) as IGST_    
			from #FinalInstallment t                  
		 --Where Not Exists                  
		 --   (                  
		 --       Select 1                  
		 --       from T_ERP_Fee_Payment_Installment f                  
		 --       where t.Stud_Enquiry_ID = @Enquiry_Regn_ID                  
		 --             and t.Stud_Comp_MapDetailID = f.I_Stud_Fee_Struct_CompMap_Details_ID                  
		 --   )                  
			--Truncate table #FinalInstallment                      
			IF OBJECT_ID(N'tempdb..#FinalInstallment') IS NOT NULL                  
			BEGIN                  
				DROP TABLE #FinalInstallment                  
			END                  
			IF OBJECT_ID(N'tempdb..#Stud_Fee_Installment') IS NOT NULL       
			BEGIN                  
				DROP TABLE #Stud_Fee_Installment           
			END          
		 End    







		--- ***** ---

 ----** Get the Installment  **------------------------------------------------------            
        
DECLARE @SGST_Tax_ID int,@CGST_Tax_ID int,@IGST_Tax_ID int  
set @SGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='SGST')  
set @CGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='CGST')  
set @IGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='IGST')  
Select distinct            
ROW_NUMBER() OVER (ORDER BY Dt_Payment_Installment_Dt) AS ID,            
Case When CPD.I_Course_Fee_Plan_Detail_ID  is NULL  Then 0      
Else       
CPD.I_Course_Fee_Plan_Detail_ID End  as I_Course_Fee_Plan_Detail_ID,            
a.R_I_Fee_Component_ID As I_Fee_Component_ID,      
Case When       
CP.I_Course_Fee_Plan_ID Is Null Then 0 Else       
CP.I_Course_Fee_Plan_ID End      
As I_Course_Fee_Plan_ID,            
--Ceiling(a.N_Installment_Amount )as I_Item_Value,            
CASE          
        WHEN a.N_Installment_Amount - FLOOR(a.N_Installment_Amount) >= 0.5 THEN CEILING(a.N_Installment_Amount)          
        ELSE FLOOR(a.N_Installment_Amount)          
    END AS I_Item_Value,          
'0.00' as N_Discount,            
Isnull(c.I_Pay_InstallmentNo ,0) as ActualInstalmentNo,            
a.Seq as I_Sequence,            
Case When d.Is_LumpSum=1 Then 'Y' Else 'N' End As C_Is_LumpSum,            
a.R_I_Fee_Component_ID As I_Display_Fee_Component_ID,            
Dt_Payment_Installment_Dt as InstalmentDate,            
DENSE_RANK() OVER (ORDER BY Dt_Payment_Installment_Dt) AS I_Installment_No ,  
a.N_CGST_Value CGST_Value,  
@CGST_Tax_ID AS CGST_Tax_ID,  
a.N_SGST_value SGST_value,  
@SGST_Tax_ID AS SGST_Tax_ID,  
a.N_IGST_Value IGST_Value,  
@IGST_Tax_ID AS IGST_Tax_ID  
--,Case When  CP.I_Course_Fee_Plan_ID Is not Null Then 1 Else 0 End as is_Individual          
--c.I_Pay_InstallmentNo as ActualInstalmentNo            
Into #TotalInstallment            
from #T_ERP_Fee_Payment_Installment_For_Revise a WITH(NOLOCK)            
Left Join #T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_For_Extra b WITH(NOLOCK) ON a.I_Stud_Fee_Struct_CompMap_Details_ID=            
b.I_Stud_Fee_Struct_CompMap_Details_ID and a.R_I_Fee_Component_ID=b.R_I_Fee_Component_ID            
Left Join T_ERP_Fee_PaymentInstallment_Type c WITH(NOLOCK) on c.I_Fee_Pay_Installment_ID=b.R_I_Fee_Pay_Installment_ID            
Left Join #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra d WITH(NOLOCK)            
on d.I_Stud_Fee_Struct_CompMap_ID=b.R_I_Stud_Fee_Struct_CompMap_ID            
Left Join T_Course_Fee_Plan CP WITH(NOLOCK) on CP.I_New_I_Fee_Structure_ID=d.R_I_Fee_Structure_ID            
Left Join T_Course_Fee_Plan_Detail CPD WITH(NOLOCK) on CPD.I_Course_Fee_Plan_ID=CP.I_Course_Fee_Plan_ID            
and CPD.I_Fee_Component_ID=b.R_I_Fee_Component_ID and    
CPD.C_Is_LumpSum=Case When d.Is_LumpSum=0 Then 'N' Else 'Y' End  
where a.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID      
group by            
a.R_I_Fee_Component_ID,Dt_Payment_Installment_Dt,c.I_Pay_InstallmentNo,a.N_Installment_Amount,            
a.Seq,d.Is_LumpSum,CP.I_Course_ID,CPD.I_Course_Fee_Plan_Detail_ID,CP.I_Course_Fee_Plan_ID,a.N_CGST_Value            
    ,a.N_SGST_Value,a.N_IGST_Value        
order by ID,a.R_I_Fee_Component_ID,Dt_Payment_Installment_Dt            
--Select * from #TotalInstallment            
            
Select             
I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID            
,SUM(I_Item_Value) as I_Item_Value,'0.00' As N_Discount,            
'1' As ActualInstalmentNo,I_Sequence,C_Is_LumpSum,I_Display_Fee_Component_ID,            
Convert(Date,Getdate()) AS InstalmentDate,1 As I_Installment_No ,  
Sum(CGST_value) CGST_value,CGST_Tax_ID,Sum(SGST_value) SGST_value,SGST_Tax_ID,Sum(IGST_value) IGST_value,IGST_Tax_ID  
            
Into #temp1            
from #TotalInstallment where InstalmentDate<=CONVERT(daTE,GETDATE())            
Group By I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID,I_Sequence            
,C_Is_LumpSum,I_Display_Fee_Component_ID,CGST_value,CGST_Tax_ID,SGST_value,SGST_Tax_ID,IGST_value,
IGST_Tax_ID       
   --Select * from    #temp1   
   --drop table #temp1
Select            
ROW_NUMBER() OVER (ORDER BY I_Fee_Component_ID) AS ID,            
*        
Into #FinalInvdATA    
--Into #temp3          
from #temp1            
uNION aLL            
Select * from #TotalInstallment where InstalmentDate>CONVERT(DATE,gETDATE())            
 Select distinct *,Case When  I_Course_Fee_Plan_Detail_ID<>0 Then 1 Else 0 End As Is_Individual    
 from #FinalInvdATA



-------------------------------------------------------------------
        
         -- update T_Enquiry_Regn_Detail set R_I_AdmStgTypeID = 6 where I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID                      
    Update #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra set I_Currency_ID=@Currency_ID      
    where I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID  

	-------------Fine Update---------------------
	    Update #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra set Is_Fine_Applicable=@Is_Fine_Applicable
		,I_FineTagID=@FineTagID
        where I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID  

	-------------------------------------------------------------------------

   select DISTINCT Is_Fine_Applicable,I_FineTagID from #T_ERP_Stud_Fee_Struct_Comp_Mapping_For_Extra                              
        
                          
        COMMIT;                                
    END TRY                                
    BEGIN CATCH                                
        IF @@TRANCOUNT > 0                                
            ROLLBACK;                                
                                
        DECLARE @ErrMsg NVARCHAR(4000),        
                @ErrSeverity int                                
                                
        SELECT 'Error-On Temporary Saving data' as Message,                                
               0 StatusFlag                                
                                
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                                
                                
    END CATCH;                                
END;
