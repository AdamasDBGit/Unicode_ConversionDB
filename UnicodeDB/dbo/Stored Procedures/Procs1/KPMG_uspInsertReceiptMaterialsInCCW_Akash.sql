  
CREATE PROCEDURE [dbo].[KPMG_uspInsertReceiptMaterialsInCCW_Akash]
    @OraclePoId NVARCHAR(MAX) ,
    @XMLData XML
AS
    BEGIN TRY   
  
        PRINT 1  
   
        DECLARE @TempTable TABLE
            (
              ID INT IDENTITY ,
              LineId VARCHAR(100) ,
              BarCode VARCHAR(100) ,
              ItemId VARCHAR(100)
            )
         
              
        DECLARE @ItemTable TABLE
            (
              ID INT IDENTITY ,
              ItemId VARCHAR(100)
            )  
        IF EXISTS ( SELECT  1
                    FROM    Tbl_KPMG_PoDetails
                    WHERE   OraclePoId = ISNULL(@OraclePoId, '')
                            AND Fld_KPMG_Status = 0 )
            BEGIN  
   
                INSERT  INTO @TempTable
                        ( LineId ,
                          BarCode ,
                          ItemId
                        )
                        SELECT  T.c.value('LineId[1]', 'NVARCHAR(255)') ,
                                T.c.value('SerialNo[1]', 'NVARCHAR(255)') ,
                                T.c.value('ItemId[1]', 'NVARCHAR(255)')
                        FROM    @XMLData.nodes('/Root/TestRTemp') T ( c )   
 
                DELETE  FROM @TempTable
                WHERE   BarCode IN ( SELECT Fld_KPMG_Barcode
                                     FROM   Tbl_KPMG_StockDetails
                                     WHERE  BarCode = Fld_KPMG_Barcode )    
    
                UPDATE  Tbl_KPMG_PoDetailItems
                SET     Fld_KPMG_Status = 1
                FROM    Tbl_KPMG_PoDetailItems (NOLOCK) A
                        JOIN @TempTable B ON A.OracleLinieId = B.LineId
                                             AND A.Fld_KPMG_Barcode = B.BarCode  
    
 
    
  --commented  update Tbl_KPMG_PoDetailItems set Fld_KPMG_Status = 4 where Fld_KPMG_Status= 1  
                
  -- commented   UPDATE Tbl_KPMG_PoDetails SET Fld_KPMG_Status = 1 FROM  Tbl_KPMG_PoDetails A  
  --commented  JOIN Tbl_KPMG_PoDetailItems B ON A.Fld_KPMG_PoPr_Id = B.Fld_KPMG_PoPr_Id     
            END  
   
        DECLARE @GENID INT  
        DECLARE @Row_Count INT  
        DECLARE @Counter INT  
        DECLARE @ItemCode VARCHAR(100)  
   
        INSERT  INTO @ItemTable
                ( ItemId
                )
                SELECT DISTINCT
                        ( ItemId )
                FROM    @TempTable  
   
        SELECT  @Row_Count = COUNT(DISTINCT ( ItemId ))
        FROM    @ItemTable  
        SET @Counter = 1  
   
        WHILE @Counter <= @Row_Count
            BEGIN  
    
                SELECT  @ItemCode = ItemId
                FROM    @ItemTable
                WHERE   ID = @Counter  
                IF ISNULL(@ItemCode, '') <> ''
                    BEGIN  
     
                        INSERT  INTO Tbl_KPMG_StockMaster
                                ( Fld_KPMG_ItemCode ,
                                  Fld_KPMG_Branch_Id ,
                                  Fld_KPMG_IsMo ,
                                  Fld_KPMG_FromBranch_Id ,
                                  Fld_KPMG_LastRecvDate ,
                                  Fld_KPMG_Mo_Id
                                )
                        VALUES  ( @ItemCode ,
                                  0 ,
                                  1 ,
                                  0 ,
                                  GETDATE() ,
                                  0
                                )  
                        SELECT  @GENID = @@IDENTITY  
     
                        INSERT  INTO Tbl_KPMG_StockDetails
                                ( Fld_KPMG_Stock_Id ,
                                  Fld_KPMG_Barcode
                                )
                                SELECT  @GENID ,
                                        BarCode
                                FROM    @TempTable
                                WHERE   ItemId = @ItemCode  
     
   --commented exec KPMG_uspInsertLoadAllocation @ItemCode  
    
                    END  
     
    
                SET @ItemCode = ''  
                SET @Counter = @Counter + 1   
            END  
   
        DECLARE @COUNT INT  
        DECLARE @TOTAL_COUNT INT  
        DECLARE @PO_PR_Id INT  
        SELECT  @PO_PR_Id = Fld_KPMG_PoPr_Id
        FROM    Tbl_KPMG_PoDetails
        WHERE   OraclePoId = @OraclePoId  
        SELECT  @COUNT = COUNT(*)
        FROM    Tbl_KPMG_PoDetailItems
        WHERE   Fld_KPMG_Status = 2
                OR Fld_KPMG_Status = 1
                AND Fld_KPMG_PoPr_Id = @PO_PR_Id  
        SELECT  @TOTAL_COUNT = COUNT(*)
        FROM    Tbl_KPMG_PoDetailItems
        WHERE   Fld_KPMG_PoPr_Id = @PO_PR_Id  
   
        IF ( @COUNT = @TOTAL_COUNT )
            BEGIN  
                UPDATE  Tbl_KPMG_PoDetails
                SET     Fld_KPMG_Status = 1
                WHERE   Fld_KPMG_PoPr_Id = @PO_PR_Id  
            END  
   
	DELETE FROM @TempTable
	DELETE FROM @ItemTable
  
    END TRY  
    BEGIN CATCH  
   
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT  
  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
    END CATCH

