CREATE TABLE [dbo].[T_Student_Transfer_Request_Details] (
    [I_Student_Transfer_Request_Detail_ID] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_TimeSlot_ID]                        INT      NULL,
    [I_Course_ID]                          INT      NULL,
    [I_Transfer_Request_ID]                INT      NULL,
    [I_Course_Fee_Plan_ID]                 INT      NULL,
    [I_Delivery_Pattern_ID]                INT      NULL,
    [S_Payment_Mode]                       CHAR (1) NULL,
    [I_Batch_ID]                           INT      NULL,
    CONSTRAINT [PK__T_Student_Transf__2D288360] PRIMARY KEY CLUSTERED ([I_Student_Transfer_Request_Detail_ID] ASC)
);

