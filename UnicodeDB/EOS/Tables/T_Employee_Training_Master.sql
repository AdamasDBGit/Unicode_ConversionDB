CREATE TABLE [EOS].[T_Employee_Training_Master] (
    [I_Training_ID]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Training_Desc]      VARCHAR (500)  NULL,
    [S_Document_Name]      VARCHAR (1000) NULL,
    [S_Feedback_Form_Name] VARCHAR (1000) NULL,
    [I_Status]             INT            NULL,
    CONSTRAINT [PK__T_Employee_Train__6069C6F2] PRIMARY KEY CLUSTERED ([I_Training_ID] ASC)
);

