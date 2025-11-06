--SELECT * FROM dbo.T_Invoice_Parent WHERE I_Student_Detail_ID=214
--SELECT * FROM DBO.T_Invoice_Child_Header WHERE I_Invoice_Header_ID=288029

--SELECT * FROM [REPORT].[fnGetUpSalesCrossSales](856,2479,'2011-01-01','2011-01-31')

CREATE FUNCTION [REPORT].[fnGetUpSalesCrossSales]
(
	@CenterID INT,
	@CourseID INT,
	@dtStartDate datetime,
	@dtEndDate datetime
)
RETURNS  @UpSalesCrossSales TABLE
(	
	UpSales INT,
	CressSales INT
)
AS
begin

	DECLARE @UpSales INT=0
	DECLARE @CrossSales INT=0
	DECLARE @StudentID INT
	DECLARE @InvCount INT=0
	DECLARE @1stCourseID INT
	DECLARE @NxtCourseID INT
	Declare @rCount INT=1
	Declare @rsCount INT=1
	Declare @rTCount Int
	
	DECLARE @tmpStudentID TABLE (Id INT IDENTITY(1, 1),StudentID INT)
	DECLARE @tmpCourseID TABLE (Id INT IDENTITY(1, 1),CourseID INT, InvDate DATETIME)
	
	INSERT INTO @tmpStudentID	
	SELECT DISTINCT IP.I_Student_Detail_ID
	FROM T_Invoice_Parent IP
	INNER JOIN dbo.T_Invoice_Child_Header ICH ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
	WHERE IP.I_Centre_Id=@CenterID
	AND ICH.I_Course_ID=@CourseID
	 AND  DATEDIFF(DD, @dtStartDate,
					 IP.Dt_Invoice_Date) >= 0
			AND DATEDIFF(DD, @dtEndDate,
					IP.Dt_Invoice_Date) <= 0
					


	IF (SELECT COUNT(*) FROM @tmpStudentID)>0
		BEGIN
			SELECT @rTCount=COUNT(*) FROM @tmpStudentID
				While @rCount<=@rTCount
					BEGIN
						SELECT @StudentID=StudentID FROM @tmpStudentID WHERE Id=@rCount
						
						SELECT @dtStartDate=MIN(IP.Dt_Invoice_Date)
						FROM T_Invoice_Parent IP
						INNER JOIN dbo.T_Invoice_Child_Header ICH ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
						WHERE IP.I_Centre_Id=@CenterID
						AND ICH.I_Course_ID=@CourseID
						AND IP.I_Student_Detail_ID=@StudentID
						 AND  DATEDIFF(DD, @dtStartDate,
										 IP.Dt_Invoice_Date) >= 0
								AND DATEDIFF(DD, @dtEndDate,
										IP.Dt_Invoice_Date) <= 0

						
						SELECT @InvCount=COUNT(IP.I_Invoice_Header_ID)
						FROM T_Invoice_Parent IP
						INNER JOIN dbo.T_Invoice_Child_Header ICH ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
						WHERE IP.I_Student_Detail_ID=@StudentID
						AND IP.I_Centre_Id=@CenterID
						 AND  DATEDIFF(DD, @dtStartDate,
										 IP.Dt_Invoice_Date) >= 0
								AND DATEDIFF(DD, @dtEndDate,
										IP.Dt_Invoice_Date) <= 0
						GROUP BY IP.I_Student_Detail_ID
							IF @InvCount>1
								BEGIN
									INSERT INTO @tmpCourseID
									SELECT ICH.I_Course_ID,ip.Dt_Invoice_Date
									FROM T_Invoice_Parent IP
									INNER JOIN dbo.T_Invoice_Child_Header ICH ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
									WHERE IP.I_Student_Detail_ID=@StudentID
									AND IP.I_Centre_Id=@CenterID
									 AND  DATEDIFF(DD, @dtStartDate,
													 IP.Dt_Invoice_Date) >= 0
											AND DATEDIFF(DD, @dtEndDate,
													IP.Dt_Invoice_Date) <= 0
									ORDER BY ip.Dt_Invoice_Date
									SET @1stCourseID=NULL
									WHILE @rsCount<=@InvCount	
										BEGIN
											IF @rsCount=1
												BEGIN
													SELECT @1stCourseID=CourseID
													FROM @tmpCourseID
													WHERE Id= @rsCount
												END
											ELSE
												BEGIN
													SELECT @NxtCourseID=CourseID
													FROM @tmpCourseID
													WHERE Id= @rsCount
													
													IF @1stCourseID=@NxtCourseID
														BEGIN
															SET @UpSales=@UpSales+1
														END	
													ELSE
														BEGIN	
															SET @CrossSales=@CrossSales+1
														END										
												END
											Set @rsCount=@rsCount+1
										END
									DELETE @tmpCourseID
								END
						Set @rCount=@rCount+1
					end		
		END
	INSERT INTO @UpSalesCrossSales
	VALUES (@UpSales,@CrossSales)
	RETURN;
END