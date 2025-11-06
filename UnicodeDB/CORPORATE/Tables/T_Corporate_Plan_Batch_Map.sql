CREATE TABLE [CORPORATE].[T_Corporate_Plan_Batch_Map] (
    [I_Corporate_Plan_ID] INT NOT NULL,
    [I_Batch_ID]          INT NOT NULL,
    CONSTRAINT [PK_T_CorporatePlan_Batch_Map] PRIMARY KEY CLUSTERED ([I_Corporate_Plan_ID] ASC, [I_Batch_ID] ASC)
);

