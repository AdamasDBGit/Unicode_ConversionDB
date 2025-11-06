CREATE TABLE [dbo].[T_ERP_Exam_Students_Result_Details] (
    [I_Exam_Students_Result_Details_ID] BIGINT         NULL,
    [I_Exam_Result_Header_ID]           INT            NULL,
    [I_Student_Detail_ID]               BIGINT         NULL,
    [I_Roll_No]                         INT            NULL,
    [I_Student_obtain_Marks]            INT            NULL,
    [S_Remarks]                         NVARCHAR (MAX) NULL,
    [Is_Present]                        BIT            NULL,
    [S_Conduct]                         NVARCHAR (MAX) NULL,
    [Is_Active]                         BIT            CONSTRAINT [DF__T_ERP_Exa__Is_Ac__5CD893A3] DEFAULT ((1)) NULL,
    [Dt_Created_At]                     DATETIME       CONSTRAINT [DF__T_ERP_Exa__Dt_Cr__5DCCB7DC] DEFAULT (getdate()) NULL,
    [Dt_Modified_At]                    DATETIME       NULL,
    [I_Created_By]                      INT            NULL,
    [I_Modified_By]                     INT            NULL
);

