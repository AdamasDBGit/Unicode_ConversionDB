CREATE TABLE [ECOMMERCE].[T_RICE_Student_Extended_Details] (
    [SEDID]               INT           IDENTITY (1, 1) NOT NULL,
    [S_Student_ID]        VARCHAR (MAX) NULL,
    [PlanId]              INT           NULL,
    [Customer_ID]         VARCHAR (MAX) NULL,
    [I_Course_ID]         INT           NULL,
    [I_Course_Name]       VARCHAR (MAX) NULL,
    [I_Batch_ID]          INT           NULL,
    [S_Batch_Code]        VARCHAR (MAX) NULL,
    [S_Batch_Name]        VARCHAR (MAX) NULL,
    [Dt_BatchStartDate]   DATETIME      NULL,
    [Dt_Valid_From]       DATETIME      NULL,
    [Course_Expected_End] DATETIME      NULL,
    [Course_Actual_End]   DATETIME      NULL
);

