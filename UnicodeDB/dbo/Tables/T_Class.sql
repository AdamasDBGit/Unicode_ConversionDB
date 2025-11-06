CREATE TABLE [dbo].[T_Class] (
    [I_Class_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Class_Code] NVARCHAR (20)  NULL,
    [S_Class_Name] NVARCHAR (255) NULL,
    [I_Status]     INT            NOT NULL,
    [I_Brand_ID]   INT            NULL,
    [I_Sequence]   INT            NULL,
    [ClassId]      INT            NULL
);

