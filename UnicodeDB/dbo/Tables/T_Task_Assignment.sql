CREATE TABLE [dbo].[T_Task_Assignment] (
    [I_Task_Assignment_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Task_ID]            INT            NULL,
    [I_To_User_ID]         INT            NULL,
    [S_From_User]          NVARCHAR (MAX) NULL
);

