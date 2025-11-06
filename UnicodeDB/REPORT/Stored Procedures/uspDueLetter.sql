CREATE PROCEDURE [REPORT].[uspDueLetter]

AS 

BEGIN


SELECT S_Center_Name,
		S_Batch_Name,
		S_Student_ID,
		S_First_Name+' '+ISNULL(S_Middle_Name,' ')+' '+S_Last_Name AS NAME,
	   --S_Component_Name,
	   Dt_Installment_Date,
	   I_Installment_No,
	   D.N_Amount_Due,
	  -- D.N_Amount_Due*112.36/100 AS TAX_Amount,
	   ROUND(SUM(ISNULL(E.N_Amount_Paid,0)),0) Amt_Paid
	  -- D.N_Amount_Due- ROUND(SUM(ISNULL(E.N_Amount_Paid,0)),0) Outstanding_Amt
	   
	   INTO #temp

FROM T_Student_Detail A INNER JOIN T_Invoice_Parent B
ON A.I_Student_Detail_ID=B.I_Student_Detail_ID 
INNER JOIN T_Invoice_Child_Header C
ON C.I_Invoice_Header_ID=B.I_Invoice_Header_ID
INNER JOIN T_Invoice_Child_Detail D
ON D.I_Invoice_Child_Header_ID=C.I_Invoice_Child_Header_ID
LEFT JOIN T_Receipt_Component_Detail E
ON E.I_Invoice_Detail_ID=D.I_Invoice_Detail_ID
INNER JOIN T_Fee_Component_Master F
ON F.I_Fee_Component_ID=D.I_Fee_Component_ID
INNER JOIN T_Center_Hierarchy_Name_Details G
ON G.I_Center_ID=B.I_Centre_Id
INNER JOIN T_Student_Batch_Details H
ON H.I_Student_ID=A.I_Student_Detail_ID AND H.I_Status=1
INNER JOIN T_Student_Batch_Master I
ON I.I_Batch_ID=H.I_Batch_ID
WHERE
B.I_Status=1
AND
B.I_Centre_Id =1
--IN (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)
AND
Dt_Installment_Date BETWEEN '2013-10-01' AND '2013-10-31'
AND
I_Receipt_Detail_ID NOT IN(SELECT I_Receipt_Detail_ID FROM T_Receipt_Header WHERE I_Invoice_Header_ID=B.I_Invoice_Header_ID AND I_Status=0)
AND 
N_Amount_Due<>0
AND
I_Installment_No<>1
--N_Amount_Paid IS NULL 
GROUP BY
S_Center_Name,
		S_Batch_Name,
		S_Student_ID,
		S_First_Name+' '+ISNULL(S_Middle_Name,' ')+' '+S_Last_Name,
	   --S_Component_Name,
	   Dt_Installment_Date,
	   I_Installment_No,
	   D.N_Amount_Due

ORDER BY S_Student_ID,I_Installment_No

SELECT * FROM #temp WHERE Amt_Paid <1

END
