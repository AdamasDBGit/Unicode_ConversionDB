CREATE PROCEDURE [dbo].[Role_Master_Parameters] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 14-09-2023
-- Description:	To get the parameters for Role Master
-- =============================================
-- Add the parameters for the stored procedure here
@Role_ID int=null,
@Role_Name nvarchar(255)=null,
@Role_Desc nvarchar(255)=null,
@CreatedBy int=null,
@Createdon date=null,
@Status int=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
       SET NOCOUNT ON;
       
	   select 
	   I_Role_ID as RoleID,
	   S_Role_Name as RoleName,
	   S_Description as Description,
	   Dt_CreatedBy as CrtdBy,
	   Dt_CreatedAt as CrtdOn,
	   I_Status Status
	   --(case when I_Status=1 then 'Active' Else 'Inactive' end ) As Status 

	   
	   
	   from T_ERP_Role

	   where 

	   -- =============================================  
            ---Dynamic Parameter Selection  
       -- =============================================  
       (I_Role_ID like @Role_ID or @Role_ID is null )
	   and
	   (S_Role_Name like '%'+@Role_Name+'%' or @Role_Name is null)
	   and 
	   (S_Description like'%'+@Role_Desc+'%' or @Role_Desc is null)
	   and
	   (Dt_CreatedBy like  @CreatedBy or @CreatedBy is null)
	   and 
	   (convert (date,Dt_CreatedAt) =  @Createdon or @Createdon is null)
	   and 
	   (I_Status like @Status Or @Status is null )

END
