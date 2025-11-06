CREATE TYPE [dbo].[UT_Grade_Pattern_Details] AS TABLE (
    [I_Exam_Grade_Master_Header_ID]  INT           NULL,
    [I_Exam_Grade_Master_Details_ID] INT           NULL,
    [Grade_Type]                     VARCHAR (10)  NULL,
    [I_Lower_Limit]                  INT           NULL,
    [I_Upper_Limit]                  INT           NULL,
    [S_Remarks]                      VARCHAR (100) NULL,
    [Is_Active]                      BIT           NULL);

