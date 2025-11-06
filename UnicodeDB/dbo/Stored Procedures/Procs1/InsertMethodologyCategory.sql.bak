CREATE PROCEDURE [dbo].[InsertMethodologyCategory]
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 28-09-2023
-- Description:	Add Methodology Category
-- =============================================
-- Add the parameters for the stored procedure here
@BrandID int,
@MethodologyCategoryName nvarchar(400),
@CreatedBy int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	
	SET NOCOUNT ON;
	declare @MC int 
	Set @MC= (select count(*) From T_ERP_Methodology_Category where S_Methodology_Category_Name in 
	
	(SELECT Value FROM VALUE_SPLITING(@MethodologyCategoryName,',')) and I_Brand_ID=@BrandID)

	IF @MC=0

	insert into T_ERP_Methodology_Category 
	( I_Brand_ID,S_Methodology_Category_Name,I_CreatedBy,Dt_CreatedAt,I_Status)   
        
		SELECT @BrandID,Value,@CreatedBy,SYSDATETIME(),1 
		FROM VALUE_SPLITING(@MethodologyCategoryName,',')  
 
 IF @@ROWCOUNT !=0
	 declare @C int,@D int
	 set @C=(Select count(*) from T_ERP_Methodology_Category group by 
	  I_Brand_ID,S_Methodology_Category_Name Having Count(*)>1);     	
     
	 SET @D=(@C-1)
	 if @C>0
	 delete Top(@D) 
	  from T_ERP_Methodology_Category where CONCAT 
	 (I_Brand_ID,S_Methodology_Category_Name) in
	 (Select distinct CONCAT(I_Brand_ID,S_Methodology_Category_Name) from 
	  T_ERP_Methodology_Category group by I_Brand_ID,S_Methodology_Category_Name 
	  Having Count(*)>1)

 
	 
	

    IF @MC>0
	
	Select 1 Index_No,'Category Name Is already Exist for Brand' Message;

	else 
	  Select 1 Index_No,'Category Add Successfully' Message;


END
