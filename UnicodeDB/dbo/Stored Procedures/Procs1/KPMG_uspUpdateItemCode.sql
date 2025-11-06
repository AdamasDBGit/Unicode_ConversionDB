
CREATE PROCEDURE [dbo].[KPMG_uspUpdateItemCode]
@XmlData XML
AS
BEGIN TRY 

DECLARE @TEMP_ORACLE_ITEMS TABLE(ItemCode NVARCHAR(max) ,ItemDescription NVARCHAR(max),ItemSegment NVARCHAR(max))

INSERT INTO @TEMP_ORACLE_ITEMS(ItemCode,ItemDescription,ItemSegment)
SELECT 
                        T.c.value('ItemCode[1]', 'NVARCHAR(max)') ,
                        T.c.value('ItemDescription[1]', 'NVARCHAR(max)') ,
                        T.c.value('ItemSegment[1]', 'NVARCHAR(max)')                         
                        
                FROM    @XmlData.nodes('/Root/Item') T ( c )   
                
       
       UPDATE A SET A.Fld_KPMG_ItemCode=B.ItemCode ,A.Fld_KPMG_IsValid='Y' FROM Tbl_KPMG_SM_List A INNER JOIN  @TEMP_ORACLE_ITEMS B ON A.Fld_KPMG_Segment=B.ItemSegment 



END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

