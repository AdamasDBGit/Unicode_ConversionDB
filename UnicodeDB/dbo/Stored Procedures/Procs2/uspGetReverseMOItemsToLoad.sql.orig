
CREATE PROCEDURE [dbo].[uspGetReverseMOItemsToLoad] 
(
	@ItemCode VARCHAR(MAX),
	@MoveOrderNo INT,
	@Context NVARCHAR(50)
)

AS
BEGIN
	
	IF ISNULL(@MoveOrderNo,0) > 0 AND 
		EXISTS(SELECT 1 FROM Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_MoId = @MoveOrderNo)
	BEGIN
		IF ISNULL(@Context,'') = 'LOAD'
		BEGIN
			IF ISNULL(@ItemCode,'') ='-None-'
			BEGIN
				print'1'
				SELECT A.Fld_KPMG_Id as SLNo, A.Fld_KPMG_ItemCode as ItemCode, A.Fld_KPMG_BarCode as BarCode,0 as IsIssued,
				CASE A.Fld_KPMG_Status WHEN 5 THEN 'Printer' ELSE 'RICE' END AS Defaulter,
				C.S_Course_Name AS CourseName		
				FROM Tbl_KPMG_ReverseMOItems A				
				INNER JOIN Tbl_KPMG_SM_List B ON A.Fld_KPMG_ItemCode=B.Fld_KPMG_ItemCode 
				INNER JOIN T_Course_Master C ON B.Fld_KPMG_CourseId=C.I_Course_ID 
				WHERE A.Fld_KPMG_MoId = @MoveOrderNo and A.Fld_KPMG_IsLoadedFromBranch = 'N'
				
				ORDER BY SLNo
			END
			ELSE
			BEGIN
				SELECT A.Fld_KPMG_Id as SLNo, A.Fld_KPMG_ItemCode as ItemCode, A.Fld_KPMG_BarCode as BarCode,0 as IsIssued,
				CASE A.Fld_KPMG_Status WHEN 5 THEN 'Printer' ELSE 'RICE' END AS Defaulter ,		
				C.S_Course_Name AS CourseName		
				FROM Tbl_KPMG_ReverseMOItems A				
				INNER JOIN Tbl_KPMG_SM_List B ON A.Fld_KPMG_ItemCode=B.Fld_KPMG_ItemCode 
				INNER JOIN T_Course_Master C ON B.Fld_KPMG_CourseId=C.I_Course_ID 
				WHERE A.Fld_KPMG_MoId = @MoveOrderNo AND A.Fld_KPMG_ItemCode = @ItemCode and A.Fld_KPMG_IsLoadedFromBranch = 'N'
				
				ORDER BY SLNo
			END
			
		END
	END
	
END
