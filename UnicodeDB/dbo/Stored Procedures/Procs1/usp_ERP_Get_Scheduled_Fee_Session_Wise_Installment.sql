-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-Dec-15>
-- Description:	<Get Scheduled Fee Strcuture>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_Get_Scheduled_Fee_Session_Wise_Installment]
	-- Add the parameters for the stored procedure here
	@iFeeScheduleID INT,
	@iAcademicSession INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	select 
	FCM.S_Component_Name as FeecompoenentName,
	EFSIB.N_Component_Actual_Total_Annual_Amount as ComponentAcrualTotalAnnulaAmount,
	EFSIB.Is_During_Admission as IsDuringAdmission,
	EFSIB.Is_OneTime,
	YEAR(EFSIB.Expected_Installment_Date) AS InstallmentYear,   -- Extracts the year
    MONTH(EFSIB.Expected_Installment_Date) AS InstallmentMonth, -- Extracts the month
    DAY(EFSIB.Expected_Installment_Date) AS InstallmentDay,
	EFSIB.I_Seq_No as Sequence
	 
	from 
	T_ERP_Fee_Structure_AcademicSession_Map as EFAM
	inner join
	T_ERP_Fee_Structure_Session_Installment_Breakup as EFSIB on  EFAM.I_Fee_Structure_AcademicSession_Map_ID=EFSIB.I_Fee_Structure_AcademicSession_Map_ID
	inner join
	T_Fee_Component_Master as FCM on EFSIB.R_I_Fee_Component_ID=FCM.I_Fee_Component_ID
	where EFAM.I_School_Session_ID=@iAcademicSession and EFAM.I_Fee_Structure_ID=@iFeeScheduleID
	




END
