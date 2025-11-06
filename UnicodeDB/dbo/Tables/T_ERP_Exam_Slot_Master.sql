CREATE TABLE [dbo].[T_ERP_Exam_Slot_Master] (
    [inSlotID]        INT            IDENTITY (1, 1) NOT NULL,
    [stSlotCode]      NVARCHAR (MAX) NULL,
    [tmSlotStartTime] TIME (0)       NULL,
    [tmSlotEndTime]   TIME (0)       NULL,
    [dtCreatedDate]   DATETIME       CONSTRAINT [DF__T_ERP_Exa__Dtt_C__5BC473D9] DEFAULT (getdate()) NULL,
    [dtModifiedDate]  DATETIME       NULL,
    [inCreatedBy]     INT            NULL,
    [inModifiedBy]    INT            NULL,
    [IsActive]        BIT            CONSTRAINT [DF__T_ERP_Exa__Is_Ac__5CB89812] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Ex__8286F00C83809727] PRIMARY KEY CLUSTERED ([inSlotID] ASC)
);

