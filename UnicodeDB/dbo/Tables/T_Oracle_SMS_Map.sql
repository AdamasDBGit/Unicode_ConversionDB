CREATE TABLE [dbo].[T_Oracle_SMS_Map] (
    [ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [I_Ora_Acc_Code]      INT            NULL,
    [S_Ora_Acc_Desc]      NVARCHAR (MAX) NULL,
    [S_SMS_Fee_Component] NVARCHAR (MAX) NULL
);

