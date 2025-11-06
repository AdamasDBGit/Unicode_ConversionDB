      
--Procedure: usp_ERP_Fee_InstallmentPayment                                    
-- Author:      Abhik Porel                                
-- Create date: 02.01.2024                                
-- Description: Generate FEE Installment                                
-- =============================================                           
                    
CREATE   PROCEDURE [dbo].[usp_ERP_Fee_InstallmentPayment]                    
(                    
    @Enquiry_Regn_ID int,                    
    @School_Session_ID int,                    
    @I_Brand_ID int ,          
 @PaymentType1 int=Null ,
 @FeeStructureID int
)                    
As                    
Begin                    
    SET NOCOUNT ON;                    
    --Drop  table #Stud_Fee_Installment                
 --Drop table #FinalInstallment                
    --Declare                         
    --@Enquiry_Regn_ID int ,@School_Session_ID int,@I_Brand_ID int                        
    --SET @Enquiry_Regn_ID=1                        
    --SET @School_Session_ID=1                        
    --SET @I_Brand_ID=1                      
    ---------------------------------------------------------                      
    Declare @sessionstDt date,                    
            @sessionEndDt Date                    
                    
    --select @sessionstDt = Convert(Date, Dt_Session_Start_Date),                    
    --       @sessionEndDt = Convert(Date, Dt_Session_End_Date)                    
    --from T_School_Academic_Session_Master                    
    --where I_School_Session_ID = @School_Session_ID   
		select @sessionstDt=Convert(date,Dt_StartDt)
	,@sessionEndDt=convert(date,Dt_EndDt )
	from T_ERP_Fee_Structure where I_Fee_Structure_ID=@FeeStructureID
	Declare @MonthDiff int
	SET @MonthDiff=(SELECT DATEDIFF(MONTH, @sessionstDt, @sessionEndDt) + 1 )
    --Select @sessionstDt,@sessionEndDt                        
    If   @PaymentType1=1          
 Begin          
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
          
 from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details cd          
 Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping cm          
 on cm.I_Stud_Fee_Struct_CompMap_ID=cd.R_I_Stud_Fee_Struct_CompMap_ID          
 and cm.R_I_Enquiry_Regn_ID=@Enquiry_Regn_ID           
 and cm.I_Brand_ID=@I_Brand_ID and cm.R_I_School_Session_ID=@School_Session_ID          
 End           
 Else          
 Begin          
    SELECT IDENTITY(INT, 1, 1) AS ID,                    
           a.R_I_Stud_Fee_Struct_CompMap_ID,                    
           a.I_Stud_Fee_Struct_CompMap_Details_ID,                    
           a.R_I_Fee_Structure_ID,                    
           a.R_I_Fee_Component_ID,                    
           a.N_Component_Actual_Amount,                  
           a.Seq,                  
           b.I_Pay_InstallmentNo,                    
           b.I_Interval,                    
           @sessionstDt as StartDt,                    
           b.I_Fee_Pay_Installment_ID,                    
           a.Is_Active ,      
     CGST_value,        
     SGST_value,        
     CGST_value+SGST_value   as IGST_value    
    Into #Stud_Fee_Installment                    
    from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details a                    
        Inner Join T_ERP_Fee_PaymentInstallment_Type b                    
            on a.R_I_Fee_Pay_Installment_ID = b.I_Fee_Pay_Installment_ID                    
        Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping c                    
            on c.I_Stud_Fee_Struct_CompMap_ID = a.R_I_Stud_Fee_Struct_CompMap_ID                    
    where c.R_I_Enquiry_Regn_ID = @Enquiry_Regn_ID                    
          and c.R_I_School_Session_ID = @School_Session_ID                    
          and c.I_Brand_ID = @I_Brand_ID    and a.Is_Active=1  and c.Is_Active=1            ----Drop table #Stud_Fee_Installment                        
   -- select * from #Stud_Fee_Installment 
      If @MonthDiff <12
	Begin 
	update  #Stud_Fee_Installment set I_Pay_InstallmentNo=@MonthDiff
	where I_Interval=1
	End 
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
            @lst int,                    
            @ID int = 1                    
    SET @lst =                    
    (                    
        select max(ID) from #Stud_Fee_Installment                    
    )                    
    WHILE @ID <= @lst                    
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
        where ID = @ID                    
                
                    
        If @interval <> 0                    
        Begin                    
            SELECT @interval As Interval,                    
                   InstallmentDate                    
            Into #IntervalInstallment                    
            FROM dbo.GetInstallmentDatesInFinancialYear(@sessionstDt, @sessionEndDt, @sessionstDt, @interval);                    
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
            Select @Enquiry_Regn_ID,                    
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
            where fi.ID = @ID                    
                    
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
            Select @Enquiry_Regn_ID,                    
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
        Set @ID = @ID + 1                    
    END                    
     --Select * from #FinalInstallment                
  ---------Start generate temp Invoice Installmentwise---------                
 --  Declare @ID1 Int,@lst1 int                
 --  SET @ID1=1                
 --  SET @lst1=(Select MAX(ID) from #FinalInstallment)                
 --  WHILE @ID1 <= @lst1                    
 --   BEGIN                 
 --  -------Generate Temp Invoice-------                
 -- --Declare @TempInv varchar(100)                
 -- --      EXEC USP_Stud_TempInvNo_Generate 1,1,'INV',@Inv_No_Out=@TempInv OUTPUT                
 -- --      --Select @TempInv                
                
 -- ----Select * from #FinalInstallment  Where ID=@ID1 and Installmentdt<>'2023-04-01'                
 -- --Update #FinalInstallment Set TempInvNo=@TempInv Where ID=@ID1 and Installmentdt<>@sessionstDt                
 -- -------------------------                
                
 --Set @ID1 = @ID1 + 1                    
 --End                 
           
  --Delete from T_ERP_Fee_Payment_Installment Where R_I_Enquiry_Regn_ID in(            
  --Select R_I_Enquiry_Regn_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping            
  --Where R_I_Enquiry_Regn_ID=@Enquiry_Regn_ID and R_I_School_Session_ID=@School_Session_ID            
  --and I_Brand_ID=@I_Brand_ID            
  --)            
            
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
    Select @Enquiry_Regn_ID,                    
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
END 
