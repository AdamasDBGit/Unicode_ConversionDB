CREATE TABLE [dbo].[T_ERP_GST_Category_Component] (
    [I_gst_CompID]                   INT      NULL,
    [I_GST_FeeComponent_Catagory_ID] INT      NULL,
    [I_Fee_Component_ID]             INT      NULL,
    [Is_Active]                      BIT      NULL,
    [Dt_createDt]                    DATETIME CONSTRAINT [DF__T_ERP_GST__Dt_cr__2AF71F4C] DEFAULT (getdate()) NULL,
    [Type]                           INT      NULL
);

