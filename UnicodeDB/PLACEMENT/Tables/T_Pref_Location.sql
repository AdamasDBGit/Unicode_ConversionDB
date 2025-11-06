CREATE TABLE [PLACEMENT].[T_Pref_Location] (
    [I_Location_ID]       INT          NOT NULL,
    [S_Location_Type]     VARCHAR (10) NOT NULL,
    [I_Student_Detail_ID] INT          NOT NULL,
    [I_Status]            INT          NOT NULL,
    CONSTRAINT [PK__T_Pref_Location__4C8C2020] PRIMARY KEY CLUSTERED ([I_Location_ID] ASC, [S_Location_Type] ASC, [I_Student_Detail_ID] ASC)
);

