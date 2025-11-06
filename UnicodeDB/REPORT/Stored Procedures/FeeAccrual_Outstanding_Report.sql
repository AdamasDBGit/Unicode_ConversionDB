CREATE PROCEDURE [REPORT].[FeeAccrual_Outstanding_Report]
(
@dtStart DATETIME,
@dtEnd DATETIME,
@iCenterID INT,
@iBrandID INT,
@iCourseID INT
)
AS
BEGIN

CREATE TABLE #temp
(
I_Student_Detail_ID INT,
S_Student_ID VARCHAR(100),
S_Invoice_No VARCHAR(100),
S_Component_Name VARCHAR(100),
S_Batch_Name VARCHAR(100),
S_Course_Name VARCHAR(100),
S_Center_Name VARCHAR(100),
Due_Value REAL,
Dt_Installment_Date DATETIME,
I_Installment_No INT,
I_Parent_Invoice_ID INT,
I_Invoice_Detail_ID INT,
Revised_Invoice_Date DATETIME,
Tax_Value REAL,
Total_Value REAL,
Amount_Paid REAL

)


INSERT INTO #temp(
I_Student_Detail_ID ,
S_Student_ID ,
S_Invoice_No ,
S_Component_Name ,
Due_Value ,
Dt_Installment_Date ,
I_Installment_No ,
I_Parent_Invoice_ID ,
I_Invoice_Detail_ID,
Revised_Invoice_Date ,
Tax_Value 
)

SELECT		A.I_Student_Detail_ID,
			S_Student_ID,
			A.S_Invoice_No,
			S_Component_Name,
			C.N_Amount_Due Due_Value,
			Dt_Installment_Date,
			I_Installment_No,
			A.I_Parent_Invoice_ID,
			C.I_Invoice_Detail_ID,
			A.Dt_Crtd_On AS Revised_Invoice_Date,
			SUM(ROUND(F.N_Tax_Value,0)) Tax_Value
			--SUM(isnulL(ROUND(F.N_Tax_Value,0),0))+C.N_Amount_Due
			--ROUND(SUM(isnulL(F.N_Tax_Value,0))+C.N_Amount_Due,0) Total_Value
			--SUM(ROUND(F.N_Tax_Value,0))+C.N_Amount_Due Total_Value
			
FROM 
        T_Invoice_Parent A 
		INNER JOIN T_Invoice_Child_Header B ON A.I_Invoice_Header_ID=B.I_Invoice_Header_ID AND A.I_Status=1
		INNER JOIN T_Invoice_Child_Detail C ON C.I_Invoice_Child_Header_ID=B.I_Invoice_Child_Header_ID
		INNER JOIN T_Fee_Component_Master D ON D.I_Fee_Component_ID=C.I_Fee_Component_ID
	    AND D.I_Status=1
		INNER JOIN T_Student_Detail E		ON E.I_Student_Detail_ID=A.I_Student_Detail_ID
		LEFT JOIN T_Invoice_Detail_Tax F	ON F.I_Invoice_Detail_ID=C.I_Invoice_Detail_ID
 
 WHERE 
		A.I_Centre_Id=ISNULL(@iCenterID,A.I_Centre_ID)
		AND
		DATEDIFF(dd,@dtStart,Dt_Installment_Date)>=0
		AND
		DATEDIFF(dd,@dtEnd,Dt_Installment_Date)<=0
		AND
		I_Brand_ID=@iBrandID
		AND
		I_Installment_No<>1

 GROUP BY
 S_Student_ID,A.S_Invoice_No,S_Component_Name,C.N_Amount_Due,Dt_Installment_Date,I_Installment_No,
 A.I_Parent_Invoice_ID,A.Dt_Crtd_On,A.I_Student_Detail_ID,C.I_Invoice_Detail_ID
 
 
 --SELECT * FROM #temp
 
 
 UPDATE 
 T1
 SET
 T1.S_Center_Name=T2.S_Center_Name
 FROM
 
 #temp T1
 
 LEFT JOIN
 
 (
 SELECT		I_Student_Detail_ID,
			S_Center_Name 
			FROM T_Student_Center_Detail A 
			INNER JOIN T_Center_Hierarchy_Name_Details B ON A.I_Centre_Id=B.I_Center_ID AND I_Status=1
			AND A.I_Centre_Id=ISNULL(@iCenterID,B.I_Center_ID)
			AND B.I_Brand_ID=@iBrandID
 )T2
 
 ON T1.I_Student_Detail_ID=T2.I_Student_Detail_ID
 
 UPDATE #temp SET Revised_Invoice_Date=NULL WHERE I_Parent_Invoice_ID IS NULL
 
 UPDATE 
 T1
 SET
 T1.Amount_Paid=ROUND(T2.Amount_Paid,0)
 FROM
 
 #temp T1
 
  INNER JOIN
 
 (
 
 SELECT	 A.I_Invoice_Detail_ID,
		 SUM(N_Amount_Paid) Amount_Paid
 
 FROM T_Receipt_Component_Detail A 
 WHERE 
		 A.I_Invoice_Detail_ID IN (SELECT I_Invoice_Detail_ID FROM #temp)
		 AND
		 I_Receipt_Detail_ID NOT IN (SELECT I_Receipt_Header_ID FROM T_Receipt_Header WHERE I_Student_Detail_ID IN(SELECT I_Student_Detail_ID FROM #temp) AND I_Status=0)
		  
GROUP BY
		 A.I_Invoice_Detail_ID
 
 ) T2
 
 ON		T1.I_Invoice_Detail_ID=T2.I_Invoice_Detail_ID
 
 
 UPDATE 
 T1
 SET
 T1.S_Batch_Name=T2.S_Batch_Name,
 T1.S_Course_Name=T2.S_Course_Name
 
 FROM
 
 #temp T1
 
  LEFT JOIN
 
 (
 SELECT  A.I_Student_Detail_ID,S_Batch_Name,S_Course_Name 
 FROM T_Student_Detail A INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID=B.I_Student_ID AND B.I_Status=1
 INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID=B.I_Batch_ID INNER JOIN T_Center_Batch_Details D
 ON D.I_Batch_ID=C.I_Batch_ID 
 INNER JOIN T_Course_Master E ON E.I_Course_ID=C.I_Course_ID
 WHERE
 D.I_Centre_Id=ISNULL(@iCenterID,D.I_Centre_ID) AND C.I_Course_ID=ISNULL(@iCourseID,C.I_Course_ID)
 ) T2
 
 ON		T1.I_Student_Detail_ID=T2.I_Student_Detail_ID
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 UPDATE #temp SET Total_Value=Due_Value+ISNULL(Tax_Value,0) WHERE I_Invoice_Detail_ID=I_Invoice_Detail_ID
 
 UPDATE #temp SET Amount_Paid=Amount_Paid+ISNULL(Tax_Value,0) WHERE I_Invoice_Detail_ID=I_Invoice_Detail_ID
 
 
 
 SELECT * FROM #temp 
 
 WHERE 
 --Total_Value<>Amount_Paid
 --AND
 Amount_Paid IS NULL OR Amount_Paid = 0 
 
 ORDER BY S_Center_Name,S_Student_ID
 
 
 END
