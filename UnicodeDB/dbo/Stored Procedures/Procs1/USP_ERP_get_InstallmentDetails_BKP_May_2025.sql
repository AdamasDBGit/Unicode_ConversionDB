
--exec [dbo].[USP_ERP_get_InstallmentDetails] 161384,null    
----exec [USP_ERP_get_InstallmentDetails] 237223,1          
CREATE Proc [dbo].[USP_ERP_get_InstallmentDetails_BKP_May_2025] (                      
@enquiryID int,                        
@paymentmode int=null,  
@UsedForReadmit bit=null,  
@SessionID int=null  
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
                    
Select  distinct                     
I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID         
,SUM(I_Item_Value) as I_Item_Value,'0.00' As N_Discount                      
--,'1' As ActualInstalmentNo
,I_Sequence,C_Is_LumpSum,I_Display_Fee_Component_ID,                      
Convert(Date,Getdate()) AS InstalmentDate,1 As I_Installment_No ,            
Sum(CGST_value) CGST_value,CGST_Tax_ID,Sum(SGST_value) SGST_value,SGST_Tax_ID,Sum(IGST_value) IGST_value,IGST_Tax_ID            
                    
Into #temp1                      
from #TotalInstallment where InstalmentDate<=CONVERT(daTE,GETDATE())                      
Group By I_Course_Fee_Plan_Detail_ID,I_Fee_Component_ID,I_Course_Fee_Plan_ID,I_Sequence                      
,C_Is_LumpSum,I_Display_Fee_Component_ID,CGST_value,CGST_Tax_ID,SGST_value,SGST_Tax_ID,IGST_value,          
IGST_Tax_ID                 
   --Select * from    #temp1             
   --drop table #temp1          
Select  distinct                    
--ROW_NUMBER() OVER (ORDER BY I_Fee_Component_ID) AS ID,                      
*                  
Into #FinalInvdATA              
--Into #temp3                    
from #temp1                      
uNION aLL                      
Select distinct * from #TotalInstallment where InstalmentDate>CONVERT(DATE,gETDATE())    

 Select distinct *,Case When  I_Course_Fee_Plan_Detail_ID<>0 Then 1 Else 0 End As Is_Individual              
 from #FinalInvdATA              
                  
End 
