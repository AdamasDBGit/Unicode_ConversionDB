CREATE   PROCEDURE [dbo].[usp_ERP_Get_TransactionCountAcademicSessionWise] 
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	Create Table #SuccessEx_InternalTransaction
	(
	TransactionNo Varchar(max),
	ReceiptHeaderID INT,
	PaymentStatusID int,
	--PaymentStatus varchar(max),
	TotalBaseAmount decimal(8,2),
	TotalTaxAmount decimal(8,2)
	)

	Create Table #UnSuccessFulExternalTransaction
	(
	TransactionNo Varchar(max),
	PaymentStatusID int,
	--PaymentStatus varchar(max),
	TotalTransactionAmount decimal(8,2),
	TransactionDate datetime
	)

	DECLARE @PaymentStatusTable TABLE 
(
	PaymentStatusID INT,
    StatusDescription VARCHAR(255),
    StatusColour VARCHAR(255)
);

---- Step 2: Insert the function result into the table variable
INSERT INTO @PaymentStatusTable
SELECT * 
FROM dbo.usp_ERP_GetTransactionStatus(NULL, NULL);


--- Success Transaction
  insert into #SuccessEx_InternalTransaction
  select Distinct TM.I_ERP_TransactionNo,RH.I_Receipt_Header_ID,
  CASE 
        WHEN TM.S_TransactionStatus = 'Initiated' THEN 1
        WHEN TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60 THEN 2
        WHEN TM.S_TransactionStatus = 'Success' THEN 3
        WHEN TM.S_TransactionStatus = 'Failure' THEN 4 
		WHEN TM.S_TransactionStatus IS NULL AND RH.I_Receipt_Header_ID IS NOT NULL THEN 3
        ELSE NULL
  END AS ExternalPaymentStatus,
  ISNULL(RH.N_Receipt_Amount,0),
  ISNULL(RH.N_Tax_Amount,0)
  from 
  T_Receipt_Header as RH
  inner join
  T_Brand_Center_Details as BD on RH.I_Centre_Id=BD.I_Centre_Id
  inner join
  T_Brand_Master as BM on BM.I_Brand_ID=BD.I_Brand_ID
  left join
  T_ERP_Transaction_Invoice_Details as TID on RH.I_Receipt_Header_ID=TID.ReceiptHeaderID and TID.IsCompleted='true'
  left join
  T_ERP_Transaction_Master as TM on TID.I_ERP_Transaction_Master_ID=TM.I_ERP_Transaction_Master_ID and TM.I_StatusID=1
  where RH.I_Status=1 
  and BM.I_Brand_ID=@iBrandID and  
  CONVERT(DATE,RH.Dt_Receipt_Date) between CONVERT(DATE,@dtStartDate) and CONVERT(DATE,@dtEndDate)
  


  select SI.*,PST.StatusDescription as PaymentStatus from #SuccessEx_InternalTransaction as SI
  left join @PaymentStatusTable as PST on SI.PaymentStatusID=PST.PaymentStatusID

  insert into #UnSuccessFulExternalTransaction
  select I_ERP_TransactionNo,
   CASE 
		WHEN TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60 THEN 2
        WHEN TM.S_TransactionStatus = 'Initiated' THEN 1
        WHEN TM.S_TransactionStatus = 'Success' THEN 3
        WHEN TM.S_TransactionStatus = 'Failure' THEN 4 
        ELSE NULL
  END TransactionStatus,
  ISNULL(TM.I_TransactionTotalAmount,0),
  TM.Dt_TransactionDate
  from T_ERP_Transaction_Master as TM
  inner join
  T_ERP_Transaction_Invoice_Details as TID on TID.I_ERP_Transaction_Master_ID=TM.I_ERP_Transaction_Master_ID 
  where (TM.IsCompleted ='false' OR TM.IsCompleted IS NULL)
  and TM.I_BrandID=@iBrandID and CONVERT(DATE,TM.Dt_TransactionDate) between CONVERT(DATE,@dtStartDate) and CONVERT(DATE,@dtEndDate)
  --and TID.ReceiptHeaderID IS NULL
  

  --select * from #UnSuccessFulExternalTransaction

  select SI.*,PST.StatusDescription as PaymentStatus from #UnSuccessFulExternalTransaction as SI
  left join @PaymentStatusTable as PST on SI.PaymentStatusID=PST.PaymentStatusID






END
