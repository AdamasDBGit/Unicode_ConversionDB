-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-July-03>
-- Description:	<Get valid Transactions which are eligible for ERP Process>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GET_ValidTransactions_For_ERP_Process]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select DISTINCT TRCJ.*,TM.I_ERP_TransactionNo TransactionNo,TM.Order_ID as OrderID
	,TM.I_BrandID BrandID,
	TM.I_ERP_Brand_PaymentGateway_Map_id as PaymentGatewayBrandID
	,CASE WHEN ISNULL(EBPM.I_IsLive,'false') ='true' THEN EBPM.S_Live_salt
	WHEN ISNULL(EBPM.I_IsLive,'false') ='false' THEN EBPM.S_Test_Salt
	ELSE 'NA' END Salt,
	CASE WHEN ISNULL(EBPM.I_IsLive,'false') ='true' THEN EBPM.S_Live_keySecret
	WHEN ISNULL(EBPM.I_IsLive,'false') ='false' THEN EBPM.S_Test_KeySecret
	ELSE 'NA' END keySecret
	from 
	T_ERP_Transaction_Requery_Cron_Job as TRCJ
	inner join
	T_ERP_Transaction_Master as TM on TM.I_ERP_Transaction_Master_ID=TRCJ.I_Transaction_Master_ID
	inner join
	T_ERP_Brand_PaymentGateway_Map as EBPM on EBPM.I_ERP_Brand_PaymentGateway_Map_id=TM.I_ERP_Brand_PaymentGateway_Map_id
	inner join
	T_ERP_PaymentGateway_Info as PGI on EBPM.I_PaymentGateway_Id=EBPM.I_PaymentGateway_Id
	where TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60
	and ISNULL(TRCJ.CronCanBeProcess,'false')='true' and ISNULL(TRCJ.PG_NoOfAttempt,0) <= 3 
	and ISNULL(TRCJ.CanbeProcessForERPSattlement,'false')='true'
	and TRCJ.PG_Response IS NOT NULL 




END
