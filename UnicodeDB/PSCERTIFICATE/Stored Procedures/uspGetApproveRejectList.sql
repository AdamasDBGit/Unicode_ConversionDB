/*
-- =================================================================
-- Author:Chandan Dey
-- Modified By : 
-- Create date:06/24/2007 
-- Description:Select List Approve & Reject Request List record in T_Student_Certificate_Request table 
-- =================================================================
*/

CREATE PROCEDURE [PSCERTIFICATE].[uspGetApproveRejectList]
(
	@iCenterID		INT,
	@iCourseID		INT,
	@iTermID		INT,
	@iPSCert        INT
)
AS
BEGIN
IF (@iPSCert = 0 AND @iTermID IS NULL)
BEGIN
   SELECT 
		ISNULL(A.I_Student_Cert_Request_ID,0) AS  I_Student_Cert_Request_ID ,
		ISNULL(A.I_Student_Certificate_ID,0) AS I_Student_Certificate_ID ,
		ISNULL(A.S_Student_FName,' ') AS  S_Student_Name ,
        ISNULL(A.S_Reiss_Reason,' ') AS  S_Reiss_Reason ,
        ISNULL(A.I_Status,0) AS I_Status  ,
        ISNULL(A.S_Crtd_By,' ') AS  S_Crtd_By ,
		ISNULL(A.S_Upd_By,' ') AS  S_Upd_By ,
		ISNULL(A.Dt_Crtd_On,' ') AS Dt_Crtd_On ,
		ISNULL(A.Dt_Upd_On,' ') AS Dt_Upd_On ,
	    ISNULL(B.I_Student_Detail_ID,0) AS I_Student_Detail_ID ,
		ISNULL(C.S_First_Name,' ') AS S_First_Name ,
		ISNULL(C.S_Middle_Name,' ') AS S_Middle_Name ,
		ISNULL(C.S_Last_Name,' ') AS S_Last_Name
     FROM [PSCERTIFICATE].T_Student_Certificate_Request A,
		  [PSCERTIFICATE].T_Student_PS_Certificate B,
		  [dbo].T_Student_Detail C,
		  [dbo].T_Student_Center_Detail F
       WHERE
			A.I_Student_Certificate_ID = B.I_Student_Certificate_ID
		AND	B.I_Student_Detail_ID = C.I_Student_Detail_ID
		AND	B.I_Student_Detail_ID = F.I_Student_Detail_ID
		AND F.I_Centre_ID = COALESCE(@iCenterID, F.I_Centre_ID)
		AND B.I_Course_ID = COALESCE(@iCourseID, B.I_Course_ID)
		AND B.I_Term_ID IS NULL --= COALESCE(@iTermID, B.I_Term_ID)
		AND (A.I_Status = 5 OR A.I_Status = 6)
		AND B.B_PS_Flag = 0
END
ELSE IF (@iPSCert = 1)
BEGIN
   SELECT 
		ISNULL(A.I_Student_Cert_Request_ID,0) AS  I_Student_Cert_Request_ID ,
		ISNULL(A.I_Student_Certificate_ID,0) AS I_Student_Certificate_ID ,
		ISNULL(A.S_Student_FName,' ') AS  S_Student_Name ,
        ISNULL(A.S_Reiss_Reason,' ') AS  S_Reiss_Reason ,
        ISNULL(A.I_Status,0) AS I_Status  ,
        ISNULL(A.S_Crtd_By,' ') AS  S_Crtd_By ,
		ISNULL(A.S_Upd_By,' ') AS  S_Upd_By ,
		ISNULL(A.Dt_Crtd_On,' ') AS Dt_Crtd_On ,
		ISNULL(A.Dt_Upd_On,' ') AS Dt_Upd_On ,
	    ISNULL(B.I_Student_Detail_ID,0) AS I_Student_Detail_ID ,
		ISNULL(C.S_First_Name,' ') AS S_First_Name ,
		ISNULL(C.S_Middle_Name,' ') AS S_Middle_Name ,
		ISNULL(C.S_Last_Name,' ') AS S_Last_Name
     FROM [PSCERTIFICATE].T_Student_Certificate_Request A,
		  [PSCERTIFICATE].T_Student_PS_Certificate B,
		  [dbo].T_Student_Detail C,
		  [dbo].T_Student_Center_Detail F
       WHERE
			A.I_Student_Certificate_ID = B.I_Student_Certificate_ID
		AND	B.I_Student_Detail_ID = C.I_Student_Detail_ID
		AND	B.I_Student_Detail_ID = F.I_Student_Detail_ID
		AND F.I_Centre_ID = COALESCE(@iCenterID, F.I_Centre_ID)
		AND B.I_Course_ID = COALESCE(@iCourseID, B.I_Course_ID)
		AND B.I_Term_ID = COALESCE(@iTermID, B.I_Term_ID)
		AND (A.I_Status = 5 OR A.I_Status = 6)
		AND B.B_PS_Flag = 1
END
ELSE
BEGIN
   SELECT 
		ISNULL(A.I_Student_Cert_Request_ID,0) AS  I_Student_Cert_Request_ID ,
		ISNULL(A.I_Student_Certificate_ID,0) AS I_Student_Certificate_ID ,
		ISNULL(A.S_Student_FName,' ') AS  S_Student_Name ,
        ISNULL(A.S_Reiss_Reason,' ') AS  S_Reiss_Reason ,
        ISNULL(A.I_Status,0) AS I_Status  ,
        ISNULL(A.S_Crtd_By,' ') AS  S_Crtd_By ,
		ISNULL(A.S_Upd_By,' ') AS  S_Upd_By ,
		ISNULL(A.Dt_Crtd_On,' ') AS Dt_Crtd_On ,
		ISNULL(A.Dt_Upd_On,' ') AS Dt_Upd_On ,
	    ISNULL(B.I_Student_Detail_ID,0) AS I_Student_Detail_ID ,
		ISNULL(C.S_First_Name,' ') AS S_First_Name ,
		ISNULL(C.S_Middle_Name,' ') AS S_Middle_Name ,
		ISNULL(C.S_Last_Name,' ') AS S_Last_Name
     FROM [PSCERTIFICATE].T_Student_Certificate_Request A,
		  [PSCERTIFICATE].T_Student_PS_Certificate B,
		  [dbo].T_Student_Detail C,
		  [dbo].T_Student_Center_Detail F
       WHERE
			A.I_Student_Certificate_ID = B.I_Student_Certificate_ID
		AND	B.I_Student_Detail_ID = C.I_Student_Detail_ID
		AND	B.I_Student_Detail_ID = F.I_Student_Detail_ID
		AND F.I_Centre_ID = COALESCE(@iCenterID, F.I_Centre_ID)
		AND B.I_Course_ID = COALESCE(@iCourseID, B.I_Course_ID)
		AND B.I_Term_ID = COALESCE(@iTermID, B.I_Term_ID)
		AND (A.I_Status = 5 OR A.I_Status = 6)
		AND B.B_PS_Flag = 0
END
END
