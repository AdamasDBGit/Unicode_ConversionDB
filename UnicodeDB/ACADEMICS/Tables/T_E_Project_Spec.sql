CREATE TABLE [ACADEMICS].[T_E_Project_Spec] (
    [I_E_Project_Spec_ID]  INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Course_ID]          INT           NULL,
    [I_Term_ID]            INT           NULL,
    [I_Module_ID]          INT           NULL,
    [S_Description]        VARCHAR (500) NULL,
    [I_File_ID]            INT           NULL,
    [Dt_Last_Allocated_On] DATETIME      NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL,
    [I_Status]             INT           NOT NULL,
    [Dt_Valid_To]          DATETIME      NULL,
    CONSTRAINT [PK__E_Project_Spec__11957784] PRIMARY KEY CLUSTERED ([I_E_Project_Spec_ID] ASC)
);

