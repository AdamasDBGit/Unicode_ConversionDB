

CREATE PROCEDURE [dbo].[usp_ERP_Map_Fee_with_Student]                                                  
    @h_I_Stud_Fee_Struct_CompMap_ID INT = NULL,                                                  
    @I_Enquiry_Regn_ID int,                                                  
    @I_Fee_Structure_ID int,                                                  
    @I_School_Session_ID int,                                                  
    @I_Brand_ID int,                                                  
    @p_Is_Active bit = null,                                                  
    @p_I_CreatedBy int,                                            
    @PaymentType int null,                                            
    @Fee_Details_On_Admission [UT_Extra_Component_Fee_Add] READONLY,              
    @routeID int =null,
	@UsedForReAdmit bit=null,
	@ReadmissionRequestID int=null
AS                                                  
Begin                                                  
    SET NOCOUNT ON;                                                  
    BEGIN TRY                                                  
        BEGIN TRANSACTION;                             
                              
  DECLARE @OutputInvNo nvarchar(max),                                                  
                @Inv_DT Date                                                  
            SET @Inv_DT = Convert(Date, Getdate())                           
   Declare @Currency_ID int                        
   SET @Currency_ID=(select top 1 I_Currency_Type_ID from T_ERP_Fee_Structure                         
   where I_Fee_Structure_ID=@I_Fee_Structure_ID)                        
              --Select @Currency_ID                                           
   ----Fetching Fee Structure Component Details-----------                                          
       Select distinct F.I_Fee_Structure_ID,                                          
       Comp.R_I_Fee_Component_ID,                                          
       Comp.I_Seq_No,                                          
       Comp.N_Component_Actual_Total_Annual_Amount,                                          
       Comp.R_I_Fee_Pay_Installment_ID,                                          
       1 as Is_Active,                                          
       cp.I_Stud_Fee_Struct_CompMap_ID,                                          
       cd.I_Stud_Fee_Struct_CompMap_Details_ID,                            
       cd.I_ExtracomponentRef_ID,                            
       cd.I_ExtracomponentRef_Type                   
                                         
       Into #tempFeeStructure                                          
       from T_ERP_Fee_Structure_Session_Installment_Breakup Comp                                          
       inner Join T_ERP_Fee_Structure F                                          
        on F.I_Fee_Structure_ID = Comp.I_Fee_Structure_ID                              
  ANd F.I_Fee_Structure_ID =@I_Fee_Structure_ID                               
  Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping cp                                           
  on cp.R_I_Fee_Structure_ID=F.I_Fee_Structure_ID                                                      
  And cp.I_Brand_ID=@I_Brand_ID                               
  and cp.R_I_School_Session_ID=@I_School_Session_ID        
  and cp.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID                               
  Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details cd                                           
  on cp.I_Stud_Fee_Struct_CompMap_ID=cd.R_I_Stud_Fee_Struct_CompMap_ID                                          
  And Comp.R_I_Fee_Component_ID=cd.R_I_Fee_Component_ID         
  Inner Join T_ERP_Fee_Structure_AcademicSession_Map ASM         
  ON ASM.I_Fee_Structure_AcademicSession_Map_ID=Comp.I_Fee_Structure_AcademicSession_Map_ID        
  and ASM.I_School_Session_ID=@I_School_Session_ID        
  where                                          
       F.Is_Active = 1  -- and  Comp.Is_OneTime=@PaymentType                                      
--   Union All                                          
--Select 0 As I_Fee_Structure_ID,                                          
--       R_I_Fee_Component_ID,                                          
--       Comp_Seq,                                     
--       [N_Component_Actual_Amount],                                          
--       I_Fee_Pay_Installment_ID,                                     
--       [Is_Active],                                          
--       [h_I_Stud_Fee_Struct_CompMap_ID],                                          
--       [I_Stud_Fee_Struct_CompMap_Details_ID] ,                            
--       I_ExtracomponentRef_ID,                            
--       I_ExtracomponentRef__Type                    
                  
