CREATE PROCEDURE [Academic].[GetClassID] 
	-- Add the parameters for the stored procedure here
	@SchoolGroupID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TSGC.I_School_Group_ID as SchoolGroupID,TSGC.I_Class_ID as ClassID,TC.S_Class_Name as ClassName FROM [dbo].[T_School_Group_Class] as TSGC
	join [dbo].[T_Class] as TC on TSGC.I_Class_ID= TC.I_Class_ID
	where I_School_Group_ID=@SchoolGroupID and TC.I_Status=1
END
