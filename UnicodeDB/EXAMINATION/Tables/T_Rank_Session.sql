CREATE TABLE [EXAMINATION].[T_Rank_Session] (
    [I_Rank_Session_ID]   INT           IDENTITY (1, 1) NOT NULL,
    [S_Rank_Session_Name] VARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_T_Rank_Session] PRIMARY KEY CLUSTERED ([I_Rank_Session_ID] ASC)
);

