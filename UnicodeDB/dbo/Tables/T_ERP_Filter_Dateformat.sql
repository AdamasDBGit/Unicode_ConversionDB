CREATE TABLE [dbo].[T_ERP_Filter_Dateformat] (
    [ID]              INT            IDENTITY (1, 1) NOT NULL,
    [DateFilter_Type] NVARCHAR (MAX) NULL,
    [I_Value]         INT            NULL,
    [S_Purpose]       NVARCHAR (MAX) NULL,
    [Is_Active]       BIT            NULL
);

