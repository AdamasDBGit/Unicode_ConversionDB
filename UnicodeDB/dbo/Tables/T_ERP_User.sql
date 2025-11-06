CREATE TABLE [dbo].[T_ERP_User] (
    [I_User_ID]                INT              IDENTITY (1, 1) NOT NULL,
    [S_Username]               NVARCHAR (50)    NOT NULL,
    [S_Password]               NVARCHAR (50)    NOT NULL,
    [S_Email]                  NVARCHAR (50)    NOT NULL,
    [S_First_Name]             NVARCHAR (30)    NOT NULL,
    [S_Middle_Name]            NVARCHAR (30)    NULL,
    [S_Last_Name]              NVARCHAR (30)    NULL,
    [S_Mobile]                 NVARCHAR (20)    NOT NULL,
    [I_Created_By]             INT              NULL,
    [Dt_CreatedAt]             DATETIME         NULL,
    [Dt_Last_Login]            DATETIME         NULL,
    [I_Status]                 INT              NOT NULL,
    [I_User_Type]              INT              NULL,
    [S_Token]                  NVARCHAR (MAX)   NULL,
    [S_FireBase_Token]         NVARCHAR (MAX)   NULL,
    [IsAllAllowedEligible]     BIT              NULL,
    [Is_Teaching_Staff]        BIT              NULL,
    [Is_Non_Teaching_Staff]    BIT              NULL,
    [Is_Active_Ignore_Allowed] BIT              NULL,
    [isPasswordChanged]        BIT              CONSTRAINT [DF__T_ERP_Use__isPas__56D5A18A] DEFAULT ((0)) NULL,
    [unUserId]                 UNIQUEIDENTIFIER CONSTRAINT [DF__T_ERP_Use__unUse__7A1EDDC7] DEFAULT (newid()) NULL,
    [Old_UserMigID]            INT              NULL,
    [stUserCode]               NVARCHAR (10)    NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0-Inactive, 1-Active, 2- Block', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_ERP_User', @level2type = N'COLUMN', @level2name = N'I_Status';