--       from @Fee_Details_On_Admission                                       
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
                                                 
           INSERT INTO T_ERP_Stud_Fee_Struct_Comp_Mapping                                                  
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
                Is_LumpSum,
				UseForReAdmit
                   
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
                @PaymentType ,                 
                @UsedForReAdmit      
            )                                                  
            SET @h_I_Stud_Fee_Struct_CompMap_ID = SCOPE_IDENTITY();                                                  
        END                                            
                                          
        ELSE                                                  
        Begin                                                  
                                                  
    UPDATE T_ERP_Stud_Fee_Struct_Comp_Mapping                                                  
            SET R_I_Fee_Structure_ID = @I_Fee_Structure_ID,                                                  
                Dtt_Modified_At = Getdate(),                                                  
                I_Modified_By = @p_I_CreatedBy,                                                  
                Is_Active = 1,                              
                Is_LumpSum=@PaymentType ,
				Is_Moved=null,
				UseForReAdmit=Case when @UsedForReAdmit=1 Then 1 Else 0 end
            from T_ERP_Stud_Fee_Struct_Comp_Mapping a1                                                  
            --Inner Join #tempFeeStructure UT                                                  
            --on UT.I_Stud_Fee_Struct_CompMap_ID = a1.I_Stud_Fee_Struct_CompMap_ID                           
            where a1.I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID                                          
                                                  
        End                                                  
                                
            ----Deleting Data from Installment Table First-----    
			



			 ----Deleting Data from Installment Table First-----
			
INSERT INTO T_ERP_Fee_Payment_Installment_Delete_history (
    I_Fee_Component_InstallmentID,
    TempInv,
    R_I_Enquiry_Regn_ID,
    I_Stud_Fee_Struct_CompMap_Details_ID,
    R_I_Fee_Structure_ID,
    R_I_Fee_Component_ID,
    Seq,
    Dt_Payment_Installment_Dt,
    N_Installment_Amount,
    I_Installment_Status,
    N_Received_Amt,
    Adv_Amt,
    Dt_Payment_Dt,
    Is_Active,
    Dt_LateFine_Due_Dt,
    Dtt_Created_At,
    Dtt_Modified_At,
    Is_Cancelled,
    Is_Moved,
    DT_Moved_Dt,
    N_CGST_Per,
    N_SGST_Per,
    N_IGST_Per,
    N_CGST_Value,
    N_SGST_Value,
    N_IGST_Value,
    Dt_Deleted_date  -- Add deletion timestamp manually
)
SELECT 
    I_Fee_Component_InstallmentID,
    TempInv,
    R_I_Enquiry_Regn_ID,
    I_Stud_Fee_Struct_CompMap_Details_ID,
    R_I_Fee_Structure_ID,
    R_I_Fee_Component_ID,
    Seq,
    Dt_Payment_Installment_Dt,
    N_Installment_Amount,
    I_Installment_Status,
    N_Received_Amt,
    Adv_Amt,
    Dt_Payment_Dt,
    Is_Active,
    Dt_LateFine_Due_Dt,
    Dtt_Created_At,
    Dtt_Modified_At,
    Is_Cancelled,
    Is_Moved,
    DT_Moved_Dt,
    N_CGST_Per,
    N_SGST_Per,
    N_IGST_Per,
    N_CGST_Value,
    N_SGST_Value,
    N_IGST_Value,
    GETDATE()  -- Set current date-time for deleted date
FROM T_ERP_Fee_Payment_Installment
WHERE I_Stud_Fee_Struct_CompMap_Details_ID IN (
    SELECT I_Stud_Fee_Struct_CompMap_Details_ID
    FROM T_ERP_Stud_Fee_Struct_Comp_Mapping_Details
    WHERE R_I_Stud_Fee_Struct_CompMap_ID IN (
        SELECT I_Stud_Fee_Struct_CompMap_ID 
        FROM T_ERP_Stud_Fee_Struct_Comp_Mapping
        WHERE R_I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID 
          AND I_Brand_ID = @I_Brand_ID 
          --AND R_I_School_Session_ID = @I_School_Session_ID
    )
);








delete from  T_ERP_Fee_Payment_Installment where I_Stud_Fee_Struct_CompMap_Details_ID in(                              
Select I_Stud_Fee_Struct_CompMap_Details_ID                               
from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details                              
where R_I_Stud_Fee_Struct_CompMap_ID in (                              
Select I_Stud_Fee_Struct_CompMap_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping                               
where R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and I_Brand_ID=@I_Brand_ID 
--AND                               
--R_I_School_Session_ID=@I_School_Session_ID                              
))                              
-----deleting STudent Mapping Details-------   


