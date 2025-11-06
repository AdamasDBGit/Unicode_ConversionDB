CREATE TABLE [dbo].[T_ERP_Permission_Role_Map] (
    [Permission_Role_MapID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Role_ID]             INT      NULL,
    [I_Permission_ID]       INT      NULL,
    [I_Status]              INT      NULL,
    [I_CreatedBy]           INT      NULL,
    [Dt_CreatedDt]          DATETIME NULL,
    [Dt_Update_Dt]          DATETIME NULL,
    [I_Modified_By]         INT      NULL
);

