CREATE TABLE [dbo].[T_Course_Center_Delivery_FeePlan] (
    [I_Course_Center_Delivery_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Course_Delivery_ID]        INT      NOT NULL,
    [I_Course_Center_ID]          INT      NOT NULL,
    [I_Course_Fee_Plan_ID]        INT      NOT NULL,
    [Dt_Valid_From]               DATETIME NULL,
    [Dt_Valid_To]                 DATETIME NULL,
    [I_Status]                    INT      NULL,
    CONSTRAINT [PK__T_Course_Center___735BD47E] PRIMARY KEY CLUSTERED ([I_Course_Center_Delivery_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NC_T_Course_Center_Delivery_FeePlan_I_Status]
    ON [dbo].[T_Course_Center_Delivery_FeePlan]([I_Status] ASC)
    INCLUDE([I_Course_Delivery_ID], [I_Course_Fee_Plan_ID]);

