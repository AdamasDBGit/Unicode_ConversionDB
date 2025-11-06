CREATE Proc [dbo].[USP_ERP_get_InstallmentDetails] (                        
@enquiryID int,                          
@paymentmode int=null,    
@UsedForReadmit bit=null,    
@SessionID int=null,  
@iDiscountSchemeID int=null    
)                        
As Begin            
--Declare @enquiryID int=237143,@paymentmode int=1            
DECLARE @SGST_Tax_ID int,@CGST_Tax_ID int,@IGST_Tax_ID int              
set @SGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='SGST')              
set @CGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='CGST')              
set @IGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='IGST')              
Select distinct                        
--ROW_NUMBER() OVER (ORDER BY Dt_Payment_Installment_Dt) AS ID,                        
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
--Isnull(c.I_Pay_InstallmentNo ,0) as ActualInstalmentNo,                        
a.Seq as I_Sequence,                        
Case When d.Is_LumpSum=1 Then 'Y' Else 'N' End As C_Is_LumpSum,                        
a.R_I_Fee_Component_ID As I_Display_Fee_Component_ID,                        
Dt_Payment_Installment_Dt as InstalmentDate,                        
DENSE_RANK() OVER (ORDER BY Dt_Payment_Installment_Dt) AS I_Installment_No ,              
ISNULL(a.N_CGST_Value,0) CGST_Value,              
@CGST_Tax_ID AS CGST_Tax_ID,              
ISNULL(a.N_SGST_value,0) SGST_value,              
@SGST_Tax_ID AS SGST_Tax_ID,              
ISNULL(a.N_IGST_Value,0) IGST_Value,              
@IGST_Tax_ID AS IGST_Tax_ID              
--,Case When  CP.I_Course_Fee_Plan_ID Is not Null Then 1 Else 0 End as is_Individual                      
--c.I_Pay_InstallmentNo as ActualInstalmentNo                        
Into #TotalInstallment                        
from T_ERP_Fee_Payment_Installment a WITH(NOLOCK)                        
Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details b WITH(NOLOCK) ON a.I_Stud_Fee_Struct_CompMap_Details_ID=                        
b.I_Stud_Fee_Struct_CompMap_Details_ID and a.R_I_Fee_Component_ID=b.R_I_Fee_Component_ID                        
Left Join T_ERP_Fee_PaymentInstallment_Type c WITH(NOLOCK) on c.I_Fee_Pay_Installment_ID=b.R_I_Fee_Pay_Installment_ID                        
Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping d WITH(NOLOCK)                        
on d.I_Stud_Fee_Struct_CompMap_ID=b.R_I_Stud_Fee_Struct_CompMap_ID                        
Left Join T_Course_Fee_Plan CP WITH(NOLOCK) on CP.I_New_I_Fee_Structure_ID=d.R_I_Fee_Structure_ID                        
Left Join T_Course_Fee_Plan_Detail CPD WITH(NOLOCK)         
on CPD.I_Course_Fee_Plan_ID=CP.I_Course_Fee_Plan_ID                        
and CPD.I_Fee_Component_ID=b.R_I_Fee_Component_ID  and CPD.C_Is_LumpSum='Y'    
--and   CPD.C_Is_LumpSum=Case When d.Is_LumpSum=0 Then 'N' Else 'Y' End             
--and   CPD.C_Is_LumpSum=Case When b.Is_OneTime=0 Then 'N' Else 'Y' End            
where a.R_I_Enquiry_Regn_ID=@enquiryID      
and (a.Is_Moved IS NULL OR a.Is_Moved = 0)     
and (b.Is_Moved IS NULL OR b.Is_Moved = 0)    
and (d.Is_Moved IS NULL OR d.Is_Moved = 0)    
and (@UsedForReadmit IS NULL OR ISNULL(d.UseForReAdmit,0) = @UsedForReadmit)    
and (@SessionID IS NULL OR d.R_I_School_Session_ID=@SessionID)    
group by                        
a.R_I_Fee_Component_ID,Dt_Payment_Installment_Dt,c.I_Pay_InstallmentNo,a.N_Installment_Amount,                        
a.Seq,d.Is_LumpSum,CP.I_Course_ID,CPD.I_Course_Fee_Plan_Detail_ID,CP.I_Course_Fee_Plan_ID,a.N_CGST_Value                        
    ,a.N_SGST_Value,a.N_IGST_Value                    
