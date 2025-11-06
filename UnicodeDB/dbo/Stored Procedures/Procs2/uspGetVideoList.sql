CREATE PROCEDURE [dbo].[uspGetVideoList] --330,'8/9/2011'       
(              
 -- Add the parameters for the stored procedure here              
 @iBatchID INT,      
 @dtCurrentDate DATETIME = NULL                      
)              
AS              
BEGIN               
       
	SELECT tbcd.I_Batch_Content_Details_ID,S_Session_Alias,S_Content_URL,tced.I_Content_Emp_Dtl_ID,tced.I_Hierarchy_Detail_ID,thd.S_Hierarchy_Name,tced.Dt_Expiry_Date,
	tcrm.I_RoleID,trm.S_Role_Code INTO #temp
	FROM dbo.T_Batch_Content_Details AS tbcd
	INNER JOIN dbo.T_Content_Employee_Dtl AS tced
	ON tbcd.I_Batch_Content_Details_ID = tced.I_Batch_Content_Details_ID
	INNER JOIN dbo.T_Content_Role_Map AS tcrm
	ON tced.I_Content_Emp_Dtl_ID = tcrm.I_Content_Emp_Dtl_ID
	INNER JOIN dbo.T_Hierarchy_Details AS thd
	ON tced.I_Hierarchy_Detail_ID = thd.I_Hierarchy_Detail_ID
	INNER JOIN dbo.T_Role_Master AS trm
	ON tcrm.I_RoleID = trm.I_Role_ID
	WHERE I_Batch_ID = @iBatchID
	AND tced.Dt_Expiry_Date >= CONVERT(date, @dtCurrentDate) 



	SELECT DISTINCT t2.I_Batch_Content_Details_ID,t2.S_Session_Alias,t2.S_Content_URL,t2.I_Content_Emp_Dtl_ID,t2.I_Hierarchy_Detail_ID,t2.S_Hierarchy_Name,t2.Dt_Expiry_Date,
	RoleCodes = STUFF((SELECT ', '+t1.S_Role_Code
	FROM #temp AS t1
	WHERE t1.I_Content_Emp_Dtl_ID = t2.I_Content_Emp_Dtl_ID
	ORDER BY t1.I_Batch_Content_Details_ID
	FOR XML PATH('')),1,1,''),
	RoleIds = STUFF((SELECT ','+CAST(t1.I_RoleID AS VARCHAR(5))
	FROM #temp AS t1
	WHERE t1.I_Content_Emp_Dtl_ID = t2.I_Content_Emp_Dtl_ID
	ORDER BY t1.I_Batch_Content_Details_ID
	FOR XML PATH('')),1,1,'') 
	FROM #temp AS t2
	
	DROP TABLE #temp

       
 
         
END
