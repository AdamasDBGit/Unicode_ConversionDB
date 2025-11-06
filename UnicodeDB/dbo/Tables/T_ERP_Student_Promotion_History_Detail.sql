CREATE TABLE [dbo].[T_ERP_Student_Promotion_History_Detail] (
    [I_Student_Promotion_History_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Promotion_History_Header_ID] INT            NULL,
    [I_Source_Academic_Session]             INT            NULL,
    [I_Destination_Academic_Session]        INT            NULL,
    [I_Student_DetailID]                    INT            NULL,
    [I_Promotion_Status_ID]                 INT            NULL,
    [S_Remarks]                             NVARCHAR (MAX) NULL,
    [S_Action_By]                           INT            NULL,
    [S_Action_On]                           DATETIME       NULL
);

