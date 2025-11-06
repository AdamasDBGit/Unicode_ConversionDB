CREATE PROCEDURE [REPORT].[UspGetVideoAccessReport]  
(  
 @sHierarchyList varchar(MAX),  
 @iBrandID int,  
 @sCourseLst Varchar(500)=NULL,  
 @sBatchLst Varchar(500)=NULL,  
 @dtStartDate datetime,  
 @dtEndDate datetime  
)  
AS  
 BEGIN
 
	IF @sCourseLst IS NOT NULL 
		BEGIN  
		IF @sBatchLst IS NOT NULL
			begin
				  SELECT SD.S_Student_ID USERID,   
					  ISNULL(UM.S_First_Name,'')+' '+ISNULL(UM.S_Middle_Name,'')+' '+ISNULL(UM.S_Last_Name,'') USERNAME,  
					  FN1.centerName,  
					  CM.S_Course_Name,  
					  SBM.S_Batch_Code,  
					  SBM.S_Batch_Name,
					  CASE WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 6 THEN 'Enrollment Full'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 5 THEN 'Completed'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 4 THEN 'Can Enroll'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 3 THEN 'Rejected'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 2 THEN 'Approved'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 1 THEN 'Created'
							ELSE 'Inactive' END AS I_Status,
					  BCD.S_Session_Topic, 
					  BCD.S_Session_Alias, 
					  UVAT.Dt_Login_Time,  
					  UVAT.Dt_Logout_Time,  
					  UVAT.S_IP_Address   
				  FROM dbo.T_USER_VIDEO_ACCESS_TRAIL UVAT  
				   INNER JOIN dbo.T_User_Master UM ON UVAT.I_User_ID=UM.I_User_ID  
				   INNER JOIN dbo.T_Student_Detail SD ON UM.I_Reference_ID=SD.I_Student_Detail_ID  
				   INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID  
					  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
					  ON ERD.I_Centre_Id=FN1.CenterID    
				   INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID=SBD.I_Student_ID  
				   INNER JOIN dbo.T_Student_Batch_Master SBM ON SBD.I_Batch_ID=SBM.I_Batch_ID  
				   INNER JOIN dbo.T_Course_Master CM ON SBM.I_Course_ID=CM.I_Course_ID  
				   INNER JOIN dbo.T_Batch_Content_Details BCD ON UVAT.I_Batch_Content_Details_ID=BCD.I_Batch_Content_Details_ID  
				   INNER JOIN dbo.T_Center_Batch_Details AS tcbd ON BCD.I_Batch_ID = tcbd.I_Batch_ID AND ERD.I_Centre_Id = tcbd.I_Centre_Id
					Where SBD.I_Batch_ID in (SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sBatchLst, ','))  
					AND SBM.I_Course_ID IN (SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCourseLst, ','))  
					AND UVAT.Dt_Login_Time BETWEEN @dtStartDate AND @dtEndDate
			end
		ELSE
			begin
				  SELECT SD.S_Student_ID USERID,   
					  ISNULL(UM.S_First_Name,'')+' '+ISNULL(UM.S_Middle_Name,'')+' '+ISNULL(UM.S_Last_Name,'') USERNAME,  
					  FN1.centerName,  
					  CM.S_Course_Name,  
					  SBM.S_Batch_Code,  
					  SBM.S_Batch_Name,
					  CASE WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 6 THEN 'Enrollment Full'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 5 THEN 'Completed'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 4 THEN 'Can Enroll'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 3 THEN 'Rejected'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 2 THEN 'Approved'
							WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 1 THEN 'Created'
							ELSE 'Inactive' END AS I_Status,
					  BCD.S_Session_Topic, 
					  BCD.S_Session_Alias,  
					  UVAT.Dt_Login_Time,  
					  UVAT.Dt_Logout_Time,  
					  UVAT.S_IP_Address   
				  FROM dbo.T_USER_VIDEO_ACCESS_TRAIL UVAT  
				   INNER JOIN dbo.T_User_Master UM ON UVAT.I_User_ID=UM.I_User_ID  
				   INNER JOIN dbo.T_Student_Detail SD ON UM.I_Reference_ID=SD.I_Student_Detail_ID  
				   INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID  
					  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
					  ON ERD.I_Centre_Id=FN1.CenterID    
				   INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID=SBD.I_Student_ID  
				   INNER JOIN dbo.T_Student_Batch_Master SBM ON SBD.I_Batch_ID=SBM.I_Batch_ID  
				   INNER JOIN dbo.T_Course_Master CM ON SBM.I_Course_ID=CM.I_Course_ID  
				   INNER JOIN dbo.T_Batch_Content_Details BCD ON UVAT.I_Batch_Content_Details_ID=BCD.I_Batch_Content_Details_ID  
				   INNER JOIN dbo.T_Center_Batch_Details AS tcbd ON BCD.I_Batch_ID = tcbd.I_Batch_ID AND ERD.I_Centre_Id = tcbd.I_Centre_Id
					Where SBM.I_Course_ID IN (SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCourseLst, ','))  
					AND UVAT.Dt_Login_Time BETWEEN @dtStartDate AND @dtEndDate
			end
		END
	ELSE
		BEGIN  
 		  SELECT SD.S_Student_ID USERID,   
			  ISNULL(UM.S_First_Name,'')+' '+ISNULL(UM.S_Middle_Name,'')+' '+ISNULL(UM.S_Last_Name,'') USERNAME,  
			  FN1.centerName,  
			  CM.S_Course_Name,  
			  SBM.S_Batch_Code,  
			  SBM.S_Batch_Name,
			  CASE WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 6 THEN 'Enrollment Full'
					WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 5 THEN 'Completed'
					WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 4 THEN 'Can Enroll'
					WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 3 THEN 'Rejected'
					WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 2 THEN 'Approved'
					WHEN ISNULL(tcbd.I_Status,SBM.I_Status) = 1 THEN 'Created'
					ELSE 'InacENDe' END AS I_Status,
			  BCD.S_Session_Topic,  
			  BCD.S_Session_Alias, 
			  UVAT.Dt_Login_Time,  
			  UVAT.Dt_Logout_Time,  
			  UVAT.S_IP_Address   
		  FROM dbo.T_USER_VIDEO_ACCESS_TRAIL UVAT  
		   INNER JOIN dbo.T_User_Master UM ON UVAT.I_User_ID=UM.I_User_ID  
		   INNER JOIN dbo.T_Student_Detail SD ON UM.I_Reference_ID=SD.I_Student_Detail_ID  
		   INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID  
			  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
			  ON ERD.I_Centre_Id=FN1.CenterID    
		   INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID=SBD.I_Student_ID  
		   INNER JOIN dbo.T_Student_Batch_Master SBM ON SBD.I_Batch_ID=SBM.I_Batch_ID  
		   INNER JOIN dbo.T_Course_Master CM ON SBM.I_Course_ID=CM.I_Course_ID  
		   INNER JOIN dbo.T_Batch_Content_Details BCD ON UVAT.I_Batch_Content_Details_ID=BCD.I_Batch_Content_Details_ID  
		   INNER JOIN dbo.T_Center_Batch_Details AS tcbd ON BCD.I_Batch_ID = tcbd.I_Batch_ID AND ERD.I_Centre_Id = tcbd.I_Centre_Id
			Where UVAT.Dt_Login_Time BETWEEN @dtStartDate AND @dtEndDate
		END
 End
