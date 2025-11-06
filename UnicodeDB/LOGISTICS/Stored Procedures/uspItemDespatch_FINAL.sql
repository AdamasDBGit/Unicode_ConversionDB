CREATE PROCEDURE [LOGISTICS].[uspItemDespatch_FINAL]
(
		@dtFromDate		DATETIME	= NULL		,
		@dtToDate		DATETIME	= NULL		
)
WITH 
EXECUTE AS CALLER
AS
BEGIN
    DECLARE @Index int,@Count Int,@CentreName varchar(200),
			@FinalName varchar(200),@Pre_CentreName varchar(200),
			@Pre_FinalName varchar(200)

    Declare @tmp_despatch table
	(
	 Row_Id int  identity(1,1),
	 I_Student_Detail_ID int,
	 CenterName  varchar(200),
     S_Item_Code varchar(200),
	 S_Item_Desc varchar(200),
	 Final_Name  varchar(200),
	 Item_Quantity varchar(200)
	)
	
    INSERT INTO @tmp_despatch
	SELECT 
			ISNULL(SD.I_Student_Detail_ID, 0) AS I_Student_Detail_ID
  		   ,ISNULL(CM.S_Center_Name,' ') AS S_Center_Name
		   ,ISNULL(LM.S_Item_Code, ' ') AS S_Item_Code			 
		   ,ISNULL(LM.S_Item_Desc,' ') AS S_Item_Desc 
		   ,ISNULL(SD.S_First_Name,' ')  +' '+ ISNULL(SD.S_Middle_Name,' ')  +' '+ ISNULL(SD.S_Last_Name,' ') AS Final_Name
		   ,ISNULL(KL.I_Kit_Qty, '') AS Item_Quantity

	FROM    LOGISTICS.T_Student_Despatch_Detailed SDD			
		    LEFT OUTER JOIN dbo.T_Centre_Master CM
		    ON  CM.I_Centre_Id = SDD.I_Center_ID
            LEFT OUTER JOIN LOGISTICS.T_Kit_Logistics KL
			ON KL.I_Kit_ID = ISNULL(SDD.I_Kit_ID,KL.I_Kit_ID)
			LEFT OUTER JOIN	LOGISTICS.T_Logistics_Master LM
			ON LM.I_Logistics_ID = KL.I_Logistics_ID					
			LEFT OUTER JOIN dbo.T_Student_Detail SD
			ON SD.I_Student_Detail_ID = SDD.I_Student_Detail_ID								
			Where ISNULL(S_Item_Code,'')!= ''
			AND
				SDD.[Dt_Dispatch_Date] >= COALESCE(@dtFromDate,SDD.[Dt_Dispatch_Date])
				AND 
				SDD.[Dt_Dispatch_Date] <=	COALESCE(@dtToDate,SDD.[Dt_Dispatch_Date])
			GROUP BY SD.I_Student_Detail_ID,CM.S_Center_Name,LM.S_Item_Code,LM.S_Item_Desc,SD.S_First_Name,SD.S_Middle_Name,SD.S_Last_Name,KL.I_Kit_Qty

			
			
	
--    Select @Count = Count(*) from @tmp_despatch
--	SET @Index =1
--
--    WHILE (@Index <= @Count)
--		BEGIN
--			SELECT @CentreName = CenterName , @FinalName = Final_Name FROM @tmp_despatch WHERE ROW_ID = @Index
--			IF ((@Pre_CentreName = @CentreName) AND (@Pre_FinalName = @FinalName))
--				BEGIN
--					UPDATE @tmp_despatch
--						SET CenterName = '',Final_Name =''
--					WHERE ROW_ID = @Index
--
--				END
--			SET @Pre_CentreName = @CentreName
--			SET @Pre_FinalName = @FinalName
--			SET @Index =@Index + 1
--		END
			
    --SELECT Final_Name AS Student_Name, CenterName AS Center_Name,  S_Item_Code AS Item_Code, S_Item_Desc AS Item_Name FROM @tmp_despatch
	--GROUP BY CenterName,Final_Name,S_Item_Code,S_Item_Desc

	declare  @temptable1 table
	(
		id_identity int identity(1,1),
		Student_Name varchar(200),
		Center_Name varchar(200),
		Item_QTY varchar(200)
	)
	
	declare  @finaltable table
	(	
		_ varchar(200),
		__ varchar(200),
		____ varchar(200)
	)

	insert into @temptable1 select distinct Final_Name,CenterName,'' from @tmp_despatch

	declare @icount int
	declare @iRowCount int
	declare @studentName varchar(200)
	declare @centerName varchar(200)
	
	set @iCount = 1
	select @iRowCount = Count(*) from @temptable1

	while (@icount <= @iRowCount)
	BEGIN
		select @studentName = Student_Name, @centerName = Center_Name from @temptable1 where id_identity = @icount 

		INSERT INTO @finaltable SELECT Student_Name,Center_Name,'' from @temptable1 where id_identity = @icount
		
		INSERT INTO @finaltable SELECT S_Item_Code,S_Item_Desc,Item_Quantity from @tmp_despatch where Final_Name = @studentName and CenterName = @centerName

		INSERT INTO @finaltable SELECT '    ', '     ','    '
		INSERT INTO @finaltable SELECT '    ', '     ','    '
	
		SET @iCount = @iCount + 1
	END

	select * from @finaltable
	
END
