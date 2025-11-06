CREATE TABLE [dbo].[T_Enquiry_PostCounselling_Feedback_Details] (
    [I_Enquiry_PostCounselling_Feedback_Details_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]                             INT            NULL,
    [S_Question]                                    NVARCHAR (MAX) NULL,
    [I_Points]                                      INT            NULL
);

