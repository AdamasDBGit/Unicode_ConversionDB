CREATE TABLE [PSCERTIFICATE].[T_Courier_Master] (
    [I_Courier_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [S_Courier_Code] VARCHAR (20) NULL,
    [S_Courier_Name] VARCHAR (50) NULL,
    [I_State]        INT          NULL,
    [S_Crtd_By]      VARCHAR (20) NULL,
    [S_Upd_By]       VARCHAR (20) NULL,
    [Dt_Crtd_On]     DATETIME     NULL,
    [Dt_Upd_On]      DATETIME     NULL
);

