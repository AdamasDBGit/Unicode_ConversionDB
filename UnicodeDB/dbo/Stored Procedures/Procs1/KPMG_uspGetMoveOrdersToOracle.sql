
CREATE PROCEDURE [dbo].[KPMG_uspGetMoveOrdersToOracle] 
(
	
	@TopCount INT
	--@Context NVARCHAR(255)
)

AS

BEGIN TRY 
DECLARE @TEMP_MovIdTbl  TABLE ( MovId INT)
--IF @Context='BRANCH_TO_CCT'
	BEGIN
		SET ROWCOUNT 50
		
		--declare @sql nvarchar(max) = 'SELECT TOP ' +CONVERT(NVARCHAR(255), @TopCount)+ ' Fld_KPMG_Mo_Id FROM Tbl_KPMG_MoMaster WHERE  Fld_KPMG_Status=0 AND Fld_KPMG_ISCollected=''N'' ORDER BY [Fld_KPMG_Created Date] ';
		declare @sql nvarchar(max) = 'SELECT TOP 1 Fld_KPMG_Mo_Id FROM Tbl_KPMG_MoMaster WHERE  Fld_KPMG_Status=0 AND Fld_KPMG_ISCollected=''N'' ORDER BY [Fld_KPMG_Created Date] ';
		
		
		
		INSERT INTO @TEMP_MovIdTbl
		exec(@sql);					
		--SELECT  Fld_KPMG_Mo_Id  FROM Tbl_KPMG_MoMaster 
		--WHERE  Fld_KPMG_Status=0 AND Fld_KPMG_ISCollected='N' ORDER BY [Fld_KPMG_Created Date] 
		PRINT @sql
		
		SELECT  Mm.Fld_KPMG_Mo_Id,
				Mm.Fld_KPMG_Branch_Id,
				CASE WHEN Mm.Fld_KPMG_Context='BRANCH_TO_CCT' THEN TBR.fld_kpmg_OracleBranchName ELSE 'CCT Common' END AS S_Center_Name,		
				Mm.[Fld_KPMG_Created Date],
				Mm.Fld_KPMG_RequiredDate,
				Mm.Fld_KPMG_Context,
				CASE WHEN Mm.Fld_KPMG_Context='BRANCH_TO_CCT' THEN 'CCT Common' ELSE TBR.fld_kpmg_OracleBranchName END AS Fld_KPMG_From_Branch
				
				
		FROM	dbo.Tbl_KPMG_MoMaster Mm 
		INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON Mm.Fld_KPMG_Branch_Id=TCHND.I_Center_ID
		INNER JOIN Tbl_KPMG_BranchConfiguration TBR ON TCHND.S_Center_Name=TBR.fld_kpmg_BranchName
		WHERE Mm.Fld_KPMG_Mo_Id IN (SELECT MovId FROM @TEMP_MovIdTbl)
		
		--select * from @TEMP_MovIdTbl
		
		SELECT  Fld_KPMG_MoItem_Id,
				Fld_KPMG_Mo_Id,
				A.Fld_KPMG_Itemcode,
				Fld_KPMG_Quantity,
				B.Fld_KPMG_ItemType
				FROM dbo.Tbl_KPMG_MoItems A
				INNER JOIN Tbl_KPMG_SM_List B
				ON A.Fld_KPMG_Itemcode=B.Fld_KPMG_ItemCode
				--INNER JOIN @TEMP_MovIdTbl C ON A.Fld_KPMG_Mo_Id=C.MovId
				WHERE Fld_KPMG_Mo_Id IN (SELECT MovId FROM @TEMP_MovIdTbl)
		
		
		--
		Update Tbl_KPMG_MoMaster set Fld_KPMG_ISCollected='F' where Fld_KPMG_Mo_Id IN (SELECT MovId FROM @TEMP_MovIdTbl)
		--
		
     END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
