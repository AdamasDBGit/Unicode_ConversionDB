CREATE TABLE [DOCUMENT].[T_User_Documents] (
    [I_Document_ID]         INT           IDENTITY (1, 1) NOT NULL,
    [I_Category_ID]         INT           NOT NULL,
    [I_Brand_ID]            INT           NOT NULL,
    [I_Hierarchy_Detail_ID] INT           NULL,
    [S_File_Name]           VARCHAR (250) NOT NULL,
    [S_File_Path]           VARCHAR (250) NOT NULL,
    [I_File_Size]           BIGINT        NOT NULL,
    [Dt_Expiry_Date]        DATETIME      NOT NULL,
    [I_Course_ID]           INT           NULL,
    [I_Term_ID]             INT           NULL,
    [I_Module_ID]           INT           NULL,
    [I_Batch_ID]            INT           NULL,
    [S_CreatedBy]           VARCHAR (50)  NULL,
    [Dt_CreatedOn]          DATETIME      NULL,
    [S_UpdatedBy]           VARCHAR (50)  NULL,
    [Dt_UpadtedOn]          DATETIME      NULL,
    [I_Status]              INT           NULL,
    CONSTRAINT [PK_T_User_Documents] PRIMARY KEY CLUSTERED ([I_Document_ID] ASC)
);

