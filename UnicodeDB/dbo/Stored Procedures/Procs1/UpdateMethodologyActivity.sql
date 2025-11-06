CREATE PROCEDURE [dbo].[UpdateMethodologyActivity] 
-- =============================================
     -- Author: Tridip Chatterjee
-- Create date: 29-09-2023
-- Description:	To Update Activities
-- =============================================
-- Add the parameters for the stored procedure here
@MethodologyActivityID int ,
@Methodology_CategoryID int = null,
@MethodologyActivityName nnvarchar(max)=null,
@MethodologyActivityDescription nnvarchar(max)=null,
@MeasureUnit nnvarchar(max)=null,
@Status int =null
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
   SET NOCOUNT ON;
   If @MethodologyActivityID is not null
   
   if @Methodology_CategoryID is null
      set @Methodology_CategoryID=
	  (select 
	   I_Methodology_Category_ID
       from 
	   T_ERP_Methodology_Activity 
	   where 
	   I_Methodology_Activity_ID=@MethodologyActivityID
	   )
   
   if @MethodologyActivityName is null
      set @MethodologyActivityName=
	  (select 
	   S_Methodology_Activity_Name

       from 
	   T_ERP_Methodology_Activity 
	   where 
	   I_Methodology_Activity_ID=@MethodologyActivityID
	   )
   
   if @MethodologyActivityDescription is null
      set @MethodologyActivityDescription=
	  (select 
	   S_Methodology_Activity_Description
       from 
	   T_ERP_Methodology_Activity 
	   where 
	   I_Methodology_Activity_ID=@MethodologyActivityID
	   )
   
   if @MeasureUnit is null
      set @MeasureUnit=
	  (select 
	   S_Measure_Unit
	   from 
	   T_ERP_Methodology_Activity 
	   where 
	   I_Methodology_Activity_ID=@MethodologyActivityID
	   )
   
   if @Status is null
      set @Status=
	  (select 
	   I_Status
       from 
	   T_ERP_Methodology_Activity 
	   where 
	   I_Methodology_Activity_ID=@MethodologyActivityID
	   )
   
   Update 
   T_ERP_Methodology_Activity 
	   
   SET 
   I_Methodology_Category_ID=@Methodology_CategoryID,
   S_Methodology_Activity_Name=@MethodologyActivityName,
   S_Methodology_Activity_Description=@MethodologyActivityDescription,
   S_Measure_Unit=@MeasureUnit,
   I_Status=@Status
   where
   I_Methodology_Activity_ID=@MethodologyActivityID

   if @@ROWCOUNT!=0
          select 1 StatusFlag,'Methodology Activity Updated Successfully' Message    
   else 
   select 1 StatusFlag,'Methodology Activity not Updated Due Incorrect Category' Message    




END