INSERT INTO T_ERP_Stud_Fee_Struct_Comp_Mapping_Details_Delete_History (
	I_Stud_Fee_Struct_CompMap_Details_ID,
	R_I_Stud_Fee_Struct_CompMap_ID,
	R_I_Fee_Structure_ID,
	R_I_Fee_Component_ID,
	Seq,
	N_Component_Actual_Amount,
	Dtt_Created_At,
	Dtt_Modified_At,
	I_Created_By,
	I_Modified_By,
	Is_Active,
	R_I_Fee_Pay_Installment_ID,
	Dt_Moved_DT,
	Is_Moved,
	I_ExtracomponentRef_ID,
	I_ExtracomponentRef_Type,
	CGST_per,
	SGST_per,
	IGST_per,
	IGST_value,
	CGST_value,
	SGST_value,
	I_ExtracomponentRef2_ID,
	Is_OneTime,
	Dt_Deleted_date
)
SELECT 
	I_Stud_Fee_Struct_CompMap_Details_ID,
	R_I_Stud_Fee_Struct_CompMap_ID,
	R_I_Fee_Structure_ID,
	R_I_Fee_Component_ID,
	Seq,
	N_Component_Actual_Amount,
	Dtt_Created_At,
	Dtt_Modified_At,
	I_Created_By,
	I_Modified_By,
	Is_Active,
	R_I_Fee_Pay_Installment_ID,
	Dt_Moved_DT,
	Is_Moved,
	I_ExtracomponentRef_ID,
	I_ExtracomponentRef_Type,
	CGST_per,
	SGST_per,
	IGST_per,
	IGST_value,
	CGST_value,
	SGST_value,
	I_ExtracomponentRef2_ID,
	Is_OneTime,
	GETDATE()
FROM T_ERP_Stud_Fee_Struct_Comp_Mapping_Details    
where R_I_Stud_Fee_Struct_CompMap_ID in (                              
Select I_Stud_Fee_Struct_CompMap_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping                               
where R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and I_Brand_ID=@I_Brand_ID 
--AND                               
--R_I_School_Session_ID=@I_School_Session_ID                              
) 




Delete                                  
from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details     
where R_I_Stud_Fee_Struct_CompMap_ID in (                              
Select I_Stud_Fee_Struct_CompMap_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping                               
where R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and I_Brand_ID=@I_Brand_ID 
--AND                               
--R_I_School_Session_ID=@I_School_Session_ID                              
)                              
-----Inserting Data into Student mapping Details----          
--Declare @I_Stud_Fee_Struct_CompMap_Details_ID bigint        
INSERT  Into    T_ERP_Stud_Fee_Struct_Comp_Mapping_Details                                             
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
                I_ExtracomponentRef_Type,        
    CGST_per,        
    SGST_per,        
    IGST_per,        
    CGST_value,        
    SGST_value,        
    IGST_value,      
 Is_OneTime      
      
           
                  
            )                                                  
             Select  DISTINCT                                       
             @h_I_Stud_Fee_Struct_CompMap_ID,                                                  
             t.I_Fee_Structure_ID,                                                  
             t.R_I_Fee_Component_ID,                                                  
             tt.totalamt,                                              
             I_Seq_No,                                              
             getdate(),                                                  
             Null,                                                  
             @p_I_CreatedBy,                                                  
             Null,                                                  
             ISNULL([Is_Active],1),                                                  
             R_I_Fee_Pay_Installment_ID,                            
             I_ExtracomponentRef_ID,                            
             I_ExtracomponentRef_Type ,        
    tt.tot_CGST_per,        
    tt.tot_SGST_per,        
    tt.tot_IGST_per,        
    tt.tot_CGST_val,        
    tt.tot_SGST_val,        
    tt.tot_IGST_val,       
 ISNULL(tt1.Is_OneTime,0) as Is_OneTime      
       
               
             From #tempFeeStructure  t        
    Inner Join        
    (        
           
select R_I_Fee_Component_ID,ib.I_Fee_Structure_ID,SUM(N_Component_Actual_Total_Annual_Amount) totalamt        
,SUM(CGST_value) tot_CGST_val        
,SUM(SGST_value) tot_SGST_val        
,SUM(IGST_value) tot_IGST_val        
,MAX(CGST_Perc) tot_CGST_per        
,MAX(SGST_Perc) tot_SGST_per        
,MAX(IGST_Perc) tot_IGST_per        
from T_ERP_Fee_Structure_Session_Installment_Breakup ib        
Inner Join T_ERP_Fee_Structure_AcademicSession_Map ASM         
  ON ASM.I_Fee_Structure_AcademicSession_Map_ID=ib.I_Fee_Structure_AcademicSession_Map_ID        
  and ASM.I_School_Session_ID=@I_School_Session_ID        
        
where ib.I_Fee_Structure_ID=@I_Fee_Structure_ID        
Group By R_I_Fee_Component_ID,ib.I_Fee_Structure_ID        
) tt ON t.I_Fee_Structure_ID=tt.I_Fee_Structure_ID         
and t.R_I_Fee_Component_ID=tt.R_I_Fee_Component_ID        
Left Join(      
select distinct ib1.I_Fee_Structure_ID,R_I_Fee_Component_ID,Is_OneTime       
from T_ERP_Fee_Structure_Session_Installment_Breakup ib1      
Inner Join T_ERP_Fee_Structure_AcademicSession_Map ASM1         
  ON ASM1.I_Fee_Structure_AcademicSession_Map_ID=ib1.I_Fee_Structure_AcademicSession_Map_ID        
  and ASM1.I_School_Session_ID=@I_School_Session_ID        
where ib1.I_fee_structure_ID=@I_Fee_Structure_ID      
)  tt1 ON tt1.I_Fee_Structure_ID=t.I_Fee_Structure_ID      
and t.R_I_Fee_Component_ID=tt1.R_I_Fee_Component_ID        
      
