CREATE TABLE [dbo].[T_ERP_Permission_Role_Map_Sync] (
    [Permission_Role_MapID] INT           NOT NULL,
    [I_Role_ID]             INT           NULL,
    [I_Permission_ID]       INT           NULL,
    [I_Status]              INT           NULL,
    [I_CreatedBy]           INT           NULL,
    [Dt_CreatedDt]          SMALLDATETIME NULL,
    [Dt_Update_Dt]          SMALLDATETIME NULL,
    [I_Modified_By]         INT           NULL
);