order by a.R_I_Fee_Component_ID,Dt_Payment_Installment_Dt                        
--Select * from #TotalInstallment   
  
  
  
----------------------------------------  
--Discount  
----------------------------------------  
  
DECLARE @iERPFeeStructureID int =null  
DECLARE @iBrandID int =NULL  
  
  
  DECLARE @InstallmentComponentDetails UT_Installments_Component_Details;  
  
 Create table #EligibleDiscountedComponentDetails  
 (  
 ID int,   
 FeeComponentID int,  
 InstallmentNo int,  
 DtInstallmentDate datetime,  
 ActualBaseAmount decimal(8,2) null,  
 ActualSGST decimal(8,2) null,  
 ActualCGST decimal(8,2) null,  
 ActualIGST decimal(8,2) null,  
 DiscountedBaseAmount decimal(8,2) null,  
 DiscountedSGST decimal(8,2) null,  
 DiscountedCGST decimal(8,2) null,  
 DiscountedIGST decimal(8,2) null,  
 DiscountedRate int null,  
 DiscountedAmount int null  
 )  
  
 Create table #DiscountDetails  
 (  
 DiscountSchemeID int,  
 DiscountSchemeName varchar(max),  
 StatusID bit,  
 ErrorMsg varchar(max)  
 )  
  
 CREATE TABLE #DiscountedInstallmentsSchedule (  
    I_Course_Fee_Plan_Detail_ID INT,  
    I_Fee_Component_ID INT,  
    I_Course_Fee_Plan_ID INT,  
    I_Item_Value DECIMAL(18, 2),  
    N_Discount DECIMAL(5, 2),  
    I_Sequence INT,  
    C_Is_LumpSum CHAR(1),  
    I_Display_Fee_Component_ID INT,  
    InstalmentDate DATETIME,  
    I_Installment_No INT,  
    CGST_value DECIMAL(18, 2),  
    CGST_Tax_ID INT,  
    SGST_value DECIMAL(18, 2),  
    SGST_Tax_ID INT,  
    IGST_value DECIMAL(18, 2),  
    IGST_Tax_ID INT  
);  
  
