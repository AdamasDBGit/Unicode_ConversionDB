CREATE Proc [dbo].[USP_ERP_Cancel_Fee_Installment](
@Enquiry_Regn_ID Bigint,
@School_Session_ID Int,
@Brand_ID Int
)
As
Begin
Update FPI SET FPI.Is_Cancelled=1,FPI.Dtt_Modified_At=Getdate()
from T_ERP_Fee_Payment_Installment FPI
Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping SCM 
on FPI.R_I_Enquiry_Regn_ID=SCM.R_I_Enquiry_Regn_ID
Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details MD 
ON MD.I_Stud_Fee_Struct_CompMap_Details_ID=FPI.I_Stud_Fee_Struct_CompMap_Details_ID
where SCM.R_I_Enquiry_Regn_ID=@Enquiry_Regn_ID and scm.R_I_School_Session_ID=@School_Session_ID 
and SCM.I_Brand_ID=@Brand_ID
END
