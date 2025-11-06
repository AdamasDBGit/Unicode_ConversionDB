CREATE PROCEDURE [REPORT].[uspGetEnquiryLabelsReport]      
(          
 -- Add the parameters for the stored procedure here          
 @sHierarchyList varchar(MAX),          
 @iBrandID INT,          
 @sCourseIDs VARCHAR(MAX),          
-- @iEnquiryID INT =NULL,          
 @sEnquiryID VARCHAR(MAX)=NULL,        
 @dtFromDate DATETIME = NULL,          
 @dtToDate DATETIME = NULL,          
 @sSourceIDs VARCHAR(MAX),          
 @sEnquiryTypeIDs VARCHAR(MAX),        
 @dtFollowupFromDate DATETIME=NULL,        
 @dtFollowupToDate  DATETIME=NULL,        
 @sEnquiryStatus VARCHAR(MAX)        
)          
AS          
BEGIN          
 SET NOCOUNT ON;          
           
 DECLARE @Enquiry TABLE          
  (          
   I_Enquiry_Regn_ID INT,          
   S_Title VARCHAR(10),          
   S_First_Name VARCHAR(50),          
   S_Middle_Name Varchar(50),          
   S_Last_Name Varchar(50),          
   S_Curr_Address1 Varchar(200),          
   S_Curr_Address2 Varchar(200),          
   S_Curr_Area Varchar(50),          
   S_City_Name Varchar(200),          
   S_Phone_No Varchar(20),          
   S_Mobile_No Varchar(20),         
   CenterCode varchar(200),         
   CenterName Varchar(200),          
   InstanceChain varchar(200),        
   S_Course_Name Varchar(250),        
   S_Enquiry_Type_Desc varchar(200),        
   S_Info_Source_Name varchar(200),        
   S_Enquiry_No varchar(20),        
   S_Email_ID varchar(200),        
   I_Enquiry_Status_Code int,        
   Dt_Crtd_On datetime,        
   Dt_Followup_Date datetime,        
   I_Feedback_Count int,        
   S_Comment varchar(Max)        
  )           
 IF @sCourseIDs Is NOT null          
  BEGIN          
  INSERT INTO @Enquiry        
  (          
   I_Enquiry_Regn_ID ,          
   S_Title ,          
   S_First_Name,          
   S_Middle_Name ,          
   S_Last_Name ,          
   S_Curr_Address1 ,          
   S_Curr_Address2,          
   S_Curr_Area,          
   S_City_Name ,          
   S_Phone_No,          
   S_Mobile_No ,         
   CenterCode ,         
   CenterName ,          
   InstanceChain ,        
   S_Course_Name ,        
   S_Enquiry_Type_Desc,        
   S_Info_Source_Name,        
   S_Enquiry_No,        
   S_Email_ID,        
   I_Enquiry_Status_Code ,        
   Dt_Crtd_On      
  )           
    SELECT DISTINCT A.I_Enquiry_Regn_ID,          
     A.S_Title,          
     A.S_First_Name,          
     A.S_Middle_Name,          
     A.S_Last_Name,          
     A.S_Curr_Address1,          
     A.S_Curr_Address2,          
     A.S_Curr_Area,          
     B.S_City_Name,          
     A.S_Phone_No,          
     A.S_Mobile_No,          
     FN1.CenterCode,          
     FN1.CenterName,          
     FN2.InstanceChain,          
     [TCM].[S_Course_Name],          
     ISNULL(ET.S_Enquiry_Type_Desc,''),          
     ISNULL(ISM.S_Info_Source_Name,''),          
     A.S_Enquiry_No,          
     A.S_Email_ID,        
     A.I_Enquiry_Status_Code,        
     A.Dt_Crtd_On         
      FROM T_Enquiry_Regn_Detail A WITH(NOLOCK)          
     INNER JOIN T_City_Master B WITH(NOLOCK)          
     ON A.I_Curr_City_ID = B.I_City_ID          
     INNER JOIN T_Enquiry_Course C WITH(NOLOCK)          
     ON A.I_Enquiry_Regn_ID = C.I_Enquiry_Regn_ID          
     INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK)          
     ON [C].[I_Course_ID] = [TCM].[I_Course_ID]          
     INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1          
     ON A.I_Centre_Id=FN1.CenterID          
     INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2          
     ON FN1.HierarchyDetailID=FN2.HierarchyDetailID          
     LEFT JOIN DBO.T_Enquiry_Type ET ON A.I_Enquiry_Type_ID=ET.I_Enquiry_Type_ID          
     LEFT JOIN DBO.T_Information_Source_Master ISM ON A.I_Info_Source_ID=ISM.I_Info_Source_ID          
     INNER JOIN dbo.T_Enquiry_Regn_Followup AS TERF ON A.I_Enquiry_Regn_ID=TERF.I_Enquiry_Regn_ID        
    WHERE  A.I_Enquiry_Status_Code =1 --Open Enquiry Only          
     AND 
     B.I_Status<> 0          
    AND C.I_Course_ID IN (SELECT Val FROM [dbo].[fnString2Rows](@sCourseIDs, ',') AS FSR)          
    --AND A.I_Enquiry_Regn_ID=ISNULL(@iEnquiryID,A.I_Enquiry_Regn_ID)          
    AND(@sEnquiryID IS NULL OR A.I_Enquiry_Regn_ID IN (SELECT Val FROM [dbo].[fnString2Rows](@sEnquiryID, ',') AS FSR) )       
    AND DATEDIFF(dd,[A].[Dt_Crtd_On],ISNULL(@dtFromDate,[A].[Dt_Crtd_On])) <= 0          
    AND DATEDIFF(dd,[A].[Dt_Crtd_On],ISNULL(@dtToDate,[A].[Dt_Crtd_On])) >= 0          
    AND DATEDIFF(dd,[TERF].[Dt_Followup_Date],ISNULL(@dtFollowupFromDate,[TERF].[Dt_Followup_Date])) <= 0          
    AND DATEDIFF(dd,[TERF].[Dt_Followup_Date],ISNULL(@dtFollowupToDate,[TERF].[Dt_Followup_Date])) >= 0          
    AND I_Corporate_ID IS NULL          
    AND [A].[I_Enquiry_Regn_ID] NOT IN (          
    SELECT [TERD].[I_Enquiry_Regn_ID] FROM [dbo].[T_Enquiry_Regn_Detail] AS TERD          
    INNER JOIN [dbo].[T_Student_Detail] AS TSD          
    ON [TERD].[I_Enquiry_Regn_ID] = [TSD].[I_Enquiry_Regn_ID]          
    WHERE [TSD].[I_Student_Detail_ID] IN           
    (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM))          
    AND (a.I_Enquiry_Type_ID IS NULL OR a.I_Enquiry_Type_ID IN (SELECT Val FROM [dbo].[fnString2Rows](@sEnquiryTypeIDs, ',') AS FSR))  
    AND (a.I_Info_Source_ID IS NULL OR a.I_Info_Source_ID IN (SELECT Val FROM [dbo].[fnString2Rows](@sSourceIDs, ',') AS FSR))          
    AND A.I_Enquiry_Status_Code IN (SELECT Val FROM [dbo].[fnString2Rows](@sEnquiryStatus, ',') AS FSR)          
   END          
  ELSE          
   BEGIN          
   INSERT INTO @Enquiry        
  (          
   I_Enquiry_Regn_ID ,          
   S_Title ,          
   S_First_Name,          
   S_Middle_Name ,          
   S_Last_Name ,          
   S_Curr_Address1 ,          
   S_Curr_Address2,          
   S_Curr_Area,          
   S_City_Name ,          
   S_Phone_No,          
   S_Mobile_No ,         
   CenterCode ,         
   CenterName ,          
   InstanceChain ,        
   S_Course_Name ,        
   S_Enquiry_Type_Desc,        
   S_Info_Source_Name,        
   S_Enquiry_No,        
   S_Email_ID,        
   I_Enquiry_Status_Code ,        
   Dt_Crtd_On      
  )           
    SELECT DISTINCT A.I_Enquiry_Regn_ID,          
     A.S_Title,          
     A.S_First_Name,          
     A.S_Middle_Name,          
     A.S_Last_Name,          
     A.S_Curr_Address1,          
     A.S_Curr_Address2,          
     A.S_Curr_Area,          
     B.S_City_Name,          
     A.S_Phone_No,          
     A.S_Mobile_No,          
     FN1.CenterCode,          
     FN1.CenterName,          
     FN2.InstanceChain,          
     [TCM].[S_Course_Name],          
     ISNULL(ET.S_Enquiry_Type_Desc,''),          
     ISNULL(ISM.S_Info_Source_Name,''),          
     A.S_Enquiry_No,          
     A.S_Email_ID,        
     A.I_Enquiry_Status_Code,        
     A.Dt_Crtd_On          
      FROM T_Enquiry_Regn_Detail A WITH(NOLOCK)          
     INNER JOIN T_City_Master B WITH(NOLOCK)          
     ON A.I_Curr_City_ID = B.I_City_ID          
     INNER JOIN T_Enquiry_Course C WITH(NOLOCK)          
     ON A.I_Enquiry_Regn_ID = C.I_Enquiry_Regn_ID          
     INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK)          
     ON [C].[I_Course_ID] = [TCM].[I_Course_ID]          
     INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1          
     ON A.I_Centre_Id=FN1.CenterID          
     INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2          
     ON FN1.HierarchyDetailID=FN2.HierarchyDetailID          
     LEFT JOIN DBO.T_Enquiry_Type ET ON A.I_Enquiry_Type_ID=ET.I_Enquiry_Type_ID          
     LEFT JOIN DBO.T_Information_Source_Master ISM ON A.I_Info_Source_ID=ISM.I_Info_Source_ID          
     INNER JOIN dbo.T_Enquiry_Regn_Followup AS TERF ON A.I_Enquiry_Regn_ID=TERF.I_Enquiry_Regn_ID        
    WHERE A.I_Enquiry_Status_Code =1 --Open Enquiry Only          
     AND
     B.I_Status<>0          
    --AND A.I_Enquiry_Regn_ID=ISNULL(@iEnquiryID,A.I_Enquiry_Regn_ID)         
    AND(@sEnquiryID IS NULL OR A.I_Enquiry_Regn_ID IN (SELECT Val FROM [dbo].[fnString2Rows](@sEnquiryID, ',') AS FSR))           
    AND DATEDIFF(dd,[A].[Dt_Crtd_On],ISNULL(@dtFromDate,[A].[Dt_Crtd_On])) <= 0          
    AND DATEDIFF(dd,[A].[Dt_Crtd_On],ISNULL(@dtToDate,[A].[Dt_Crtd_On])) >= 0          
    AND DATEDIFF(dd,[TERF].[Dt_Followup_Date],ISNULL(@dtFollowupFromDate,[TERF].[Dt_Followup_Date])) <= 0          
    AND DATEDIFF(dd,[TERF].[Dt_Followup_Date],ISNULL(@dtFollowupToDate,[TERF].[Dt_Followup_Date])) >= 0          
    AND I_Corporate_ID IS NULL          
    AND [A].[I_Enquiry_Regn_ID] NOT IN (          
    SELECT [TERD].[I_Enquiry_Regn_ID] FROM [dbo].[T_Enquiry_Regn_Detail] AS TERD          
    INNER JOIN [dbo].[T_Student_Detail] AS TSD          
    ON [TERD].[I_Enquiry_Regn_ID] = [TSD].[I_Enquiry_Regn_ID]          
    WHERE [TSD].[I_Student_Detail_ID] IN           
    (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM))          
    AND (a.I_Enquiry_Type_ID  IS NULL OR a.I_Enquiry_Type_ID IN (SELECT Val FROM [dbo].[fnString2Rows](@sEnquiryTypeIDs, ',') AS FSR)    )      
    AND (a.I_Enquiry_Type_ID  IS NULL OR a.I_Info_Source_ID IN (SELECT Val FROM [dbo].[fnString2Rows](@sSourceIDs, ',') AS FSR)        )  
    AND A.I_Enquiry_Status_Code IN (SELECT Val FROM [dbo].[fnString2Rows](@sEnquiryStatus, ',') AS FSR)         
         
   END          
            
   UPDATE @Enquiry SET I_Feedback_Count = FCount        
   FROM @Enquiry AS E        
   INNER JOIN         
   (SELECT I_Enquiry_Regn_ID,COUNT(I_Followup_ID)AS FCount FROM dbo.T_Enquiry_Regn_Followup AS TERF WHERE         
   DATEDIFF(dd,[TERF].[Dt_Followup_Date],ISNULL(@dtFollowupFromDate,[TERF].[Dt_Followup_Date])) <= 0          
   AND DATEDIFF(dd,[TERF].[Dt_Followup_Date],ISNULL(@dtFollowupToDate,[TERF].[Dt_Followup_Date])) >= 0  GROUP BY I_Enquiry_Regn_ID)AS Followup        
   ON E.I_Enquiry_Regn_ID = Followup.I_Enquiry_Regn_ID        
         
   UPDATE @Enquiry SET S_Comment = FComment      
   FROM @Enquiry AS E        
   INNER JOIN        
   (SELECT  STUFF(( SELECT  ',' + S_Followup_Remarks      
                        FROM    T_Enquiry_Regn_Followup      
                        WHERE   I_Enquiry_Regn_ID = Enquiry.I_Enquiry_Regn_ID AND       
                        DATEDIFF(dd,[Dt_Followup_Date],ISNULL(@dtFollowupFromDate,Dt_Followup_Date)) <= 0          
      AND DATEDIFF(dd,Dt_Followup_Date,ISNULL(@dtFollowupToDate,Dt_Followup_Date)) >= 0       
                      FOR      
                        XML PATH('')      
                      ), 1, 1, '') AS FComment ,I_Enquiry_Regn_ID      
          
    FROM @Enquiry AS Enquiry      
    GROUP BY Enquiry.I_Enquiry_Regn_ID ) AS Comment ON E.I_Enquiry_Regn_ID=Comment.I_Enquiry_Regn_ID      
          
    UPDATE @Enquiry SET Dt_Followup_Date = SUBSTRING(FDate+',',1,(CHARINDEX(',',FDate+',',1)-1))      
    FROM  @Enquiry AS E       
   INNER JOIN        
   (SELECT  STUFF(( SELECT  ',' + CAST (Dt_Followup_Date AS VARCHAR(23) )      
                        FROM    T_Enquiry_Regn_Followup      
                        WHERE   I_Enquiry_Regn_ID = Enquiry.I_Enquiry_Regn_ID      
                        AND DATEDIFF(dd,[Dt_Followup_Date],ISNULL(@dtFollowupFromDate,Dt_Followup_Date)) <= 0          
      AND DATEDIFF(dd,Dt_Followup_Date,ISNULL(@dtFollowupToDate,Dt_Followup_Date)) >= 0       
                        ORDER BY Dt_Followup_Date desc      
                      FOR      
                        XML PATH('')      
                      ), 1, 1, '') AS FDate ,I_Enquiry_Regn_ID      
          
    FROM @Enquiry AS Enquiry      
    GROUP BY Enquiry.I_Enquiry_Regn_ID ) AS Comment ON E.I_Enquiry_Regn_ID=Comment.I_Enquiry_Regn_ID      
          
          
   SELECT * FROM @Enquiry            
END       
      
      
--EXEC report.uspGetEnquiryLabelsReport  1,2,NULL,null,NULL,NULL,'88,4,97','3,4',NULL,NULL,'1,2,3' 
