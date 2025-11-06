CREATE PROCEDURE [dbo].[AddMethodologyActivityValue] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 30-09-2023
-- Description:	To Add Activity Value
-- =============================================
-- Add the parameters for the stored procedure here

@MethodologyActivityID int,
@ActivityValue nnvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	declare @AV int 
	Set @AV= (select count(*) From T_ERP_Methodology_Activity_Value where S_Activity_Value in 
	
	(SELECT Value FROM VALUE_SPLITING(@ActivityValue,',')) and I_Methodology_Activity_ID=
	 @MethodologyActivityID)

	IF @AV=0

	insert into T_ERP_Methodology_Activity_Value 
	 (I_Methodology_Activity_ID,S_Activity_Value)   
        
		SELECT @MethodologyActivityID,Value
		FROM VALUE_SPLITING(@ActivityValue,',')  
     
	IF @@ROWCOUNT !=0
	 declare @C int,@D int
	 set @C=(Select count(*) from T_ERP_Methodology_Activity_Value group by 
	  I_Methodology_Activity_ID,S_Activity_Value Having Count(*)>1);     	
     SET @D=(@C-1)
	 if @C>0
	 delete Top(@D) 
	  from T_ERP_Methodology_Activity_Value where CONCAT 
	 (I_Methodology_Activity_ID,S_Activity_Value) in
	 (Select CONCAT(I_Methodology_Activity_ID,S_Activity_Value) from 
	  T_ERP_Methodology_Activity_Value group by I_Methodology_Activity_ID,S_Activity_Value 
	  Having Count(*)>1)

 
	

    IF @AV>0
	
	Select 1 Index_No,'Activity Value Is already Exist ' Message;

	else 
	  Select 1 Index_No,'Activity Value Added Successfully' Message;


END
