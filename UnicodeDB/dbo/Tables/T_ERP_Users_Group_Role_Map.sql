CREATE TABLE [dbo].[T_ERP_Users_Group_Role_Map] (
    [I_User_Group_Role_Map_ID] BIGINT   IDENTITY (1, 1) NOT NULL,
    [I_User_ID]                BIGINT   NOT NULL,
    [I_UserGroup_Role_Map_ID]  BIGINT   NULL,
    [Is_Active]                BIT      CONSTRAINT [DF__T_ERP_Use__Is_Ac__7410FEB6] DEFAULT ((1)) NULL,
    [Dt_Create_Dt]             DATETIME CONSTRAINT [DF__T_ERP_Use__Dt_Cr__750522EF] DEFAULT (getdate()) NULL,
    [Dt_Modified_dt]           DATETIME NULL,
    [I_Created_by]             INT      NULL,
    [I_Modified_By]            INT      NULL
);

