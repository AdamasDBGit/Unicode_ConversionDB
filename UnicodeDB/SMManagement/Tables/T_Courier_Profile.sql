CREATE TABLE [SMManagement].[T_Courier_Profile] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [Vendor]    VARCHAR (MAX) NULL,
    [UserID]    VARCHAR (20)  NULL,
    [SPassword] VARCHAR (50)  NULL,
    [StatusID]  INT           NULL
);

