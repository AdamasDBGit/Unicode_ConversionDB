CREATE TABLE [dbo].[T_ERP_Faculty_Subject] (
    [I_Faculty_Subject_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Faculty_Master_ID]  INT      NOT NULL,
    [I_Subject_ID]         INT      NOT NULL,
    [I_Is_Primary]         INT      NOT NULL,
    [I_Status]             INT      NOT NULL,
    [I_CreatedBy]          INT      NOT NULL,
    [Dt_CreatedAt]         DATETIME NOT NULL
);

