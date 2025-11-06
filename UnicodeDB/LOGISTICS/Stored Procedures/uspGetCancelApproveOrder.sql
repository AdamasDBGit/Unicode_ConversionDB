/*  
-- =================================================================  
-- Author:Chandan Dey  
-- Create date:31/07/2007  
-- Description:Get Order List From T_Logistics_Order table  
-- Parameter :   
-- =================================================================  
*/  
CREATE PROCEDURE [LOGISTICS].[uspGetCancelApproveOrder]  
(  
 @iOrderID INT = 0,   
 @iCenterID INT,  
 @iStatusID INT = NULL,  
 @dtFromDate DATETIME = NULL,  
 @dtToDate DATETIME = NULL  
)  
AS  
BEGIN  
IF(@dtToDate IS NOT NULL)  
 BEGIN  
 SET @dtTodate = DATEADD(dd,1,@dtTodate)  
 END  
  
IF (@iOrderID IS NOT NULL AND @iOrderID != 0)  
BEGIN  
 SELECT DISTINCT  
  ISNULL(LO.I_Logistic_Order_ID, 0) AS I_Logistics_Order_ID,  
    ISNULL(LO.I_Status_ID,0) AS I_Status_ID,  
  ISNULL(LO.I_Total_Amount, 0) AS I_Total_Amount,  
  ISNULL(SUM(LOL.I_Item_Qty), 0) AS I_Item_Qty,  
  ISNULL(LO.Order_Date, ' ') AS Order_Date,  
  ISNULL(LO.I_Center_ID,0) AS I_Center_ID,  
  ISNULL(CM.S_Center_Name,'') AS S_Center_Name  
  --ISNULL(LM.S_Item_Code,' ') AS S_Item_Code,  
  --ISNULL(LM.S_Item_Desc, ' ') AS S_Item_Desc    
 FROM  [LOGISTICS].T_Logistics_Order LO  
    LEFT OUTER JOIN [LOGISTICS].T_Logistics_Order_Line LOL  
    ON LO.I_Logistic_Order_ID = LOL.I_Logistics_Order_ID  
    LEFT OUTER JOIN LOGISTICS.T_Logistics_Despatch_Info LDI  
    ON LDI.I_Logistics_Order_ID = LO.I_Logistic_Order_ID  
    --Left Outer Join [LOGISTICS].T_Logistics_Master LM  
    --ON LOL.I_Logistics_ID = LM.I_Logistics_ID  
    LEFT OUTER JOIN dbo.T_Centre_Master CM  
    ON CM.I_Centre_ID = LO.I_Center_ID  
 WHERE   
        LO.I_Logistic_Order_ID = COALESCE(@iOrderID, LO.I_Logistic_Order_ID)   
		AND LO.I_Status_ID = COALESCE(@iStatusID, LO.I_Status_ID)  
		AND LO.I_Status_ID NOT IN (8,10,12)  
        AND LO.I_Center_ID = COALESCE(@iCenterID, LO.I_Center_ID)  
  AND LO.Order_Date >= COALESCE(@dtFromDate, LO.Order_Date)  
  AND LO.Order_Date <= COALESCE(@dtToDate, LO.Order_Date)  
 GROUP BY  
  LO.I_Logistic_Order_ID  
  ,LO.I_Status_ID  
  ,LO.I_Total_Amount  
  ,LO.Order_Date  
  ,LO.I_Center_ID  
  ,CM.S_Center_Name  
      
END  
ELSE  
BEGIN  
 SELECT DISTINCT  
  ISNULL(LO.I_Logistic_Order_ID, 0) AS I_Logistics_Order_ID,  
    ISNULL(LO.I_Status_ID,0) AS I_Status_ID,  
  ISNULL(LO.I_Total_Amount, 0) AS I_Total_Amount,  
  ISNULL(SUM(LOL.I_Item_Qty), 0) AS I_Item_Qty,  
  ISNULL(LO.Order_Date, ' ') AS Order_Date,  
  --ISNULL(LM.S_Item_Code,' ') AS S_Item_Code,  
  --ISNULL(LM.S_Item_Desc, ' ') AS S_Item_Desc     
  ISNULL(LO.I_Center_ID,0) AS I_Center_ID,  
  ISNULL(CM.S_Center_Name,'') AS S_Center_Name  
 FROM  [LOGISTICS].T_Logistics_Order LO  
    LEFT OUTER JOIN [LOGISTICS].T_Logistics_Order_Line LOL  
    ON LO.I_Logistic_Order_ID = LOL.I_Logistics_Order_ID  
    LEFT OUTER JOIN LOGISTICS.T_Logistics_Despatch_Info LDI  
    ON LDI.I_Logistics_Order_ID = LO.I_Logistic_Order_ID  
    --Left Outer Join [LOGISTICS].T_Logistics_Master LM  
    --ON LOL.I_Logistics_ID = LM.I_Logistics_ID   
    LEFT OUTER JOIN dbo.T_Centre_Master CM  
    ON CM.I_Centre_Id = LO.I_Center_ID  
 WHERE  
		LO.I_Status_ID = COALESCE(@iStatusID, LO.I_Status_ID)  
		AND LO.I_Status_ID NOT IN (8,10,12)  
        AND LO.I_Center_ID = COALESCE(@iCenterID, LO.I_Center_ID)  
  AND LO.Order_Date >= COALESCE(@dtFromDate, LO.Order_Date)  
  AND LO.Order_Date <= COALESCE(@dtToDate, LO.Order_Date)  
 GROUP BY  
   LO.I_Logistic_Order_ID  
  ,LO.I_Status_ID  
  ,LO.I_Total_Amount  
  ,LO.Order_Date  
  ,LO.I_Center_ID  
  ,CM.S_Center_Name  
END  
END