--select distinct ib1.I_Fee_Structure_ID,R_I_Fee_Component_ID,Is_OneTime       
--from T_ERP_Fee_Structure_Session_Installment_Breakup ib1      
--Inner Join T_ERP_Fee_Structure_AcademicSession_Map ASM1         
--  ON ASM1.I_Fee_Structure_AcademicSession_Map_ID=ib1.I_Fee_Structure_AcademicSession_Map_ID        
--  and ASM1.I_School_Session_ID=35        
--where ib1.I_fee_structure_ID=1162      
        
------------------------------------------------------------------------------------------------------------        
Insert Into T_ERP_Fee_Payment_Installment                              
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
        
 Select @I_Enquiry_Regn_ID,CMD.I_Stud_Fee_Struct_CompMap_Details_ID,        
 FB.I_Fee_Structure_ID        
 ,FB.R_I_Fee_Component_ID        
 ,FB.I_Seq_No        
 ,Null as tempinv        
 ,case when ISNULL(FB.Is_During_Admission,0)=0 Then  FB.Expected_Installment_Date        
 Else convert(date,GETDATE()) end         
 ,FB.N_Component_Actual_Total_Annual_Amount        
 ,0        
 ,1        
 ,Null        
 ,GETDATE()        
 ,Null        
 ,FB.CGST_value        
 ,FB.SGST_value        
 ,FB.IGST_value        
 from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details CMD        
 Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping CM         
 ON CM.I_Stud_Fee_Struct_CompMap_ID=CMD.R_I_Stud_Fee_Struct_CompMap_ID        
 Inner Join T_ERP_Fee_Structure_Session_Installment_Breakup FB         
 ON FB.I_Fee_Structure_ID=CM.R_I_Fee_Structure_ID and FB.R_I_Fee_Component_ID=CMD.R_I_Fee_Component_ID        
 Inner Join T_ERP_Fee_Structure_AcademicSession_Map ASM         
    ON ASM.I_Fee_Structure_AcademicSession_Map_ID=fb.I_Fee_Structure_AcademicSession_Map_ID        
    and ASM.I_School_Session_ID=@I_School_Session_ID        
 where CM.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and CM.R_I_Fee_Structure_ID=@I_Fee_Structure_ID        
 and cm.I_Brand_ID=@I_Brand_ID AND                               
    cm.R_I_School_Session_ID=@I_School_Session_ID           
      -----------------------------------------------------------------                              
  --  ------------------GST Implementation----------------------------                          
  -- EXEC ERP_FEE_GST_Generation @I_Enquiry_Regn_ID,@I_School_Session_ID,@I_Brand_ID                          
  -----------------------------------------------------------------------                          
                               
  --      ----Generate Installment Payment Process----------                                                    
  --      EXEC usp_ERP_Fee_InstallmentPayment @Enquiry_Regn_ID = @I_Enquiry_Regn_ID,                                                  
  --                                          @School_Session_ID = @I_School_Session_ID,                                                  
  --                     @I_Brand_ID = @I_Brand_ID  ,                                      
  --                                          @PaymentType1=@PaymentType ,          
  --         @FeeStructureID=@I_Fee_Structure_ID          
  -------------------------------------------------------------------                              
                          
                          
    update T_Enquiry_Regn_Detail set R_I_AdmStgTypeID = 6 where I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID                                        
    Update T_ERP_Stud_Fee_Struct_Comp_Mapping set I_Currency_ID=@Currency_ID                        
    where I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID                    
 -------------Fine Update-------------------------------------------                 
     Update T_ERP_Stud_Fee_Struct_Comp_Mapping set Is_Fine_Applicable=@Is_Fine_Applicable                  
     ,I_FineTagID=@FineTagID                  
        where I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID                    
                  
              
 ----------------------------------------------------------------------     
 -------Appened Extra Fee Component Here------------------    
 Declare @is_Exists int,@ExtraFeecomponentID int    
    
    
 --SET @ExtraFeecomponentID= (select * from @Fee_Details_On_Admission     
 SET @is_Exists=(    
 select ISNULL(COUNT(1),0) from @Fee_Details_On_Admission    
 )    
 If @is_Exists>0    
 Begin    
  Create table #ExtraFeecomponent (ID int identity(1,1),ExtraFeecomponentID  int)    
  Insert Into #ExtraFeecomponent( ExtraFeecomponentID)    
  Select Distinct [R_I_Fee_Component_ID] from @Fee_Details_On_Admission    

 select GIC.I_Fee_Component_ID,ISNULL(GCD.N_CGST,0) as CGST_Per,ISNULL(GCD.N_SGST,0) as SGST_Per
,ISNULL(GCD.N_IGST,0) as IGST_Per,GIC.I_GST_FeeComponent_Catagory_ID
into #GST_temp
from T_ERP_GST_Configuration_Details GCD
--Inner Join T_ERP_GST_Item_Category GIC 
Inner Join T_ERP_GST_Component_Mapping GIC 
ON GIC.I_GST_FeeComponent_Catagory_ID=GCD.I_GST_FeeComponent_Catagory_ID
and GIC.Is_Active=1
Inner Join #ExtraFeecomponent ect on ect.ExtraFeecomponentID=GIC.I_Fee_Component_ID
where GIC.I_GST_Component_Type=1-----For fee Component

drop table #ExtraFeecomponent    
 Print 'extra component Adding '    
 INSERT  Into    T_ERP_Stud_Fee_Struct_Comp_Mapping_Details                                             
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
                I_ExtracomponentRef_Type,        
                Is_OneTime ,
				StartPeriod
  )     
