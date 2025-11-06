CREATE PROCEDURE [dbo].[UpdateMethodologyCategory] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 28-09-2023
-- Description:	To Alter Methodology Category
-- =============================================
-- Add the parameters for the stored procedure here
@MethodologyCategoryID int,
@BrandID int=null,
@MethodologyCategoryName nvarchar(400)=null,
@Status int =null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	If @MethodologyCategoryID is not null
	
	If @BrandID is null
	   set @BrandID=
	   (select I_Brand_ID 
	   from 
	   T_ERP_Methodology_Category 
	   where 
	   I_Methodology_Category_ID=@MethodologyCategoryID
	   )
    
    if @MethodologyCategoryName is null
	   set @MethodologyCategoryName=
	   (select S_Methodology_Category_Name 
	    from 
	    T_ERP_Methodology_Category 
	    where 
	    I_Methodology_Category_ID=@MethodologyCategoryID
	   )
   
   if @Status is null
   
     set @Status=
     (select I_Status 
     from 
	 T_ERP_Methodology_Category 
	 where 
	 I_Methodology_Category_ID=@MethodologyCategoryID
	 )
   
   Update 
   T_ERP_Methodology_Category 
   SET 
   I_Brand_Id=@BrandID,
   S_Methodology_Category_Name=@MethodologyCategoryName,
   I_Status=@Status
   where
   I_Methodology_Category_ID=@MethodologyCategoryID

   if @@ROWCOUNT!=0
          select 1 StatusFlag,'Methodology Category Updated Successfully' Message    
   else 
   select 1 StatusFlag,'Methodology Category not Updated Due Incorrect Category' Message    

END
