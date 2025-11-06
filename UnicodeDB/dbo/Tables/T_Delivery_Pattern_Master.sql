CREATE TABLE [dbo].[T_Delivery_Pattern_Master] (
    [I_Delivery_Pattern_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Pattern_Name]        NVARCHAR (MAX) NULL,
    [I_Status]              INT            NULL,
    [I_No_Of_Session]       INT            NULL,
    [N_Session_Day_Gap]     NUMERIC (8, 2) NULL,
    [S_DaysOfWeek]          NVARCHAR (MAX) NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    CONSTRAINT [PK__T_Delivery_Patte__1CF15040] PRIMARY KEY CLUSTERED ([I_Delivery_Pattern_ID] ASC)
);

