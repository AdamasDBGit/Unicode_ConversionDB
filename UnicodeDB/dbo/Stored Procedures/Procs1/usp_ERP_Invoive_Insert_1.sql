  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
  
--exec [dbo].[usp_ERP_Invoive_Insert] 1, 107, 2
-- =============================================  
 -- EXEC usp_ERP_Invoive_Insert_1 1,107,Null,2,2533,1
  
CREATE PROCEDURE [dbo].[usp_ERP_Invoive_Insert_1]  
 -- Add the parameters for the stored procedure here  
 (  
  @EnquiryID INT ,  
  @Brand_ID int =Null,  
  @Centre_Id int =null,
  @SessionID int=Null,
  @StudentDetailsID int=Null,
  @CreatedBy NVARCHAR(MAX)=Null
  --@FeeStructureID INT = NULL  
  --@TargetDate datetime= null  
 )  
  
AS  
Begin  

  
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
  Declare @TotalInvAmt Numeric(18,2)
  Select @TotalInvAmt=SUM(N_Installment_Amount) 
  from #Temp_Fee_Installment
 Select @TotalInvAmt as TotalAMt
  ---Start Process to Inserting Invoices------------
  --If Not Exists(Select 1 from [T_Invoice_Parent] 
  --where I_Student_Detail_ID=@StudentDetailsID)
  --Begin
  If @Centre_Id is  null
  Begin
  Set @Centre_Id=(Select Top 1 I_Centre_Id from T_Brand_Center_Details 
  where I_Brand_ID=@Brand_ID)
  End
  Else 
  Begin
  Select @Centre_Id
  End
  Print @Centre_Id
  Declare @Invoice_Header_ID Int
  --Insert Into [T_Invoice_Parent](

  -- S_Invoice_No
  --,I_Student_Detail_ID
  --,I_Centre_Id
  --,N_Invoice_Amount
  --,Dt_Invoice_Date
  --,I_Status
  --,S_Crtd_By
  --,Dt_Crtd_On
  --,IsAdmissionInvoice
  --)
Select
  Null,
  @StudentDetailsID,
  @Centre_Id,
  @TotalInvAmt,
  Getdate(),
  1,
  @CreatedBy,
  Getdate(),
  1
  
  SET @Invoice_Header_ID=SCOPE_IDENTITY()
  Print 'Invoice Header Inserted'
  ------Inserting Into T_Invoice_Child_Header------- 
  Declare @classID int,@streamID Int,@CourseID int
  SET @classID=(
  Select I_Class_ID from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@EnquiryID
  )
    SET @streamID=(
  Select I_Stream_ID from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@EnquiryID
  )
  SET @CourseID=(select Top 1 I_Course_ID from T_Course_Group_Class_Mapping where I_Brand_ID=@Brand_ID
  and I_Class_ID=@classID and I_School_Session_ID=@SessionID
  And (I_Stream_ID=@streamID or I_Stream_ID Is null)
  )
  -----Set Fee Plan ID from Fee Structure----
  Declare @Course_FeePlan_ID Int,@Fee_Structure_ID int,@Is_LumpSum int,@TotalInv_Amt Numeric(18,2),
  @TotalNonInv_AMt Numeric(18,2)
  SET @Fee_Structure_ID=(
  Select R_I_Fee_Structure_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping 
  where R_I_Enquiry_Regn_ID=@EnquiryID
  )
  SET @Course_FeePlan_ID=(Select I_Course_Fee_Plan_ID from T_Course_Fee_Plan 
  where I_New_I_Fee_Structure_ID=@Fee_Structure_ID
  )
    SET @Is_LumpSum=
    (Select Is_LumpSum from T_ERP_Stud_Fee_Struct_Comp_Mapping 
	where R_I_Enquiry_Regn_ID=@EnquiryID
    and I_Brand_ID=@Brand_ID and R_I_School_Session_ID=@SessionID)

	SET @TotalInv_Amt=(Select SUM(N_Installment_Amount) from #InvType)
    SET @TotalNonInv_AMt=(Select SUM(N_Installment_Amount) from #Non_Inv_Type)
	Print @Is_LumpSum 
  --Insert Into T_Invoice_Child_Header
  --(

  --  I_Invoice_Header_ID
  -- ,I_Course_ID
  -- ,I_Course_FeePlan_ID
  -- ,C_Is_LumpSum
  -- ,N_Amount
  -- ,N_Tax_Amount
  -- ,N_Discount_Amount
  -- ,I_Discount_Scheme_ID
  -- ,I_Discount_Applied_At
  --)
  Select @Invoice_Header_ID,@CourseID,@Course_FeePlan_ID,
  Case When @Is_LumpSum=1 Then 'Y' Else 'N' end,SUM(N_Installment_Amount),Null,Null,Null,Null

  from #InvType Group by R_I_Enquiry_Regn_ID
  Union All
  Select @Invoice_Header_ID,Null,Null,
  Case When @Is_LumpSum=1 Then 'Y' Else 'N' end,SUM(N_Installment_Amount),Null,Null,Null,Null

  from #Non_Inv_Type Group by R_I_Enquiry_Regn_ID
  Print 'Invoice Child Header Inserted for Inv Amt'
  --End
  
  Drop table #Temp_Fee_Installment  
  --Drop table #InvTotalAmt
  Drop table #InvType
  Drop table #Non_Inv_Type


END

