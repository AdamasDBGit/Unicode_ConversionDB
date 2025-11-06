CREATE PROCEDURE [dbo].[uspGetCorporateStudents]
(
	@CenterCorpFeePlanID INT 
)
AS
BEGIN  
SELECT A.I_Corp_Student_Invoice_Map,B.S_Student_ID,
B.S_First_Name+' '+ S_Middle_Name+' '+S_Last_Name AS StudentName,
E.S_Course_Name,
C.S_Fee_Plan_Name,
D.N_TotalLumpSum,
A.I_Invoice_Header_ID
FROM dbo.T_Corp_Student_Invoice_Map A
INNER JOIN dbo.T_Student_Detail B
ON A.I_Student_Detail_ID = B.I_Student_Detail_ID
INNER JOIN dbo.T_Center_Corporate_Plan C
ON A.I_Center_Corp_Plan_ID = C.I_Center_Corp_Plan_ID
INNER JOIN dbo.T_Course_Fee_Plan D
ON C.I_Course_Fee_Plan_ID = D.I_Course_Fee_Plan_ID
INNER JOIN dbo.T_Course_Master E
ON D.I_Course_ID = E.I_Course_ID
WHERE A.I_Status = 1
AND A.I_Center_Corp_Plan_ID = @CenterCorpFeePlanID
 
  
END
