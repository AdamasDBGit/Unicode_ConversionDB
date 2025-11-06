CREATE PROCEDURE [SMManagement].[uspInsertEligibleStudentDetails]
    (
      @EligibleStudentDetails XML = NULL
    )
AS
    BEGIN

        IF @EligibleStudentDetails IS NOT NULL
            BEGIN TRY
                BEGIN TRANSACTION

                DECLARE @StdPosition INT= 1
                DECLARE @StdCount INT
                DECLARE @StdDetPosition INT= 1
                DECLARE @StdDetCount INT
                DECLARE @Header INT
                DECLARE @StdHeader INT= NULL
                DECLARE @StdXML XML
                DECLARE @StdDetailXML XML

                SET @StdCount = @EligibleStudentDetails.value('count((EligibleStudentList/Student))',
                                                              'int')

                INSERT  INTO SMManagement.T_Stock_Dispatch_Header
                        ( StockDispatchHeaderName ,
                          StudentCount ,
                          ItemCount ,
                          IsDispatched ,
                          StatusID ,
                          CreatedBy ,
                          CreatedOn 
                        )
                VALUES  ( 'DISPATCHLIST ' + CAST(CURRENT_TIMESTAMP AS VARCHAR) , -- StockDispatchHeaderName - varchar(max)
                          @StdCount , -- StudentCount - int
                          0 , -- ItemCount - int
                          0 , -- IsDispatched - bit
                          1 , -- StatusID - int
                          'rice-group-admin' , -- CreatedBy - varchar(max)
                          GETDATE()  -- CreatedOn - datetime
                        )
                               
        
                SET @Header = SCOPE_IDENTITY()       
        
                WHILE ( @StdPosition <= @StdCount )
                    BEGIN        

                        SET @StdXML = @EligibleStudentDetails.query('/EligibleStudentList/Student[position()=sql:variable("@StdPosition")]')

                        INSERT  INTO SMManagement.T_Stock_Dispatch_Student_Header
                                ( StockDispatchHeaderID ,
                                  StudentDetailID ,
                                  StatusID ,
                                  IsDispatched
                                )
                                SELECT  @Header ,
                                        T.a.value('@StudentID', 'int') ,
                                        1 ,
                                        0
                                FROM    @StdXML.nodes('/Student') T ( a )
                                WHERE   T.a.value('@IsSelected', 'bit') <> 0

                        SET @StdHeader = SCOPE_IDENTITY()

                        IF ( @StdHeader IS NOT NULL )
                            BEGIN

                                SET @StdDetPosition = 1

                                SET @StdDetCount = @StdXML.value('count((Student/EligibleHeader))',
                                                              'int')

                                WHILE ( @StdDetPosition <= @StdDetCount )
                                    BEGIN

                                        SET @StdDetailXML = @StdXML.query('/Student/EligibleHeader[position()=sql:variable("@StdDetPosition")]')

                                        INSERT  INTO SMManagement.T_Stock_Dispatch_Student_Details
                                                ( StockDispatchStudentHeaderID ,
                                                  EligibilityHeaderID ,
                                                  EligibilityDetailID ,
                                                  StatusID
                                                )
                                                SELECT  @StdHeader ,
                                                        TSED.EligibilityHeaderID ,
                                                        TSED.EligibilityDetailID ,
                                                        1
                                                FROM    SMManagement.T_Student_Eligibity_Details
                                                        AS TSED
                                                        INNER JOIN ( SELECT
                                                              T.a.value('@HeaderID',
                                                              'int') AS EligibilityHeaderID ,
                                                              T.a.value('@DeliveryNo',
                                                              'int') AS DeliveryNo
                                                              FROM
                                                              @StdDetailXML.nodes('/EligibleHeader') T ( a )
                                                              ) T1 ON T1.EligibilityHeaderID = TSED.EligibilityHeaderID
                                                              AND T1.DeliveryNo = TSED.I_Delivery

                                        SET @StdDetPosition = @StdDetPosition
                                            + 1

                                    END

                                UPDATE  SMManagement.T_Stock_Dispatch_Student_Header
                                SET     ItemCount = ( SELECT  COUNT(*)
                                                      FROM    SMManagement.T_Stock_Dispatch_Student_Details
                                                              AS TSDSD
                                                      WHERE   TSDSD.StockDispatchStudentHeaderID = @StdHeader
                                                    )
                                WHERE   StockDispatchStudentHeaderID = @StdHeader


                            END

                        SET @StdPosition = @StdPosition + 1
                    END


                UPDATE  SMManagement.T_Stock_Dispatch_Header
                SET     ItemCount = ( SELECT    SUM(ISNULL(T.ItemCount, 0))
                                      FROM      SMManagement.T_Stock_Dispatch_Student_Header T
                                      WHERE     StockDispatchHeaderID = @Header
                                    )
                WHERE   StockDispatchHeaderID = @Header

				UPDATE SMManagement.T_Student_Eligibity_Details SET IsApproved=1,ApprovedDate=GETDATE() WHERE EligibilityDetailID IN
				(
				SELECT TSDSD.EligibilityDetailID FROM SMManagement.T_Stock_Dispatch_Header AS TSDH
				INNER JOIN SMManagement.T_Stock_Dispatch_Student_Header AS TSDSH ON TSDSH.StockDispatchHeaderID = TSDH.StockDispatchHeaderID
				INNER JOIN SMManagement.T_Stock_Dispatch_Student_Details AS TSDSD ON TSDSD.StockDispatchStudentHeaderID = TSDSH.StockDispatchStudentHeaderID
				WHERE TSDH.StockDispatchHeaderID=@Header
				)
				


                COMMIT TRANSACTION
            END TRY


            BEGIN CATCH
    
	--Error occurred:  
                ROLLBACK TRANSACTION
                DECLARE @ErrMsg NVARCHAR(4000) ,
                    @ErrSeverity INT
                SELECT  @ErrMsg = ERROR_MESSAGE() ,
                        @ErrSeverity = ERROR_SEVERITY()

                RAISERROR(@ErrMsg, @ErrSeverity, 1)
            END CATCH




    END
