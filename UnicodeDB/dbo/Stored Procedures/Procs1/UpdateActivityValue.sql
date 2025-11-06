CREATE PROCEDURE [dbo].[UpdateActivityValue]
-- =============================================
-- Author:		Tridip Chatterjee
-- Create date: 30-09-2023
-- Description:	Update Activity value
-- =============================================
-- Add the parameters for the stored procedure here
@MethodologyActivityValueID int,
@MethodologyActivityID int =null,
@ActivityValue NVARCHAR(max)=null 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	declare @C int 
	if @MethodologyActivityValueID is not null
	
	
	if @MethodologyActivityID is null
	set @MethodologyActivityID=(select I_Methodology_Activity_ID 
	                            from 
								T_ERP_Methodology_Activity_Value 
								where
	                            I_Methodology_Activity_Value_ID=@MethodologyActivityValueID)
	if @MethodologyActivityID is not null
	set @C=(select count(*) from T_ERP_Methodology_Activity where 
	I_Methodology_Activity_ID=@MethodologyActivityID)
	


	if @ActivityValue is null
	set @ActivityValue=(select S_Activity_Value
	                            from 
								T_ERP_Methodology_Activity_Value 
								where
	                            I_Methodology_Activity_Value_ID=@MethodologyActivityValueID)
 
  If @C>0

  update 
  T_ERP_Methodology_Activity_Value 
  set I_Methodology_Activity_ID =@MethodologyActivityID,S_Activity_Value=@ActivityValue
  where I_Methodology_Activity_Value_ID=@MethodologyActivityValueID

  if @@ROWCOUNT!=0
     select 1 StatusFlag,'Activity Value Updated Successfully' Message    
  
  else 
   select 1 StatusFlag,'Activity value not Updated Due Incorrect Activity' Message    

  


END

