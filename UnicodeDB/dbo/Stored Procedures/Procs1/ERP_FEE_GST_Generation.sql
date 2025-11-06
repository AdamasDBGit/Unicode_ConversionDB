
CREATE Proc [dbo].[ERP_FEE_GST_Generation](
@EnquiryID bigint,@sessionID int,@BrandID int
)
As 
Begin
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
from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details a
Inner Join T_ERP_GST_Item_Category b on a.R_I_Fee_Component_ID=b.I_Fee_Component_ID
Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping c 
on c.I_Stud_Fee_Struct_CompMap_ID=a.R_I_Stud_Fee_Struct_CompMap_ID

where  c.R_I_Enquiry_Regn_ID=@EnquiryID and c.R_I_School_Session_ID=@sessionID
and c.I_Brand_ID=@BrandID and b.Is_Active=1

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

Update T_ERP_Stud_Fee_Struct_Comp_Mapping_Details set 
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
End


--EXEC ERP_FEE_GST_Generation 234918,1,107
