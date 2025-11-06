CREATE PROCEDURE [dbo].[usp_ERP_GetStudentAdhocPaymentDue]    

(    

    @inStudentDetailID INT    

)    

AS    

BEGIN    

    SET NOCOUNT ON;    

    SELECT    

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

    AND SD.inPaymentStatus  NOT IN (1, 2) 

    GROUP BY SD.inStudentDetailID;    

END;
 