CREATE PROCEDURE [SMManagement].[uspUpdateStudentDispatchDetails]
    (
      @StdDispatchDetails XML = NULL
    )
AS
    BEGIN

        IF ( @StdDispatchDetails IS NOT NULL )
            BEGIN
                BEGIN TRY
				
                    BEGIN TRANSACTION
				
                    DECLARE @count INT
                    DECLARE @startpos INT= 1
                    DECLARE @dispatchheaderID INT
                    DECLARE @DetailXML XML

                    SET @count = @StdDispatchDetails.value('count((DispatchList/Details))',
                                                           'int')

                    SELECT  @dispatchheaderID = T.a.value('@DispatchHeaderID',
                                                          'int')
                    FROM    @StdDispatchDetails.nodes('/DispatchList') T ( a )

                    WHILE ( @startpos <= @count )
                        BEGIN

                            DECLARE @stockid INT
                            DECLARE @eligibilityheaderid INT
                            DECLARE @eligibilitydetailid INT
                            DECLARE @stdheaderid INT
                            DECLARE @stddetailid INT
                            DECLARE @barcode VARCHAR(MAX)
                            DECLARE @trackingid VARCHAR(MAX)

                            SET @DetailXML = @StdDispatchDetails.query('/DispatchList/Details[position()=sql:variable("@startpos")]')

                            SELECT  @stdheaderid = T.a.value('@StdDispatchHeaderID',
                                                             'int') ,
                                    @stddetailid = T.a.value('@StdDispatchDetailID',
                                                             'int') ,
                                    @eligibilityheaderid = T.a.value('@EligibilityHeaderID',
                                                              'int') ,
                                    @eligibilitydetailid = T.a.value('@EligibilityDetailID',
                                                              'int') ,
                                    @stockid = T.a.value('@StockID', 'int') ,
                                    @barcode = T.a.value('@Barcode',
                                                         'varchar(50)'),
                                    @trackingid=T.a.value('@TrackingID','varchar(100)')                     
                            FROM    @DetailXML.nodes('/Details') T ( a )


                            UPDATE  SMManagement.T_Stock_Dispatch_Student_Details
                            SET     StockID = @stockid ,
                                    Barcode = @barcode
                            WHERE   StockDispatchStudentHeaderID = @stdheaderid
                                    AND StockDispatchStudentDetailID = @stddetailid
                                    AND EligibilityHeaderID = @eligibilityheaderid
                                    AND EligibilityDetailID = @eligibilitydetailid
                            
                            UPDATE SMManagement.T_Stock_Dispatch_Student_Header SET TrackingID=@trackingid WHERE StockDispatchStudentHeaderID=@stdheaderid AND (TrackingID IS NULL OR TrackingID='')
                            UPDATE SMManagement.T_Courier_TrackingID SET StatusID=1 WHERE TrackingID=@trackingid AND StatusID=4       
                                
                            UPDATE  SMManagement.T_Stock_Master
                            SET     StatusID = 2,UpdatedBy='rice-group-admin',UpdatedOn=GETDATE()
                            WHERE   StockID = @stockid
                            UPDATE  SMManagement.T_Student_Eligibity_Details
                            SET     IsDispatched = 1
                            WHERE   EligibilityDetailID = @eligibilitydetailid
                                    AND EligibilityHeaderID = @eligibilityheaderid        

                            IF NOT EXISTS ( SELECT  *
                                            FROM    SMManagement.T_Stock_Dispatch_Student_Header
                                                    AS TSDSH
                                                    INNER JOIN SMManagement.T_Stock_Dispatch_Student_Details
                                                    AS TSDSD ON TSDSD.StockDispatchStudentHeaderID = TSDSH.StockDispatchStudentHeaderID
                                            WHERE   TSDSD.StockID IS NULL
                                                    AND TSDSD.StatusID = 1
                                                    AND TSDSH.StatusID = 1
                                                    AND TSDSH.StockDispatchStudentHeaderID = @stdheaderid
                                                    AND TSDSH.StockDispatchHeaderID = @dispatchheaderID )
                                BEGIN                    
                                    UPDATE  SMManagement.T_Stock_Dispatch_Student_Header
                                    SET     IsDispatched = 1 ,
                                            DispatchDate = GETDATE()
                                    WHERE   StockDispatchHeaderID = @dispatchheaderID
                                            AND StockDispatchStudentHeaderID = @stdheaderid
                                    
                                END 
                            
                            SET @startpos = @startpos + 1           

                        END
                    
                    IF NOT EXISTS ( SELECT  *
                                    FROM    SMManagement.T_Stock_Dispatch_Student_Header
                                            AS TSDSH
                                    WHERE   TSDSH.StockDispatchHeaderID = @dispatchheaderID
                                            AND TSDSH.StatusID = 1
                                            AND TSDSH.IsDispatched = 0 )
                        UPDATE  SMManagement.T_Stock_Dispatch_Header
                        SET     IsDispatched = 1 ,
                                DispatchDate = GETDATE() ,
                                UpdatedBy = 'rice-group-admin' ,
                                UpdatedOn = GETDATE()
                        WHERE   StockDispatchHeaderID = @dispatchheaderID
                    ELSE
                        RAISERROR('ERROR',11,1)
				
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



    END
