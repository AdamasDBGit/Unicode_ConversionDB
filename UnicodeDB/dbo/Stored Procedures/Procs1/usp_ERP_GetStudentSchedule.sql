--EXEC [usp_ERP_GetStudentSchedule] 135266,7

CREATE PROCEDURE [dbo].[usp_ERP_GetStudentSchedule]      
(      
    @inStudentDetailID INT ,@SessionID int     
)      
AS      
BEGIN      
    SET NOCOUNT ON;      
     DEclare @EnquiryID int
	 SET @EnquiryID=(
	 Select I_Enquiry_Regn_ID from T_Student_Detail where I_Student_Detail_ID=@inStudentDetailID
	 )
	 --Select @inStudentDetailID, SUM(ISNULL(N_Receipt_Amount,0)+ISNULL(N_Tax_Amount,0)) as TotalAdhocPaid
	 --from T_Receipt_Header where I_Enquiry_Regn_ID=@EnquiryID 

	 Select Adhocsch.inStudentDetailID,Adhocsch.TotalDueAmount,asAdhoc_paid.TotalAdhocPaid from (
    SELECT  inStudentDetailID,    
              
        SUM(CASE       
                WHEN SD.inPaymentStatus = 1 THEN 0      
                ELSE H.nAmount      
            END) AS TotalDueAmount      
    FROM T_ERP_AdhocPaymentScheduleStudentDetail SD      
    INNER JOIN T_ERP_AdhocPaymentScheduleHeaderDetail HD       
        ON SD.inAdhocPaymentScheduleHeaderDetailID = HD.inAdhocPaymentScheduleHeaderDetailID      
    INNER JOIN T_ERP_AdhocPaymentScheduleHeader H       
        ON HD.inAdhocPaymentScheduleHeaderID = H.inAdhocPaymentScheduleHeaderID      
    WHERE SD.inStudentDetailID = @inStudentDetailID    
	and H.inSessionID=@SessionID
    GROUP BY SD.inStudentDetailID
	) Adhocsch
	Left JOin (
	 Select @inStudentDetailID as inStudentDetailID, SUM(ISNULL(N_Receipt_Amount,0)+ISNULL(N_Tax_Amount,0)) as TotalAdhocPaid
	 from T_Receipt_Header where I_Enquiry_Regn_ID=@EnquiryID 
	)  asAdhoc_paid on asAdhoc_paid.inStudentDetailID=Adhocsch.inStudentDetailID
END;