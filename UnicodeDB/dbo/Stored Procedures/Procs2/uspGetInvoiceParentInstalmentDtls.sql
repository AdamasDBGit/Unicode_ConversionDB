CREATE PROCEDURE [dbo].[uspGetInvoiceParentInstalmentDtls]
AS
BEGIN

CREATE TABLE #temp1 ( InvoiceNo VARCHAR(MAX) )
CREATE TABLE #temp2
    (
      RevisedInvoiceNo VARCHAR(MAX) ,
      InvoiceHeaderID INT ,
      InvoiceNo VARCHAR(MAX) ,
      InvoiceChildHeaderID INT ,
      InstalmentDate DATE ,
      InstalmentNo INT ,
      AmountDue DECIMAL(14, 2)
    )



INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83071' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83074' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82725' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82729' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82731' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82760' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82764' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82730' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83031' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83029' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83035' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83068' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82985' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83034' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83070' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83038' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83033' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83030' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83028' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83032' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83027' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82986' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83036' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83039' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82989' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82990' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82991' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82979' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82783' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82784' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82977' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82767' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82984' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82983' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82779' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82773' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82774' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82981' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82777' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82786' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83098' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83100' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83096' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83093' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83099' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83090' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83092' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83101' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83046' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83041' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83047' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83049' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83050' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83055' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83051' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83048' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83044' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83054' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83045' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83085' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83083' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83082' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83081' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83080' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83109' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83079' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '81981' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '81994' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '81988' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82872' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82875' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82883' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82901' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82902' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82903' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82905' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82904' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82906' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82907' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82908' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82909' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82910' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82912' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82911' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82918' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82987' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82988' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82922' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82937' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82940' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82944' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82945' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82948' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82949' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82951' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82952' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82954' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82957' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82845' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82828' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82685' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82846' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82842' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82843' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82861' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82856' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82834' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82811' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82807' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82798' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82780' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82716' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82717' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82718' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82719' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82721' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82722' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82723' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82748' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82743' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82751' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82753' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82754' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82755' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82756' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82757' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82758' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82759' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82761' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82768' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82770' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82778' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82927' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82793' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82795' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82796' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82797' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82801' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82802' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82803' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82804' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82805' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82806' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82809' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82810' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82816' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82817' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82818' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82819' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82820' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82821' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82822' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82823' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82824' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82829' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82830' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82831' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82833' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82836' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82839' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82841' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82864' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '82867' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83501' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83503' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83506' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83507' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83509' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83511' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83518' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83519' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83524' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83525' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83526' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83527' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83528' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83529' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83530' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83532' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83537' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83538' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83539' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83548' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83549' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83551' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83552' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83553' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83554' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83643' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83540' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83541' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83542' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83543' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83544' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83545' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83546' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83547' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83591' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83614' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83616' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83618' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83619' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83629' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83630' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83631' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83632' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83634' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83636' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83637' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83638' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83640' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83641' )
INSERT  INTO #temp1
        ( InvoiceNo )
VALUES  ( '83642' )

DECLARE @InvNo VARCHAR(MAX)

DECLARE Inv CURSOR
FOR SELECT InvoiceNo FROM #temp1

OPEN Inv
FETCH NEXT FROM Inv
INTO @InvNo

WHILE @@FETCH_STATUS = 0 
    BEGIN

        INSERT  INTO #temp2
                ( RevisedInvoiceNo ,
                  InvoiceHeaderID ,
                  InvoiceNo ,
                  InvoiceChildHeaderID ,
                  InstalmentDate ,
                  InstalmentNo ,
                  AmountDue
                )
                SELECT  @InvNo AS RevisedInvoiceNo ,
                        TIP.I_Invoice_Header_ID ,
                        TIP.S_Invoice_No ,
                        TICH.I_Invoice_Child_Header_ID ,
                        TICD.Dt_Installment_Date ,
                        TICD.I_Installment_No ,
                        TICD.N_Amount_Due
                FROM    dbo.T_Invoice_Parent TIP
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                WHERE   TCHND.I_Brand_ID = 109
                        AND TIP.I_Invoice_Header_ID IN (
                        SELECT  TIP2.I_Parent_Invoice_ID
                        FROM    dbo.T_Invoice_Parent TIP2
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND2 ON TIP2.I_Centre_Id = TCHND2.I_Center_ID
                        WHERE   TCHND2.I_Brand_ID = 109
                                AND TIP2.S_Invoice_No = @InvNo )
                        AND TICD.Dt_Installment_Date >= '2016-03-01'

--SELECT * FROM dbo.T_Invoice_Parent TIP WHERE S_Invoice_No='83071'

        FETCH NEXT FROM Inv
INTO @InvNo

    END



CLOSE Inv ;
DEALLOCATE Inv ;

SELECT  *
FROM    #temp2 ;

END
