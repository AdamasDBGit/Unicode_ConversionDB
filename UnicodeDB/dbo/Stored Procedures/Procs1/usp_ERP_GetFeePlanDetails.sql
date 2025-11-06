CREATE   PROCEDURE [dbo].[usp_ERP_GetFeePlanDetails] 
	-- Add the parameters for the stored procedure here
	@iBrand INT,
	@iSchoolGroup INT =null,
	@iClass INT =null,
	@iFeeCategory int=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Create table #Temp 
	(
	FeeStructureID INT,
	FeeStructureName varchar(max), 
	FeeCode varchar(max),
	ValidStartDate datetime,      
	ValidEndDate datetime,      
	SchoolGroupID int,
	SchoolGroupName varchar(max),
	ClassID int, 
	ClassName varchar(max),
	StreamID INT,
	StreamName varchar(max),     
	IsLateFineApplicable bit,                 
	CurrencyTypeID int,
	CurrencyType varchar(max),
	OnetimeTotalFeeAmount decimal(18,2),
	InstallmentTotalFeeAmount decimal(18,2),
	TotalFeeAmountDuringPreAdmission decimal(18,2),
	CreatedBy varchar(max),
	CreatedAt Datetime,
	IsEditable bit,
	FeeCategory int,
	FeeCategoryName varchar(max)
	)


	insert into #Temp
	(
	FeeStructureID,
	FeeStructureName, 
	FeeCode,
	ValidStartDate,      
	ValidEndDate,      
	SchoolGroupID,
	SchoolGroupName,
	ClassID, 
	ClassName,
	StreamID,
	StreamName,     
	IsLateFineApplicable,                 
	CurrencyTypeID,
	CurrencyType,
	OnetimeTotalFeeAmount,
	InstallmentTotalFeeAmount,
	IsEditable,
	FeeCategory,
	FeeCategoryName
	)
   select 
   FS.I_Fee_Structure_ID,
   FS.S_Fee_Structure_Name,
   FS.S_Fee_Code,
   FS.Dt_StartDt,
   FS.Dt_EndDt,
   SG.I_School_Group_ID,
   SG.S_School_Group_Name,
   TC.I_Class_ID,
   TC.S_Class_Name,
   SM.I_Stream_ID,
   SM.S_Stream_Name,
   FS.Is_Late_Fine_Applicable,
   CM.I_Currency_ID,
   CM.S_Currency_Name,
   FS.N_Total_OneTime_Amount,
   FS.N_Total_Installment_Amount,
   CASE WHEN invoice.noinvoice > 0 THEN 'FALSE'
   ELSE
   'true' END as IsEditable,
   FCM.I_ERP_Fee_Category_Master_ID,
   FCM.S_Fee_Category_Name
   from 
   T_ERP_Fee_Structure FS
   inner join
   T_School_Group as SG on FS.I_School_Group_ID=SG.I_School_Group_ID and SG.I_Status=1
   inner join
   T_Class as TC on TC.I_Class_ID=FS.I_Class_ID and TC.I_Status=1
   inner join
   T_School_Group_Class as SGC on SG.I_School_Group_ID=SGC.I_School_Group_ID and SGC.I_Class_ID=TC.I_Class_ID and SGC.I_Status=1
   inner join
   T_ERP_Currency_Master as CM on CM.I_Currency_ID=FS.I_Currency_Type_ID
   inner join
   T_Brand_Master as BM on SG.I_Brand_Id=BM.I_Brand_ID
   left join
   T_ERP_Fee_Category_Master as FCM on FCM.I_ERP_Fee_Category_Master_ID=FS.I_ERP_Fee_Category_Master_ID
   left join
   (
   select R_I_Fee_Structure_ID,count(*) as noinvoice from T_ERP_Stud_Fee_Struct_Comp_Mapping 
   group by R_I_Fee_Structure_ID
   ) as invoice on invoice.R_I_Fee_Structure_ID=FS.I_Fee_Structure_ID
   left join
   T_Stream_Master as SM on FS.I_Stream_ID=SM.I_Stream_ID
   where BM.I_Brand_ID=ISNULL(@iBrand,BM.I_Brand_ID)
   and FS.I_School_Group_ID=ISNULL(@iSchoolGroup,FS.I_School_Group_ID)
   and FS.I_Class_ID=ISNULL(@iClass,FS.I_Class_ID)
   and ISNULL(FS.I_ERP_Fee_Category_Master_ID,0)=ISNULL(@iFeeCategory,ISNULL(FS.I_ERP_Fee_Category_Master_ID,0))


   
  -- update #Temp set TotalFeeAmountDuringPreAdmission=
 Update  #Temp set TotalFeeAmountDuringPreAdmission=T2.Amount
 from 
  #Temp T1 
  inner join
   (
   select ComponentwisePreadmissionAmountDetail.R_I_Fee_Structure_ID as FeeStructureID,
   SUM(ISNULL(ComponentwisePreadmissionAmountDetail.ComponentwisePreadmissionAmount,0)) as Amount from
   (
   select  
   SIC.R_I_Fee_Structure_ID,SIC.R_I_Fee_Component_ID,
   ISNULL(SIC.N_Component_Actual_Total_Annual_Amount,0) as Componenttotal,
   ISNULL(FPT.I_Pay_InstallmentNo,0) I_Pay_InstallmentNo,
   SIC.Installm_Range_PreAdm as Installm_Range_PreAdm,
   (ISNULL(SIC.N_Component_Actual_Total_Annual_Amount,0)/ISNULL(FPT.I_Pay_InstallmentNo,0))*ISNULL(SIC.Installm_Range_PreAdm,0) as ComponentwisePreadmissionAmount
   from #Temp as T
  inner join
  T_ERP_Fee_Structure_Installment_Component as SIC on T.FeeStructureID=SIC.R_I_Fee_Structure_ID 
  inner join
  T_ERP_Fee_PaymentInstallment_Type as FPT on SIC.R_I_Fee_Pay_Installment_ID=FPT.I_Fee_Pay_Installment_ID
  and SIC.Is_Active=1 and SIC.Is_OneTime='false' and SIC.Is_During_Admission=1 
  ) as ComponentwisePreadmissionAmountDetail
  group by ComponentwisePreadmissionAmountDetail.R_I_Fee_Structure_ID
  ) as T2 on T2.FeeStructureID=T1.FeeStructureID
 
  
  

   select t1.*,FSAM.I_School_Session_ID MappedAcademicSessionID,
   CASE WHEN SASM.I_Current_Session =1 
   THEN  SASM.S_Label+'(Current)' 
   ELSE  SASM.S_Label END MappedAcademicSessionLabel 
   from #Temp t1
   left join
   T_ERP_Fee_Structure_AcademicSession_Map as FSAM on t1.FeeStructureID=FSAM.I_Fee_Structure_ID and FSAM.Is_Active=1
   left join
   T_School_Academic_Session_Master as SASM on FSAM.I_School_Session_ID=SASM.I_School_Session_ID


  select
  FSIC.R_I_Fee_Structure_ID as FeeStructureID,
  FSIC.I_Fee_Structure_Installment_Component_ID as FeeStructureInstallCompID,
  FSIC.R_I_Fee_Component_ID as FeeComponentID,
  FC.S_Fee_Component_Name as FeeComponentName,
  FSIC.N_Component_Actual_Total_Annual_Amount as ComponentTotalAmount,
  FSIC.Is_OneTime as IsOneTime,
  FSIC.I_Seq_No as SequenceNo,
  FPT.I_Fee_Pay_Installment_ID as FeeInstallmentFrequencyID,
  FPT.I_Pay_InstallmentNo as NoInstallments,
  FPT.S_Installment_Frequency as InstallmentTypeName,
  ISNULL(FSIC.Is_During_Admission,'false') as IsConsiderForPreAdmission
  
  from  #Temp as T
  inner join
  T_ERP_Fee_Structure_Installment_Component as FSIC on T.FeeStructureID=FSIC.R_I_Fee_Structure_ID
  inner join
  T_ERP_Fee_Component as FC on FC.I_Fee_Component_ID=FSIC.R_I_Fee_Component_ID
  inner join
  T_ERP_Fee_PaymentInstallment_Type as FPT on FPT.I_Fee_Pay_Installment_ID=FSIC.R_I_Fee_Pay_Installment_ID 
  where FSIC.Is_Active=1

  

END
