CREATE PROCEDURE [SMManagement].[uspUpdateQRCodeContent]
    (
      @QrCodeContentList XML
    )
AS
    BEGIN

        DECLARE @count INT
        DECLARE @startpos INT= 1
        DECLARE @dispatchheaderID INT
        DECLARE @DetailXML XML

        SET @count = @QrCodeContentList.value('count((DispatchList/Details))',
                                              'int')

        SELECT  @dispatchheaderID = T.a.value('@DispatchHeaderID', 'int')
        FROM    @QrCodeContentList.nodes('/DispatchList') T ( a )

        WHILE ( @startpos <= @count )
            BEGIN

                DECLARE @stddetailid INT
                DECLARE @qrcontent VARCHAR(MAX)

                SET @DetailXML = @QrCodeContentList.query('/DispatchList/Details[position()=sql:variable("@startpos")]')

                SELECT  @stddetailid = T.a.value('@StdDetailID', 'int') ,
                        @qrcontent = T.a.value('@QRCodeContent',
                                               'varchar(500)')
                FROM    @DetailXML.nodes('/Details') T ( a )
                            
                            
                UPDATE  SMManagement.T_Stock_Dispatch_Student_Header
                SET     DispatchDocument = @qrcontent
                WHERE   StudentDetailID = @stddetailid
                        AND StockDispatchHeaderID = @dispatchheaderID
                        AND IsDispatched = 1
                            
                IF ( ( SELECT   DispatchDocument
                       FROM     SMManagement.T_Stock_Dispatch_Student_Header
                       WHERE    StockDispatchHeaderID = @dispatchheaderID
                                AND IsDispatched = 1
                                AND StudentDetailID = @stddetailid
                     ) IS NOT NULL )
                    BEGIN
                            
                        DECLARE @stdcontact VARCHAR(20)
                        DECLARE @uniqueid VARCHAR(17)= SUBSTRING(@qrcontent, 0,
                                                              17)
                        DECLARE @centreid INT
                        DECLARE @trackingid VARCHAR(MAX)= ( SELECT
                                                              ISNULL(TrackingID,
                                                              '') AS TrackingID
                                                            FROM
                                                              SMManagement.T_Stock_Dispatch_Student_Header
                                                            WHERE
                                                              StudentDetailID = @stddetailid
                                                              AND StockDispatchHeaderID = @dispatchheaderID
                                                              AND IsDispatched = 1
                                                          )
                        
                        SELECT  @centreid = TSCD.I_Centre_Id
                        FROM    dbo.T_Student_Center_Detail AS TSCD
                        WHERE   TSCD.I_Student_Detail_ID = @stddetailid
                                AND TSCD.I_Status = 1                                      
                            
                        SELECT  @stdcontact = ISNULL(TSD.S_Mobile_No,'9903608031')
                        FROM    dbo.T_Student_Detail AS TSD
                        WHERE   TSD.I_Student_Detail_ID = @stddetailid
                        
                        IF ( @centreid IN ( 18, 19 ,17) )
                            BEGIN
                            
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
                                VALUES  ( @stdcontact ,
                                          @stddetailid ,
                                          11 ,
                                          'Dear Student: Your Study Material (Id:'
                                          + @uniqueid
                                          + ') is being dispatched to your centre. Your Branch Officials will contact with you shortly. RICE' ,
                                          @stddetailid ,
                                          4 ,
                                          1 ,
                                          'dba' ,
                                          GETDATE()
                                        )
                                
                            END
                                
                        ELSE
                            BEGIN
                                
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
                                VALUES  ( @stdcontact ,
                                          @stddetailid ,
                                          12 ,
                                          --'Dear Student: Your Study Material (Id:'
                                          --+ @uniqueid
                                          --+ ') has been dispatched to your registered address.It is expected to get delivered within 7 working days. Track your shipment at http://www.dtdc.in/tracking/tracking_results.asp?strCnno='+@trackingid+'&GES=N&action=track&sec=tr&ctlActiveVal=1&Ttype=cnno&TrkType2=awb_no RICE' ,
                                          'Dear Student: Your Study Material (Id:'
                                          + @uniqueid
                                          + ') is being dispatched to your centre.Your Branch Officials will contact with you shortly. RICE' ,
                                          @stddetailid ,
                                          4 ,
                                          1 ,
                                          'dba' ,
                                          GETDATE()
                                        )
                                        --Dear Student: Your Study Material (Id:[UNIQUEID]) has been dispatched to your registered address. It is expected to get delivered within 7 working days – RICE
                                        --Dear Student: Your Study Material (Id:[UNIQUEID]) has been dispatched to your centre. Please collect it after 3 working days. – RICE
                                
                            END
                                
                    END
                            
                            
                SET @startpos = @startpos + 1
                            
            END
                            


    END
