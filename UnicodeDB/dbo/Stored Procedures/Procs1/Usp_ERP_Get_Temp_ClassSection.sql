--exec Usp_ERP_Get_Temp_ClassSection 64,107    
CREATE Proc [dbo].[Usp_ERP_Get_Temp_ClassSection]    
(    
    @ClassID Int=null,    
    @BrandID int    
)    
as    
Begin    
    
SELECT     
    t1.I_Stream_ID AS StreamID,    
    t1.S_Stream AS StreamName,    
    NULL AS I_Class_ID,    
    NULL AS I_Brand_ID,    
 NULL I_Active,    
    0 AS IsSelected    
FROM     
    T_Stream t1    
WHERE     
    @ClassID IS NULL    
UNION ALL    
SELECT     
    t1.I_Stream_ID AS StreamID,    
    t1.S_Stream AS StreamName,    
    t2.I_Class_ID,    
    t2.I_Brand_ID,    
 t2.I_Active,    
    CASE    
        WHEN t2.I_Active =1 THEN 1    
    
        ELSE 0    
    END AS IsSelected    
FROM     
    T_Stream t1    
LEFT JOIN     
    T_ERP_Temp_ClassStream t2    
ON     
    t1.I_Stream_ID = t2.I_Stream_ID    
AND     
    (t2.I_Class_ID = @ClassID OR @ClassID IS NULL)    
AND     
    (t2.I_Brand_ID = @BrandID OR t2.I_Brand_ID IS NULL)    
WHERE     
    @ClassID IS NOT NULL AND t1.I_Status=1 --AND t2.I_Active=1    
    and t1.I_brand_id=@BrandID  
    
    
       
End