CREATE TABLE [dbo].[T_ERP_Exam_Category_Mapping] (
    [Exam_Configuration_HeaderID] INT              IDENTITY (1, 1) NOT NULL,
    [S_Exam_Config_Name]          NVARCHAR (MAX)   NULL,
    [I_Exam_Type_Master_ID]       INT              NULL,
    [I_EXAM_CATEGORY_ID]          INT              NULL,
    [I_Child_EXAM_CATEGORY_ID]    INT              NULL,
    [N_Fullmarks]                 DECIMAL (18, 2)  NULL,
    [N_weightage]                 DECIMAL (18, 2)  NULL,
    [Is_term]                     BIT              NULL,
    [I_brand_ID]                  INT              NULL,
    [Is_Active]                   BIT              NULL,
    [I_created_by]                INT              NULL,
    [dt_created_dt]               DATETIME         NULL,
    [un_Exam_Category_MappingID]  UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_T_ERP_Exam_Configuration_Header] PRIMARY KEY CLUSTERED ([Exam_Configuration_HeaderID] ASC)
);

