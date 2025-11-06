--exec [dbo].[usp_ERP_GetAdhocPaymentScheduleDetails] '','';  
CREATE PROCEDURE [dbo].[usp_ERP_GetAdhocPaymentScheduleDetails]          
(          
 @AdhocPaymentScheduleHeaderID INT = NULL  ,    
 @brandID INT NULL    
)          
AS          
BEGIN          
    SET NOCOUNT ON;          
      
    -- Compute total and completed payment counts per schedule      
    ;WITH CompletedPayments AS (      
        SELECT      
            HD.inAdhocPaymentScheduleHeaderID,      
            COUNT(*) AS TotalCount,      
            SUM(CASE WHEN SD.inPaymentStatus = 1 THEN 1 ELSE 0 END) AS CompletedCount,      
            CASE       
                WHEN COUNT(*) = SUM(CASE WHEN SD.inPaymentStatus = 1 THEN 1 ELSE 0 END)       
                THEN 1 ELSE 0       
            END AS AllStudentsPaid      
        FROM T_ERP_AdhocPaymentScheduleHeaderDetail HD      
        INNER JOIN T_ERP_AdhocPaymentScheduleStudentDetail SD       
            ON HD.inAdhocPaymentScheduleHeaderDetailID = SD.inAdhocPaymentScheduleHeaderDetailID      
        GROUP BY HD.inAdhocPaymentScheduleHeaderID      
    )      
      
    SELECT         
        H.inAdhocPaymentScheduleHeaderID AS AdhocPaymentScheduleHeaderID,          
        F.S_Status_Desc AS AdhocFeeName,          
        H.nAmount AS Amount,          
        FORMAT(H.dtStartDate, 'yyyy-MM-dd') AS StartDate,          
        FORMAT(H.dtEndDate, 'yyyy-MM-dd') AS EndDate,          
        H.sDescription AS Description,          
      
        CASE      
            WHEN CP.AllStudentsPaid = 1 THEN 'Completed'      
            ELSE 'Upcoming'      
        END AS Status,      
      
        ISNULL(CP.CompletedCount, 0) AS CompletedCount,      
        ISNULL(CP.TotalCount, 0) AS TotalCount,      
      
        -- ✅ Added High Priority Flag
        H.IsCollectWithHighPriority AS IsCollectWithHighPriority,
        H.EventId AS EventId,
        ApplicableTo = STUFF((        
            SELECT ', ' + C2.S_Class_Name          
            FROM T_ERP_AdhocPaymentScheduleHeaderDetail HD2          
            INNER JOIN T_Class C2 ON HD2.inClassID = C2.I_Class_ID          
            WHERE HD2.inAdhocPaymentScheduleHeaderID = H.inAdhocPaymentScheduleHeaderID          
            FOR XML PATH(''), TYPE          
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')          
      
    FROM T_ERP_AdhocPaymentScheduleHeader H          
    INNER JOIN T_Status_Master F           
        ON H.inAdHocFeeComponentID = F.I_Status_Value          
    LEFT JOIN CompletedPayments CP      
        ON H.inAdhocPaymentScheduleHeaderID = CP.inAdhocPaymentScheduleHeaderID      
    WHERE ((@AdhocPaymentScheduleHeaderID IS NULL OR H.inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID) AND H.inBrandID=@brandID);          
END;
