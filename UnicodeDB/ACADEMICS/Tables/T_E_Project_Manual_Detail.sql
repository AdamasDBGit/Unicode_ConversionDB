CREATE TABLE [ACADEMICS].[T_E_Project_Manual_Detail] (
    [I_E_Project_Manual_Detail_ID] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_E_Proj_Manual_ID]           INT NULL,
    [I_From_Number]                INT NULL,
    [I_To_Number]                  INT NULL,
    CONSTRAINT [PK_T_E_Project_Manual_Detail] PRIMARY KEY CLUSTERED ([I_E_Project_Manual_Detail_ID] ASC)
);

