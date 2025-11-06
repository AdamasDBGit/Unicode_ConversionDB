CREATE TABLE [dbo].[T_ERP_Notification_Temp_Recepient] (
    [I_Notification_Temp_Recepient_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Notification_ID]                INT            NOT NULL,
    [S_Type]                           CHAR (2)       NULL,
    [I_School_Group_ID]                INT            NULL,
    [I_Class_ID]                       INT            NULL,
    [I_Section_ID]                     INT            NULL,
    [I_Stream_ID]                      INT            NULL,
    [I_Student_ID]                     INT            NULL,
    [I_User_ID]                        INT            NULL,
    [S_Email]                          NVARCHAR (300) NULL,
    [S_Mobile]                         NVARCHAR (50)  NULL,
    [S_FirebaseToken]                  NVARCHAR (MAX) NULL,
    [I_IsActive]                       INT            NULL
);

