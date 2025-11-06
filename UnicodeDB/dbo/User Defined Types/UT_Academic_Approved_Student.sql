CREATE TYPE [dbo].[UT_Academic_Approved_Student] AS TABLE (
    [I_Student_Detail_ID]            INT           NOT NULL,
    [I_Source_Academic_Session]      INT           NOT NULL,
    [I_Destination_Academic_Session] INT           NOT NULL,
    [I_Source_Class_ID]              INT           NOT NULL,
    [I_Source_Stream_ID]             INT           NULL,
    [I_Source_SectionID]             INT           NULL,
    [I_Destination_Class_ID]         INT           NOT NULL,
    [I_Destination_Stream_ID]        INT           NULL,
    [I_Destination_SectionID]        INT           NULL,
    [I_Destination_RollNo]           INT           NULL,
    [I_Promotion_Status]             INT           NOT NULL,
    [Remarks]                        VARCHAR (200) NULL);

