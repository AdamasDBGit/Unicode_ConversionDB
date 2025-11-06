CREATE PROCEDURE [dbo].[AddMethodologyActivity] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 29-09-2023
-- Description:	To Insert Activity 
-- =============================================
-- Add the parameters for the stored procedure here
@MethodologyCategoryID int,
@MethodologyActivityName nnvarchar(max),
@MethodologyActivityDescription nnvarchar(max),
@MeasureUnit nnvarchar(max),
@CreatedBy nnvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

    declare @MA int 
	Set @MA= (select count(*) From T_ERP_Methodology_Activity where S_Methodology_Activity_Name 
	in 
	(SELECT Value FROM VALUE_SPLITING(@MethodologyActivityName,',')) and 
	S_Measure_Unit in (SELECT Value FROM VALUE_SPLITING(@MeasureUnit,','))
	and I_Methodology_Category_ID=@MethodologyCategoryID)

	IF @MA=0
	
	insert into T_ERP_Methodology_Activity 
	(I_Methodology_Category_ID,S_Methodology_Activity_Name,S_Methodology_Activity_Description,
	 S_Measure_Unit,I_CreatedBy,Dt_CreatedAt,I_Status)   
        
		  
	SELECT 
	      @MethodologyCategoryID,a.Value, @MethodologyActivityDescription,
	      b.Value,@CreatedBy,SYSDATETIME(),1 
		  FROM VALUE_SPLITING(@MethodologyActivityName,',') as a 
          cross join 
	      VALUE_SPLITING(@MeasureUnit,',')  as b 
	
	IF @@ROWCOUNT !=0
	 declare @C int,@D int
	 set @C=(Select count(*) from T_ERP_Methodology_Activity group by I_Methodology_Category_ID,	
	          S_Methodology_Activity_Name,S_Measure_Unit Having Count(*)>1);     	
     SET @D=(@C-1)
	 if @C>0
	 delete Top(@D) 
	  from T_ERP_Methodology_Activity where CONCAT 
	 (I_Methodology_Category_ID,	
	          S_Methodology_Activity_Name,S_Measure_Unit) in
	 (Select CONCAT(I_Methodology_Category_ID,	
	          S_Methodology_Activity_Name,S_Measure_Unit) from 
	 T_ERP_Methodology_Activity group by I_Methodology_Category_ID,	
	          S_Methodology_Activity_Name,S_Measure_Unit Having Count(*)>1)

    if @MA>0
	begin
	Select 1 Index_No,'Activity Name and Mesure Unit Is already Exsist for Category' Message;
	end
	else 
	select 1 Index_No,'Activity Add Successfully' Message;

	 


END
