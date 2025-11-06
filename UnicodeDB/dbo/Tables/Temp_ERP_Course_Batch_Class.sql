CREATE TABLE [dbo].[Temp_ERP_Course_Batch_Class] (
    [I_Course_ID]         INT           NOT NULL,
    [I_Brand_ID]          INT           NULL,
    [I_Class_ID]          INT           NOT NULL,
    [CurrentDate]         DATETIME      NOT NULL,
    [I_School_Session]    INT           NOT NULL,
    [I_Stream_ID]         INT           NULL,
    [S_School_Group_Code] NVARCHAR (20) NULL,
    [I_School_Group_ID]   INT           NOT NULL,
    [I_Batch_ID]          INT           NULL
);

