CREATE TABLE [dbo].[T_Center_Functionality_Status] (
    [I_Center_Functionality_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_ID]               INT            NULL,
    [S_Status_Code]             NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_T_Center_Functionality_Status] PRIMARY KEY CLUSTERED ([I_Center_Functionality_ID] ASC)
);

