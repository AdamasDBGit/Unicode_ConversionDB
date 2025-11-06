CREATE TABLE [dbo].[T_ERP_Brand_Info_Details] (
    [BrandInfo_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]    INT            NULL,
    [s_GST_No]      NVARCHAR (MAX) NULL,
    [s_CIN_No]      NVARCHAR (MAX) NULL,
    [s_Pan_No]      NVARCHAR (MAX) NULL,
    [s_stateCode]   NVARCHAR (MAX) NULL,
    [is_Active]     BIT            NULL,
    [dt_created_dt] DATETIME       DEFAULT (getdate()) NULL,
    [S_Email]       NVARCHAR (MAX) NULL,
    [S_Address]     NVARCHAR (MAX) NULL,
    [S_PinCode]     NVARCHAR (MAX) NULL,
    [S_Telephone]   NVARCHAR (MAX) NULL
);

