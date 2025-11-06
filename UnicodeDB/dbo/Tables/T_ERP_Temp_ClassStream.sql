CREATE TABLE [dbo].[T_ERP_Temp_ClassStream] (
    [I_Temp_Class_Stream_ID] INT IDENTITY (1, 1) NOT NULL,
    [I_Class_ID]             INT NOT NULL,
    [I_Stream_ID]            INT NOT NULL,
    [I_Brand_ID]             INT NOT NULL,
    [I_Active]               INT NOT NULL,
    CONSTRAINT [PK__T_ERP_Te__ADD69640611EA27D] PRIMARY KEY CLUSTERED ([I_Temp_Class_Stream_ID] ASC)
);

