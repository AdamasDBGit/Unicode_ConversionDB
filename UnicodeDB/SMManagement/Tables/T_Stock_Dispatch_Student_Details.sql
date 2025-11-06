CREATE TABLE [SMManagement].[T_Stock_Dispatch_Student_Details] (
    [StockDispatchStudentDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [StockDispatchStudentHeaderID] INT           NULL,
    [EligibilityHeaderID]          INT           NULL,
    [EligibilityDetailID]          INT           NULL,
    [StockID]                      INT           NULL,
    [Barcode]                      VARCHAR (MAX) NULL,
    [StatusID]                     INT           NULL
);

