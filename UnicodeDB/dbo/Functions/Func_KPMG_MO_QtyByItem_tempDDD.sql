
-- =============================================
-- Author:		<Author,,Pramatha Nath Ghosh>
-- Create date: <Create Date, ,31-03-2014> 
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[Func_KPMG_MO_QtyByItem_tempDDD] 
(
	-- Add the parameters for the function here
	@ItemCode varchar(50),
	@Course_Id	int,
	@Centre_Id int	
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	declare @lastDate date = DATEADD(DD,-1,GETDATE())
	declare @firstDate date = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,Getdate()))-1),DATEADD(mm,1,Getdate())),101)
	declare @intCurProjection int = 0;
	declare @intNextProjection int = 0;
	declare @intCurBuffer int = 0;
	declare @intNextBuffer int = 0;
	declare @intMTD_Consumption int = 0;
	declare @intMTD_Stock int = 0;	
	
	DECLARE @projectedMonth INT=MONTH(DATEADD(MM,1,Getdate()))	
	DECLARE @projectedYear INT=YEAR(DATEADD(MM,1,Getdate()));
	
	--DECLARE @projectedNextMonth INT=MONTH(DATEADD(MM,2,Getdate()))	
	--DECLARE @projectedNextYear INT=YEAR(DATEADD(MM,2,Getdate()));
	DECLARE @historicalprojectedYear INT=YEAR(DATEADD(YY,-1,DATEADD(MM,2,GETDATE())));
	DECLARE @historicalprojectedMonth INT=MONTH(DATEADD(MM,2,GETDATE()))	
	
	
	IF EXISTS(SELECT 1 FROM Tbl_KPMG_Projection_tempDDD where Fld_KPMG_Month = @projectedMonth AND Fld_KPMG_Year = @projectedYear AND Fld_KPMG_Branch_Id = @Centre_Id AND Fld_KPMG_Course_Id = @Course_Id)
	BEGIN
		Select @intCurProjection = Fld_KPMG_Projection from Tbl_KPMG_Projection_tempDDD where Fld_KPMG_Month = @projectedMonth AND Fld_KPMG_Year = @projectedYear AND Fld_KPMG_Branch_Id = @Centre_Id AND Fld_KPMG_Course_Id = @Course_Id
	END
	ELSE
	BEGIN
		Select @intCurProjection = Fld_KPMG_Projection from Tbl_KPMG_ProjectionHistorical where Fld_KPMG_Month = @historicalprojectedMonth AND Fld_KPMG_Year = @historicalprojectedYear AND Fld_KPMG_Branch_Id = @Centre_Id AND Fld_KPMG_Course_Id = @Course_Id
	END
	Select @intNextProjection = Fld_KPMG_Projection from Tbl_KPMG_ProjectionHistorical where Fld_KPMG_Month = @historicalprojectedMonth AND Fld_KPMG_Year = @historicalprojectedYear AND Fld_KPMG_Branch_Id = @Centre_Id AND Fld_KPMG_Course_Id = @Course_Id
	
	Select @intCurBuffer = Fld_KPMG_BufferStock from Tbl_KPMG_Projection_tempDDD where Fld_KPMG_Month = @projectedMonth AND Fld_KPMG_Year = @projectedYear AND Fld_KPMG_Branch_Id = @Centre_Id AND Fld_KPMG_Course_Id = @Course_Id
	
	Select @intNextBuffer = Fld_KPMG_BufferStock from Tbl_KPMG_ProjectionHistorical where Fld_KPMG_Month= @historicalprojectedMonth AND Fld_KPMG_Year = @historicalprojectedYear AND Fld_KPMG_Branch_Id = @Centre_Id AND Fld_KPMG_Course_Id = @Course_Id
	
	Select @intMTD_Consumption = Count(smisu.Fld_KPMG_StudentId) from Tbl_KPMG_SM_Issue smisu INNER JOIN T_Student_Batch_Details sbd ON sbd.I_Student_ID = smisu.Fld_KPMG_StudentId INNER JOIN T_Center_Batch_Details cbd ON cbd.I_Batch_ID = sbd.I_Batch_ID	where cbd.I_Centre_Id =  @Centre_Id AND smisu.FLD_KPMG_ItemCode = @ItemCode AND Fld_KPMG_IssueDate between @firstDate and @lastDate
	
	Select @intMTD_Stock = Count(dtls.Fld_KPMG_Barcode) from Tbl_KPMG_StockDetails dtls INNER JOIN Tbl_KPMG_SM_Map map ON dtls.Fld_KPMG_Barcode = map.Fld_KPMG_Barcode where dtls.Fld_KPMG_isIssued = 0 AND map.Fld_KPMG_ItemCode = @ItemCode
	
				
	Return ((@intCurProjection - @intMTD_Consumption) - @intMTD_Stock + @intNextProjection + @intNextBuffer - @intCurBuffer)	
	-- Return ( Convert(Nvarchar(max),@intCurProjection) + ' , ' +  Convert(Nvarchar(max),@intNextProjection )+ ' , ' +  Convert(Nvarchar(max),@intCurBuffer) + ' , ' +  Convert(Nvarchar(max),@intMTD_Consumption) + ' , ' + Convert(Nvarchar(max),@intMTD_Consumption ))
--Return 'ssss'
	 
END