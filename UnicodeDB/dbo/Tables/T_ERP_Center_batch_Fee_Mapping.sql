CREATE TABLE [dbo].[T_ERP_Center_batch_Fee_Mapping] (
    [I_Center_batch_Fee_ID] INT  IDENTITY (1, 1) NOT NULL,
    [I_Center_ID]           INT  NULL,
    [I_batch_ID]            INT  NULL,
    [I_Fee_PlanID]          INT  NULL,
    [Dt_created_On]         DATE CONSTRAINT [DF__T_ERP_Cen__Dt_cr__5498535D] DEFAULT (getdate()) NULL,
    [Is_Active]             BIT  CONSTRAINT [DF__T_ERP_Cen__Is_Ac__558C7796] DEFAULT ((1)) NULL
);

