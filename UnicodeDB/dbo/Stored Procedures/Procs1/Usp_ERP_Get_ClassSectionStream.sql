CREATE   Proc [dbo].[Usp_ERP_Get_ClassSectionStream]  
(  
    @ClassID Int=null,  
    @BrandID int=null,  
    @sessionID int = null,  
    @groupID int = null  
)  
as  
Begin  
  
SELECT   
    c.S_Class_Name AS ClassName,  
    ISNULL(st.S_Stream, 'null') AS StreamName,  
 st.I_Stream_ID StreamID,  
    sec.S_Section_Name AS Section,  
 sec.I_Section_ID SectionID,  
 c.I_Class_ID ClassID
 Into #tempclasssection
FROM   
    T_Class c  
LEFT JOIN   
    T_ERP_Temp_ClassStream cs ON c.I_Class_ID = cs.I_Class_ID AND cs.I_Active = 1  
LEFT JOIN   
    T_Stream st ON cs.I_Stream_ID = st.I_Stream_ID  
CROSS JOIN   
    T_Section sec  
 where c.I_Brand_ID=@BrandID AND c.I_Status=1  
ORDER BY   
    c.I_Class_ID asc;  

	
SELECT 
 tt.*,
    CASE 
        WHEN ecs.I_Class_ID = tt.ClassID 
             AND ecs.I_Section_ID = tt.SectionID 
             AND (ecs.I_Stream_ID = tt.StreamID OR tt.StreamID IS NULL) 
        THEN 1 
        ELSE 0 
    END AS IsSelected
FROM 
    #tempclasssection tt
LEFT JOIN 
    T_ERP_Class_Section ecs 
    ON ecs.I_School_Session_ID = @sessionID
    AND ecs.I_School_Group_ID = @groupID
    AND ecs.I_Class_ID = tt.ClassID
    AND ecs.I_Section_ID = tt.SectionID
    AND (ecs.I_Stream_ID = tt.StreamID OR tt.StreamID IS NULL);

  
     
End