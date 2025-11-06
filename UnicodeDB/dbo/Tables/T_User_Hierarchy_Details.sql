CREATE TABLE [dbo].[T_User_Hierarchy_Details] (
    [I_User_Hierarchy_Detail_ID] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_User_ID]                  INT      NOT NULL,
    [I_Hierarchy_Master_ID]      INT      NOT NULL,
    [I_Hierarchy_Detail_ID]      INT      NOT NULL,
    [Dt_Valid_From]              DATETIME NULL,
    [Dt_Valid_To]                DATETIME NULL,
    [I_Status]                   INT      NULL,
    CONSTRAINT [PK__T_User_Hierarchy__68BE4A7A] PRIMARY KEY CLUSTERED ([I_User_Hierarchy_Detail_ID] ASC)
);

