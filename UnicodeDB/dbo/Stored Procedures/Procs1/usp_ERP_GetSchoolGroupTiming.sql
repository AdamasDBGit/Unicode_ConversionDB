-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <26th sept 2023>
-- Description:	<to get the timing>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSchoolGroupTiming] 
	-- Add the parameters for the stored procedure here
	@iGroupID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
select SGCT.I_School_Group_Class_Timing_ID as GroupClassTimingID,
SGCT.I_School_Group_ID as SchoolGroupID,
SG.S_School_Group_Name as SchoolGroupName,
SGCT.I_Class_ID as ClassID,
TC.S_Class_Name as ClassName,
SGCT.Start_Time as StartTime,
SGCT.End_Time as EndTime 
from [T_School_Group_Class_Timing] as SGCT 
left join [dbo].[T_School_Group] as SG on SG.I_School_Group_ID=SGCT.I_School_Group_ID
left join  [dbo].[T_Class] as TC on TC.I_Class_ID=SGCT.I_Class_ID 
where SGCT.I_School_Group_ID = @iGroupID
END
