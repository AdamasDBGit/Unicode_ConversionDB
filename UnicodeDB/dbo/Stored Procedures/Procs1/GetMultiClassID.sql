CREATE PROCEDURE [dbo].[GetMultiClassID] 
	@SchoolGroupID  dbo.IntArray READONLY
AS
BEGIN
	SET NOCOUNT ON;
	SELECT DISTINCT
		0 as SchoolGroupID,
		TSGC.I_Class_ID as ClassID,
		TC.S_Class_Name as ClassName 
	FROM [dbo].[T_School_Group_Class] as TSGC
	JOIN [dbo].[T_Class] as TC on TSGC.I_Class_ID= TC.I_Class_ID
	where 
		I_School_Group_ID IN (SELECT Value FROM @SchoolGroupID)
		AND TC.I_Status=1
	GROUP BY TSGC.I_Class_ID,TC.S_Class_Name,TSGC.I_School_Group_ID
	ORDER BY TSGC.I_Class_ID ASC
END