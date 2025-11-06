-- =============================================    
-- Author:  Qutub Haider    
-- Create date: 15 Aug 2024    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetSectionList]    
(    
 @iClassID dbo.IntArray READONLY    
)    
AS    
BEGIN    
    SET NOCOUNT ON;   
--Declare @brandID int
--SET @brandID=(
--Select top 1  I_Brand_ID from T_Class where I_Class_ID=14
--)
    
    SELECT     
        TC.I_Class_ID AS ClassId,    
        TC.S_Class_Name +    
        CASE     
            WHEN TS.S_Stream IS NOT NULL THEN ' - ' + TS.S_Stream     
            ELSE ''    
        END +     
        ' - ' + S.S_Section_Name AS SectionName,    
        CS.I_Section_ID AS SectionID,    
        TS.I_Stream_ID AS inStreamId  ,
		TS.S_Stream as Stream
    FROM      
        [dbo].[T_ERP_Class_Section] AS CS     
        JOIN [dbo].[T_Section] AS S ON CS.I_Section_ID = S.I_Section_ID    
        JOIN [dbo].[T_Class] TC ON TC.I_Class_ID = CS.I_Class_ID  -- and TC.I_Brand_ID=@brandID 
       -- LEFT JOIN [dbo].[T_ERP_Class_Stream] ECS ON ECS.I_Class_Stream_ID = CS.I_Stream_ID    
        LEFT JOIN [dbo].[T_Stream] AS TS ON cs.I_Stream_ID = TS.I_Stream_ID --and TS.I_brand_id=@brandID   
    WHERE     
        CS.I_Class_ID IN (select value from @iClassID)    
    GROUP BY     
        S.S_Section_Name,    
        CS.I_Section_ID,    
        S.I_Section_ID,    
        TC.S_Class_Name,    
        TC.I_Class_ID,    
       -- ECS.I_Class_Stream_ID,    
        TS.S_Stream  ,
		TS.I_Stream_ID
    ORDER BY     
        TC.I_Class_ID;    
    
END 

--select * from [T_ERP_Class_Section]

