CREATE PROCEDURE [dbo].[SMSforDue]
AS
    BEGIN

        DECLARE @dtDate DATETIME= GETDATE();

        CREATE TABLE #temp
            (
              I_Student_Detail_ID INT ,
              S_Mobile_No VARCHAR(50) ,
              S_Student_ID VARCHAR(100) ,
              I_Roll_No INT ,
              S_Student_Name VARCHAR(200) ,
              S_Invoice_No VARCHAR(100) ,
              S_Receipt_No VARCHAR(100) ,
              Dt_Invoice_Date DATETIME ,
              I_Fee_Component_ID INT ,
              S_Component_Name VARCHAR(100) ,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
              TypeofCentre VARCHAR(MAX),
              S_Brand_Name VARCHAR(100) ,
              S_Cost_Center VARCHAR(100) ,
              Due_Value REAL ,
              Dt_Installment_Date DATETIME ,
              I_Installment_No INT ,
              I_Parent_Invoice_ID INT ,
              I_Invoice_Detail_ID INT ,
              Revised_Invoice_Date DATETIME ,
              Tax_Value DECIMAL(14, 2) ,
              Total_Value DECIMAL(14, 2) ,
              Amount_Paid DECIMAL(14, 2) ,
              Tax_Paid DECIMAL(14, 2) ,
              Total_Paid DECIMAL(14, 2) ,
              Total_Due DECIMAL(14, 2) ,
              IsGSTImplemented INT ,
              Age INT ,
              sInstance VARCHAR(MAX)
            )

        INSERT  INTO #temp
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = '54', -- varchar(max)
                    @iBrandID = 109, -- int
                    @dtUptoDate = @dtDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)


        INSERT  INTO dbo.T_SMS_SEND_DETAILS
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
                SELECT  XX.S_Mobile_No ,
                        XX.I_Student_Detail_ID ,
                        5 ,
                        'Dear Student: Due date for paying monthly tuition fees is over. Request you to pay immediately. Ignore if already paid – RICE' ,
                        109 ,
                        1 ,
                        1 ,
                        'dba' ,
                        @dtDate
                FROM    ( SELECT    I_Student_Detail_ID ,
                                    ISNULL(S_Mobile_No, '9432211475') AS S_Mobile_No ,
                                    SUM(Total_Due) AS TotalDue
                          FROM      #temp T
                          GROUP BY  I_Student_Detail_ID ,
                                    ISNULL(S_Mobile_No, '9432211475')
                        ) XX
                WHERE   XX.TotalDue >= 100.00

    
    END
