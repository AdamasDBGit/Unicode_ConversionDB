CREATE PROCEDURE [dbo].[usp_ERP_GetSaasDetail]  
 @Brandid INT = NULL  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    -- Fetch brand details
    SELECT 
        BM.S_Brand_Code AS BrandCode,  
        BM.S_Brand_Name AS BrandName,  
        BM.S_Short_Code AS ShortCode,  
        BM.I_Brand_ID AS BrandID  
    FROM 
        T_Brand_Master AS BM 
    WHERE 
        BM.I_Brand_ID = @Brandid;  
  
    -- Fetch Saas details with value type
    SELECT   
        SPH.I_Pattern_HeaderID AS PatternHeaderID,  
        SPH.S_Property_Type AS PropertyType,   
        SPH.S_Property_Name AS PropertyName,  
        SPH.N_Help AS Help,  
        CASE   
            WHEN PCH.Is_Active = 1 THEN PCH.N_Value  
            ELSE NULL  
        END AS PropertyValue,  
        PCH.I_Saas_Pattern_Child_Header_ID AS ChildHeaderID,  
        PCH.Pattern1 AS Pattern1,  
        PCH.Pattern2 AS Pattern2,  
        PCH.Pattern3 AS Pattern3,
        SPH.S_Screen AS Screen,
        PCH.S_Description AS Description,
        PCH.I_Value_Type AS ValueTypeID,  -- Add ValueType ID
        TCVT.S_Type AS ValueType         -- Add ValueType description
    FROM   
        T_ERP_Saas_Pattern_Header AS SPH   
    LEFT JOIN   
        T_ERP_Saas_Pattern_Child_Header AS PCH ON SPH.I_Pattern_HeaderID = PCH.I_Pattern_HeaderID  
    LEFT JOIN
        T_Configuration_Value_Type AS TCVT ON PCH.I_Value_Type = TCVT.I_Configuration_Value_Type_ID  -- Join with configuration table
    WHERE   
        SPH.I_Brand_ID = @Brandid  
        AND SPH.Is_Active = 1;  
END;
