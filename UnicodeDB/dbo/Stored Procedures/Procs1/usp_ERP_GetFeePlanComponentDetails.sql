-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_GetFeePlanComponentDetails null, null, null, null, null, null, null
-- exec usp_ERP_GetFeePlanComponentDetails 107, null, null, null, null, null, 21
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetFeePlanComponentDetails]
	-- Add the parameters for the stored procedure here
	(
		@iBrand INT NULL,
		@iSchoolGroupID INT NULL,
		@iClassID INT NULL,
		@iStreamID INT NULL,
		@iValidYearFrom INT NULL,
		@iValidYearTo INT NULL,
		@feeStructureID INT NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select TEFS.I_Fee_Structure_ID AS FeeStructureID,
TEFS.I_School_Group_ID AS SchoolGroupID,
TSG.S_School_Group_Name AS SchoolGroupName,
TEFS.I_Class_ID AS ClassID,
TC.S_Class_Name AS ClassName,
TEFS.I_Stream_ID AS StreamID,
TSM.S_Stream_Name AS StreamName,
TEFS.I_Currency_Type_ID AS CurrencyTypeID,
TCM.S_Currency_Name AS CurrencyTypeName,
TEFS.S_Fee_Structure_Name AS FeeStructureName,
TEFS.Dt_StartDt AS ValidFrom,
TEFS.Dt_EndDt AS ValidTo,
--TEFSIC.R_I_Fee_Structure_ID AS FeeStructureID,
--TEFSIC.R_I_Fee_Component_ID AS FeeComponentID,
--TERC.S_Fee_Component_Name AS FeeComponentName,
--TEFSIC.I_Seq_No AS SeqNo,
--TEFSIC.Is_OneTime AS IsOneTime,
TEFS.N_Total_OneTime_Amount AS TotalOneTimeAmount,
TEFS.N_Total_Installment_Amount AS TotalInstallmentAmount
--TEFSIC.R_I_Fee_Pay_Installment_ID AS FeePayInstallmentID,
--TEFPT.S_Installment_Frequency AS InstallmentFrequency,
--TEFPT.I_Pay_InstallmentNo AS PayInstallmentNo,
--TEFPT.I_Interval AS PayInterval,
--TEFSIC.Is_During_Admission AS IsDuringAdmission
from T_ERP_Fee_Structure TEFS
inner join T_School_Group as TSG on TEFS.I_School_Group_ID=TSG.I_School_Group_ID and TSG.I_Status=1
inner join T_Brand_Master as TBM on TSG.I_Brand_Id = TBM.I_Brand_ID and TBM.I_Status =1
inner join T_Class as TC on TEFS.I_Class_ID = TC.I_Class_ID and TC.I_Status = 1
left join T_Stream_Master as TSM on TEFS.I_Stream_ID = TSM.I_Stream_ID and TSM.I_Status = 1
left join T_Currency_Master as TCM on TEFS.I_Currency_Type_ID = TCM.I_Currency_ID and TCM.I_Status = 1
--left join T_ERP_Fee_Structure_Installment_Component as TEFSIC on TEFS.I_Fee_Structure_ID = TEFSIC.R_I_Fee_Structure_ID and TEFSIC.Is_Active = 1
--left join T_ERP_Fee_Component as TERC on TERC.I_Fee_Component_ID = TEFSIC.R_I_Fee_Component_ID 
--left join T_ERP_Fee_PaymentInstallment_Type as TEFPT on TEFSIC.R_I_Fee_Pay_Installment_ID = TEFPT.I_Fee_Pay_Installment_ID and TEFPT.Is_Active = 1

Where TBM.I_Brand_ID=ISNULL(@iBrand,TBM.I_Brand_ID)
   and TEFS.I_School_Group_ID=ISNULL(@iSchoolGroupID,TEFS.I_School_Group_ID)
   and TEFS.I_Class_ID=ISNULL(@iClassID,TEFS.I_Class_ID)
       --AND (
       --     (TEFS.Dt_StartDt IS NULL AND TEFS.Dt_EndDt IS NULL)
       --     OR (
       --         TEFS.Dt_StartDt IS NOT NULL AND TEFS.Dt_EndDt IS NOT NULL
       --         AND YEAR(CONVERT(DATE, TEFS.Dt_StartDt)) <= @iValidYearFrom
       --         AND YEAR(CONVERT(DATE, TEFS.Dt_EndDt)) >= @iValidYearFrom
       --         AND YEAR(CONVERT(DATE, TEFS.Dt_StartDt)) <= @iValidYearTo
       --         AND YEAR(CONVERT(DATE, TEFS.Dt_EndDt)) >= @iValidYearTo
       --     )
       -- )
   and TEFS.I_Fee_Structure_ID = ISNULL(@feeStructureID, TEFS.I_Fee_Structure_ID)
   and TEFS.Is_Active = 1

   select TEFSIC.R_I_Fee_Structure_ID as FeeStructureID,
   TEFSIC.R_I_Fee_Component_ID AS FeeComponentID,
   TEFSIC.N_Component_Actual_Total_Annual_Amount as TotalAmount,
   TEFSIC.Installm_Range_PreAdm as PreAdmissionRange,
   TERC.S_Fee_Component_Name AS FeeComponentName,
	TEFSIC.I_Seq_No AS SeqNo,
	TEFSIC.Is_OneTime AS IsOneTime,
	TEFSIC.R_I_Fee_Pay_Installment_ID AS FeePayInstallmentID,
	TEFPT.S_Installment_Frequency AS InstallmentFrequency,
	TEFPT.I_Pay_InstallmentNo AS PayInstallmentNo,
	TEFPT.I_Interval AS PayInterval,
	TEFSIC.Is_During_Admission AS IsDuringAdmission
   from T_ERP_Fee_Structure_Installment_Component as TEFSIC
   left join T_ERP_Fee_Component as TERC on TERC.I_Fee_Component_ID = TEFSIC.R_I_Fee_Component_ID 
   left join T_ERP_Fee_PaymentInstallment_Type as TEFPT on TEFSIC.R_I_Fee_Pay_Installment_ID = TEFPT.I_Fee_Pay_Installment_ID and TEFPT.Is_Active = 1
   where TEFSIC.R_I_Fee_Structure_ID=@feeStructureID


END
