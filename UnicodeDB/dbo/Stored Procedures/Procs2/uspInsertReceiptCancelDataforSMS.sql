CREATE PROCEDURE [dbo].[uspInsertReceiptCancelDataforSMS]
    (
      @iReceiptHeaderID INT ,
      @iFlag INT
    )
AS 
    BEGIN
	
        DECLARE @iStatus INT ;
        DECLARE @iBrandID INT ;
        DECLARE @MobileNo nvarchar(max) ;
        DECLARE @ChequeNo nvarchar(max) ;
        DECLARE @iStudentDetailID INT;
        DECLARE @iCentreID INT;
        
        
        SELECT @iStudentDetailID=I_Student_Detail_ID FROM dbo.T_Receipt_Header TRH WHERE I_Receipt_Header_ID=@iReceiptHeaderID
        SELECT @iCentreID=I_Centre_Id FROM dbo.T_Receipt_Header TRH WHERE I_Receipt_Header_ID=@iReceiptHeaderID
                
        DECLARE @Bank nvarchar(max) ;
        DECLARE @ChequeDate DATE ;

        SELECT  @iBrandID = I_Brand_ID
        FROM    dbo.T_Center_Hierarchy_Name_Details TCHND
        WHERE   I_Center_ID = @iCentreID

        SELECT  @iStatus = I_Status
        FROM    dbo.T_Receipt_Header TRH
        WHERE   I_Receipt_Header_ID = @iReceiptHeaderID

        IF ( @iStatus = 0
             AND @iFlag = 1
           ) 
            BEGIN

	
                SELECT  @MobileNo = S_Mobile_No
                FROM    dbo.T_Student_Detail TSD
                WHERE   I_Student_Detail_ID = @iStudentDetailID
                SELECT  @ChequeNo = S_ChequeDD_No
                FROM    dbo.T_Receipt_Header TRH
                WHERE   I_Receipt_Header_ID = @iReceiptHeaderID
                SELECT  @Bank = S_Bank_Name
                FROM    dbo.T_Receipt_Header TRH
                WHERE   I_Receipt_Header_ID = @iReceiptHeaderID
                SELECT  @ChequeDate = Dt_ChequeDD_Date
                FROM    dbo.T_Receipt_Header TRH
                WHERE   I_Receipt_Header_ID = @iReceiptHeaderID
	
                IF ( @iBrandID <> 109 ) 
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
                        VALUES  ( @MobileNo , -- S_MOBILE_NO - nvarchar(max)
                                  @iStudentDetailID , -- I_SMS_STUDENT_ID - int
                                  7 , -- I_SMS_TYPE_ID - int
                                  'Dear Student, Your cheque No '
                                  + CAST(@ChequeNo AS VARCHAR) + ' drawn on '
                                  + CAST (@Bank AS VARCHAR) + ' dated '
                                  + CAST(CONVERT(DATE,@ChequeDate) AS VARCHAR)
                                  + ' has been cancelled-Adamas' , -- S_SMS_BODY - nvarchar(max)
                                  @iReceiptHeaderID , -- I_REFERENCE_ID - int
                                  1 , -- I_REFERENCE_TYPE_ID - int
                                  1 , -- I_Status - int
                                  'dba' , -- S_Crtd_By - nvarchar(max)
                                  GETDATE()  -- Dt_Crtd_On - datetime
	          
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
                        VALUES  ( @MobileNo , -- S_MOBILE_NO - nvarchar(max)
                                  @iStudentDetailID , -- I_SMS_STUDENT_ID - int
                                  7 , -- I_SMS_TYPE_ID - int
                                  'Dear Student, Your cheque No '
                                  + CAST(@ChequeNo AS VARCHAR) + ' drawn on '
                                  + CAST (@Bank AS VARCHAR) + ' dated '
                                  + CAST(CONVERT(DATE,@ChequeDate) AS VARCHAR)
                                  + ' has been cancelled-RICE' , -- S_SMS_BODY - nvarchar(max)
                                  @iReceiptHeaderID , -- I_REFERENCE_ID - int
                                  1 , -- I_REFERENCE_TYPE_ID - int
                                  1 , -- I_Status - int
                                  'dba' , -- S_Crtd_By - nvarchar(max)
                                  GETDATE()  -- Dt_Crtd_On - datetime
	          
	                          )
                    END
            END
    END
