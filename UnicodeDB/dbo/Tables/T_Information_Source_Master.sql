CREATE TABLE [dbo].[T_Information_Source_Master] (
    [I_Info_Source_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Info_Source_Name] NVARCHAR (MAX) NULL,
    [I_Status]           INT            NULL,
    [S_Crtd_By]          NVARCHAR (MAX) NULL,
    [S_Upd_By]           NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [Dt_Upd_On]          DATETIME       NULL,
    [I_ERP_Status]       BIT            NULL,
    [Is_Show_c]          BIT            NULL,
    [Is_DropdownReq]     BIT            NULL,
    [S_CRM_Input]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Information_So__5319221E] PRIMARY KEY CLUSTERED ([I_Info_Source_ID] ASC)
);

