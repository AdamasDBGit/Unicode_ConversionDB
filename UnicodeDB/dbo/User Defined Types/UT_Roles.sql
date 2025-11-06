CREATE TYPE [dbo].[UT_Roles] AS TABLE (
    [I_Role_ID]   INT           NULL,
    [S_Role_Code] VARCHAR (20)  NULL,
    [S_Role_Desc] VARCHAR (100) NULL,
    [Is_Active]   BIT           NULL);

