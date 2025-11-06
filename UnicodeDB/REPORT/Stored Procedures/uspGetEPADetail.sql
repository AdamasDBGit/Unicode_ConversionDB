CREATE PROCEDURE [REPORT].[uspGetEPADetail]
(
@iCenterID INT,
@dtStart DATETIME,
@dtEnd DATETIME
)
AS
BEGIN



CREATE TABLE #tblEnquiry(

[I_User_ID] INT,
[Counsellor] VARCHAR(100),
[Enquiry] INT,
[Prospectus] INT,
[Admission] INT,
--[Date] DATE


)



CREATE TABLE #tblCourseEnquiry(

[I_User_ID] INT,
[CourseName] VARCHAR(100),
[CountAdm] INT


)

INSERT INTO #tblEnquiry([I_user_ID],[Counsellor])

SELECT B.I_User_ID,B.S_First_Name+' '+B.S_Last_Name AS "Name" 

FROM T_User_Hierarchy_Details A INNER JOIN T_User_Master B
ON A.I_User_ID=B.I_User_ID INNER JOIN T_Center_Hierarchy_Details C
ON C.I_Hierarchy_Detail_ID=A.I_Hierarchy_Detail_ID
INNER JOIN T_User_Role_Details D
ON D.I_User_ID=B.I_User_ID
INNER JOIN T_Role_Master E
ON E.I_Role_ID=D.I_Role_ID
WHERE C.I_Center_Id=@iCenterID
AND S_Role_Code IN ('CH','CON')
AND B.I_Status=1

--SELECT * FROM #tblEnquiry
 
 UPDATE		T1
 
 SET T1.Enquiry=Y2.Enquiry
 
 FROM
 
 #tblEnquiry T1
 
 INNER JOIN
 
 (
 
 SELECT 
			D.I_User_ID,
			D.S_First_Name+' '+D.S_Last_Name AS "Name",
			COUNT(*) AS "Enquiry" 
			
			FROM T_Enquiry_Regn_Detail A
			INNER JOIN T_User_Master D
			ON D.S_Login_ID=A.S_Crtd_By
			
			WHERE 
			I_Centre_Id=@iCenterID 
			AND 
			DATEDIFF(dd,@dtStart,A.Dt_Crtd_On)>=0
			AND
			DATEDIFF(dd,@dtEnd,A.Dt_Crtd_On)<=0
			
			AND
			I_PreEnquiryFor=1
			AND
			I_Enquiry_Status_Code<>NULL
						
			GROUP BY
			D.S_First_Name,
			D.S_Last_Name,
			D.I_User_ID
			--CAST(A.Dt_Crtd_On AS DATE) 
			) Y2
 
 ON Y2.I_User_ID=T1.I_User_ID


 
 UPDATE		T
 
 SET T.Prospectus=Y.Prospectus
 
 FROM
 
 #tblEnquiry T
 
 INNER JOIN
 
 (
 
 SELECT 
			D.I_User_ID,
			D.S_First_Name+' '+D.S_Last_Name AS "Name",
			COUNT(*) AS "Prospectus" 
			---CAST(A.Dt_Crtd_On AS DATE) AS "Date"
			FROM T_Enquiry_Regn_Detail A
			INNER JOIN T_User_Master D
			ON D.S_Login_ID=A.S_Crtd_By
			
			WHERE 
			I_Centre_Id=@iCenterID 
			AND 
			DATEDIFF(dd,@dtStart,A.Dt_Crtd_On)>=0
			AND
			DATEDIFF(dd,@dtEnd,A.Dt_Crtd_On)<=0
			
			AND
			I_PreEnquiryFor=1
			AND
			I_Enquiry_Status_Code<>NULL
			AND
			S_Form_No IS NOT NULL
			
			GROUP BY
			D.S_First_Name,
			D.S_Last_Name,
			D.I_User_ID
			--CAST(A.Dt_Crtd_On AS DATE) 
			) Y 
 
 ON Y.I_User_ID=T.I_User_ID
 
 
 
 
 
 UPDATE T2
 
 SET T2.Admission= Y2.Admission
 
 FROM #tblEnquiry T2
 
 INNER JOIN
 
 (
 
 SELECT 
		D.I_User_ID,
		D.S_First_Name+' '+D.S_Last_Name AS "Name",
		COUNT(*) AS "Admission"
		--CAST(A.Dt_Crtd_On AS DATE) AS "Date"
		FROM T_Student_Detail A 
		INNER JOIN T_Invoice_Parent B
		ON A.I_Student_Detail_ID = B.I_Student_Detail_ID 
		INNER JOIN T_Enquiry_Regn_Detail C
		ON C.I_Enquiry_Regn_ID=A.I_Enquiry_Regn_ID
		INNER JOIN T_User_Master D
		ON D.S_Login_ID=C.S_Crtd_By
		
		WHERE 
		DATEDIFF(dd,@dtStart,A.Dt_Crtd_On)>=0
		AND
		DATEDIFF(dd,@dtEnd,A.Dt_Crtd_On)<=0
		AND 
		B.N_Invoice_Amount<>0
		AND
		C.I_Centre_Id=@iCenterID
		AND 
		B.I_Status=1
		AND
		C.I_PreEnquiryFor=1
		AND
		C.I_Enquiry_Status_Code=3
		
		GROUP BY
		D.S_First_Name,
		D.S_Last_Name,
		I_User_ID
		--CAST(A.Dt_Crtd_On AS DATE) 
) Y2 

