CREATE Proc [dbo].[USP_ERP_get_Structure_GST_Generation](        
@GSTCATID int  
)        
As         
Begin        
select GIC.I_GST_FeeComponent_Catagory_ID,GIC.S_GST_FeeComponent_Category_Type,
GICD.N_Start_Amount,GICD.N_End_Amount
,GICD.N_SGST,GICD.N_CGST,GICD.N_IGST
from T_ERP_GST_Item_Category   GIC
Inner Join T_ERP_GST_Configuration_Details GICD
ON GIC.I_GST_FeeComponent_Catagory_ID=GICD.I_GST_FeeComponent_Catagory_ID
where GIC.I_GST_FeeComponent_Catagory_ID=@GSTCATID
        
        
       
End  