print '@iDiscountSchemeID'  
print @iDiscountSchemeID  
  IF @iDiscountSchemeID IS NOT NULL  
 BEGIN  
  
   BEGIN TRY  
  
  
   Select distinct                        
      --ROW_NUMBER() OVER (ORDER BY Dt_Payment_Installment_Dt) AS ID,                        
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
      --Isnull(c.I_Pay_InstallmentNo ,0) as ActualInstalmentNo,                        
      a.Seq as I_Sequence,                        
      Case When d.Is_LumpSum=1 Then 'Y' Else 'N' End As C_Is_LumpSum,                        
      a.R_I_Fee_Component_ID As I_Display_Fee_Component_ID,                        
      Dt_Payment_Installment_Dt as InstalmentDate,                        
      DENSE_RANK() OVER (ORDER BY Dt_Payment_Installment_Dt) AS I_Installment_No ,              
      ISNULL(a.N_CGST_Value,0) CGST_Value,              
      @CGST_Tax_ID AS CGST_Tax_ID,              
      ISNULL(a.N_SGST_value,0) SGST_value,              
      @SGST_Tax_ID AS SGST_Tax_ID,              
      ISNULL(a.N_IGST_Value,0) IGST_Value,              
      @IGST_Tax_ID AS IGST_Tax_ID              
      --,Case When  CP.I_Course_Fee_Plan_ID Is not Null Then 1 Else 0 End as is_Individual                      
      --c.I_Pay_InstallmentNo as ActualInstalmentNo    
      ,a.R_I_Fee_Structure_ID  
      ,b.CGST_per  
      ,b.SGST_per  
      ,b.IGST_per  
      ,d.I_Brand_ID  
      Into #TotalInstallment_1                        
      from T_ERP_Fee_Payment_Installment a WITH(NOLOCK)                        
      Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details b WITH(NOLOCK) ON a.I_Stud_Fee_Struct_CompMap_Details_ID=                        
      b.I_Stud_Fee_Struct_CompMap_Details_ID and a.R_I_Fee_Component_ID=b.R_I_Fee_Component_ID                        
      Left Join T_ERP_Fee_PaymentInstallment_Type c WITH(NOLOCK) on c.I_Fee_Pay_Installment_ID=b.R_I_Fee_Pay_Installment_ID                        
      Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping d WITH(NOLOCK)                        
      on d.I_Stud_Fee_Struct_CompMap_ID=b.R_I_Stud_Fee_Struct_CompMap_ID                        
      Left Join T_Course_Fee_Plan CP WITH(NOLOCK) on CP.I_New_I_Fee_Structure_ID=d.R_I_Fee_Structure_ID                        
      Left Join T_Course_Fee_Plan_Detail CPD WITH(NOLOCK)         
      on CPD.I_Course_Fee_Plan_ID=CP.I_Course_Fee_Plan_ID                        
      and CPD.I_Fee_Component_ID=b.R_I_Fee_Component_ID  and CPD.C_Is_LumpSum='Y'    
      --and   CPD.C_Is_LumpSum=Case When d.Is_LumpSum=0 Then 'N' Else 'Y' End             
      --and   CPD.C_Is_LumpSum=Case When b.Is_OneTime=0 Then 'N' Else 'Y' End            
      where a.R_I_Enquiry_Regn_ID=@enquiryID      
      and (a.Is_Moved IS NULL OR a.Is_Moved = 0)     
      and (b.Is_Moved IS NULL OR b.Is_Moved = 0)    
      and (d.Is_Moved IS NULL OR d.Is_Moved = 0)    
      and (@UsedForReadmit IS NULL OR ISNULL(d.UseForReAdmit,0) = @UsedForReadmit)    
      and (@SessionID IS NULL OR d.R_I_School_Session_ID=@SessionID)    
      group by                        
      a.R_I_Fee_Component_ID,Dt_Payment_Installment_Dt,c.I_Pay_InstallmentNo,a.N_Installment_Amount,                        
      a.Seq,d.Is_LumpSum,CP.I_Course_ID,CPD.I_Course_Fee_Plan_Detail_ID,CP.I_Course_Fee_Plan_ID,a.N_CGST_Value                        
       ,a.N_SGST_Value,a.N_IGST_Value,a.R_I_Fee_Structure_ID  
       ,b.CGST_per  
      ,b.SGST_per  
      ,b.IGST_per  
      ,d.I_Brand_ID  
      order by a.R_I_Fee_Component_ID,Dt_Payment_Installment_Dt   
  
           
       
   --  select * from #TotalInstallment_1  
  
      set @iERPFeeStructureID= (select top 1 R_I_Fee_Structure_ID from #TotalInstallment_1 where R_I_Fee_Structure_ID IS NOT NULL and R_I_Fee_Structure_ID > 0)  
  
  
      set @iBrandID=(select top 1 I_Brand_ID from #TotalInstallment_1 where I_Brand_ID IS NOT NULL)  
     
   print 'brand'  
   print @iBrandID  
   print '@iDiscountSchemeID'  
   print @iDiscountSchemeID  
   print '@iERPFeeStructureID'  
   print @iERPFeeStructureID  
  
  
   IF exists(     
   select DSM.I_Discount_Scheme_ID as DiscountSchemeID,  
      DSM.S_Discount_Scheme_Name as DiscountSchemeName  
      from   
      T_Discount_Scheme_Master as DSM   
      --inner join  
      --T_Discount_Brand_Map as DBM on DSM.I_Discount_Scheme_ID=DBM.I_Discount_Scheme_ID  
      --inner join  
      --T_Discount_Fee_Schedule_Detail as DFSD on DBM.I_Discount_Brand_ID=DFSD.I_Discount_Brand_ID  
      where --DFSD.I_ERP_Fee_Structure_ID=@iERPFeeStructureID and 
	  DSM.I_Discount_Scheme_ID=@iDiscountSchemeID  
	  and DSM.I_Brand_ID=@iBrandID
      --and DFSD.I_Status_ID=1 and DBM.I_Status_ID=1 
	  and DSM.I_Status=1  
      --and GETDATE() between  DSM.Dt_Valid_From  and DSM.Dt_Valid_To  
   )  
   BEGIN  
  
  
   print 'brand'  
   print @iBrandID  
     
  
   INSERT INTO @InstallmentComponentDetails (  
    I_InstallmentNo,  
    Dt_Installment_Date,  
    I_Component_ID,  
    BaseAmount,  
    CGST,  
    SGST,  
    IGST  
   )  
   select I_Installment_No,InstalmentDate,I_Fee_Component_ID,I_Item_Value,CGST_value,SGST_value,IGST_value  
   from #TotalInstallment_1  
   ORDER BY I_Installment_No;  
  
   --select * from @InstallmentComponentDetails  
  
   print @iDiscountSchemeID  
   print @iBrandID     
   print @iERPFeeStructureID  
  
   INSERT INTO #EligibleDiscountedComponentDetails     
   EXEC [dbo].[usp_ERP_Get_Discounted_Revised_Installments]  
   @iDiscountSchemeID = @iDiscountSchemeID,  
   @iBrandID = @iBrandID,  
   @iERPFeeStructure = @iERPFeeStructureID,  
   @InstallmentComponentDetails = @InstallmentComponentDetails  
   WITH RECOMPILE;
   --select * from #EligibleDiscountedComponentDetails  
  
       --select   
       --T1.I_Course_Fee_Plan_Detail_ID,                        
       --T1.I_Fee_Component_ID,                  
       --T1.I_Course_Fee_Plan_ID,    
       --ISNULL(EDC.DiscountedBaseAmount,0),  
       --T1.N_Discount,                      
       --T1.I_Sequence,                        
       --T1.C_Is_LumpSum,                        
       --EDC.FeeComponentID,   
       --EDC.DtInstallmentDate,  
       --EDC.InstallmentNo,  
       --EDC.DiscountedCGST,           
       --T1.CGST_Tax_ID,     
       --EDC.DiscountedSGST,             
       --T1.SGST_Tax_ID,    
       --EDC.DiscountedIGST,             
       --T1.IGST_Tax_ID      
       --from      
       --#TotalInstallment_1 as T1  
       --inner join  
       --#EligibleDiscountedComponentDetails as EDC   
       --on T1.I_Fee_Component_ID=EDC.FeeComponentID  
       --and T1.I_Installment_No=EDC.InstallmentNo  
       --and T1.InstalmentDate=EDC.DtInstallmentDate  
  
       --select   
       --T1.I_Course_Fee_Plan_Detail_ID,                        
       --T1.I_Fee_Component_ID,                  
       --T1.I_Course_Fee_Plan_ID,    
       --SUM(ISNULL(EDC.DiscountedBaseAmount,0)),  
       --T1.N_Discount,                      
       --T1.I_Sequence,                        
       --T1.C_Is_LumpSum,                        
       --EDC.FeeComponentID,   
       --EDC.DtInstallmentDate,  
       --EDC.InstallmentNo,  
       --EDC.DiscountedCGST,           
       --T1.CGST_Tax_ID,     
       --EDC.DiscountedSGST,             
       --T1.SGST_Tax_ID,    
       --EDC.DiscountedIGST,             
       --T1.IGST_Tax_ID      
       --from      
       --#TotalInstallment_1 as T1  
       --inner join  
       --#EligibleDiscountedComponentDetails as EDC   
       --on T1.I_Fee_Component_ID=EDC.FeeComponentID  
       --and T1.I_Installment_No=EDC.InstallmentNo  
       --and T1.InstalmentDate=EDC.DtInstallmentDate  
       --group by   
       --T1.N_Discount,                      
       --T1.I_Sequence,                        
       --T1.C_Is_LumpSum,                        
       --EDC.FeeComponentID,   
       --EDC.DtInstallmentDate,  
       --EDC.InstallmentNo,  
       --EDC.DiscountedCGST,           
       --T1.CGST_Tax_ID,     
       --EDC.DiscountedSGST,             
       --T1.SGST_Tax_ID,    
       --EDC.DiscountedIGST,             
       --T1.IGST_Tax_ID,  
       --T1.I_Course_Fee_Plan_Detail_ID,                        
       --T1.I_Fee_Component_ID,                  
       --T1.I_Course_Fee_Plan_ID  
  
  
  
       INSERT INTO #DiscountedInstallmentsSchedule (  
       I_Course_Fee_Plan_Detail_ID,  
       I_Fee_Component_ID,  
       I_Course_Fee_Plan_ID,  
       I_Item_Value,  
       N_Discount,  
       I_Sequence,  
       C_Is_LumpSum,  
       I_Display_Fee_Component_ID,  
       InstalmentDate,  
       I_Installment_No,  
       CGST_value,  
       CGST_Tax_ID,  
       SGST_value,  
       SGST_Tax_ID,  
       IGST_value,  
       IGST_Tax_ID  
        )  
       SELECT  
         T1.I_Course_Fee_Plan_Detail_ID,  
         T1.I_Fee_Component_ID,  
         T1.I_Course_Fee_Plan_ID,  
         SUM(ISNULL(EDC.DiscountedBaseAmount, 0)) AS I_Item_Value,  
         T1.N_Discount,  
         T1.I_Sequence,  
         T1.C_Is_LumpSum,  
         EDC.FeeComponentID AS I_Display_Fee_Component_ID,  
         EDC.DtInstallmentDate AS InstalmentDate,  
         EDC.InstallmentNo AS I_Installment_No,  
         EDC.DiscountedCGST AS CGST_value,  
         T1.CGST_Tax_ID,  
         EDC.DiscountedSGST AS SGST_value,  
         T1.SGST_Tax_ID,  
         EDC.DiscountedIGST AS IGST_value,  
         T1.IGST_Tax_ID  
          
        FROM #TotalInstallment_1 AS T1  
        INNER JOIN #EligibleDiscountedComponentDetails AS EDC   
         ON T1.I_Fee_Component_ID = EDC.FeeComponentID  
         AND T1.I_Installment_No = EDC.InstallmentNo  
         AND T1.InstalmentDate = EDC.DtInstallmentDate and EDC.DiscountedBaseAmount IS NOT NULL  
        GROUP BY   
         T1.I_Course_Fee_Plan_Detail_ID,  
         T1.I_Fee_Component_ID,  
         T1.I_Course_Fee_Plan_ID,  
         T1.N_Discount,  
         T1.I_Sequence,  
         T1.C_Is_LumpSum,  
         EDC.FeeComponentID,  
         EDC.DtInstallmentDate,  
         EDC.InstallmentNo,  
         EDC.DiscountedCGST,  
         T1.CGST_Tax_ID,  
         EDC.DiscountedSGST,  
         T1.SGST_Tax_ID,  
         EDC.DiscountedIGST,  
         T1.IGST_Tax_ID;  
  
  
  
  
         
   insert into #DiscountDetails  
   select   
   @iDiscountSchemeID,  
   (select top 1 S_Discount_Scheme_Name from T_Discount_Scheme_Master where I_Discount_Scheme_ID=@iDiscountSchemeID)  
   ,1,NULL  
      
  
   END  
   ELSE  
   BEGIN  
  
   --print 'not exist'  
   insert into #DiscountDetails  
   select 0,'',0,'Invalid Discount Scheme'  
  
   END  
     
  
  END TRY  
  BEGIN CATCH  
   -- Catch block: show error  
   PRINT 'Error occurred while creating or inserting into #TotalAmountForDiscount';  
   PRINT ERROR_MESSAGE();  
  
   insert into #DiscountDetails  
   select 0,'',0,ERROR_MESSAGE()  
  
  END CATCH  
   
 END  
  
--drop table #EligibleDiscountedComponentDetails  
--drop table #TotalInstallment_1  
-------------------------------------  
  
  
  
  
  
  
  
  
  
                      

                    
Select  distinct                     
I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID         
,SUM(I_Item_Value) as I_Item_Value,'0.00' As N_Discount                      
--,'1' As ActualInstalmentNo
--,I_Sequence,C_Is_LumpSum,I_Display_Fee_Component_ID,                      
--Convert(Date,Getdate()) AS InstalmentDate,1 As I_Installment_No ,            
--Sum(CGST_value) CGST_value,CGST_Tax_ID,Sum(SGST_value) SGST_value,SGST_Tax_ID,Sum(IGST_value) IGST_value,IGST_Tax_ID            
   ,I_Sequence,C_Is_LumpSum,I_Display_Fee_Component_ID,                      
InstalmentDate AS InstalmentDate,I_Installment_No As I_Installment_No ,            
Sum(CGST_value) CGST_value,CGST_Tax_ID,Sum(SGST_value) SGST_value,SGST_Tax_ID,Sum(IGST_value) IGST_value,IGST_Tax_ID            
                  
Into #temp1                      
from #TotalInstallment where
InstalmentDate<=CONVERT(daTE,GETDATE())  and I_Course_Fee_Plan_Detail_ID > 0                      
Group By I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID,I_Sequence                      
,C_Is_LumpSum,I_Display_Fee_Component_ID,CGST_value,CGST_Tax_ID,SGST_value,SGST_Tax_ID,IGST_value,          
IGST_Tax_ID,InstalmentDate,I_Installment_No  


Select  distinct                     
I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID         
,SUM(I_Item_Value) as I_Item_Value,'0.00' As N_Discount                      
--,'1' As ActualInstalmentNo
,I_Sequence,C_Is_LumpSum,I_Display_Fee_Component_ID,                      
InstalmentDate AS InstalmentDate,I_Installment_No As I_Installment_No ,            
Sum(CGST_value) CGST_value,CGST_Tax_ID,Sum(SGST_value) SGST_value,SGST_Tax_ID,Sum(IGST_value) IGST_value,IGST_Tax_ID            
                    
Into #temp2                      
from #TotalInstallment where
InstalmentDate<=CONVERT(daTE,GETDATE())  and I_Course_Fee_Plan_Detail_ID <= 0                      
Group By I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID,I_Sequence                      
,C_Is_LumpSum,I_Display_Fee_Component_ID,CGST_value,CGST_Tax_ID,SGST_value,SGST_Tax_ID,IGST_value,          
IGST_Tax_ID,InstalmentDate,I_Installment_No

   --Select * from    #temp1             
   --drop table #temp1          
Select  distinct                    
--ROW_NUMBER() OVER (ORDER BY I_Fee_Component_ID) AS ID,                      
*                  
Into #FinalInvdATA              
--Into #temp3                    
from #temp1  
union all
select * from #temp2
uNION aLL                      
Select distinct * from #TotalInstallment where InstalmentDate>CONVERT(DATE,gETDATE())  
union all
(
(
Select  distinct                     
I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID         
,SUM(I_Item_Value) as I_Item_Value,'0.00' As N_Discount                      
--,'1' As ActualInstalmentNo
,I_Sequence,C_Is_LumpSum,I_Display_Fee_Component_ID,                      
Convert(Date,Getdate()) AS InstalmentDate,1 As I_Installment_No ,            
Sum(CGST_value) CGST_value,CGST_Tax_ID,Sum(SGST_value) SGST_value,SGST_Tax_ID,Sum(IGST_value) IGST_value,IGST_Tax_ID 
from
#DiscountedInstallmentsSchedule
		where InstalmentDate<=CONVERT(daTE,GETDATE())                      
Group By I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID,I_Sequence                      
,C_Is_LumpSum,I_Display_Fee_Component_ID,CGST_value,CGST_Tax_ID,SGST_value,SGST_Tax_ID,IGST_value,          
IGST_Tax_ID
)
union all
Select distinct * from #DiscountedInstallmentsSchedule where InstalmentDate>CONVERT(DATE,gETDATE()) 
)

 Select distinct *,Case When  I_Course_Fee_Plan_Detail_ID<>0 Then 1 Else 0 End As Is_Individual              
 from #FinalInvdATA               
                    
End 