SELECT DISTINCT  
    @h_I_Stud_Fee_Struct_CompMap_ID AS Stud_Fee_Struct_CompMap_ID,  
    t.R_I_Fee_Structure_ID,  
    t.R_I_Fee_Component_ID,  
    SUM(t.N_Component_Actual_Amount) AS Component_Actual_Amount,  
    t.Comp_Seq,  
    GETDATE() AS CreatedDate,  
    NULL AS UpdatedDate,  
    @p_I_CreatedBy AS CreatedBy,  
    NULL AS UpdatedBy,  
    ISNULL(t.Is_Active, 1) AS Is_Active,  
    t.I_Fee_Pay_Installment_ID,  
    t.I_ExtracomponentRef_ID,  
    t.I_ExtracomponentRef__Type,   
    ISNULL(t.Is_OneTime, 0) AS Is_OneTime,
	ISNULL(t.I_Start_Period,0) as StartPeriod
FROM   
    @Fee_Details_On_Admission t  

GROUP BY  
    t.R_I_Fee_Structure_ID,  
    t.R_I_Fee_Component_ID,  
    t.Comp_Seq,  
    t.Is_Active,  
    t.I_Fee_Pay_Installment_ID,  
    t.I_ExtracomponentRef_ID,  
    t.I_ExtracomponentRef__Type,  
    t.Is_OneTime,
	t.I_Start_Period

 -------Update GST ------
update CMD SET CMD.CGST_per=t.CGST_Per,
CMD.SGST_per=t.SGST_Per,CMD.IGST_per=t.IGST_Per,
CMD.CGST_value=(CMD.N_Component_Actual_Amount * t.CGST_Per / 100) ,
CMD.SGST_value=(CMD.N_Component_Actual_Amount * t.SGST_Per / 100) ,
CMD.IGST_value=(CMD.N_Component_Actual_Amount * t.IGST_Per / 100) 
from  T_ERP_Stud_Fee_Struct_Comp_Mapping_Details CMD
 Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping SCM 
 ON SCM.I_Stud_Fee_Struct_CompMap_ID=CMD.R_I_Stud_Fee_Struct_CompMap_ID
 Inner Join #GST_temp t on t.I_Fee_Component_ID=CMD.R_I_Fee_Component_ID
 where SCM.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and CMD.R_I_Fee_Structure_ID=0
   
   ---------Insert for Installment ------ 
