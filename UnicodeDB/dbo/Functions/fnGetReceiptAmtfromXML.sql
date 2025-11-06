CREATE FUNCTION [dbo].[fnGetReceiptAmtfromXML] ( @XML XML )
RETURNS DECIMAL(14, 2)
AS
    BEGIN

        DECLARE @ReceiptAmount DECIMAL(14, 2)= 0.00
        DECLARE @count INT= 0
        DECLARE @startpos INT= 1
        
        --PRINT @ReceiptAmount

        SET @count = @XML.value('count((TblRctCompDtl/RowRctCompDtl))', 'int')

        WHILE ( @startpos <= @count )
            BEGIN

                DECLARE @ReceiptDetailXML XML

                SET @ReceiptDetailXML = @XML.query('/TblRctCompDtl/RowRctCompDtl[position()=sql:variable("@startpos")]')

                SET @ReceiptAmount = @ReceiptAmount
                    + ( SELECT  T.a.value('@N_Amount_Paid', 'decimal(14,2)')
                        FROM    @ReceiptDetailXML.nodes('/RowRctCompDtl') T ( a )
                      )
                      
                --PRINT @ReceiptAmount       
                                                       
                SET @startpos = @startpos + 1                                                       


            END



        RETURN @ReceiptAmount

    END