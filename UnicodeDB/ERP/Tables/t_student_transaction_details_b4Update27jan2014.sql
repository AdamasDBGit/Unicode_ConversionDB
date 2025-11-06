CREATE TABLE [ERP].[t_student_transaction_details_b4Update27jan2014] (
    [I_Student_Transaction_Detail_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]                      INT             NOT NULL,
    [I_Transaction_Type_ID]           INT             NOT NULL,
    [I_Student_ID]                    INT             NULL,
    [I_Enquiry_Regn_ID]               INT             NULL,
    [S_Cost_Center]                   VARCHAR (50)    NOT NULL,
    [N_Amount]                        NUMERIC (24, 2) NOT NULL,
    [Transaction_Date]                DATETIME        NOT NULL,
    [Instrument_Number]               VARCHAR (50)    NULL,
    [Bank_Account_Name]               VARCHAR (50)    NULL
);

