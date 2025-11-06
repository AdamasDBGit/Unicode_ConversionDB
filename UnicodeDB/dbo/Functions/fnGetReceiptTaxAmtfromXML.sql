CREATE FUNCTION [dbo].[fnGetReceiptTaxAmtfromXML] ( @XML XML )
RETURNS DECIMAL(14, 2)
AS
    BEGIN

        DECLARE @ReceiptTaxAmount DECIMAL(14, 2)= 0.00
        DECLARE @count INT= 0
        DECLARE @startpos INT= 1
        
        --PRINT @ReceiptTaxAmount

        SET @count = @XML.value('count((TblRctCompDtl/RowRctCompDtl))', 'int')

        WHILE ( @startpos <= @count )
            BEGIN

                DECLARE @ReceiptDetailXML XML
                DECLARE @InnerCount INT= 0
                DECLARE @innerstartpos INT= 1

                SET @ReceiptDetailXML = @XML.query('/TblRctCompDtl/RowRctCompDtl[position()=sql:variable("@startpos")]')
                
                SET @InnerCount  = @ReceiptDetailXML.value('count((RowRctCompDtl/TblRctTaxDtl/RowRctTaxDtl))',
                                                     'int')
                
                WHILE ( @innerstartpos <= @InnerCount )
                    BEGIN
                
                        DECLARE @TaxXML XML
                
                        SET @TaxXML = @ReceiptDetailXML.query('RowRctCompDtl/TblRctTaxDtl/RowRctTaxDtl[position()=sql:variable("@innerstartpos")]')
                
                        SET @ReceiptTaxAmount = @ReceiptTaxAmount
                            + ( SELECT  T.b.value('@N_Tax_Paid',
                                                  'decimal(14,2)')
                                FROM    @TaxXML.nodes('/RowRctTaxDtl') T ( b )
                              )
                        
                        
                        SET @innerstartpos = @innerstartpos + 1        
                
                    END
                
                
                

                      
                --PRINT @ReceiptAmount       
                                                       
                SET @startpos = @startpos + 1                                                       


            END



        RETURN @ReceiptTaxAmount

    END