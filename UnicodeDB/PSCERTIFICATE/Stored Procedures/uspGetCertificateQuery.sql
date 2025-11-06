CREATE PROCEDURE [PSCERTIFICATE].[uspGetCertificateQuery] 
(	
	@dtFromDate DATETIME = NULL,
	@dtToDate DATETIME = NULL,
	@HierarchyDetailID INT = null,
	@BRANDID INT = null
)
AS
BEGIN

SET NOCOUNT ON

IF(@dtToDate IS NOT NULL)
	BEGIN
	SET @dtTodate = DATEADD(dd,1,@dtTodate)
	END

DECLARE @User TABLE
(
 I_User_ID INT
)

DECLARE @Centre TABLE
(
 I_Center_Id INT
)

INSERT INTO @CENTRE
SELECT I_CENTER_ID FROM DBO.FNGETCENTERIDFROMHIERARCHY(@HIERARCHYDETAILID,@BRANDID)

IF(@HierarchyDetailID IS NOT NULL)
BEGIN 
	INSERT INTO @User
	SELECT UM.I_User_ID FROM dbo.T_User_Master UM
	INNER JOIN dbo.T_User_Hierarchy_Details UHD
	on UM.I_User_ID=UHD.I_User_ID
	inner join T_Center_Hierarchy_Details CHD
	on UHD.I_Hierarchy_Detail_ID=CHD.I_Hierarchy_Detail_ID
	and UHD.I_Hierarchy_Master_ID = CHD.I_Hierarchy_Master_ID
	WHERE CHD.I_Center_Id in 
	(select I_Center_Id from @Centre)
	and CHD.I_Status <> 0
	and UHD.I_Status <> 0
	and UM.I_Status <> 0
	
END

DECLARE @TempTable TABLE
(
ID INT IDENTITY(1,1),
I_Certificate_Query_ID INT,
I_Student_Detail_ID INT,
S_Replied_By VARCHAR(100),
S_Crtd_By VARCHAR(100),
Dt_Crtd_On DATETIME,
Dt_Upd_On DATETIME,
S_Query VARCHAR(5000),
S_Reply VARCHAR(2000),
I_Status INT,
B_PS_Flag INT,
S_Title VARCHAR(250),
S_First_Name VARCHAR(100),
S_Middle_Name VARCHAR(100),
S_Last_Name VARCHAR(100),
S_Student_ID VARCHAR(100),
S_Center_Name VARCHAR(250)
)

INSERT INTO @TempTable
SELECT DISTINCT
		  ISNULL(A.I_Certificate_Query_ID, ' ') AS I_Certificate_Query_ID,
		  ISNULL(A.I_Student_Detail_ID,0) AS I_Student_Detail_ID,
          ISNULL(A.S_Replied_By,' ') AS S_Replied_By,
	      ISNULL(A.S_Crtd_By,' ') AS S_Crtd_By,
		  ISNULL(A.Dt_Crtd_On,' ') AS Dt_Crtd_On,
		  ISNULL(A.Dt_Upd_On,' ') AS Dt_Upd_On,
          ISNULL(A.S_Query, ' ') AS S_Query,
          ISNULL(A.S_Reply, ' ') AS S_Reply,
		  ISNULL(A.I_Status,0) AS I_Status,
		  ISNULL(A.B_PS_Flag, 0) AS B_PS_Flag,
		  ISNULL(UM.S_Title, ' ') AS S_Title,
		  ISNULL(UM.S_First_Name, ' ') AS S_First_Name,
	      ISNULL(UM.S_Middle_Name, ' ') AS S_Middle_Name,
		  ISNULL(UM.S_Last_Name, ' ') AS S_Last_Name,
		  ISNULL(UM.S_Login_Id, ' ') AS S_Student_ID,	
			''
		FROM [PSCERTIFICATE].T_Certificate_Query A
		INNER JOIN dbo.T_User_Master UM
		ON UM.I_User_ID = A.I_Student_Detail_ID
		INNER JOIN dbo.T_User_Hierarchy_Details UHD
		on UM.I_User_ID=UHD.I_User_ID
		inner join T_Center_Hierarchy_Details CHD
		on UHD.I_Hierarchy_Detail_ID=CHD.I_Hierarchy_Detail_ID
		and UHD.I_Hierarchy_Master_ID = CHD.I_Hierarchy_Master_ID
	   WHERE 		 
		  A.Dt_Crtd_On >= COALESCE(@dtFromDate, A.Dt_Crtd_On)
		  AND A.Dt_Crtd_On <= COALESCE(@dtToDate, A.Dt_Crtd_On)	
		  AND A.I_Student_Detail_ID IN (SELECT I_User_ID FROM @User) 
		  AND CHD.I_Center_Id in (SELECT I_Center_Id from @Centre)	
		  AND A.S_Reply IS NULL

	UPDATE @TEMPTABLE 
	SET S_CENTER_NAME=CM.S_CENTER_NAME
	FROM @TEMPTABLE TMP
	inner join dbo.T_User_Master UM
	on tmp.i_student_detail_id=um.i_user_id
	INNER JOIN dbo.T_User_Hierarchy_Details UHD
	on UM.I_User_ID=UHD.I_User_ID
	inner join T_Center_Hierarchy_Details CHD
	on UHD.I_Hierarchy_Detail_ID=CHD.I_Hierarchy_Detail_ID
	and UHD.I_Hierarchy_Master_ID = CHD.I_Hierarchy_Master_ID
	inner join t_centre_master CM 
	on CHD.i_center_id = CM.i_centre_id
	WHERE CHD.I_Center_Id in 
	(select I_Center_Id from @Centre)
	and CHD.I_Status <> 0
	and UHD.I_Status <> 0
	and UM.I_Status <> 0
	and CM.I_Status <> 0

SELECT * FROM @TempTable ORDER BY Dt_Crtd_On DESC

END