ON Y2.I_User_ID=T2.I_User_ID








INSERT INTO #tblCourseEnquiry(I_User_ID,CourseName,CountAdm)

--SELECT D.I_User_ID,S_Course_Desc,COUNT(*) FROM T_Enquiry_Course A INNER JOIN T_Enquiry_Regn_Detail B
--ON
--A.I_Enquiry_Regn_ID=B.I_Enquiry_Regn_ID INNER JOIN T_Course_Master C
--ON C.I_Course_ID = A.I_Course_ID INNER JOIN T_User_Master D
--ON D.S_Login_ID=B.S_Crtd_By
--WHERE
--B.I_PreEnquiryFor=1
--AND
--B.I_Enquiry_Status_Code=1
--AND
--B.I_Centre_Id=@iCenterID
--AND
--B.Dt_Crtd_On BETWEEN @dtStart AND @dtEnd
--GROUP BY
--S_Course_Desc,D.I_User_ID
SELECT 
		D.I_User_ID,
		--D.S_First_Name+' '+D.S_Last_Name AS "Name",
		F.S_Course_Desc,
		COUNT(*) AS "Admission"
		--CAST(A.Dt_Crtd_On AS DATE) AS "Date",
		
 
		FROM T_Student_Detail A 
		INNER JOIN T_Invoice_Parent B
		ON A.I_Student_Detail_ID = B.I_Student_Detail_ID 
		INNER JOIN T_Enquiry_Regn_Detail C
		ON C.I_Enquiry_Regn_ID=A.I_Enquiry_Regn_ID
		INNER JOIN T_User_Master D
		ON D.S_Login_ID=C.S_Crtd_By
		INNER JOIN T_Student_Course_Detail E
		ON E.I_Student_Detail_ID=A.I_Student_Detail_ID
		INNER JOIN T_Course_Master F
		ON F.I_Course_ID=E.I_Course_ID
		WHERE 
		DATEDIFF(dd,@dtStart,A.Dt_Crtd_On)>=0
		AND
		DATEDIFF(dd,@dtEnd,A.Dt_Crtd_On)<=0
		AND 
		B.N_Invoice_Amount<>0
		AND
		C.I_Centre_Id=@iCenterID
		AND 
		B.I_Status=1
		AND
		C.I_PreEnquiryFor=1
		AND
		C.I_Enquiry_Status_Code=3
		AND
		E.I_Status=1
		GROUP BY
		--D.S_First_Name,
		--D.S_Last_Name,
		I_User_ID,
		F.S_Course_Desc


SELECT T2.Counsellor,T2.Enquiry,T2.Prospectus,T2.Admission,T1.CourseName,T1.CountAdm FROM #tblCourseEnquiry T1 INNER JOIN #tblEnquiry T2
ON T1.I_User_ID=T2.I_User_ID
END
