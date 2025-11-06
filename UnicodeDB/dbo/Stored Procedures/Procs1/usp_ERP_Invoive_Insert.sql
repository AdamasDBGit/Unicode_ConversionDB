  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
  
--exec [dbo].[usp_ERP_Invoive_Insert] 1, 107, 1
-- =============================================  
  
  
CREATE PROCEDURE [dbo].[usp_ERP_Invoive_Insert]  
 -- Add the parameters for the stored procedure here  
 (  
  @EnquiryID INT ,  
  @Brand_ID int =Null,  
  @SessionID int=Null,
  @StudentDetailsID int=Null
  --@FeeStructureID INT = NULL  
  --@TargetDate datetime= null  
 )  
  
AS  
BEGIN  

  
 Select   
 t1.I_Fee_Component_InstallmentID,  
 t1.R_I_Enquiry_Regn_ID,  
 t1.Seq,  
t1.Dt_Payment_Installment_Dt,  
 t1.N_Installment_Amount,  
 --t1.TempInv,  
 t1.R_I_Fee_Structure_ID,
 t1.R_I_Fee_Component_ID,
 t2.S_Fee_Component_Name,  
 t3.S_Fee_Structure_Name  
 ,DENSE_RANK() OVER (ORDER BY t1.Dt_Payment_Installment_Dt) AS DateWiseInstallmentSequenceNo  
 Into #Temp_Fee_Installment  
 from T_ERP_Fee_Payment_Installment t1  
 inner join T_ERP_Fee_Component t2 on t2.I_Fee_Component_ID= t1.R_I_Fee_Component_ID  
 left join T_ERP_Fee_Structure t3 on t3.I_Fee_Structure_ID = t1.R_I_Fee_Structure_ID  
 Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping SCM on SCM.R_I_Enquiry_Regn_ID=@EnquiryID  
 and SCM.I_Brand_ID=@Brand_ID   
 and SCM.R_I_School_Session_ID=@SessionID  
 where   
 --t1.Dt_Payment_Installment_Dt>@TargetDate   
 --and   
 t1.R_I_Enquiry_Regn_ID=@EnquiryID  and t1.Is_Moved is  null --and t3.I_Fee_Structure_ID = @FeeStructureID  
 --and t1.TempInv is  null  
 Order by t1.Dt_Payment_Installment_Dt,  
  CASE        WHEN t1.Seq = 0 THEN 1        ELSE 0    END,Seq      
  Select 'Invoice' As Type, * Into #InvType from #Temp_Fee_Installment Where R_I_Fee_Structure_ID<>0    
  Select  'Non-Invoice' as Type,* Into #Non_Inv_Type from #Temp_Fee_Installment Where R_I_Fee_Structure_ID=0   
  Select * from #InvType
  Select * from #Non_Inv_Type

  --Select SUM(N_Installment_Amount) as Total_AMt,DateWiseInstallmentSequenceNo,    CONVERT(varchar,Dt_Payment_Installment_Dt,107) Dt_Payment_Installment_Dt       
  --from #Temp_Fee_Installment    
  --Group by DateWiseInstallmentSequenceNo,Dt_Payment_Installment_Dt    
  --order by DateWiseInstallmentSequenceNo   
  Select SUM(N_Installment_Amount) as InvTotalAmt into #InvTotalAmt
  from #Temp_Fee_Installment
  Select * from #InvTotalAmt
  Drop table #Temp_Fee_Installment  
  Drop table #InvTotalAmt
  Drop table #InvType
  Drop table #Non_Inv_Type


END
