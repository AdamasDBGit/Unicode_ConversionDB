CREATE PROCEDURE [dbo].[uspDiscontinueStudents] ( @sLoginID VARCHAR(50) )
AS
    BEGIN


        BEGIN TRY
            BEGIN TRANSACTION



            DECLARE @BatchID INT
            DECLARE @CourseID INT
            DECLARE @FeePlanID INT
            DECLARE @InvoiceHeaderID INT
            DECLARE @CentreID INT
            DECLARE @StudentDetID INT



            UPDATE  T1
            SET     T1.I_Invoice_Header_ID = T2.I_Invoice_Header_ID ,
                    T1.InstalmentDate = T2.Dt_Installment_Date
            FROM    dbo.T_Discontinue_Student_Interface AS T1
                    INNER JOIN ( SELECT TICD.I_Invoice_Detail_ID ,
                                        TIP.I_Invoice_Header_ID ,
                                        TICD.Dt_Installment_Date
                                 FROM   dbo.T_Discontinue_Student_Interface AS TDSI
                                        INNER JOIN dbo.T_Invoice_Child_Detail
                                        AS TICD ON TICD.I_Invoice_Detail_ID = TDSI.I_Invoice_Detail_ID
                                        INNER JOIN dbo.T_Invoice_Child_Header
                                        AS TICH ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                        INNER JOIN dbo.T_Invoice_Parent AS TIP ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                 WHERE  TIP.I_Status IN ( 1, 3 )
                               ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID
            WHERE   T1.Status IS NULL


            UPDATE  dbo.T_Discontinue_Student_Interface
            SET     AmountDue = ISNULL(DueAmount, 0) - ISNULL(AmountPaid, 0)
            WHERE   [Status] IS NULL

            UPDATE  dbo.T_Discontinue_Student_Interface
            SET     TaxDue = ISNULL(TaxAmount, 0) - ISNULL(TaxPaid, 0)
            WHERE   [Status] IS NULL


            DECLARE Discontinue CURSOR
            FOR
                SELECT DISTINCT
                        TDSI.I_Invoice_Header_ID
                FROM    dbo.T_Discontinue_Student_Interface AS TDSI
                WHERE   TDSI.Status IS NULL

            OPEN Discontinue
            FETCH NEXT FROM Discontinue INTO @InvoiceHeaderID


            WHILE @@FETCH_STATUS = 0
                BEGIN
    
    


                    DECLARE @newInvoiceHeaderID INT
                    DECLARE @iBrandID INT
                    DECLARE @newInvoiceChildHeaderID INT

                    SELECT  @CentreID = TIP.I_Centre_Id ,
                            @BatchID = TIBM.I_Batch_ID ,
                            @CourseID = TICH.I_Course_ID ,
                            @FeePlanID = TICH.I_Course_FeePlan_ID ,
                            @StudentDetID = TIP.I_Student_Detail_ID
                    FROM    dbo.T_Invoice_Parent AS TIP
                            INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Invoice_Batch_Map AS TIBM ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                    WHERE   TIP.I_Invoice_Header_ID = @InvoiceHeaderID

                    SET @iBrandID = ( SELECT    I_Brand_ID
                                      FROM      dbo.T_Center_Hierarchy_Name_Details
                                      WHERE     I_Center_ID = @CentreID
                                    )




                    INSERT  INTO dbo.T_Invoice_Parent
                            ( S_Invoice_No ,
                              I_Student_Detail_ID ,
                              I_Centre_Id ,
                              N_Invoice_Amount ,
                              N_Discount_Amount ,
                              N_Tax_Amount ,
                              Dt_Invoice_Date ,
                              I_Status ,
                              I_Discount_Scheme_ID ,
                              I_Discount_Applied_At ,
                              S_Crtd_By ,
                              S_Upd_By ,
                              Dt_Crtd_On ,
                              Dt_Upd_On ,
                              I_Coupon_Discount ,
                              I_Parent_Invoice_ID ,
                              S_Cancel_Type
                            )
                    VALUES  ( NULL , -- S_Invoice_No - varchar(50)
                              @StudentDetID , -- I_Student_Detail_ID - int
                              @CentreID , -- I_Centre_Id - int
                              0.00 , -- N_Invoice_Amount - numeric
                              0.00 , -- N_Discount_Amount - numeric
                              0.00 , -- N_Tax_Amount - numeric
                              GETDATE() , -- Dt_Invoice_Date - datetime
                              1 , -- I_Status - int
                              NULL , -- I_Discount_Scheme_ID - int
                              NULL , -- I_Discount_Applied_At - int
                              @sLoginID , -- S_Crtd_By - varchar(20)
                              NULL , -- S_Upd_By - varchar(20)
                              GETDATE() , -- Dt_Crtd_On - datetime
                              NULL , -- Dt_Upd_On - datetime
                              NULL , -- I_Coupon_Discount - int
                              @InvoiceHeaderID , -- I_Parent_Invoice_ID - int
                              NULL  -- S_Cancel_Type - varchar(10)
                            )
        
                    SET @newInvoiceHeaderID = SCOPE_IDENTITY()        
        
                    DECLARE @iInvoiceNo BIGINT          
            
                    SELECT  @iInvoiceNo = MAX(CAST(S_Invoice_No AS BIGINT))
                    FROM    T_Invoice_Parent TIP
                    WHERE   I_Invoice_Header_ID NOT IN (
                            SELECT  I_Invoice_Header_ID
                            FROM    T_Invoice_Parent
                            WHERE   @iInvoiceNo LIKE '%[A-Z]' )
                            AND TIP.I_Centre_Id IN (
                            SELECT  I_Centre_Id
                            FROM    dbo.T_Brand_Center_Details AS TBCD
                            WHERE   I_Brand_ID = @iBrandID
                                    AND I_Status = 1 )        
          
                    SET @iInvoiceNo = ISNULL(@iInvoiceNo, 0) + 1          
          
                    UPDATE  dbo.T_Invoice_Parent
                    SET     S_Invoice_No = CAST(@iInvoiceNo AS VARCHAR(20))
                    WHERE   I_Invoice_Header_ID = @newInvoiceHeaderID 
                
                
                    INSERT  INTO dbo.T_Invoice_Child_Header
                            ( I_Invoice_Header_ID ,
                              I_Course_ID ,
                              I_Course_FeePlan_ID ,
                              C_Is_LumpSum ,
                              N_Amount ,
                              N_Tax_Amount ,
                              N_Discount_Amount ,
                              I_Discount_Scheme_ID ,
                              I_Discount_Applied_At
                            )
                    VALUES  ( @newInvoiceHeaderID , -- I_Invoice_Header_ID - int
                              @CourseID , -- I_Course_ID - int
                              @FeePlanID , -- I_Course_FeePlan_ID - int
                              'N' , -- C_Is_LumpSum - char(1)
                              0.00 , -- N_Amount - numeric
                              0.00 , -- N_Tax_Amount - numeric
                              NULL , -- N_Discount_Amount - numeric
                              NULL , -- I_Discount_Scheme_ID - int
                              NULL  -- I_Discount_Applied_At - int
                            )
         
                    SET @newInvoiceChildHeaderID = SCOPE_IDENTITY()
 
                    INSERT  INTO dbo.T_Invoice_Batch_Map
                            ( I_Invoice_Child_Header_ID ,
                              I_Batch_ID ,
                              I_Status ,
                              S_Crtd_By ,
                              S_Updt_By ,
                              Dt_Crtd_On ,
                              Dt_Updt_On
                            )
                    VALUES  ( @newInvoiceChildHeaderID , -- I_Invoice_Child_Header_ID - int
                              @BatchID , -- I_Batch_ID - int
                              1 , -- I_Status - int
                              @sLoginID , -- S_Crtd_By - varchar(20)
                              NULL , -- S_Updt_By - varchar(20)
                              GETDATE() , -- Dt_Crtd_On - datetime
                              NULL  -- Dt_Updt_On - datetime
                            )
                
                    UPDATE  dbo.T_Student_Course_Detail
                    SET     I_Status = 0
                    WHERE   I_Student_Detail_ID = @StudentDetID
                            AND I_Course_ID = @CourseID        
         
                    EXEC dbo.uspCancelInvoice @iInvoiceId = @InvoiceHeaderID, -- int
                        @sUpdatedBy = @sLoginID, -- varchar(20)
                        @iCancellationReasonId = 2 -- int
    
                    INSERT  INTO dbo.T_Student_Batch_Details
                            ( I_Student_ID ,
                              I_Batch_ID ,
                              I_Status ,
                              I_Student_Certificate_ID ,
                              I_Total_Attendance_Count ,
                              Dt_Valid_From ,
                              Dt_Valid_To ,
                              C_Is_LumpSum ,
                              I_ToBatch_ID ,
                              I_FromBatch_ID
                            )
                    VALUES  ( @StudentDetID , -- I_Student_ID - int
                              @BatchID , -- I_Batch_ID - int
                              1 , -- I_Status - int
                              NULL , -- I_Student_Certificate_ID - int
                              NULL , -- I_Total_Attendance_Count - int
                              GETDATE() , -- Dt_Valid_From - datetime
                              NULL , -- Dt_Valid_To - datetime
                              'N' , -- C_Is_LumpSum - char(1)
                              NULL , -- I_ToBatch_ID - int
                              NULL  -- I_FromBatch_ID - int
                            )                                             

        --EXEC dbo.uspGetStudentTermMapper @CourseID = @CourseID, -- int
        --    @iBrandID = @iBrandID -- int

        --EXEC dbo.uspGetStudentModuleMapper @CourseID = @CourseID, -- int
        --    @iBrandID = @iBrandID -- int
    
                    UPDATE  T1
                    SET     T1.CreditNoteNumber = T2.S_Invoice_Number ,
                            T1.CreditNoteAmount = T2.N_Amount ,
                            T1.CreditNoteTax = T2.TaxAmt ,
                            T1.CreditNoteDate = T2.Dt_Crtd_On
                    FROM    dbo.T_Discontinue_Student_Interface AS T1
                            INNER JOIN ( SELECT TCNICD.I_Invoice_Detail_ID ,
                                                TCNICD.S_Invoice_Number ,
                                                TCNICD.Dt_Crtd_On ,
                                                TCNICD.N_Amount ,
                                                Tax.TaxAmt
                                         FROM   dbo.T_Credit_Note_Invoice_Child_Detail
                                                AS TCNICD
                                                LEFT JOIN ( SELECT
                                                              TCNICDT.I_Invoice_Detail_ID ,
                                                              ISNULL(SUM(ISNULL(TCNICDT.N_Tax_Value,
                                                              0)), 0) AS TaxAmt
                                                            FROM
                                                              dbo.T_Credit_Note_Invoice_Child_Detail_Tax
                                                              AS TCNICDT
                                                            GROUP BY TCNICDT.I_Invoice_Detail_ID
                                                          ) Tax ON Tax.I_Invoice_Detail_ID = TCNICD.I_Invoice_Detail_ID
                                       ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID
                    WHERE   T1.I_Invoice_Header_ID = @InvoiceHeaderID


                    UPDATE  dbo.T_Discontinue_Student_Interface
                    SET     NewInvoiceNo = @iInvoiceNo ,
                            InvoiceDate = GETDATE() ,
                            InvoiceAmount = 0.0 ,
                            [Status] = 'DONE'
                    WHERE   I_Invoice_Header_ID = @InvoiceHeaderID
        
                    IF EXISTS ( SELECT  *
                                FROM    ACADEMICS.T_Dropout_Details AS TDD
                                WHERE   TDD.I_Student_Detail_ID = @StudentDetID
                                        AND TDD.I_Dropout_Status = 1 )
                        BEGIN
					
                            INSERT  INTO ACADEMICS.T_Dropout_Details
                                    ( I_Dropout_Status ,
                                      I_Student_Detail_ID ,
                                      I_Center_Id ,
                                      Dt_Dropout_Date ,
                                      I_Dropout_Type_ID ,
                                      S_Crtd_By ,
                                      S_Reason ,
                                      Dt_Crtd_On 
                                    )
                            VALUES  ( 1 , -- I_Dropout_Status - int
                                      @StudentDetID , -- I_Student_Detail_ID - int
                                      @CentreID , -- I_Center_Id - int
                                      GETDATE() , -- Dt_Dropout_Date - datetime
                                      4 , -- I_Dropout_Type_ID - int
                                      @sLoginID , -- S_Crtd_By - varchar(20)
                                      'Discontinued in the system' , -- S_Reason - varchar(2000)
                                      GETDATE()  -- Dt_Crtd_On - datetime
                                    )
        
        
                            UPDATE  dbo.T_Student_Detail
                            SET     I_Status = 0
                            WHERE   I_Student_Detail_ID = @StudentDetID
					
                        END

                    FETCH NEXT FROM Discontinue INTO @InvoiceHeaderID

--UPDATE dbo.T_Invoice_Parent SET I_Status=0,Dt_Upd_On=GETDATE(),S_Upd_By='dba',S_Cancel_Type='1' WHERE I_Invoice_Header_ID=@InvoiceHeaderID        

                END
    
            CLOSE Discontinue
            DEALLOCATE Discontinue

            COMMIT TRANSACTION

        END TRY

        BEGIN CATCH      
            ROLLBACK TRANSACTION  
            DECLARE @ErrMsg NVARCHAR(4000) ,
                @ErrSeverity INT      
            SELECT  @ErrMsg = ERROR_MESSAGE() ,
                    @ErrSeverity = ERROR_SEVERITY()      
      
            RAISERROR(@ErrMsg, @ErrSeverity, 1)      
        END CATCH

    END
