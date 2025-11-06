CREATE TABLE [dbo].[T_Parent_Master_Bak_07042025_NoUpdate] (
    [I_Parent_Master_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [I_Parent_Parent_Master_ID] INT            NULL,
    [I_Relation_ID]             INT            NULL,
    [I_Brand_ID]                INT            NULL,
    [S_Mobile_No]               NVARCHAR (50)  NULL,
    [S_First_Name]              NVARCHAR (100) NULL,
    [S_Middile_Name]            NVARCHAR (100) NULL,
    [S_Last_Name]               NVARCHAR (100) NULL,
    [S_Guardian_Email]          NVARCHAR (100) NULL,
    [I_Guardian_Occupation_ID]  INT            NULL,
    [S_Profile_Picture]         NVARCHAR (200) NULL,
    [S_Address]                 NVARCHAR (MAX) NULL,
    [S_Pin_Code]                NVARCHAR (50)  NULL,
    [S_Token]                   NVARCHAR (MAX) NULL,
    [S_Firebase_Token]          NVARCHAR (MAX) NULL,
    [I_IsPrimary]               INT            NULL,
    [I_IsBusTravel]             INT            NULL,
    [S_CreatedBy]               NVARCHAR (50)  NULL,
    [Dt_CreatedAt]              DATETIME       NULL,
    [Dt_UpdatedAt]              DATETIME       NULL,
    [I_Status]                  INT            NULL
);

