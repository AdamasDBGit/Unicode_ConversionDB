CREATE TABLE [dbo].[T_ERP_User_Two_Factor_Authentication] (
    [I_User_Two_Factor_Authentication_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_User_ID]                           INT           NOT NULL,
    [S_Method_Type]                       NVARCHAR (50) NOT NULL,
    [S_Verification_Code]                 NVARCHAR (50) NOT NULL,
    [Dt_Expiry_Date]                      DATETIME      NOT NULL,
    [I_Created_By]                        INT           NULL,
    [Dt_CreatedAt]                        DATETIME      NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'How the second authentication step is carried out, e.g., SMS, Authenticator App.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_ERP_User_Two_Factor_Authentication', @level2type = N'COLUMN', @level2name = N'S_Method_Type';

