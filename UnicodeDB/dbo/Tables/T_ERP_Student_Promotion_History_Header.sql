CREATE TABLE [dbo].[T_ERP_Student_Promotion_History_Header] (
    [I_Student_Promotion_History_Header_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Source_Academic_Session]             INT            NULL,
    [I_Destination_Academic_Session]        INT            NULL,
    [I_Student_DetailID]                    INT            NULL,
    [I_Source_Class_ID]                     INT            NULL,
    [I_Source_Stream_ID]                    INT            NULL,
    [I_Source_SectionID]                    INT            NULL,
    [I_Destination_Class_ID]                INT            NULL,
    [I_Destination_Stream_ID]               INT            NULL,
    [I_Destination_SectionID]               INT            NULL,
    [I_Promotion_Status]                    INT            NULL,
    [IsDemoted]                             BIT            NULL,
    [IsPromoted]                            BIT            NULL,
    [Is_Due_Cleared]                        BIT            NULL,
    [RemainingDueOfSourceSession]           DECIMAL (8, 2) NULL,
    [IsOverDueSkiped]                       BIT            NULL,
    [S_Last_Remarks]                        NVARCHAR (MAX) NULL,
    [S_Academic_Approved_By]                INT            NULL,
    [Dt_Academic_Approved_At]               DATETIME       NULL,
    [CreatedBy]                             INT            NULL,
    [Dt_Created_At]                         DATETIME       NULL,
    [S_Last_Action_By]                      INT            NULL,
    [Dt_Last_Action_At]                     DATETIME       NULL,
    [I_Brand_ID]                            INT            NULL,
    [I_Center_ID]                           INT            NULL,
    [I_Source_School_Group_ID]              INT            NULL,
    [I_Destination_School_Group_ID]         INT            NULL,
    [IsTransportUsed]                       BIT            NULL,
    [IsHostelOpted]                         BIT            NULL,
    [IsFeeMapped]                           BIT            NULL,
    [IsFinancialApproved]                   BIT            NULL,
    [RollNo]                                INT            NULL,
    [IsAcademicApproved]                    BIT            NULL,
    [FeeStructureID]                        INT            NULL,
    [WillDemoted]                           BIT            NULL,
    [I_Source_Batch_ID]                     INT            NULL,
    [WillRetain]                            BIT            NULL,
    [WillOnHold]                            BIT            NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1:Promote to Next Class ; 2:On Hold; 3: Demote', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_ERP_Student_Promotion_History_Header', @level2type = N'COLUMN', @level2name = N'I_Student_Promotion_History_Header_ID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1:Promote to Next Class;2:On Hold ;3:Demote ; 4:Fee Mapped', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_ERP_Student_Promotion_History_Header', @level2type = N'COLUMN', @level2name = N'I_Promotion_Status';

