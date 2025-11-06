CREATE PROCEDURE [Academic].[GetSchoolGroup]    
 -- Add the parameters for the stored procedure here    
 @brandid int    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
    -- Insert statements for procedure here    
 select TSG.I_School_Group_ID as SchoolGroupID, TSG.I_Brand_Id as BrandId, TSG.S_School_Group_Name as SchoolGroupName   
 from [dbo].[T_School_Group]as TSG where I_Brand_Id=@brandid    
 and I_Status=1  
END
