--EXEC [USP_ERP_get_FEE_Structure_GST_Generation] 1160,NULL        
        
CREATE Proc [dbo].[USP_ERP_get_FEE_Structure_GST_Generation](          
@FeeStructureID int,          
@paymentTypeID int  =NULL        
)          
As           
Begin          
--Declare @FeeStructureID int =44          
-----Creating Temp Table for Holding GST data------          
Create Table #GST_Component_Amount (          
ID int Identity(1,1),          
I_Fee_Structure_ID int,          
S_Fee_Structure_Name varchar(200),          
I_Currency_Type_ID int,          
I_Fee_Structure_Installment_Component_ID int,          
N_Component_Actual_Total_Annual_Amount numeric(18,2),          
R_I_Fee_Component_ID int,          
S_Component_Name Varchar(100),          
R_I_Fee_Pay_Installment_ID int ,          
I_Pay_InstallmentNo int,          
S_Installment_Frequency Varchar(100),          
I_Interval int,          
I_Seq_No int,          
Is_OneTime int,          
I_GST_FeeComponent_Catagory_ID int,          
N_CGST_Per Numeric(10,2),          
N_CGST_Val Numeric(18,2),          
N_SGST_Val Numeric(18,2),          
N_SGST_Per Numeric(10,2),          
N_IGST_Val Numeric(18,2),          
N_IGST_Per Numeric(10,2)          
)          
Insert Into #GST_Component_Amount          
(          
I_Fee_Structure_ID,          
S_Fee_Structure_Name ,          
I_Currency_Type_ID ,          
I_Fee_Structure_Installment_Component_ID ,          
N_Component_Actual_Total_Annual_Amount ,          
R_I_Fee_Component_ID ,          
S_Component_Name ,          
R_I_Fee_Pay_Installment_ID ,          
I_Pay_InstallmentNo ,          
S_Installment_Frequency ,          
I_Interval ,          
I_Seq_No ,          
Is_OneTime ,          
I_GST_FeeComponent_Catagory_ID          
)          
 SELECT                      
     TEFS.I_Fee_Structure_ID,                  
     TEFS.S_Fee_Structure_Name,                       
     TEFS.I_Currency_Type_ID,                  
     TEFSIC.I_Fee_Structure_Installment_Component_ID,                  
     TEFSIC.N_Component_Actual_Total_Annual_Amount,                  
     TEFSIC.R_I_Fee_Component_ID,                  
     TEFC.S_Component_Name,                  
     TEFSIC.R_I_Fee_Pay_Installment_ID,                  
     TEFPT.I_Pay_InstallmentNo,                  
     TEFPT.S_Installment_Frequency,                  
     TEFPT.I_Interval,                  
     TEFSIC.I_Seq_No,                  
     TEFSIC.Is_OneTime,               
     b.I_GST_FeeComponent_Catagory_ID           
   -- Into #GST_Component_Amount                     
    from T_ERP_Fee_Structure TEFS                      
        Inner Join T_ERP_Fee_Structure_Installment_Component TEFSIC on TEFS.I_Fee_Structure_ID = TEFSIC.R_I_Fee_Structure_ID                      
        Left Join T_ERP_Fee_PaymentInstallment_Type TEFPT on TEFSIC.R_I_Fee_Pay_Installment_ID = TEFPT.I_Fee_Pay_Installment_ID                   
        Inner Join T_Fee_Component_Master TEFC on TEFSIC.R_I_Fee_Component_ID = TEFC.I_Fee_Component_ID               
        Left Join T_ERP_GST_Component_Mapping b on TEFSIC.R_I_Fee_Component_ID=b.I_Fee_Component_ID   
  and b.I_GST_Component_Type=1-----for Fee Structure Component  
        --Left Join T_ERP_GST_Item_Category b on TEFSIC.R_I_Fee_Component_ID=b.I_Fee_Component_ID          
  
 where TEFS.I_Fee_Structure_ID =@FeeStructureID              
 --and TEFSIC.Is_OneTime= @paymentTypeID       
 and b.Is_Active=1          
     -- select * from #GST_Component_Amount    
--Select * from #GST_Component_Amount          
--Drop table #GST_Component_Amount          
          
          
Declare @GSTCategoryID int,@Fee_Component_Amount Numeric(18,2),          
@SGST_Per numeric(10,2), @SGST_Value numeric(18,2),          
@CGST_Per numeric(10,2), @CGST_Value numeric(18,2),          
@IGST_Per numeric(10,2), @IGST_Value numeric(18,2),          
@Fee_ComponentID int          
          
Declare @ID int=1          
Declare @Lst Int          
SET @Lst=(SElect MAX(ID) from #GST_Component_Amount)          
          
While @ID<=@Lst          
Begin           
SET @GSTCategoryID=(          
Select I_GST_FeeComponent_Catagory_ID from #GST_Component_Amount where ID=@ID          
)          
SET @Fee_Component_Amount=(          
Select N_Component_Actual_Total_Annual_Amount from #GST_Component_Amount where ID=@ID          
)          
SET @Fee_ComponentID=(          
Select Top 1 R_I_Fee_Component_ID from #GST_Component_Amount where ID=@ID          
)          
          
SET @IGST_Per =          
(          
Select Top 1 N_IGST from T_ERP_GST_Configuration_Details           
where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID          
and @Fee_Component_Amount between N_Start_Amount and N_End_Amount          
)          
          
SET @CGST_Per =(          
Select Top 1 N_CGST from T_ERP_GST_Configuration_Details         
where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID          
and @Fee_Component_Amount between N_Start_Amount and N_End_Amount          
)          
        
          
SET @SGST_Per =(          
Select Top 1 N_SGST from T_ERP_GST_Configuration_Details         
where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID          
and @Fee_Component_Amount between N_Start_Amount and N_End_Amount          
)          
          
SET @SGST_Value=(@Fee_Component_Amount * @SGST_Per / 100)           
SET @CGST_Value=(@Fee_Component_Amount * @CGST_Per / 100)           
SET @IGST_Value=(@Fee_Component_Amount * @IGST_Per / 100)           
          
--Select @GSTCategoryID          
--Select @Fee_Component_Amount          
--Select @IGST_Per,@CGST_Per,@SGST_Per          
--Select @IGST_Value,@SGST_Value,@CGST_Value          
          
Update #GST_Component_Amount set           
 N_CGST_Val=@CGST_Value,          
 N_SGST_Val=@SGST_Value,          
 N_IGST_Val=@IGST_Value,          
 N_CGST_Per=@CGST_Per,          
 N_SGST_Per=@SGST_Per,          
 N_IGST_Per=@IGST_Per          
 Where ID=@ID           
          
SET @ID=@ID+1          
End          
          
Select           
I_Fee_Structure_ID,          
R_I_Fee_Component_ID,          
N_CGST_Val,          
N_SGST_Val,          
N_IGST_Val,          
N_CGST_Per,          
N_SGST_Per,          
N_IGST_Per          
from #GST_Component_Amount          
          
Drop Table #GST_Component_Amount          
End   --EXEC ERP_FEE_GST_Generation 234918,1,107 