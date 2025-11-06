CREATE PROCEDURE [dbo].[uspGetReceipt]
    (
      @iInvoiceHeaderID INT
    )
AS
    BEGIN

        SELECT  RH.*
        FROM    T_Receipt_Header RH WITH (NOLOCK)
                INNER JOIN T_Invoice_Parent IP WITH (NOLOCK) ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
        WHERE   IP.I_Invoice_Header_ID = @iInvoiceHeaderID
                AND RH.I_Status = 1
        OPTION  ( MAXDOP 1 )


        SELECT  RCD.*
        FROM    T_Receipt_Component_Detail RCD WITH (NOLOCK)
                INNER JOIN T_Receipt_Header RH WITH (NOLOCK) ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
                INNER JOIN T_Invoice_Parent IP WITH (NOLOCK) ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
        WHERE   IP.I_Invoice_Header_ID = @iInvoiceHeaderID
                AND RH.I_Status = 1
        OPTION  ( MAXDOP 1 )

        SELECT  RTD.*
        FROM    T_Receipt_Tax_Detail RTD WITH (NOLOCK)
                INNER JOIN T_Receipt_Component_Detail RCD WITH (NOLOCK) ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
                INNER JOIN T_Receipt_Header RH WITH (NOLOCK) ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
                INNER JOIN T_Invoice_Parent IP WITH (NOLOCK) ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
        WHERE   IP.I_Invoice_Header_ID = @iInvoiceHeaderID
                AND RH.I_Status = 1
        OPTION  ( MAXDOP 1 )
    END
