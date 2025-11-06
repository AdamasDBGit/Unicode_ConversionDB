-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 9 Spet, 2010  
-- Description: Selects All the Registration Receipts for student  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetRegistrationReceipts]  
@iCenterID INT,  
@iEnquiryID INT  
AS  
BEGIN  
  SELECT I_Registration_ID,  
  SRD.Crtd_On AS RegistrationDate,  
  SBM.S_Batch_Code AS BatchCode,  
  SBM.S_Batch_Name,
  SBM.I_Batch_ID,  
  RH.I_Receipt_Header_ID,  
  RH.N_Receipt_Amount + RH.N_Tax_Amount AS Amount,  
  I_Origin_Center_Id,  
  I_Destination_Center_ID,  
  SRD.I_Fee_Plan_ID,  
  CFP.S_Fee_Plan_Name,  
  ISNULL(N_Referral_Amount,0) AS N_Referral_Amount  
  FROM dbo.T_Student_Registration_Details SRD  
  INNER JOIN dbo.T_Student_Batch_Master SBM  
  ON SRD.I_Batch_ID = SBM.I_Batch_ID  
  INNER JOIN dbo.T_Receipt_Header RH  
  ON SRD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID  
  LEFT OUTER JOIN dbo.T_Course_Fee_Plan CFP  
  ON SRD.I_Fee_Plan_ID = CFP.I_Course_Fee_Plan_ID  
  WHERE SRD.I_Status = 1  
  AND SRD.I_Destination_Center_ID = @iCenterID  
  AND SRD.I_Enquiry_Regn_ID = @iEnquiryID  
  
END
