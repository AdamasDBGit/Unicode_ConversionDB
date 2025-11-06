CREATE PROCEDURE [REPORT].[uspGetEnquiryEnrollmentHierarchyReportDetails] --88,109,NULL,'09/25/2013','09/25/2013',NULL  
(  
 @sHierarchyID VARCHAR(MAX),  
 @sBrandID VARCHAR(20),  
 @sCenterIDs VARCHAR(MAX) = NULL,  
 @dtStartDate DATETIME,  
 @dtEndDate DATETIME,  
 @sCourseIDs VARCHAR(MAX) = NULL  
)  
AS  
BEGIN  
 DECLARE @YEARMONTH TABLE ( [MONTH] INT,[YEAR] INT )  
   
 DECLARE @MONTH_START INT, @MONTH_CURRENT INT, @MONTH_END INT, @YR_START INT, @YR_CURRENT INT, @YR_END INT   
   
 DECLARE @EEBCINITIAL TABLE  
 (  
  I_CENTRE_ID INT,  
  CENTERCODE VARCHAR(20),  
  CENTERNAME VARCHAR(100),  
  S_CURRENCY_CODE VARCHAR(20)  
 )  
  
 DECLARE @EEBCANALYSIS TABLE  
 (  
  I_CENTRE_ID INT,  
  CENTERCODE VARCHAR(20),  
  S_CURRENCY_CODE VARCHAR(20),  
  S_COURSE_FAMILY VARCHAR(50),  
  I_COURSE_ID INT,  
  S_COURSE VARCHAR(250),  
  [MONTH] INT,  
  [YEAR] INT,  
  TOTAL_ENQUIRY INT,  
  TOTAL_REGISTRATION INT,  
  TOTAL_ENROLL INT,  
  INVOICE_AMOUNT NUMERIC(18,2),  
  COLLECTION_AMOUNT NUMERIC(18,2),  
  INVOICE_TAX_AMOUNT NUMERIC(18,2),  
  COLLECTION_TAX_AMOUNT NUMERIC(18,2)  
 )  
   
 DECLARE @EEBCANALYSIS1 TABLE  
 (  
  I_CENTRE_ID INT,  
  CENTERCODE VARCHAR(20),  
  S_CURRENCY_CODE VARCHAR(20),  
  S_COURSE_FAMILY VARCHAR(50),  
  I_COURSE_ID INT,  
  S_COURSE VARCHAR(250),  
  [MONTH] INT,  
  [YEAR] INT,  
  TOTAL_ENQUIRY INT,  
  TOTAL_REGISTRATION INT,  
  TOTAL_ENROLL INT,  
  INVOICE_AMOUNT NUMERIC(18,2),  
  COLLECTION_AMOUNT NUMERIC(18,2),  
  INVOICE_TAX_AMOUNT NUMERIC(18,2),  
  COLLECTION_TAX_AMOUNT NUMERIC(18,2)  
 )  
   
 DECLARE @index INT, @rowCount INT, @iTempCenterID INT  
 DECLARE @tblCenter TABLE(CenterId INT)    
 DECLARE @tblCourse TABLE(CourseID INT)  
   
 DECLARE @S_Instance_Chain VARCHAR(500)  
   
        SELECT TOP 1  
                @S_Instance_Chain = FN2.instanceChain  
        FROM    [dbo].[fnGetInstanceNameChainForReports](@sHierarchyID,  
                                                         @sBrandID) FN2  
        WHERE   FN2.HierarchyDetailID IN (  
                SELECT  HierarchyDetailID  
                FROM    [fnGetCentersForReports](@sHierarchyID, @sBrandID) )   
   
 SELECT @MONTH_START=MONTH(@dtStartDate)  
 SELECT @MONTH_CURRENT=MONTH(@dtStartDate)  
 SELECT @MONTH_END=MONTH(@dtEndDate)  
 SELECT @YR_START=YEAR(@dtStartDate)  
 SELECT @YR_CURRENT=YEAR(@dtStartDate)  
 SELECT @YR_END=YEAR(@dtEndDate)  
   
 WHILE (@YR_END>@YR_CURRENT) OR (@YR_END=@YR_CURRENT AND @MONTH_END>=@MONTH_CURRENT)  
 BEGIN  
  INSERT INTO @YEARMONTH VALUES(@MONTH_CURRENT,@YR_CURRENT)  
  IF @MONTH_CURRENT =12  
   BEGIN  
    SELECT @MONTH_CURRENT = 1  
    SELECT @YR_CURRENT=@YR_CURRENT+1  
   END  
  ELSE  
   BEGIN  
    SELECT @MONTH_CURRENT = @MONTH_CURRENT +1  
   END  
 END  
   
 INSERT INTO @tblCenter  
 SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCenterIDs, ',') AS FSR  
   
 IF ((SELECT COUNT([CenterId]) FROM @tblCenter) = 0)  
 BEGIN  
  INSERT INTO @tblCenter  
  SELECT [I_Center_ID] FROM [dbo].[fnGetCenterIDFromHierarchy](@sHierarchyID, CAST(@sBrandID AS INT)) AS FGCIFH  
 END  
   
 INSERT INTO @tblCourse  
 SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCourseIDs, ',') AS FSR  
   
 IF ((SELECT COUNT(CourseID) FROM @tblCourse) = 0)  
 BEGIN  
  INSERT INTO @tblCourse  
  SELECT I_Course_ID FROM dbo.T_Course_Master AS tcm WHERE I_Brand_ID = CAST(@sBrandID AS INT)  
 END  
  
 DECLARE @TOTAL_ENQUIRY INT  
 DECLARE @TOTAL_ENROLL INT  
 DECLARE @INVOICE_AMOUNT NUMERIC(18,2)  
 DECLARE @COLLECTION_AMOUNT NUMERIC(18,2)  
  
 DECLARE @CENTERID INT  
 DECLARE @CENTERCODE VARCHAR(20)  
 DECLARE @CURRENCYCODE VARCHAR(20)  
   
 INSERT INTO @EEBCINITIAL  
 SELECT DISTINCT   
 FN1.CENTERID,  
 TCM.[S_Center_Code] AS CENTERCODE,  
 TCM.[S_Center_Name] AS CENTERNAME,  
 CUM.S_CURRENCY_CODE  
 FROM @tblCenter FN1  
 INNER JOIN [dbo].[T_Centre_Master] AS TCM WITH(NOLOCK) ON [FN1].[CenterId] = [TCM].[I_Centre_Id]  
 INNER JOIN DBO.T_COUNTRY_MASTER COM WITH(NOLOCK) ON TCM.[I_Country_ID] = COM.I_COUNTRY_ID  
 INNER JOIN DBO.T_CURRENCY_MASTER CUM WITH(NOLOCK) ON COM.I_CURRENCY_ID = CUM.I_CURRENCY_ID  
 ORDER BY CENTERID  
   
 INSERT INTO @EEBCANALYSIS1 (I_CENTRE_ID,CENTERCODE,S_CURRENCY_CODE,I_COURSE_ID,S_COURSE,S_COURSE_FAMILY,[MONTH],[YEAR])  
 (  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH([C].[Dt_Crtd_On]),  
 YEAR([C].[Dt_Crtd_On])  
 FROM DBO.T_ENQUIRY_REGN_DETAIL C WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=C.I_CENTRE_ID  
 INNER JOIN [dbo].[T_Enquiry_Course] AS TEC WITH(NOLOCK) ON [C].[I_Enquiry_Regn_ID] = [TEC].[I_Enquiry_Regn_ID]  
 INNER JOIN @tblCourse TC ON TC.CourseID = [TEC].[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON [TEC].[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE C.I_ENQUIRY_STATUS_CODE<>0  
 AND (DATEDIFF(DD,[C].[Dt_Crtd_On],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,[C].[Dt_Crtd_On]) <= 0)  
   
 UNION ALL  
  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,   
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH([SD].[Dt_Crtd_On]),  
 YEAR([SD].[Dt_Crtd_On])  
 FROM DBO.t_student_detail SD WITH(NOLOCK)  
 ------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD WITH(NOLOCK)   
 ------ON [TSCD].[I_Student_Detail_ID] = [SD].[I_Student_Detail_ID]  
 INNER JOIN dbo.T_Student_Batch_Details AS tsbd ON tsbd.I_Student_ID = SD.I_Student_Detail_ID  
 INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tsbd.I_Batch_ID  
 INNER JOIN dbo.T_Student_Center_Detail AS tscd2 ON tscd2.I_Student_Detail_ID = SD.I_Student_Detail_ID  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID = tscd2.I_CENTRE_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tsbm.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tsbm.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE SD.I_STATUS <> 0  
 AND (DATEDIFF(DD,[SD].[Dt_Crtd_On],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,[SD].[Dt_Crtd_On]) <= 0)  
  
 UNION ALL  
  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH([IP].[Dt_Invoice_Date]),  
 YEAR([IP].[Dt_Invoice_Date])  
 FROM DBO.T_INVOICE_PARENT IP WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=IP.I_CENTRE_ID  
 ------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD WITH(NOLOCK)   
 ------ON [TSCD].[I_Student_Detail_ID] = IP.[I_Student_Detail_ID]   
 ------AND [TSCD].[I_Centre_Id] = [IP].[I_Centre_Id]  
 INNER JOIN dbo.T_Invoice_Child_Header AS tich ON IP.I_Invoice_Header_ID = tich.I_Invoice_Header_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tich.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tich.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE (DATEDIFF(DD,[IP].[Dt_Invoice_Date],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,[IP].[Dt_Invoice_Date])<= 0)  
  
 UNION ALL  
  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH([IP].Dt_Upd_On),  
 YEAR([IP].Dt_Upd_On)  
 FROM DBO.T_INVOICE_PARENT IP WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=IP.I_CENTRE_ID  
 ------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD WITH(NOLOCK)   
 ------ON [TSCD].[I_Student_Detail_ID] = IP.[I_Student_Detail_ID]   
 ------AND [TSCD].[I_Centre_Id] = [IP].[I_Centre_Id]  
 INNER JOIN dbo.T_Invoice_Child_Header AS tich ON IP.I_Invoice_Header_ID = tich.I_Invoice_Header_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tich.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tich.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE (DATEDIFF(DD,[IP].Dt_Upd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,[IP].Dt_Upd_On)<= 0)  
  
 UNION ALL  
  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH([RH].[Dt_Receipt_Date]),  
 YEAR([RH].[Dt_Receipt_Date])  
 FROM T_Receipt_Header RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=RH.I_CENTRE_ID  
 ------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD WITH(NOLOCK) ON [TSCD].[I_Student_Detail_ID] = RH.[I_Student_Detail_ID]  
 INNER JOIN dbo.T_Invoice_Child_Header AS tich2 ON RH.I_Invoice_Header_ID = tich2.I_Invoice_Header_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tich2.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tich2.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE RH.I_STATUS <> 0  
 AND (DATEDIFF(DD,[RH].[Dt_Receipt_Date],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,[RH].[Dt_Receipt_Date]) <= 0)  
  
 UNION ALL  
  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH([RH].[Dt_Upd_On]),  
 YEAR([RH].[Dt_Upd_On])  
 FROM T_Receipt_Header RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=RH.I_CENTRE_ID  
 ------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD WITH(NOLOCK) ON [TSCD].[I_Student_Detail_ID] = RH.[I_Student_Detail_ID]  
 INNER JOIN dbo.T_Invoice_Child_Header AS tich2 ON RH.I_Invoice_Header_ID = tich2.I_Invoice_Header_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tich2.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tich2.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE RH.I_STATUS = 0  
 AND (DATEDIFF(DD,[RH].[Dt_Upd_On],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,[RH].[Dt_Upd_On]) <= 0)  
   
 UNION ALL  
  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH(tsrd.Crtd_On),  
 YEAR(tsrd.Crtd_On)  
 FROM T_Receipt_Header RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=RH.I_CENTRE_ID  
 ------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD WITH(NOLOCK) ON [TSCD].[I_Student_Detail_ID] = RH.[I_Student_Detail_ID]  
 INNER JOIN dbo.T_Student_Registration_Details AS tsrd ON RH.I_Enquiry_Regn_ID = tsrd.I_Enquiry_Regn_ID  
 INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsrd.I_Batch_ID = tsbm.I_Batch_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tsbm.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tsbm.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE (DATEDIFF(DD,tsrd.Crtd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,tsrd.Crtd_On) <= 0)  
   
 UNION ALL  
  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH(tsrd.Updt_On),  
 YEAR(tsrd.Updt_On)  
 FROM T_Receipt_Header RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=RH.I_CENTRE_ID  
 ------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD WITH(NOLOCK) ON [TSCD].[I_Student_Detail_ID] = RH.[I_Student_Detail_ID]  
 INNER JOIN dbo.T_Student_Registration_Details AS tsrd ON RH.I_Enquiry_Regn_ID = tsrd.I_Enquiry_Regn_ID  
 INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsrd.I_Batch_ID = tsbm.I_Batch_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tsbm.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tsbm.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE (DATEDIFF(DD,tsrd.Updt_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,tsrd.Updt_On) <= 0)  
   
 UNION ALL  
  
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH(RH.Dt_Upd_On),  
 YEAR(RH.Dt_Upd_On)  
 FROM T_Receipt_Header RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=RH.I_CENTRE_ID  
 ------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD WITH(NOLOCK) ON [TSCD].[I_Student_Detail_ID] = RH.[I_Student_Detail_ID]  
 INNER JOIN dbo.T_Student_Registration_Details AS tsrd ON RH.I_Enquiry_Regn_ID = tsrd.I_Enquiry_Regn_ID  
 INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsrd.I_Batch_ID = tsbm.I_Batch_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tsbm.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tsbm.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE (DATEDIFF(DD,RH.Dt_Upd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.Dt_Upd_On) <= 0)  
   
 UNION ALL  
   
 SELECT   
 A.I_CENTRE_ID CID,  
 A.CENTERCODE,  
 A.S_CURRENCY_CODE,  
 TC.CourseID,  
 TCM.S_Course_Name,  
 TCFM.S_CourseFamily_Name,  
 MONTH(RH.Dt_Receipt_Date),  
 YEAR(RH.Dt_Receipt_Date)  
 FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A  
 ON RH.I_CENTRE_ID = A.I_CENTRE_ID  
 AND I_Receipt_Type = 21  
 INNER JOIN [dbo].T_Student_Registration_Details AS TSRD WITH(NOLOCK)   
 ON [TSRD].I_Enquiry_Regn_ID = [RH].I_Enquiry_Regn_ID  
 INNER JOIN T_Student_Batch_Master AS TSBM WITH(NOLOCK) ON TSBM.I_Batch_ID = TSRD.I_Batch_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = TSBM.[I_Course_ID]  
 INNER JOIN [dbo].[T_Course_Master] AS TCM WITH(NOLOCK) ON tsbm.[I_Course_ID] = [TCM].[I_Course_ID]  
 INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM WITH(NOLOCK) ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]  
 WHERE RH.[I_Student_Detail_ID] IS NULL  
 AND (DATEDIFF(DD,RH.Dt_Receipt_Date,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.Dt_Receipt_Date) <= 0)  
   
 UNION ALL  
   
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 99999999,  
 'On-Account Receipts',  
 'On-Account Receipts',  
 MONTH(trh.Dt_Receipt_Date),  
 YEAR(trh.Dt_Receipt_Date)  
 FROM dbo.T_Receipt_Header AS trh  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID= trh.I_CENTRE_ID  
 WHERE I_Student_Detail_ID IS NOT NULL AND I_Invoice_Header_ID IS NULL  
 AND (DATEDIFF(DD,trh.Dt_Receipt_Date,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,trh.Dt_Receipt_Date) <= 0)  
   
 UNION ALL  
   
 SELECT   
 A.I_CENTRE_ID,   
 A.CENTERCODE,   
 A.S_CURRENCY_CODE,  
 99999999,  
 'On-Account Receipts',  
 'On-Account Receipts',  
 MONTH(trh.Dt_Upd_On),  
 YEAR(trh.Dt_Upd_On)  
 FROM dbo.T_Receipt_Header AS trh  
 INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID= trh.I_CENTRE_ID  
 WHERE I_Student_Detail_ID IS NOT NULL AND I_Invoice_Header_ID IS NULL  
 AND (DATEDIFF(DD,trh.Dt_Upd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,trh.Dt_Upd_On) <= 0)  
   
 )  
   
 INSERT INTO @EEBCANALYSIS  
 SELECT DISTINCT * FROM @EEBCANALYSIS1  
   
 --SELECT DISTINCT * FROM @EEBCANALYSIS1  
   
 UPDATE @EEBCANALYSIS SET TOTAL_ENQUIRY = ISNULL(Z.CNT,0)  
 FROM @EEBCANALYSIS P INNER JOIN  
 (  
 SELECT A.I_CENTRE_ID CID,TC.CourseID, B.MONTH M,B.YEAR Y,COUNT(DISTINCT SCD.I_ENQUIRY_REGN_ID) CNT  
 FROM @EEBCINITIAL A  
 INNER JOIN DBO.T_ENQUIRY_REGN_DETAIL SCD  WITH(NOLOCK)  
 ON SCD.I_CENTRE_ID=A.I_CENTRE_ID  
 INNER JOIN @YEARMONTH B  
 ON MONTH(SCD.DT_CRTD_ON)=B.MONTH  
 AND YEAR(SCD.DT_CRTD_ON)=B.YEAR   
 LEFT OUTER JOIN [dbo].[T_Enquiry_Course] AS TEC WITH(NOLOCK) ON [SCD].[I_Enquiry_Regn_ID] = [TEC].[I_Enquiry_Regn_ID]  
 LEFT OUTER JOIN @tblCourse TC ON TC.CourseID = [TEC].[I_Course_ID]  
 --WHERE SCD.[I_Enquiry_Regn_ID] NOT IN (  
 -- SELECT [TERD].[I_Enquiry_Regn_ID] FROM [dbo].[T_Enquiry_Regn_Detail] AS TERD WITH(NOLOCK)  
 -- INNER JOIN [dbo].[T_Student_Detail] AS TSD WITH(NOLOCK)  
 -- ON [TERD].[I_Enquiry_Regn_ID] = [TSD].[I_Enquiry_Regn_ID]  
 -- WHERE [TSD].[I_Student_Detail_ID] IN   
 -- (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK)))  
 WHERE (DATEDIFF(DD,SCD.[Dt_Crtd_On],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,SCD.[Dt_Crtd_On]) <= 0)  
 AND SCD.I_PreEnquiryFor=1  
 GROUP BY A.I_CENTRE_ID, TC.CourseID, B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y  
   
 UPDATE @EEBCANALYSIS SET TOTAL_REGISTRATION = ISNULL(Z.CNT,0)  
 FROM @EEBCANALYSIS P INNER JOIN  
 (  
 SELECT A.I_CENTRE_ID CID,TC.CourseID, B.MONTH M,B.YEAR Y,COUNT(DISTINCT trh.I_Receipt_Header_ID) CNT  
 FROM @EEBCINITIAL A  
 INNER JOIN dbo.T_Receipt_Header AS trh ON trh.I_Centre_Id = A.I_CENTRE_ID  
 AND trh.I_Receipt_Type IN (31,32,50,51,57) AND trh.I_Status = 1  
 --INNER JOIN DBO.T_Student_Registration_Details SRD WITH(NOLOCK)  
 --ON SRD.I_DESTINATION_CENTER_ID=A.I_CENTRE_ID  
 INNER JOIN @YEARMONTH B  
 ON MONTH(trh.Dt_Crtd_On)=B.MONTH  
 AND YEAR(trh.Dt_Crtd_On)=B.YEAR  
 --INNER JOIN [dbo].T_Student_Batch_Master TSBM ON TSBM.I_Batch_ID = SRD.I_Batch_ID  
 INNER JOIN dbo.T_Enquiry_Course AS tec ON tec.I_Enquiry_Regn_ID = trh.I_Enquiry_Regn_ID  
 INNER JOIN @tblCourse TC ON TC.CourseID = tec.I_Course_ID  
 --WHERE SRD.[I_Enquiry_Regn_ID] NOT IN (  
 -- SELECT [TERD].[I_Enquiry_Regn_ID] FROM [dbo].[T_Enquiry_Regn_Detail] AS TERD WITH(NOLOCK)  
 -- INNER JOIN [dbo].[T_Student_Detail] AS TSD WITH(NOLOCK)  
 -- ON [TERD].[I_Enquiry_Regn_ID] = [TSD].[I_Enquiry_Regn_ID]  
 -- WHERE [TSD].[I_Student_Detail_ID] IN   
 -- (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK)))  
 WHERE (DATEDIFF(DD,trh.Dt_Crtd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,trh.Dt_Crtd_On) <= 0)  
  
 GROUP BY A.I_CENTRE_ID, TC.CourseID, B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y  
   
 ---Commented by Akash on 15.1.2014
  
 --UPDATE @EEBCANALYSIS SET TOTAL_ENROLL = ISNULL(Z.CNT,0)  
 --FROM @EEBCANALYSIS P INNER JOIN  
 --(SELECT A.I_CENTRE_ID CID,TC.CourseID,B.MONTH M,B.YEAR Y,COUNT(DISTINCT IP.I_Invoice_Header_ID) CNT  
 --FROM @EEBCINITIAL A  
 --INNER JOIN DBO.T_INVOICE_PARENT IP WITH(NOLOCK)  
 --ON IP.[I_Centre_Id] = A.I_CENTRE_ID  
 --INNER JOIN @YEARMONTH B  
 --ON MONTH(IP.Dt_Crtd_On)=B.MONTH  
 --AND YEAR(IP.Dt_Crtd_On)=B.YEAR  
 --INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH ON [IP].[I_Invoice_Header_ID] = [TICH].[I_Invoice_Header_ID]  
 --LEFT OUTER JOIN @tblCourse TC ON TC.CourseID = [TICH].[I_Course_ID]  
 --WHERE IP.[I_Student_Detail_ID] NOT IN   
 --  (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))
   
 --  ---Added by Akash---
 --  AND IP.I_Student_Detail_ID IN (SELECT TSD.I_Student_Detail_ID FROM dbo.T_Student_Detail TSD WHERE DATEDIFF(dd,TSD.Dt_Crtd_On,IP.Dt_Crtd_On)=0)
 --  ---Added End by Akash---
     
 --AND (DATEDIFF(DD,IP.Dt_Crtd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,IP.Dt_Crtd_On) <= 0)  
 --AND IP.N_Invoice_Amount >= 0  
 --GROUP BY A.I_CENTRE_ID,TC.CourseID,B.MONTH,B.YEAR  
 --) AS Z  
 --ON P.I_CENTRE_ID = Z.CID  
 --AND P.I_Course_ID = [Z].CourseID  
 --AND P.MONTH = Z.M  
 --AND P.YEAR = Z.Y
 
 ------Comment End--------
 
 UPDATE @EEBCANALYSIS SET TOTAL_ENROLL = ISNULL(Z.CNT,0)  
 FROM @EEBCANALYSIS P INNER JOIN  
 (SELECT A.I_CENTRE_ID CID,TC.CourseID,B.MONTH M,B.YEAR Y,COUNT(TSD.S_Student_ID) CNT 
 FROM @EEBCINITIAL A
 INNER JOIN dbo.T_Center_Batch_Details TCBD ON A.I_CENTRE_ID=TCBD.I_Centre_Id
 INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON TCBD.I_Batch_ID = TSBM2.I_Batch_ID
 INNER JOIN dbo.T_Student_Batch_Details TSBD2 ON TSBM2.I_Batch_ID = TSBD2.I_Batch_ID
 INNER JOIN dbo.T_Student_Detail TSD ON TSD.I_Student_Detail_ID=TSBD2.I_Student_ID
 INNER JOIN @YEARMONTH B  
 ON MONTH(TSD.Dt_Crtd_On)=B.MONTH  
 AND YEAR(TSD.Dt_Crtd_On)=B.YEAR  
 LEFT OUTER JOIN @tblCourse TC ON TC.CourseID = TSBM2.I_Course_ID
 WHERE TSBD2.I_Status=1
 AND (DATEDIFF(DD,TSD.Dt_Crtd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,TSD.Dt_Crtd_On) <= 0)
 GROUP BY A.I_CENTRE_ID,TC.CourseID,B.YEAR,B.MONTH 
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y
 ---Commented by Akash-----  
 --UPDATE @EEBCANALYSIS SET TOTAL_ENROLL = ISNULL(TOTAL_ENROLL,0) - ISNULL(Z.CNT,0)  
 --FROM @EEBCANALYSIS P INNER JOIN  
 --(SELECT A.I_CENTRE_ID CID,TC.CourseID,B.MONTH M,B.YEAR Y,COUNT(DISTINCT IP.I_Invoice_Header_ID) CNT  
 --FROM @EEBCINITIAL A  
 --INNER JOIN DBO.T_INVOICE_PARENT IP WITH(NOLOCK)  
 --ON IP.[I_Centre_Id] = A.I_CENTRE_ID AND I_Status = 0  
 --INNER JOIN @YEARMONTH B  
 --ON MONTH(IP.DT_UPD_ON)=B.MONTH  
 --AND YEAR(IP.DT_UPD_ON)=B.YEAR  
 --INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH ON [IP].[I_Invoice_Header_ID] = [TICH].[I_Invoice_Header_ID]  
 --LEFT OUTER JOIN @tblCourse TC ON TC.CourseID = [TICH].[I_Course_ID]  
 ----INNER JOIN DBO.T_STUDENT_CENTER_DETAIL SCD  
 ----ON SCD.I_CENTRE_ID=A.I_CENTRE_ID  
 ----INNER JOIN DBO.T_INVOICE_PARENT IP  
 ----ON IP.I_STUDENT_DETAIL_ID=SCD.I_STUDENT_DETAIL_ID  
 ----INNER JOIN @YEARMONTH B  
 ----ON MONTH(IP.DT_UPD_ON)=B.MONTH  
 ----AND YEAR(IP.DT_UPD_ON)=B.YEAR  
 ----INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD ON [TSCD].[I_Student_Detail_ID] = [SCD].[I_Student_Detail_ID]  
 ----INNER JOIN @tblCourse TC ON TC.CourseID = TSCD.[I_Course_ID]  
 --WHERE IP.[I_Student_Detail_ID] NOT IN   
 --  (SELECT DISTINCT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)  
 --AND (DATEDIFF(DD,IP.Dt_Upd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,IP.Dt_Upd_On) <= 0)  
 --AND IP.N_Invoice_Amount > 0  
 --GROUP BY A.I_CENTRE_ID,TC.CourseID,B.MONTH,B.YEAR  
 --) AS Z  
 --ON P.I_CENTRE_ID = Z.CID  
 --AND P.I_Course_ID = [Z].CourseID  
 --AND P.MONTH = Z.M  
 --AND P.YEAR = Z.Y
 
 ----Commented End by Akash-----  
  
 UPDATE @EEBCANALYSIS SET INVOICE_AMOUNT = ISNULL(Z.SUM1,0), INVOICE_TAX_AMOUNT=ISNULL(Z.SUM2,0)  
 FROM @EEBCANALYSIS P INNER JOIN  
 (SELECT   
 A.I_CENTRE_ID CID,TC.CourseID,  
 B.MONTH M,  
 B.YEAR Y,   
 SUM(ISNULL([TICH].[N_Amount],0)) SUM1,  
 SUM(ISNULL([TICH].[N_Tax_Amount],0)) SUM2  
 FROM @EEBCINITIAL A  
 INNER JOIN DBO.T_INVOICE_PARENT IP WITH(NOLOCK) ON A.I_CENTRE_ID = IP.I_CENTRE_ID --AND IP.I_STATUS = 1  
 INNER JOIN @YEARMONTH B ON MONTH(IP.DT_INVOICE_DATE)=B.MONTH AND YEAR(IP.DT_INVOICE_DATE)=B.YEAR  
 INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH ON [IP].[I_Invoice_Header_ID] = [TICH].[I_Invoice_Header_ID]  
 INNER JOIN @tblCourse TC ON TC.CourseID = [TICH].[I_Course_ID]  
 WHERE IP.[I_Student_Detail_ID] NOT IN   
   (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))  
 AND (DATEDIFF(DD,IP.[Dt_Invoice_Date],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,IP.[Dt_Invoice_Date]) <= 0)  
 GROUP BY A.I_CENTRE_ID,TC.CourseID,B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y   
   
 ----------------  
 UPDATE @EEBCANALYSIS SET INVOICE_AMOUNT = ISNULL(INVOICE_AMOUNT,0) - ISNULL(Z.SUM1,0),INVOICE_TAX_AMOUNT= ISNULL(INVOICE_TAX_AMOUNT,0) - ISNULL(Z.SUM2,0)  
 FROM @EEBCANALYSIS P INNER JOIN  
 (SELECT   
 A.I_CENTRE_ID CID,TC.CourseID,  
 B.MONTH M,  
 B.YEAR Y,   
 SUM(ISNULL([TICH].[N_Amount],0)) SUM1,  
 SUM(ISNULL([TICH].[N_Tax_Amount],0)) SUM2  
 FROM @EEBCINITIAL A  
 INNER JOIN DBO.T_INVOICE_PARENT IP WITH(NOLOCK) ON A.I_CENTRE_ID = IP.I_CENTRE_ID --AND IP.I_STATUS = 0  
 INNER JOIN @YEARMONTH B ON MONTH(IP.DT_UPD_ON)=B.MONTH AND YEAR(IP.DT_UPD_ON)=B.YEAR  
 INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH ON [IP].[I_Invoice_Header_ID] = [TICH].[I_Invoice_Header_ID]  
 INNER JOIN @tblCourse TC ON TC.CourseID = TICH.[I_Course_ID]  
 WHERE IP.[I_Student_Detail_ID] NOT IN   
   (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))  
 AND (DATEDIFF(DD,IP.DT_UPD_ON,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,IP.DT_UPD_ON) <= 0)  
 GROUP BY A.I_CENTRE_ID,TC.CourseID,B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y  
 -----------------------  
  
 UPDATE @EEBCANALYSIS SET COLLECTION_AMOUNT = Z.SUM1, COLLECTION_TAX_AMOUNT=Z.SUM2  
 FROM @EEBCANALYSIS P INNER JOIN  
 (SELECT A.I_CENTRE_ID CID,TC.CourseID,B.MONTH M,B.YEAR Y, SUM(ISNULL(TRCD.[N_Amount_Paid],0.00)) SUM1,SUM(ISNULL(Tax.N_Tax_Paid,0.00)) SUM2  
 FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)   
 INNER JOIN @EEBCINITIAL A  
 ON RH.I_CENTRE_ID = A.I_CENTRE_ID   
 --AND [RH].[I_Status] = 1  
 INNER JOIN [dbo].[T_Receipt_Component_Detail] AS TRCD ON [RH].[I_Receipt_Header_ID] = [TRCD].[I_Receipt_Detail_ID]  
 LEFT OUTER JOIN (SELECT trtd.I_Receipt_Comp_Detail_ID, SUM(trtd.N_Tax_Paid) AS N_Tax_Paid FROM dbo.T_Receipt_Tax_Detail AS trtd   
    GROUP BY trtd.I_Receipt_Comp_Detail_ID) AS Tax  
 ON TRCD.I_Receipt_Comp_Detail_ID = Tax.I_Receipt_Comp_Detail_ID  
 INNER JOIN [dbo].[T_Invoice_Child_Detail] AS TICD ON [TRCD].[I_Invoice_Detail_ID] = [TICD].[I_Invoice_Detail_ID]  
 INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH ON TICD.[I_Invoice_Child_Header_ID] = [TICH].[I_Invoice_Child_Header_ID]  
 INNER JOIN @YEARMONTH B  
 ON MONTH(RH.DT_RECEIPT_DATE)=B.MONTH  
 AND YEAR(RH.DT_RECEIPT_DATE)=B.YEAR  
 INNER JOIN @tblCourse TC ON TC.CourseID = TICH.[I_Course_ID]  
 WHERE RH.[I_Student_Detail_ID] IS NOT NULL   
  AND RH.[I_Student_Detail_ID] NOT IN   
   (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))  
 AND (DATEDIFF(DD,RH.DT_RECEIPT_DATE,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_RECEIPT_DATE) <= 0)  
 GROUP BY A.I_CENTRE_ID,TC.CourseID,B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y  
   
 /*UPDATE @EEBCANALYSIS SET COLLECTION_AMOUNT = ISNULL(COLLECTION_AMOUNT,0) + Z.SUM1,COLLECTION_TAX_AMOUNT = ISNULL(COLLECTION_TAX_AMOUNT,0) + Z.SUM2  
 FROM @EEBCANALYSIS P INNER JOIN  
 (SELECT A.I_CENTRE_ID CID,99999999 AS CourseID,B.MONTH M,B.YEAR Y, SUM(ISNULL(RH.N_RECEIPT_AMOUNT,0.00)) SUM1, SUM(ISNULL(RH.N_Tax_Amount,0.00)) SUM2  
 FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A  
 ON RH.I_CENTRE_ID = A.I_CENTRE_ID  
 --AND [RH].[I_Status] = 1  
 INNER JOIN @YEARMONTH B  
 ON MONTH(RH.DT_RECEIPT_DATE)=B.MONTH  
 AND YEAR(RH.DT_RECEIPT_DATE)=B.YEAR  
 --INNER JOIN [dbo].T_Student_Registration_Details AS TSRD WITH(NOLOCK)   
 --ON [TSRD].I_Enquiry_Regn_ID = [RH].I_Enquiry_Regn_ID  
 --AND [TSRD].[I_Receipt_Header_ID] = [RH].[I_Receipt_Header_ID]  
 --INNER JOIN T_Student_Batch_Master AS TSBM WITH(NOLOCK) ON TSBM.I_Batch_ID = TSRD.I_Batch_ID  
 --INNER JOIN @tblCourse TC ON TC.CourseID = TSBM.[I_Course_ID]  
 WHERE RH.[I_Student_Detail_ID] IS NULL  
 AND (DATEDIFF(DD,RH.DT_RECEIPT_DATE,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_RECEIPT_DATE) <= 0)  
 GROUP BY A.I_CENTRE_ID,B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y*/  
   
 UPDATE @EEBCANALYSIS SET COLLECTION_AMOUNT = ISNULL(COLLECTION_AMOUNT,0) + Z.SUM1,COLLECTION_TAX_AMOUNT = ISNULL(COLLECTION_TAX_AMOUNT,0) + Z.SUM2  
 FROM @EEBCANALYSIS P INNER JOIN  
 (SELECT A.I_CENTRE_ID CID,99999999 AS CourseID,B.MONTH M,B.YEAR Y, SUM(ISNULL(RH.N_RECEIPT_AMOUNT,0.00)) SUM1, SUM(ISNULL(RH.N_Tax_Amount,0.00)) SUM2  
 FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A  
 ON RH.I_CENTRE_ID = A.I_CENTRE_ID  
 INNER JOIN @YEARMONTH B  
 ON MONTH(RH.DT_RECEIPT_DATE)=B.MONTH  
 AND YEAR(RH.DT_RECEIPT_DATE)=B.YEAR   
 WHERE I_Invoice_Header_ID IS NULL  
 AND (DATEDIFF(DD,RH.DT_RECEIPT_DATE,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_RECEIPT_DATE) <= 0)  
 GROUP BY A.I_CENTRE_ID,B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y  
   
 UPDATE @EEBCANALYSIS SET COLLECTION_AMOUNT = ISNULL(COLLECTION_AMOUNT,0) - Z.SUM1,COLLECTION_TAX_AMOUNT = ISNULL(COLLECTION_TAX_AMOUNT,0) - Z.SUM2  
 FROM @EEBCANALYSIS P INNER JOIN  
 (SELECT A.I_CENTRE_ID CID,TC.CourseID,B.MONTH M,B.YEAR Y, SUM(ISNULL(TRCD.[N_Amount_Paid],0.00)) SUM1,SUM(ISNULL(Tax.N_Tax_Paid,0.00)) SUM2  
 FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)   
 INNER JOIN @EEBCINITIAL A  
 ON RH.I_CENTRE_ID = A.I_CENTRE_ID   
 AND [RH].[I_Status] = 0  
 INNER JOIN [dbo].[T_Receipt_Component_Detail] AS TRCD ON [RH].[I_Receipt_Header_ID] = [TRCD].[I_Receipt_Detail_ID]  
 LEFT OUTER JOIN (SELECT trtd.I_Receipt_Comp_Detail_ID, SUM(trtd.N_Tax_Paid) AS N_Tax_Paid FROM dbo.T_Receipt_Tax_Detail AS trtd   
    GROUP BY trtd.I_Receipt_Comp_Detail_ID) AS Tax  
 ON TRCD.I_Receipt_Comp_Detail_ID = Tax.I_Receipt_Comp_Detail_ID  
 INNER JOIN [dbo].[T_Invoice_Child_Detail] AS TICD ON [TRCD].[I_Invoice_Detail_ID] = [TICD].[I_Invoice_Detail_ID]  
 INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH ON TICD.[I_Invoice_Child_Header_ID] = [TICH].[I_Invoice_Child_Header_ID]   
 INNER JOIN @YEARMONTH B  
 ON MONTH(RH.DT_UPD_ON)=B.MONTH  
 AND YEAR(RH.DT_UPD_ON)=B.YEAR  
 LEFT OUTER JOIN @tblCourse TC ON TC.CourseID = TICH.[I_Course_ID]  
 WHERE RH.[I_Student_Detail_ID] IS NOT NULL   
  AND RH.[I_Student_Detail_ID] NOT IN   
   (SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))  
 AND (DATEDIFF(DD,RH.DT_UPD_ON,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_UPD_ON) <= 0)  
 GROUP BY A.I_CENTRE_ID,TC.CourseID,B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y  
   
 UPDATE @EEBCANALYSIS SET COLLECTION_AMOUNT = ISNULL(COLLECTION_AMOUNT,0) - Z.SUM1,COLLECTION_TAX_AMOUNT = ISNULL(COLLECTION_TAX_AMOUNT,0) - Z.SUM2  
 FROM @EEBCANALYSIS P INNER JOIN  
 (SELECT A.I_CENTRE_ID CID,99999999 AS CourseID,B.MONTH M,B.YEAR Y, SUM(ISNULL(RH.N_RECEIPT_AMOUNT,0.00)) SUM1, SUM(ISNULL(RH.N_Tax_Amount,0.00)) SUM2  
 FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)  
 INNER JOIN @EEBCINITIAL A  
 ON RH.I_CENTRE_ID = A.I_CENTRE_ID  
 AND RH.I_Status = 0  
 INNER JOIN @YEARMONTH B  
 ON MONTH(RH.Dt_Upd_On)=B.MONTH  
 AND YEAR(RH.Dt_Upd_On)=B.YEAR   
 WHERE I_Invoice_Header_ID IS NULL  
 AND (DATEDIFF(DD,RH.Dt_Upd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.Dt_Upd_On) <= 0)  
 GROUP BY A.I_CENTRE_ID,B.MONTH,B.YEAR  
 ) AS Z  
 ON P.I_CENTRE_ID = Z.CID  
 AND P.I_Course_ID = [Z].CourseID  
 AND P.MONTH = Z.M  
 AND P.YEAR = Z.Y  
   
 SELECT [B].[I_Center_ID] AS CenterID ,  
         [B].[S_Center_Name] AS CenterName ,  
         [B].[I_Brand_ID] AS BrandID ,  
         [B].[S_Brand_Name] AS BrandName ,  
         [B].[I_Region_ID] AS RegionID ,  
         [B].[S_Region_Name] AS RegionName ,  
         [B].[I_Territory_ID] AS TerritoryID ,  
         [B].[S_Territiry_Name]  AS TerritiryName,  
         [B].[I_City_ID] AS CityID ,  
         [B].[S_City_Name] AS CityName, A.*, @S_Instance_Chain AS S_Instance_Chain FROM @EEBCANALYSIS A  
 INNER JOIN [dbo].[T_Center_Hierarchy_Name_Details] AS B WITH(NOLOCK)  
 ON B.[I_Center_ID] = A.I_Centre_ID  
END
