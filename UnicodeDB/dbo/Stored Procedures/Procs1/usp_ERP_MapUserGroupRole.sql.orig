-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-April-18>
-- Description:	<Map Group-Role>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_MapUserGroupRole]
	-- Add the parameters for the stored procedure here
	@sRoleCode varchar(max),
	@sUserGroups varchar(max),
	@iBrand INT,
	@icreatedBy INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 -- Create a temporary table to hold the split roles
    CREATE TABLE #SplitGroups (UserGroupName NVARCHAR(200))
	DECLARE @UserGroupName NVARCHAR(200)
	DECLARE @UserGroupID INT

    -- Split the input string and insert into the temporary table
    INSERT INTO #SplitGroups (UserGroupName)
    SELECT CAST(Val as NVARCHAR(200)) as UserGroupName  FROM dbo.fnString2Rows(@sUserGroups, ',')

	 -- Loop through each role in the temporary table
    DECLARE SplitCursor CURSOR FOR
    SELECT UserGroupName FROM #SplitGroups

	OPEN SplitCursor
FETCH NEXT FROM SplitCursor INTO @UserGroupName
	WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check if the role exists in the Roles table
        IF NOT EXISTS (SELECT 1 FROM T_ERP_User_Group_Master WHERE S_User_GroupName = @UserGroupName)
        BEGIN
           INSERT INTO T_ERP_User_Group_Master (S_User_GroupName) VALUES (@UserGroupName)
		   SET @UserGroupID=SCOPE_IDENTITY()
        END
        ELSE
        BEGIN

			SELECT @UserGroupID=I_User_Group_Master_ID FROM T_ERP_User_Group_Master WHERE S_User_GroupName = @UserGroupName
            
        END

		DECLARE @iRoleId INT

	select @iRoleId= I_Role_ID from T_ERP_Role_Master where S_Role_Code=@sRoleCode and I_Brand_ID=@iBrand

	print @iRoleId
		IF EXISTS (select * from T_ERP_Role_Master where S_Role_Code=@sRoleCode and I_Brand_ID=@iBrand)
		AND NOT EXISTS(select * from T_ERP_UserGroup_Role_Brand_Map where I_Role_ID=@iRoleId and I_Brand_ID=@iBrand and I_User_Group_Master_ID=@UserGroupID)
			BEGIN

				
				print @UserGroupID
				insert into T_ERP_UserGroup_Role_Brand_Map
				(
				I_User_Group_Master_ID,
				I_Role_ID,
				I_Brand_ID,
				Is_Active,
				I_Created_By,
				Dt_created_Dt
				)
				values
				(
				@UserGroupID,
				@iRoleId,
				@iBrand,
				1,
				@icreatedBy,
				GETDATE()
				)

			END

        FETCH NEXT FROM SplitCursor INTO @UserGroupName
    END


	 CLOSE SplitCursor
    DEALLOCATE SplitCursor

    -- Drop the temporary table
    DROP TABLE #SplitGroups



END
