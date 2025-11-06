



-- =============================================
-- Author:		<Pramatha Nath Ghosh>
-- Create date: <05-21-2014,>
-- Description:	<For Report>
-- =============================================
CREATE PROCEDURE [dbo].[KPMG_uspGetStockByBranch]
(		
	@Branch_Id INT,	
	@Month int,
	@Year int
)
AS

BEGIN
SET NOCOUNT ON

		Declare @Date Datetime
				
		SELECT @Date = DateAdd(dd, 0, DateAdd(mm, @Month -1, DateAdd(yy, @Year - 2000, '20000101')))

		Select stcIntake.CenterName,stcIntake.ItemCode,stcIntake.Quantity - stcConsump.Isu_Qty as BeginnigStock,stcMonIssu.IsuQty as Consumption,((stcIntake.Quantity - stcConsump.Isu_Qty) - stcMonIssu.IsuQty) as CurrentStock from
		   (Select Cm.S_Center_Name as CenterName, 
		   Sm.Fld_KPMG_ItemCode as ItemCode, 
		   Count(Sd.Fld_KPMG_Barcode) as Quantity from Tbl_KPMG_StockMaster Sm 
						 Inner Join Tbl_KPMG_StockDetails Sd ON Sd.Fld_KPMG_Stock_Id = Sm.Fld_KPMG_Stock_Id
						 Inner Join T_Centre_Master Cm ON Cm.I_Centre_Id = Sm.Fld_KPMG_Branch_Id					 																  
			Group By  Cm.S_Center_Name,Sm.Fld_KPMG_ItemCode,Sm.Fld_KPMG_Branch_Id,Sd.Fld_KPMG_Status,Sd.Fld_KPMG_Date
			Having Sm.Fld_KPMG_Branch_Id = @Branch_Id   -- Sd.Fld_KPMG_Status = '0'  AND
			AND Sd.Fld_KPMG_Date < @Date)stcIntake 
		
			INNER JOIN 
	
			(Select Cm.S_Center_Name  as Center_Name,
					Si.Fld_KPMG_ItemCode as Item_Code,					
					COUNT(Si.Fld_KPMG_Barcode) as Isu_Qty
			 from T_Student_Detail Sd 
					INNER JOIN Tbl_KPMG_SM_Issue Si ON Sd.I_Student_Detail_ID = Si.Fld_KPMG_StudentId
					INNER JOIN T_Student_Batch_Details Bd ON Sd.I_Student_Detail_ID = Bd.I_Student_ID
					INNER JOIN T_Center_Batch_Details Cbd ON Bd.I_Batch_ID = Cbd.I_Batch_ID
					INNER JOIN T_Centre_Master Cm ON Cm.I_Centre_Id = Cbd.I_Centre_Id
			 Group By Cm.S_Center_Name,Si.Fld_KPMG_ItemCode,Si.Fld_KPMG_IssueDate,Si.Fld_KPMG_Context
			 Having Si.Fld_KPMG_IssueDate < @Date AND Si.Fld_KPMG_Context = 'Issued'
			)stcConsump ON stcIntake.ItemCode COLLATE DATABASE_DEFAULT = stcConsump.Item_Code COLLATE DATABASE_DEFAULT AND stcIntake.CenterName = stcConsump.Center_Name									
			INNER JOIN 			
			(Select Cm.S_Center_Name  as Center_Name,
					Si.Fld_KPMG_ItemCode as ItemCode,					
					COUNT(Si.Fld_KPMG_Barcode) as IsuQty
			 from T_Student_Detail Sd 
					INNER JOIN Tbl_KPMG_SM_Issue Si ON Sd.I_Student_Detail_ID = Si.Fld_KPMG_StudentId
					INNER JOIN T_Student_Batch_Details Bd ON Sd.I_Student_Detail_ID = Bd.I_Student_ID
					INNER JOIN T_Center_Batch_Details Cbd ON Bd.I_Batch_ID = Cbd.I_Batch_ID
					INNER JOIN T_Centre_Master Cm ON Cm.I_Centre_Id = Cbd.I_Centre_Id
			 Group By Si.Fld_KPMG_ItemCode,	Cm.S_Center_Name,Si.Fld_KPMG_IssueDate,Si.Fld_KPMG_Context
			 Having Month(Si.Fld_KPMG_IssueDate) = @Month AND YEAR(Si.Fld_KPMG_IssueDate) = @Year AND Si.Fld_KPMG_Context = 'Issued'
			)stcMonIssu ON stcIntake.ItemCode COLLATE DATABASE_DEFAULT = stcMonIssu.ItemCode COLLATE DATABASE_DEFAULT AND stcIntake.CenterName = stcMonIssu.Center_Name
	



END
