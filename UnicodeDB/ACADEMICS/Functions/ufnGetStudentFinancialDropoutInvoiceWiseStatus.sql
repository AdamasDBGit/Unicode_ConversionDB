CREATE FUNCTION [ACADEMICS].[ufnGetStudentFinancialDropoutInvoiceWiseStatus]     
(      
 @iStudentID int,      
 @iCenterID int,      
 @iAllowedNumberOfNonPaymentDays int,      
 @dCurrenDate datetime,    
 @iCourseId  int    
)      
RETURNS  CHAR(1)      
AS       
-- Returns the Student Status whether ACTIVE, ON LEAVE or DROPOUT.      
BEGIN      
      
DECLARE @cDropoutStatus CHAR(1)      
DECLARE @dDateCompare DATETIME      
DECLARE @dLastInstallmentDate DATETIME      
DECLARE @dActualLastInstallmentDate DATETIME      
DECLARE @iDayCount INT      
DECLARE @iInvoiceHeaderID INT      
DECLARE @iActualNumberofNonPaymentDays int      
      
SET @cDropoutStatus = 'N'      
      
  IF EXISTS(      
   SELECT DD.I_Student_Detail_ID    
   FROM ACADEMICS.T_Dropout_Details DD    
   INNER JOIN dbo.T_Invoice_Parent IP ON DD.I_Student_Detail_ID = IP.I_Student_Detail_ID  
              AND DD.I_Invoice_Header_ID = IP.I_Invoice_Header_ID    
   INNER JOIN dbo.T_Invoice_Child_Header ICH ON ICH.I_Invoice_Header_Id = IP.I_Invoice_Header_Id    
   WHERE DD.I_Student_Detail_ID = @iStudentID     
   AND DD.I_Dropout_Status = 1      
   AND DD.I_Dropout_Type_ID = 2    
   AND IP.I_Centre_Id = @iCenterID    
   AND ICH.I_Course_Id = @iCourseId      
   )      
  BEGIN      
   SET @cDropoutStatus = 'Y'      
  END      
      
    RETURN @cDropoutStatus      
END