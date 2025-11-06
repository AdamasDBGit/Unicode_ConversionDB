CREATE TABLE [dbo].[T_Company_Coupon] (
    [I_Coupon_ID]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [S_Coupon_Number]     NVARCHAR (MAX)  NULL,
    [Dt_Expiry_Date]      DATETIME        NULL,
    [I_Status]            INT             NULL,
    [Dt_Discount_Date]    DATETIME        NULL,
    [D_Coupon_Discount]   DECIMAL (18, 2) NULL,
    [I_Invoice_Header_ID] INT             NULL,
    CONSTRAINT [PK_T_Coupon] PRIMARY KEY CLUSTERED ([I_Coupon_ID] ASC)
);

