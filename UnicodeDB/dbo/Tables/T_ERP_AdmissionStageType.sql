CREATE TABLE [dbo].[T_ERP_AdmissionStageType] (
    [I_AdmStgTypeID]  INT            IDENTITY (1, 1) NOT NULL,
    [S_AdmStage_Desc] NVARCHAR (MAX) NULL,
    [Dtt_Created_At]  DATETIME       CONSTRAINT [DF__T_ERP_Adm__Dtt_C__53EE47E7] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At] DATETIME       NULL,
    [I_Created_By]    INT            NULL,
    [I_Modified_By]   INT            NULL,
    [Is_Active]       BIT            CONSTRAINT [DF__T_ERP_Adm__Is_Ac__54E26C20] DEFAULT ((1)) NULL
);

