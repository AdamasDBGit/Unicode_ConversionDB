CREATE TABLE [dbo].[T_Student_Detail] (
    [I_Student_Detail_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]         INT             NULL,
    [S_Student_ID]              VARCHAR (500)   NULL,
    [S_Title]                   NVARCHAR (MAX)  NULL,
    [S_First_Name]              NVARCHAR (MAX)  NULL,
    [S_Middle_Name]             NVARCHAR (MAX)  NULL,
    [S_Last_Name]               NVARCHAR (MAX)  NULL,
    [S_Guardian_Name]           NVARCHAR (MAX)  NULL,
    [I_Guardian_Occupation_ID]  INT             NULL,
    [S_Guardian_Email_ID]       NVARCHAR (MAX)  NULL,
    [S_Guardian_Phone_No]       NVARCHAR (MAX)  NULL,
    [S_Guardian_Mobile_No]      NVARCHAR (MAX)  NULL,
    [I_Income_Group_ID]         INT             NULL,
    [Dt_Birth_Date]             DATETIME        NULL,
    [S_Age]                     NVARCHAR (MAX)  NULL,
    [S_Email_ID]                NVARCHAR (MAX)  NULL,
    [S_Phone_No]                NVARCHAR (MAX)  NULL,
    [S_Mobile_No]               NVARCHAR (MAX)  NULL,
    [C_Skip_Test]               CHAR (1)        NULL,
    [I_Occupation_ID]           INT             NULL,
    [I_Pref_Career_ID]          INT             NULL,
    [I_Qualification_Name_ID]   INT             NULL,
    [I_Stream_ID]               INT             NULL,
    [S_Curr_Address1]           NVARCHAR (MAX)  NULL,
    [S_Curr_Address2]           NVARCHAR (MAX)  NULL,
    [I_Curr_Country_ID]         INT             NULL,
    [I_Curr_State_ID]           INT             NULL,
    [I_Curr_City_ID]            INT             NULL,
    [S_Curr_Area]               NVARCHAR (MAX)  NULL,
    [S_Curr_Pincode]            NVARCHAR (MAX)  NULL,
    [S_Perm_Address1]           NVARCHAR (MAX)  NULL,
    [S_Perm_Address2]           NVARCHAR (MAX)  NULL,
    [I_Perm_Country_ID]         INT             NULL,
    [I_Perm_State_ID]           INT             NULL,
    [I_Perm_City_ID]            INT             NULL,
    [S_Perm_Area]               NVARCHAR (MAX)  NULL,
    [S_Perm_Pincode]            NVARCHAR (MAX)  NULL,
    [I_Status]                  INT             NOT NULL,
    [S_Crtd_By]                 NVARCHAR (MAX)  NULL,
    [S_Upd_By]                  NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]                DATETIME        NULL,
    [Dt_Upd_On]                 DATETIME        NULL,
    [S_Conduct_Code]            NVARCHAR (MAX)  NULL,
    [S_Is_Corporate]            NVARCHAR (MAX)  NULL,
    [I_Corporate_ID]            INT             NULL,
    [I_Residence_Area_ID]       INT             NULL,
    [I_RollNo]                  INT             NULL,
    [I_Marital_Status_ID]       INT             NULL,
    [I_Transport_ID]            INT             CONSTRAINT [DF_T_Student_Detail_I_Transport_ID] DEFAULT ((0)) NULL,
    [I_room_ID]                 INT             CONSTRAINT [DF_T_Student_Detail_I_room_ID] DEFAULT ((0)) NULL,
    [I_House_ID]                INT             NULL,
    [I_Route_ID]                INT             NULL,
    [B_Is_APAI_Acc_Settled]     BIT             NULL,
    [Dt_Transport_Deactivation] DATETIME        NULL,
    [B_IsBooking]               INT             CONSTRAINT [Df_Val] DEFAULT ((0)) NULL,
    [B_HasTakenLoan]            BIT             NULL,
    [I_DiscountType_ID]         INT             NULL,
    [S_Ext_Email_ID]            NVARCHAR (MAX)  NULL,
    [IsDropOut]                 BIT             NULL,
    [IsWaiting]                 BIT             NULL,
    [IsDefaulter]               BIT             NULL,
    [IsOnLeave]                 BIT             NULL,
    [IsCompleted]               BIT             NULL,
    [IsDiscontinued]            BIT             NULL,
    [N_DueAmount]               DECIMAL (14, 2) NULL,
    [S_OrgEmailID]              NVARCHAR (MAX)  NULL,
    [S_OrgEmailPassword]        NVARCHAR (MAX)  NULL,
    [IsPreDefaulter]            DATETIME        NULL,
    [IsPaymentDue]              BIT             NULL,
    [I_IsPreDefaulter]          INT             NULL,
    [DefaulterCourses]          NVARCHAR (MAX)  NULL,
    [PreDefaulterCourses]       NVARCHAR (MAX)  NULL,
    [PaymentDueCourses]         NVARCHAR (MAX)  NULL,
    [I_buzzedDB_Slot_ID]        INT             NULL,
    [CBT_Email]                 NVARCHAR (MAX)  NULL,
    [Mig_brand]                 INT             NULL,
    [I_Brand_ID]                INT             NULL,
    CONSTRAINT [PK__T_Student_Detail__00AAE2A4] PRIMARY KEY CLUSTERED ([I_Student_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Idx_S_Student_ID]
    ON [dbo].[T_Student_Detail]([S_Student_ID] ASC)
    INCLUDE([I_Enquiry_Regn_ID]);


GO
CREATE TRIGGER [dbo].[trgAfterInsertStudentDetail] ON [dbo].[T_Student_Detail]
AFTER INSERT
AS
DECLARE @iStudentID INT;
DECLARE @sMobileNo VARCHAR(MAX);
DECLARE @sStudentID VARCHAR(MAX);

SELECT @iStudentID=i.I_Student_Detail_ID
FROM INSERTED i; 

SELECT @sMobileNo=i.S_Mobile_No
FROM INSERTED i;

SELECT @sStudentID=i.S_Student_ID
FROM INSERTED i;


IF (@sStudentID LIKE '%RICE%')
BEGIN
INSERT INTO dbo.T_SMS_SEND_DETAILS
        ( S_MOBILE_NO ,
          I_SMS_STUDENT_ID ,
          I_SMS_TYPE_ID ,
          S_SMS_BODY ,
          
          
          I_REFERENCE_ID ,
          I_REFERENCE_TYPE_ID ,
          
          I_Status ,
          S_Crtd_By ,
          
          Dt_Crtd_On 
          
        )
VALUES  ( @sMobileNo , -- S_MOBILE_NO - varchar(25)
          @iStudentID , -- I_SMS_STUDENT_ID - int
          7 , -- I_SMS_TYPE_ID - int
          'Dear Student: Welcome to RICE. – RICE' , -- S_SMS_BODY - varchar(160)
          
          
          @iStudentID , -- I_REFERENCE_ID - int
          3 , -- I_REFERENCE_TYPE_ID - int
         
          1 , -- I_Status - int
          'dba' , -- S_Crtd_By - varchar(20)
          
          GETDATE()  -- Dt_Crtd_On - datetime
          
        )
        
        --INSERT INTO dbo.T_Student_Status_Details
        --        ( I_Student_Detail_ID ,
        --          I_Student_Status_ID ,
        --          I_Status ,
        --          N_Due ,
        --          Dt_Crtd_On ,
        --          S_Crtd_By ,
        --          IsEditable
        --        )
        --VALUES  ( @iStudentID , -- I_Student_Detail_ID - int
        --          2 , -- I_Student_Status_ID - int
        --          1 , -- I_Status - int
        --          NULL , -- N_Due - decimal
        --          GETDATE() , -- Dt_Crtd_On - datetime
        --          'dba' , -- S_Crtd_By - varchar(50)
        --          1  -- IsEditable - bit
        --        )
END
ELSE IF (@sStudentID LIKE '%/AC/%')
BEGIN
	INSERT INTO dbo.T_SMS_SEND_DETAILS
        ( S_MOBILE_NO ,
          I_SMS_STUDENT_ID ,
          I_SMS_TYPE_ID ,
          S_SMS_BODY ,
          
          
          I_REFERENCE_ID ,
          I_REFERENCE_TYPE_ID ,
          
          I_Status ,
          S_Crtd_By ,
          
          Dt_Crtd_On 
          
        )
VALUES  ( @sMobileNo , -- S_MOBILE_NO - varchar(25)
          @iStudentID , -- I_SMS_STUDENT_ID - int
          7 , -- I_SMS_TYPE_ID - int
          'Dear Student: Welcome to Adamas Career. – ADAMAS' , -- S_SMS_BODY - varchar(160)
          
          
          @iStudentID , -- I_REFERENCE_ID - int
          3 , -- I_REFERENCE_TYPE_ID - int
         
          1 , -- I_Status - int
          'dba' , -- S_Crtd_By - varchar(20)
          
          GETDATE()  -- Dt_Crtd_On - datetime
          
        )
        
        --INSERT INTO dbo.T_Student_Status_Details
        --        ( I_Student_Detail_ID ,
        --          I_Student_Status_ID ,
        --          I_Status ,
        --          N_Due ,
        --          Dt_Crtd_On ,
        --          S_Crtd_By ,
        --          IsEditable
        --        )
        --VALUES  ( @iStudentID , -- I_Student_Detail_ID - int
        --          2 , -- I_Student_Status_ID - int
        --          1 , -- I_Status - int
        --          NULL , -- N_Due - decimal
        --          GETDATE() , -- Dt_Crtd_On - datetime
        --          'dba' , -- S_Crtd_By - varchar(50)
        --          1  -- IsEditable - bit
        --        )
END

ELSE IF (@sStudentID LIKE '%AWS%')
BEGIN
	INSERT INTO dbo.T_SMS_SEND_DETAILS
        ( S_MOBILE_NO ,
          I_SMS_STUDENT_ID ,
          I_SMS_TYPE_ID ,
          S_SMS_BODY ,
          
          
          I_REFERENCE_ID ,
          I_REFERENCE_TYPE_ID ,
          
          I_Status ,
          S_Crtd_By ,
          
          Dt_Crtd_On 
          
        )
VALUES  ( @sMobileNo , -- S_MOBILE_NO - varchar(25)
          @iStudentID , -- I_SMS_STUDENT_ID - int
          7 , -- I_SMS_TYPE_ID - int
          'Dear Student: Welcome to Adamas World School. – ADAMAS' , -- S_SMS_BODY - varchar(160)
          
          
          @iStudentID , -- I_REFERENCE_ID - int
          3 , -- I_REFERENCE_TYPE_ID - int
         
          1 , -- I_Status - int
          'dba' , -- S_Crtd_By - varchar(20)
          
          GETDATE()  -- Dt_Crtd_On - datetime
          
        )
END

ELSE IF (@sStudentID LIKE '__-%')
BEGIN
	INSERT INTO dbo.T_SMS_SEND_DETAILS
        ( S_MOBILE_NO ,
          I_SMS_STUDENT_ID ,
          I_SMS_TYPE_ID ,
          S_SMS_BODY ,
          
          
          I_REFERENCE_ID ,
          I_REFERENCE_TYPE_ID ,
          
          I_Status ,
          S_Crtd_By ,
          
          Dt_Crtd_On 
          
        )
VALUES  ( @sMobileNo , -- S_MOBILE_NO - varchar(25)
          @iStudentID , -- I_SMS_STUDENT_ID - int
          7 , -- I_SMS_TYPE_ID - int
          'Dear Student: Welcome to Adamas International School. – ADAMAS' , -- S_SMS_BODY - varchar(160)
          
          
          @iStudentID , -- I_REFERENCE_ID - int
          3 , -- I_REFERENCE_TYPE_ID - int
         
          1 , -- I_Status - int
          'dba' , -- S_Crtd_By - varchar(20)
          
          GETDATE()  -- Dt_Crtd_On - datetime
          
        )
END

ELSE
BEGIN
	INSERT INTO dbo.T_SMS_SEND_DETAILS
        ( S_MOBILE_NO ,
          I_SMS_STUDENT_ID ,
          I_SMS_TYPE_ID ,
          S_SMS_BODY ,
          
          
          I_REFERENCE_ID ,
          I_REFERENCE_TYPE_ID ,
          
          I_Status ,
          S_Crtd_By ,
          
          Dt_Crtd_On 
          
        )
VALUES  ( @sMobileNo , -- S_MOBILE_NO - varchar(25)
          @iStudentID , -- I_SMS_STUDENT_ID - int
          7 , -- I_SMS_TYPE_ID - int
          'Dear Student: Welcome to Adamas Institute of Technology. – ADAMAS' , -- S_SMS_BODY - varchar(160)
          
          
          @iStudentID , -- I_REFERENCE_ID - int
          3 , -- I_REFERENCE_TYPE_ID - int
         
          1 , -- I_Status - int
          'dba' , -- S_Crtd_By - varchar(20)
          
          GETDATE()  -- Dt_Crtd_On - datetime
          
        )
END
GO
DISABLE TRIGGER [dbo].[trgAfterInsertStudentDetail]
    ON [dbo].[T_Student_Detail];


GO
CREATE TRIGGER [dbo].[TUPDATE_T_Student_Detail] ON [dbo].[T_Student_Detail] AFTER UPDATE ASBEGININSERT INTO T_Student_Detail_A(I_Student_Detail_ID,I_Enquiry_Regn_ID,S_Student_ID,S_Title,S_First_Name,S_Middle_Name,S_Last_Name,S_Guardian_Name,I_Guardian_Occupation_ID,S_Guardian_Email_ID,S_Guardian_Phone_No,S_Guardian_Mobile_No,I_Income_Group_ID,Dt_Birth_Date,S_Age,S_Email_ID,S_Phone_No,S_Mobile_No,C_Skip_Test,I_Occupation_ID,I_Pref_Career_ID,I_Qualification_Name_ID,I_Stream_ID,S_Curr_Address1,S_Curr_Address2,I_Curr_Country_ID,I_Curr_State_ID,I_Curr_City_ID,S_Curr_Area,S_Curr_Pincode,S_Perm_Address1,S_Perm_Address2,I_Perm_Country_ID,I_Perm_State_ID,I_Perm_City_ID,S_Perm_Area,S_Perm_Pincode,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,S_Conduct_Code,S_Is_Corporate,I_Corporate_ID,I_Residence_Area_ID,I_RollNo,I_Marital_Status_ID,I_Transport_ID,I_room_ID,I_House_ID,I_Route_ID,B_Is_APAI_Acc_Settled,Dt_Transport_Deactivation,AuditedOn,AuditType)SELECT I_Student_Detail_ID,I_Enquiry_Regn_ID,S_Student_ID,S_Title,S_First_Name,S_Middle_Name,S_Last_Name,S_Guardian_Name,I_Guardian_Occupation_ID,S_Guardian_Email_ID,S_Guardian_Phone_No,S_Guardian_Mobile_No,I_Income_Group_ID,Dt_Birth_Date,S_Age,S_Email_ID,S_Phone_No,S_Mobile_No,C_Skip_Test,I_Occupation_ID,I_Pref_Career_ID,I_Qualification_Name_ID,I_Stream_ID,S_Curr_Address1,S_Curr_Address2,I_Curr_Country_ID,I_Curr_State_ID,I_Curr_City_ID,S_Curr_Area,S_Curr_Pincode,S_Perm_Address1,S_Perm_Address2,I_Perm_Country_ID,I_Perm_State_ID,I_Perm_City_ID,S_Perm_Area,S_Perm_Pincode,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,S_Conduct_Code,S_Is_Corporate,I_Corporate_ID,I_Residence_Area_ID,I_RollNo,I_Marital_Status_ID,I_Transport_ID,I_room_ID,I_House_ID,I_Route_ID,B_Is_APAI_Acc_Settled,Dt_Transport_Deactivation, GETDATE(), 'U'FROM DELETED IEND
GO
CREATE TRIGGER [dbo].[TDELETE_T_Student_Detail] ON [dbo].[T_Student_Detail] AFTER DELETE ASBEGININSERT INTO T_Student_Detail_A(I_Student_Detail_ID,I_Enquiry_Regn_ID,S_Student_ID,S_Title,S_First_Name,S_Middle_Name,S_Last_Name,S_Guardian_Name,I_Guardian_Occupation_ID,S_Guardian_Email_ID,S_Guardian_Phone_No,S_Guardian_Mobile_No,I_Income_Group_ID,Dt_Birth_Date,S_Age,S_Email_ID,S_Phone_No,S_Mobile_No,C_Skip_Test,I_Occupation_ID,I_Pref_Career_ID,I_Qualification_Name_ID,I_Stream_ID,S_Curr_Address1,S_Curr_Address2,I_Curr_Country_ID,I_Curr_State_ID,I_Curr_City_ID,S_Curr_Area,S_Curr_Pincode,S_Perm_Address1,S_Perm_Address2,I_Perm_Country_ID,I_Perm_State_ID,I_Perm_City_ID,S_Perm_Area,S_Perm_Pincode,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,S_Conduct_Code,S_Is_Corporate,I_Corporate_ID,I_Residence_Area_ID,I_RollNo,I_Marital_Status_ID,I_Transport_ID,I_room_ID,I_House_ID,I_Route_ID,B_Is_APAI_Acc_Settled,Dt_Transport_Deactivation,AuditedOn,AuditType)SELECT I_Student_Detail_ID,I_Enquiry_Regn_ID,S_Student_ID,S_Title,S_First_Name,S_Middle_Name,S_Last_Name,S_Guardian_Name,I_Guardian_Occupation_ID,S_Guardian_Email_ID,S_Guardian_Phone_No,S_Guardian_Mobile_No,I_Income_Group_ID,Dt_Birth_Date,S_Age,S_Email_ID,S_Phone_No,S_Mobile_No,C_Skip_Test,I_Occupation_ID,I_Pref_Career_ID,I_Qualification_Name_ID,I_Stream_ID,S_Curr_Address1,S_Curr_Address2,I_Curr_Country_ID,I_Curr_State_ID,I_Curr_City_ID,S_Curr_Area,S_Curr_Pincode,S_Perm_Address1,S_Perm_Address2,I_Perm_Country_ID,I_Perm_State_ID,I_Perm_City_ID,S_Perm_Area,S_Perm_Pincode,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,S_Conduct_Code,S_Is_Corporate,I_Corporate_ID,I_Residence_Area_ID,I_RollNo,I_Marital_Status_ID,I_Transport_ID,I_room_ID,I_House_ID,I_Route_ID,B_Is_APAI_Acc_Settled,Dt_Transport_Deactivation, GETDATE(), 'D'FROM DELETED IEND