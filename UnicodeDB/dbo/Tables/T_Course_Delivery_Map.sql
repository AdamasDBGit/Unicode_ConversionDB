CREATE TABLE [dbo].[T_Course_Delivery_Map] (
    [I_Course_Delivery_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_Delivery_Pattern_ID] INT            NULL,
    [I_Course_ID]           INT            NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [N_Course_Duration]     NUMERIC (18)   NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [I_Status]              INT            NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    CONSTRAINT [PK__T_Course_Deliver__2D7D891B] PRIMARY KEY CLUSTERED ([I_Course_Delivery_ID] ASC)
);

