CREATE PROCEDURE Usp_Erp_GetClassesBySchoolGroupId_Reports      
    @SchoolGroupId INT =NULL     
AS      
BEGIN   
If @SchoolGroupId is null
Begin
Select Null as I_Class_ID, 'ALL' as S_Class_Name
End
Else
begin
    SELECT T_Class.I_Class_ID, T_Class.S_Class_Name      
    FROM T_School_Group_Class      
    JOIN T_Class ON T_School_Group_Class.I_Class_ID = T_Class.I_Class_ID      
    WHERE T_School_Group_Class.I_School_Group_ID = @SchoolGroupId      
      AND T_Class.I_Status = 1   

   Order by I_Class_ID  
   End
END;