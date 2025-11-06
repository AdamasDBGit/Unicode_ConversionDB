--EXEC USP_ERP_get_Group_ClassbyTenantID_API 118
create  PROCEDURE dbo.USP_ERP_get_Group_ClassbyTenantID_API  
    @BrandID INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT DISTINCT  
        SG.I_School_Group_ID as SchoolGroupID,  
        SG.S_School_Group_Name as SchoolGroup,  
        C.I_Class_ID as ClassID,  
        C.S_Class_Name as classname,  
        sec.I_Stream_ID as StreamID, 
		st.S_Stream as Stream,
        SEC.I_Section_ID as SectionID,
		ts.S_Section_Name as Section
    FROM T_School_Group SG  
    JOIN T_School_Group_Class SGC  
        ON SG.I_School_Group_ID = SGC.I_School_Group_ID  and SG.I_Brand_Id=@BrandID
    JOIN T_Class C  
        ON SGC.I_Class_ID = C.I_Class_ID  and C.I_Brand_ID=@BrandID
    LEFT JOIN T_ERP_Class_Stream CS  
        ON CS.I_School_Group_ID = SG.I_School_Group_ID  
        AND CS.I_Class_ID = C.I_Class_ID  
    LEFT JOIN T_ERP_Class_Section SEC  
        ON SEC.I_School_Group_ID = SG.I_School_Group_ID  
        AND SEC.I_Class_ID = C.I_Class_ID  
        AND SEC.I_Stream_ID = CS.I_Stream_ID 
        LEFT Join T_School_Academic_Session_Master asm on asm.I_School_Session_ID=SEC.I_School_Session_ID
        and asm.I_Current_Session=1
		Left Join T_Stream st on st.I_Stream_ID=sec.I_Stream_ID and st.I_brand_id=@BrandID
		Left Join T_Section ts on ts.I_Section_ID=sec.I_Section_ID
    WHERE  
      
      SG.I_Status = 1  
      AND SGC.I_Status = 1  
      AND C.I_Status = 1;  
END