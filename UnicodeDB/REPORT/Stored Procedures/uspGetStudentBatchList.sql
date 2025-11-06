CREATE PROCEDURE [REPORT].[uspGetStudentBatchList]-- [REPORT].[uspGetStudentBatchList] 107,'1','5'   
    (
      @iBrandId INT ,
      @sHierarchyList VARCHAR(MAX) ,
      @iBatchId VARCHAR(MAX) = NULL    
    )
AS 
    BEGIN    
    
    IF (@iBatchId IS NOT NULL AND  @iBatchId!='' AND @iBatchId!=0 AND @iBatchId!='--Select--' )
    BEGIN
        SELECT  E.S_Brand_Name ,
                C.S_Batch_Name ,
                A.S_Student_ID ,
                A.S_First_Name ,
                A.S_Middle_Name ,
                A.S_Last_Name ,
                I.S_Sex_Name ,
                a.Dt_Birth_Date AS DateOfBirth ,
                A.S_Mobile_No ,
                H.S_Father_Name ,
                H.S_Mother_Name ,
                H.S_Phone_No ,
                CASE WHEN F.I_Brand_ID = 107
                     THEN CASE WHEN H.S_Father_Name IS NOT NULL
                                    AND LTRIM(RTRIM(H.S_Father_Name)) <> ''
                               THEN H.S_Father_Name
                               ELSE H.S_Mother_Name
                          END
                     ELSE A.S_Guardian_Name
                END AS S_Guardian_Name ,
                A.S_Curr_Address1 ,
                A.S_Perm_Address1 ,
                G.S_House_Name ,
                K.S_Route_No ,
                J.S_PickupPoint_Name,
                A.S_Guardian_Phone_No AS S_Guardian_Mobile_No,
                CASE WHEN C.Dt_BatchStartDate>GETDATE() THEN 'Waiting'
                WHEN C.Dt_BatchStartDate<=GETDATE() AND T1.AttnCount IS NULL THEN 'Waiting'
                WHEN C.Dt_BatchStartDate<=GETDATE() AND T1.AttnCount IS NOT NULL THEN 'Active'
                END AS StdStatus
        FROM    T_Student_Detail A
                INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID = B.I_Student_ID
                INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID = B.I_Batch_ID
                INNER JOIN T_Center_Batch_Details D ON C.I_Batch_ID = D.I_Batch_ID
                INNER JOIN T_Center_Hierarchy_Name_Details E ON E.I_Center_ID = D.I_Centre_Id
                INNER JOIN T_Course_Master F ON F.I_Course_ID = C.I_Course_ID    
--left join T_House_Master G    
--on A.I_House_ID=G.I_House_ID    
                INNER JOIN T_Enquiry_Regn_Detail H ON H.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
                LEFT JOIN T_User_Sex I ON I.I_Sex_ID = H.I_Sex_ID
                LEFT JOIN T_House_Master G ON A.I_House_ID = G.I_House_ID
                LEFT JOIN T_Transport_Master J ON J.I_PickupPoint_ID = A.I_Transport_ID
                LEFT JOIN T_BusRoute_Master K ON K.I_Route_ID = A.I_Route_ID
                LEFT JOIN
                (
                SELECT TSA.I_Student_Detail_ID,COUNT(DISTINCT TSA.I_TimeTable_ID) AS AttnCount FROM dbo.T_Student_Attendance TSA
                GROUP BY TSA.I_Student_Detail_ID
                ) T1 ON A.I_Student_Detail_ID = T1.I_Student_Detail_ID
                INNER JOIN T_Brand_Master L ON L.I_Brand_ID = E.I_Brand_ID    
--INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,@iBrandID) TBCD2     
--ON [TBCD2].centerID = E.I_Center_ID    
        WHERE   B.I_Status = 1    
--and C.I_Batch_ID=5    
                AND C.I_Batch_ID = CAST(@iBatchId AS INT)
                AND E.I_Center_ID IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
        ORDER BY A.S_First_Name
        
        END
        
        ELSE
        
        BEGIN
        	SELECT  E.S_Brand_Name ,
                C.S_Batch_Name ,
                A.S_Student_ID ,
                A.S_First_Name ,
                A.S_Middle_Name ,
                A.S_Last_Name ,
                I.S_Sex_Name ,
                a.Dt_Birth_Date AS DateOfBirth ,
                A.S_Mobile_No ,
                H.S_Father_Name ,
                H.S_Mother_Name ,
                H.S_Phone_No ,
                CASE WHEN F.I_Brand_ID = 107
                     THEN CASE WHEN H.S_Father_Name IS NOT NULL
                                    AND LTRIM(RTRIM(H.S_Father_Name)) <> ''
                               THEN H.S_Father_Name
                               ELSE H.S_Mother_Name
                          END
                     ELSE A.S_Guardian_Name
                END AS S_Guardian_Name ,
                A.S_Curr_Address1 ,
                A.S_Perm_Address1 ,
                G.S_House_Name ,
                K.S_Route_No ,
                J.S_PickupPoint_Name,
                A.S_Guardian_Phone_No AS S_Guardian_Mobile_No,
                CASE WHEN C.Dt_BatchStartDate>GETDATE() THEN 'Waiting'
                WHEN C.Dt_BatchStartDate<=GETDATE() AND T1.AttnCount IS NULL THEN 'Waiting'
                WHEN C.Dt_BatchStartDate<=GETDATE() AND T1.AttnCount IS NOT NULL THEN 'Active'
                END AS StdStatus
        FROM    T_Student_Detail A
                INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID = B.I_Student_ID
                INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID = B.I_Batch_ID
                INNER JOIN T_Center_Batch_Details D ON C.I_Batch_ID = D.I_Batch_ID
                INNER JOIN T_Center_Hierarchy_Name_Details E ON E.I_Center_ID = D.I_Centre_Id
                INNER JOIN T_Course_Master F ON F.I_Course_ID = C.I_Course_ID    
--left join T_House_Master G    
--on A.I_House_ID=G.I_House_ID    
                INNER JOIN T_Enquiry_Regn_Detail H ON H.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
                LEFT JOIN T_User_Sex I ON I.I_Sex_ID = H.I_Sex_ID
                LEFT JOIN T_House_Master G ON A.I_House_ID = G.I_House_ID
                LEFT JOIN T_Transport_Master J ON J.I_PickupPoint_ID = A.I_Transport_ID
                LEFT JOIN T_BusRoute_Master K ON K.I_Route_ID = A.I_Route_ID
                LEFT JOIN
                (
                SELECT TSA.I_Student_Detail_ID,COUNT(DISTINCT TSA.I_TimeTable_ID) AS AttnCount FROM dbo.T_Student_Attendance TSA
                GROUP BY TSA.I_Student_Detail_ID
                ) T1 ON A.I_Student_Detail_ID = T1.I_Student_Detail_ID
                INNER JOIN T_Brand_Master L ON L.I_Brand_ID = E.I_Brand_ID    
--INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,@iBrandID) TBCD2     
--ON [TBCD2].centerID = E.I_Center_ID    
        WHERE   B.I_Status = 1    
--and C.I_Batch_ID=5    
                --AND C.I_Batch_ID = CAST(@iBatchId AS INT)
                AND E.I_Center_ID IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
        ORDER BY A.S_First_Name
        END
        
        
            
    END
