CREATE TABLE [LOGISTICS].[T_Logistics_Master_Audit] (
    [I_Logistics_Audit_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_Logistics_ID]       INT           NULL,
    [I_Logistics_Type_ID]  INT           NULL,
    [S_SAP_Logistic_ID]    VARCHAR (20)  NULL,
    [I_Course_ID]          INT           NULL,
    [I_Module_ID]          INT           NULL,
    [S_Item_Code]          VARCHAR (50)  NULL,
    [S_Item_Desc]          VARCHAR (200) NULL,
    [I_Document_ID]        INT           NULL,
    [I_Item_Price_INR]     FLOAT (53)    NULL,
    [I_Item_Price_USD]     FLOAT (53)    NULL,
    [S_Item_Grade]         CHAR (10)     NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL
);