delete from  T_ERP_Fee_Payment_Installment where I_Stud_Fee_Struct_CompMap_Details_ID in(                              
Select I_Stud_Fee_Struct_CompMap_Details_ID                               
from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details                              
where R_I_Stud_Fee_Struct_CompMap_ID in (                              
Select I_Stud_Fee_Struct_CompMap_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping                               
where R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and I_Brand_ID=@I_Brand_ID AND                               
R_I_School_Session_ID=@I_School_Session_ID                           
)) and   R_I_Fee_Structure_ID=0 

   Insert Into T_ERP_Fee_Payment_Installment                              
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
        Dtt_Modified_At                 
              
    )    
	
 Select distinct @I_Enquiry_Regn_ID,cmd.I_Stud_Fee_Struct_CompMap_Details_ID    
 ,UT.R_I_Fee_Structure_ID,UT.R_I_Fee_Component_ID,UT.Comp_Seq,null,UT.Expected_Installment_Date    
 ,UT.N_Component_Actual_Amount,0,ISNULL(UT.Is_Active,0),Null,GETDATE(),NuLL    
   
     
 from @Fee_Details_On_Admission UT    
 Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details cmd    
 ON cmd.R_I_Fee_Structure_ID=UT.R_I_Fee_Structure_ID    
 and cmd.R_I_Fee_Component_ID=UT.R_I_Fee_Component_ID   
 Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping SCM 
 ON SCM.I_Stud_Fee_Struct_CompMap_ID=cmd.R_I_Stud_Fee_Struct_CompMap_ID
 and SCM.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID

 where ISNULL(cmd.R_I_Fee_Structure_ID,0)=0   
 -------Update GST ------

update FPI set N_CGST_Value=(FPI.N_Installment_Amount * t.CGST_Per / 100),
N_SGST_Value=(FPI.N_Installment_Amount * t.SGST_Per / 100),
N_IGST_Value=(FPI.N_Installment_Amount * t.IGST_Per / 100)
from T_ERP_Fee_Payment_Installment FPI
 Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details CMD 
 ON CMD.I_Stud_Fee_Struct_CompMap_Details_ID=FPI.I_Stud_Fee_Struct_CompMap_Details_ID
 Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping SCM 
 ON SCM.I_Stud_Fee_Struct_CompMap_ID=cmd.R_I_Stud_Fee_Struct_CompMap_ID
 and SCM.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID
 Inner Join #GST_temp t on t.I_Fee_Component_ID=FPI.R_I_Fee_Component_ID
 where ISNULL(cmd.R_I_Fee_Structure_ID,0)=0  and FPI.R_I_Fee_Structure_ID=0
 -------------------------Update Route ID----------------------------------------     
	
update cd set cd.I_ExtracomponentRef2_ID=@routeID              
from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details cd              
 Inner Join @Fee_Details_On_Admission t               
 on cd.I_ExtracomponentRef_ID=t.I_ExtracomponentRef_ID              
 and cd.I_ExtracomponentRef_Type=t.I_ExtracomponentRef__Type              
 and cd.R_I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID              
 where cd.R_I_Fee_Structure_ID=0  
    
 End------End of Extra Component add.   
 


 IF @UsedForReAdmit = 1 and @ReadmissionRequestID IS NOT NULL
 BEGIN

 update T_ERP_Student_Promotion_History_Header set IsFeeMapped='true', FeeStructureID=@I_Fee_Structure_ID where 
 I_Student_Promotion_History_Header_ID= @ReadmissionRequestID

 END



                  
   select 1 StatusFlag,                                                  
               'Fee Structure Mapped with Student' Message                                                
                          
                 
        COMMIT;                                                  
    END TRY                            
    BEGIN CATCH                                                  
        IF @@TRANCOUNT > 0                                                  
            ROLLBACK;                                                  
                                                  
        DECLARE @ErrMsg Nnvarchar(max),                          
                @ErrSeverity int                                                  
                                                  
        SELECT @ErrMsg as Message,                     
               0 StatusFlag                                                  
                                                  
       --- RAISERROR(@ErrMsg, @ErrSeverity, 1)                                                  
                                                  
    END CATCH;                                                  
END; 