CREATE PROCEDURE [dbo].[uspGetStudentsForActivity] --330,794     
(              
 @iBatchID INT,  
 @iCenterID INT              
)              
as              
BEGIN                
SELECT TSBD.I_Student_ID,B.S_Student_ID,B.S_First_Name ,ISNULL(S_Middle_Name,'') as S_Middle_Name, B.S_Last_Name into #temp 
FROM dbo.T_Student_Batch_Master AS TSBM      
INNER JOIN dbo.T_Student_Batch_Details AS TSBD      
ON TSBM.I_Batch_ID = TSBD.I_Batch_ID               
INNER JOIN dbo.T_Student_Detail B          
ON TSBD.I_Student_ID= b.I_Student_Detail_ID            
INNER JOIN dbo.T_Center_Batch_Details D                
ON TSBM.I_Batch_ID = D.I_Batch_ID                
AND D.I_Centre_Id = @iCenterID                
INNER JOIN T_Student_Center_Detail I              
ON TSBD.I_Student_ID = I.I_Student_Detail_ID   
WHERE TSBD.I_Status = 1                
AND TSBD.I_Batch_ID = @iBatchID         
AND I.I_Centre_Id =  @iCenterID  

select * from #temp

select I_Student_Detail_ID,I_Activity_ID from T_Student_Activity_Details where I_Student_Detail_ID IN  
(
	select I_Student_ID from #temp
)
AND I_Batch_ID = @iBatchID
AND I_Status = 1
END
