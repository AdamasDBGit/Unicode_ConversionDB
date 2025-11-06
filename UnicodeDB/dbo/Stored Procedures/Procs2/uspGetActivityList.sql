CREATE PROCEDURE [dbo].[uspGetActivityList] --771,950     
(              
 @iBatchID INT,  
 @iCenterID INT              
)              
as              
BEGIN
select DISTINCT(TSAD.I_Activity_ID),TAM.S_Activity_Name,TSBD.I_Student_ID into #temp 
 from dbo.T_Student_Activity_Details as TSAD
 INNER JOIN dbo.T_Student_Batch_Details AS TSBD      
ON TSAD.I_Batch_ID = TSBD.I_Batch_ID           
 INNER JOIN dbo.T_Student_Detail B          
ON TSBD.I_Student_ID= b.I_Student_Detail_ID         
INNER JOIN dbo.T_Center_Batch_Details D                
ON TSBD.I_Batch_ID = D.I_Batch_ID  
AND D.I_Centre_Id = @iCenterID               
INNER JOIN T_Student_Center_Detail I              
ON TSBD.I_Student_ID = I.I_Student_Detail_ID 
INNER JOIN  DBO.T_Activity_Master TAM
ON TAM.I_Activity_ID = TSAD.I_Activity_ID 
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
