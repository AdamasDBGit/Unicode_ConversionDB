CREATE TABLE [dbo].[T_ERP_User_Type] (
    [I_User_Type_ID] INT           IDENTITY (1, 1) NOT NULL,
    [S_UserType]     NVARCHAR (50) NULL,
    [I_CreatedBy]    INT           NULL,
    [Dt_CreatedAt]   DATETIME      CONSTRAINT [DF__T_ERP_Use__Dt_Cr__3EBE20D7] DEFAULT (getdate()) NULL,
    [Dt_ModifiedAt]  DATETIME      NULL,
    [I_ModifiedBy]   INT           NULL,
    [Is_Active]      BIT           CONSTRAINT [DF__T_ERP_Use__Is_Ac__3FB24510] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Us__1DFD0A39BE9185DE] PRIMARY KEY CLUSTERED ([I_User_Type_ID] ASC)
);

