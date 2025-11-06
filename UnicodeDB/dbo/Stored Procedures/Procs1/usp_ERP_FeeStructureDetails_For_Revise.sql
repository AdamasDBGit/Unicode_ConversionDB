CREATE PROCEDURE [dbo].[usp_ERP_FeeStructureDetails_For_Revise]          
(          
@StudentDetailID int,          
@iOldInvoiceID int,
@iBrandID int
)          
 -- Add the parameters for the stored procedure here          
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;          
          
    -- Insert statements for procedure here          
       
   Declare @ClassID int,@streamID int,@academicSession int, @CurrentERPFeeSchedule int,@ClassGroupID int



select
@ClassID=SGC.I_Class_ID,@streamID=SCS.I_Stream_ID,@academicSession=SASM.I_School_Session_ID
,@CurrentERPFeeSchedule=CFP.I_New_I_Fee_Structure_ID,@ClassGroupID=SGC.I_School_Group_Class_ID
from T_Student_Class_Section as SCS
inner join
T_School_Group_Class as SGC on SCS.I_School_Group_Class_ID=SGC.I_School_Group_Class_ID
inner join
T_School_Academic_Session_Master as SASM on SCS.I_School_Session_ID=SASM.I_School_Session_ID  --and SASM.I_Status=1
and SASM.I_Brand_ID=@iBrandID and SASM.I_Status=1
inner join
T_Invoice_Parent as TIP on  
--CONVERT(DATE,TIP.Dt_Crtd_On) between CONVERT(DATE,SASM.Dt_Session_Start_Date) AND CONVERT(DATE,SASM.Dt_Session_End_Date)
--and
TIP.I_Invoice_Header_ID=@iOldInvoiceID and SCS.I_Student_Detail_ID=@StudentDetailID
and TIP.I_School_Session_ID=SCS.I_School_Session_ID
inner join
T_Invoice_Child_Header as ICP on ICP.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID
inner join
T_Course_Fee_Plan as CFP on CFP.I_Course_Fee_Plan_ID=ICP.I_Course_FeePlan_ID

print @academicSession
print @ClassID
print @CurrentERPFeeSchedule

IF @ClassID IS NULL
begin

select
@ClassID=SGC.I_Class_ID,@streamID=SCS.I_Stream_ID,@academicSession=SASM.I_School_Session_ID
,@CurrentERPFeeSchedule=CFP.I_New_I_Fee_Structure_ID
from T_Student_Class_Section as SCS
inner join
T_School_Group_Class as SGC on SCS.I_School_Group_Class_ID=SGC.I_School_Group_Class_ID
inner join
T_School_Academic_Session_Master as SASM on SCS.I_School_Session_ID=SASM.I_School_Session_ID 
and SASM.I_Brand_ID=@iBrandID and SASM.I_Status=1
inner join
T_Invoice_Parent as TIP on  
CONVERT(DATE,TIP.Dt_Crtd_On) between CONVERT(DATE,SASM.Dt_Session_Start_Date) AND CONVERT(DATE,SASM.Dt_Session_End_Date)
and
TIP.I_Invoice_Header_ID=@iOldInvoiceID and SCS.I_Student_Detail_ID=@StudentDetailID
inner join
T_Invoice_Child_Header as ICP on ICP.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID
inner join
T_Course_Fee_Plan as CFP on CFP.I_Course_Fee_Plan_ID=ICP.I_Course_FeePlan_ID

end

print @academicSession
print @ClassID
print @CurrentERPFeeSchedule

IF @academicSession IS NOT NULL AND @ClassID IS NOT NULL AND @CurrentERPFeeSchedule IS NOT NULL
	BEGIN
		If @streamID is  null  
			Begin  
				 SELECT           
				 TEFS.S_Fee_Structure_Name+' (' +TEFS.S_Fee_Code+')' FeeStructureName           
				,TEFS.S_Fee_Code FeeCode          
				,TEFS.I_Fee_Structure_ID ERPFeeStructureID          
				,ISNULL(TEFS.N_Total_OneTime_Amount,0) OneTimeTotalAmount   
				,ISNULL(TEFS.N_Total_Installment_Amount,0) InstallmentTotalAmount
				,TEFS.Is_Late_Fine_Applicable IsLateFineApplicable          
               ,CASE WHEN TEFS.I_Fee_Structure_ID=@CurrentERPFeeSchedule THEN 'true'
			   ELSE 'false' END as IsCurrentFeeStructure ,
			   @ClassID ClassID,
			   @streamID StreamID,
			   @academicSession AcademicSession
				 FROM T_ERP_Fee_Structure TEFS 
				 inner join
				 T_ERP_Fee_Structure_AcademicSession_Map as FAM on TEFS.I_Fee_Structure_ID=FAM.I_Fee_Structure_ID
				 where TEFS.Is_Active =1   and TEFS.I_Class_ID=@ClassID   and FAM.I_School_Session_ID=@academicSession
			 End  
		 Else  
			 Begin  
				  SELECT           
				 TEFS.S_Fee_Structure_Name+' (' +TEFS.S_Fee_Code+')' FeeStructureName           
				,TEFS.S_Fee_Code FeeCode          
				,TEFS.I_Fee_Structure_ID ERPFeeStructureID          
				,ISNULL(TEFS.N_Total_OneTime_Amount,0) OneTimeTotalAmount   
				,ISNULL(TEFS.N_Total_Installment_Amount,0) InstallmentTotalAmount          
				,TEFS.Is_Late_Fine_Applicable IsLateFineApplicable          
			   ,CASE WHEN TEFS.I_Fee_Structure_ID=@CurrentERPFeeSchedule THEN 'true'
			   ELSE 'false' END as IsCurrentFeeStructure,
			   @ClassID ClassID,
			   @streamID StreamID,
			   @academicSession AcademicSession
				 FROM T_ERP_Fee_Structure TEFS
				 inner join
				 T_ERP_Fee_Structure_AcademicSession_Map as FAM on TEFS.I_Fee_Structure_ID=FAM.I_Fee_Structure_ID
				 where TEFS.Is_Active =1   and TEFS.I_Class_ID=@ClassID and  FAM.I_School_Session_ID=@academicSession  and TEFS.I_Stream_ID=@streamID 
				 or @streamID is null
			 End   
     
	END          
          
END 
