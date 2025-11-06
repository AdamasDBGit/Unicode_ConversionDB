-- =====================================================================      
-- Author : Surya Narayan Chakraborty.      
-- Created On : 03/11/2025      
-- =====================================================================   
  
-- EXEC [dbo].[usp_ERP_Get_Transport_Fees_Edit_Details] 1;  
CREATE PROCEDURE [dbo].[usp_ERP_Get_Transport_Fees_Edit_Details]  
@RouteID INT = NULL  
AS  
BEGIN      
SET NOCOUNT ON;      
BEGIN TRY   
             SELECT DISTINCT  
                   c.Fare_Code AS [Fare_Code],      
            b.Configuration_Name AS [Configuration_Name],      
            d.I_School_Session_ID AS [Academic_Session],     
            --a.I_Route_ID,    
            a.S_Route_No AS [Route],      
            --c.I_PickupPoint_ID,      
            --c.S_PickupPoint_Name,      
            COUNT(b.I_PickupPoint_ID) OVER (PARTITION BY b.I_Route_ID)  AS [Total_Pickup_Points],      
            b.Monthly_Amount AS [Monthly],      
            b.Bimonthly_Amount AS [Bimonthly],      
            b.Quarterly_Amount AS [Quarterly],      
            b.Yearly_Amount AS [Yearly],      
            CASE       
               WHEN vw.I_Fee_Component_ID IS NOT NULL THEN 'YES'      
               ELSE 'NO'      
            END AS [GST],      
            FORMAT(b.Dt_Effective_From, 'dd MMM yyyy') + ' - ' + FORMAT(b.Dt_Effective_To, 'dd MMM yyyy') AS [Effective],      
            c.I_Status AS [Status]      
            --vw.I_Fee_Component_ID      
        FROM T_BusRoute_Master a      
        INNER JOIN T_Route_Transport_Map b ON a.I_Route_ID = b.I_Route_ID      
        INNER JOIN T_Transport_Master c ON c.I_PickupPoint_ID = b.I_PickupPoint_ID      
        LEFT JOIN T_School_Academic_Session_Master d on d.I_School_Session_ID = b.I_Academic_Session_ID      
        CROSS JOIN [dbo].[VW_Get_TransportGST_By_ComponentID] vw      
        WHERE   
             @RouteID IS NULL OR a.I_Route_ID = @RouteID  
             AND a.I_Status = 1       
            AND b.I_Status = 1       
            AND d.I_Status = 1  
        GROUP BY      
            c.Fare_Code,      
            b.Configuration_Name,      
            d.I_School_Session_ID,  
            a.S_Route_No,  
            b.I_Route_ID,  
            b.I_PickupPoint_ID,  
            b.Monthly_Amount,      
            b.Bimonthly_Amount,      
            b.Quarterly_Amount,      
            b.Yearly_Amount,      
            FORMAT(b.Dt_Effective_From, 'dd MMM yyyy') + ' - ' + FORMAT(b.Dt_Effective_To, 'dd MMM yyyy'),      
            c.I_Status,  
            vw.I_Fee_Component_ID;  
  
 END TRY              
    BEGIN CATCH      
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();      
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();      
        DECLARE @ErrorState INT = ERROR_STATE();      
              
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);      
    END CATCH            
END;