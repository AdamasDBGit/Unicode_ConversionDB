CREATE PROCEDURE [dbo].[uspGetStudentCourseComonentForRefund]    --8573,296735
 @iInvoiceHeaderID INT ,
 @iBatchID INT           
AS                      
BEGIN TRY          
 SET NOCOUNT OFF;
  SELECT  
		tich.I_Course_ID,
		tcm.S_Course_Name,
		tsbm.I_Batch_ID,
		tsbm.S_Batch_Code,
		tsbm.S_Batch_Name,
		tip.I_Invoice_Header_ID,
		tip.S_Invoice_No,
		tich.I_Course_ID,
		tfcm.S_Component_Code,
		ticd.N_Amount_Due As Component_Amount,
		--tich.N_Amount AS Total_Amount,
		ISNULL([dbo].[fnCalculateTaxAmount](trcd.I_Invoice_Detail_ID),0) AS Tax_Amount,
		SUM(N_Amount_Paid)+ISNULL([dbo].[fnCalculateTaxAmount](trcd.I_Invoice_Detail_ID),0) AS Amount_Paid  
		         
  FROM dbo.T_Invoice_Parent AS tip          
  
  inner join dbo.T_Invoice_Child_Header AS tich          
  ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID   
  INNER JOIN dbo.T_Course_Master AS tcm          
  ON tich.I_Course_ID = tcm.I_Course_ID  
  INNER JOIN dbo.T_Student_Batch_Master AS tsbm              
  ON tich.I_Course_ID = tsbm.I_Course_ID           
  INNER JOIN dbo.T_Invoice_Child_Detail AS ticd          
  ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID   
  inner join dbo.T_Fee_Component_Master AS tfcm    
  ON tfcm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
  LEFT OUTER JOIN dbo.T_Receipt_Component_Detail AS trcd          
  ON ticd.I_Invoice_Detail_ID = trcd.I_Invoice_Detail_ID 
  Where tich.I_Invoice_Header_ID=@iInvoiceHeaderID AND tsbm.I_Batch_ID=@iBatchID  
  
  GROUP BY 
  tip.I_Invoice_Header_ID,
  tip.S_Invoice_No,
  tich.I_Course_ID,
  tcm.S_Course_Name,
  tsbm.I_Batch_ID,
  tsbm.S_Batch_Code,
  tsbm.S_Batch_Name,
  tfcm.S_Component_Code,
  ticd.N_Amount_Due,
  --tich.N_Amount+tich.N_Tax_Amount,
  trcd.I_Invoice_Detail_ID
 
 
 END TRY          
BEGIN CATCH          
 --Error occurred:            
 ROLLBACK TRANSACTION           
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int          
 SELECT @ErrMsg = ERROR_MESSAGE(),          
   @ErrSeverity = ERROR_SEVERITY()          
          
 RAISERROR(@ErrMsg, @ErrSeverity, 1)          
END CATCH   

--exec uspGetStudentCourseComonentForRefund 296761,754
