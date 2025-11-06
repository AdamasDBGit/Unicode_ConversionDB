CREATE PROCEDURE [dbo].[uspSendSMSForOnlinePayments]
    (
      @iBrandID INT ,
      @sTransactionNo NVARCHAR(max)
    )
AS
    BEGIN

        DECLARE @Amount DECIMAL(14, 2)
        DECLARE @Component nvarchar(max)
        DECLARE @studentname nvarchar(max)
        DECLARE @stdid INT
        DECLARE @sReceiptIDs nvarchar(max)
        DECLARE @endgreeting nvarchar(max)
        DECLARE @ContactNo nvarchar(max)


        IF @iBrandID = 109
            SET @endgreeting = 'Team RICE Education'
        ELSE IF @iBrandID=107
			SET @endgreeting='Team AIS'
		ELSE IF @iBrandID=110
			SET @endgreeting='Team AWS'		    


        SELECT  @sReceiptIDs = COALESCE(@sReceiptIDs + ',', ',', '')
                + CAST(TOPRM.I_Receipt_Header_ID AS VARCHAR)
        FROM    dbo.T_OnlinePayment_Receipt_Mapping AS TOPRM
        WHERE   TOPRM.S_Transaction_No = @sTransactionNo



        SELECT  @stdid = T1.I_Student_Detail_ID ,
                @studentname = T1.S_First_Name ,
                @ContactNo = T1.ContactNo ,
                @Amount = T1.TotalAmount
        FROM    ( SELECT    TSD.I_Student_Detail_ID ,
                            TSD.S_First_Name ,
                            ISNULL(TSD.S_Mobile_No, '') AS ContactNo ,
                            SUM(ISNULL(TRH.N_Receipt_Amount, 0)
                                + ISNULL(TRH.N_Tax_Amount, 0)) AS TotalAmount
                  FROM      dbo.T_Receipt_Header AS TRH
                            INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TRH.I_Student_Detail_ID
                  WHERE     TRH.I_Receipt_Header_ID IN (
                            SELECT  CAST(FSR.Val AS INT)
                            FROM    dbo.fnString2Rows(@sReceiptIDs, ',') AS FSR )
                  GROUP BY  TSD.I_Student_Detail_ID ,
                            TSD.S_First_Name ,
                            ISNULL(TSD.S_Mobile_No, '')
                ) T1


        SELECT  @Component = COALESCE(@Component, ', ', '') + T1.ComponentName
        FROM    ( SELECT DISTINCT
                            TFCM.S_Component_Name + ',' AS ComponentName
                  FROM      dbo.T_Receipt_Header AS TRH
                            INNER JOIN dbo.T_Receipt_Component_Detail AS TRCD ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                            INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                            INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID
                  WHERE     TRH.I_Receipt_Header_ID IN (
                            SELECT  CAST(FSR.Val AS INT)
                            FROM    dbo.fnString2Rows(@sReceiptIDs, ',') AS FSR )
                            AND TRH.I_Status = 1
                            AND TRH.I_Receipt_Type = 2
                  UNION ALL
                  SELECT DISTINCT
                            TSM.S_Status_Desc + ',' AS ComponentName
                  FROM      dbo.T_Receipt_Header AS TRH2
                            INNER JOIN dbo.T_Status_Master AS TSM ON TRH2.I_Receipt_Type = TSM.I_Status_Value
                  WHERE     TRH2.I_Receipt_Header_ID IN (
                            SELECT  CAST(FSR.Val AS INT)
                            FROM    dbo.fnString2Rows(@sReceiptIDs, ',') AS FSR )
                            AND TRH2.I_Status = 1
                            AND TSM.S_Status_Type = 'ReceiptType'
                            AND TRH2.I_Receipt_Type <> 2
                ) T1

        SET @Component = SUBSTRING(@Component, 2, LEN(@Component) - 2)
        
        
        IF ( @ContactNo IS NOT NULL
             AND @ContactNo != ''
           )
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
                VALUES  ( @ContactNo ,
                          @stdid ,
                          10 ,
                          'Dear ' + @studentname + ' , thanks for paying '
                          + CAST(@Amount AS VARCHAR) + ' towards '
                          + @Component + '.We wish you all the success.'
                          + @endgreeting ,
                          @iBrandID ,
                          1 ,
                          1 ,
                          'rice-group-admin' ,
                          GETDATE()
                        )


        --SELECT  'Dear ' + @studentname + ' , thanks for paying ' + CAST(@Amount AS VARCHAR)
        --        + ' towards ' + @Component + '.We wish you all the success.'
        --        + @endgreeting
                
            END
                


    END


