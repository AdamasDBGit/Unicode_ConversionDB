CREATE PROCEDURE [SMManagement].[uspUpdateStudentDeliveryDetails]
    (
      @DeliveryDetails XML ,
      @HierarchyID VARCHAR(MAX) ,
      @CourseID INT ,
      @BrandID INT
    )
AS
    BEGIN

        DECLARE @count INT
        DECLARE @startpos INT= 1
        DECLARE @dispatchheaderID INT
        DECLARE @DetailXML XML

        SET @count = @DeliveryDetails.value('count((DispatchList/Details))',
                                            'int')

        WHILE ( @startpos <= @count )
            BEGIN

                DECLARE @stddetailid INT
                DECLARE @stddispatchheaderid INT

                SET @DetailXML = @DeliveryDetails.query('/DispatchList/Details[position()=sql:variable("@startpos")]')

                SELECT  @stddetailid = T.a.value('@StdDetailID', 'int') ,
                        @stddispatchheaderid = T.a.value('@StdDispatchHeaderID',
                                                         'int')
                FROM    @DetailXML.nodes('/Details') T ( a )
                            
                UPDATE  SMManagement.T_Stock_Master
                SET     StatusID = 3 ,
                        UpdatedOn = GETDATE()
                WHERE   StockID IN (
                        SELECT  TSDSD.StockID
                        FROM    SMManagement.T_Stock_Dispatch_Student_Details
                                AS TSDSD
                                INNER JOIN SMManagement.T_Stock_Dispatch_Student_Header
                                AS TSDSH ON TSDSH.StockDispatchStudentHeaderID = TSDSD.StockDispatchStudentHeaderID
                        WHERE   TSDSH.StockDispatchStudentHeaderID = @stddispatchheaderid
                                AND TSDSH.IsDispatched = 1
                                AND TSDSH.StudentDetailID = @stddetailid )
                            
                UPDATE  SMManagement.T_Stock_Dispatch_Student_Header
                SET     IsDelivered = 1 ,
                        DeliveryDate = GETDATE()
                WHERE   StudentDetailID = @stddetailid
                        AND StockDispatchStudentHeaderID = @stddispatchheaderid
                        AND IsDispatched = 1
                        
                UPDATE SMManagement.T_Student_Eligibity_Details SET IsDelivered=1 WHERE EligibilityDetailID IN
                (
                SELECT TSDSD.EligibilityDetailID FROM SMManagement.T_Stock_Dispatch_Student_Details AS TSDSD WHERE TSDSD.StockDispatchStudentHeaderID=@stddispatchheaderid
                )        
                        
                PRINT 'OK'+CAST(@dispatchheaderID AS VARCHAR)            
                IF ( ( SELECT   DispatchDocument
                       FROM     SMManagement.T_Stock_Dispatch_Student_Header
                       WHERE    StockDispatchStudentHeaderID = @stddispatchheaderid
                                AND IsDelivered = 1
                                AND StudentDetailID = @stddetailid
                     ) IS NOT NULL )
                    BEGIN
                            
                        DECLARE @stdcontact VARCHAR(20)
                        DECLARE @qrcontent VARCHAR(MAX)
                        
                        SELECT  @qrcontent = DispatchDocument
                        FROM    SMManagement.T_Stock_Dispatch_Student_Header
                        WHERE   StockDispatchStudentHeaderID = @stddispatchheaderid
                                AND IsDelivered = 1
                                AND StudentDetailID = @stddetailid 
                        
                        DECLARE @uniqueid VARCHAR(16)= SUBSTRING(@qrcontent, 0,
                        
                                                              16)
                        PRINT @uniqueid                                      
                        DECLARE @centreid INT
                        
                        SELECT  @centreid = TSCD.I_Centre_Id
                        FROM    dbo.T_Student_Center_Detail AS TSCD
                        WHERE   TSCD.I_Student_Detail_ID = @stddetailid
                                AND TSCD.I_Status = 1                                      
                            
                        SELECT  @stdcontact = TSD.S_Mobile_No
                        FROM    dbo.T_Student_Detail AS TSD
                        WHERE   TSD.I_Student_Detail_ID = @stddetailid
                        
                        --IF ( @centreid IN ( 18, 19 ) )
                        --    BEGIN
                            
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
                                  13 ,
                                  'Dear Student: Your Study Material (Id:'
                                  + @uniqueid
                                  + ') has been delivered to you. – RICE' ,
                                  @stddispatchheaderid ,
                                  5 ,
                                  1 ,
                                  'dba' ,
                                  GETDATE()
                                )
                                
                            --END
                                
                                
                    END
                            
                SET @startpos = @startpos + 1
                            
            END
                       
        EXEC SMManagement.uspGetStudentDetailsForDelivery @BrandID = @BrandID, -- int
            @HierarchyID = @HierarchyID, -- varchar(max)
            @CourseID = @CourseID -- int
                       


    END
