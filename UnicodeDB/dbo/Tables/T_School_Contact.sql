CREATE TABLE [dbo].[T_School_Contact] (
    [I_School_Contact_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]          INT            NOT NULL,
    [S_Email]             NVARCHAR (100) NULL,
    [S_Mobile]            NVARCHAR (30)  NOT NULL,
    [S_Description]       NVARCHAR (255) NULL,
    [S_Logo]              NVARCHAR (MAX) NULL,
    [I_Status]            INT            NOT NULL,
    [s_Websites]          NVARCHAR (MAX) NULL
);

