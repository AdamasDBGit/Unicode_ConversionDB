CREATE PROCEDURE [ERP_REPORTS].[GetStudent_TransportHistory_details] 
    @brandID INT,  
    @SessionID INT,  
    @schoolGroupID INT,  
    --@ClassID INT,
	@strclass varchar(100)
AS  
BEGIN  
    SET NOCOUNT ON; 
	--step1
	IF OBJECT_ID('tempdb..#Courses') IS NULL
	BEGIN     CREATE TABLE #Courses (         Id INT IDENTITY(1,1), CourseID INT     )
	END  
	--step2
INSERT INTO #Courses (CourseID) -- Adjust ColumnName to match your table's column                                  
SELECT Value                                  
FROM dbo.ERP_SplitString(@strclass, ','); 

;WITH RankedData AS (
    SELECT
        I_Student_Detail_ID,
        I_PickupPoint_ID,
        I_Route_ID,
        Dt_Crtd_On,
        ROW_NUMBER() OVER (PARTITION BY I_Student_Detail_ID ORDER BY Dt_Crtd_On DESC) AS row_num
    FROM
        T_Student_Transport_History
)
SELECT
    curr.I_Student_Detail_ID,
    curr.I_Route_ID AS current_route_id,
    curr.I_PickupPoint_ID AS current_pickup_id,
    prev.I_Route_ID AS previous_route_id,
    prev.I_PickupPoint_ID AS previous_pickup_id
	Into #Stud_RouteDiff_Info
FROM
    RankedData curr
LEFT JOIN
    RankedData prev
ON
    curr.I_Student_Detail_ID = prev.I_Student_Detail_ID
    AND prev.row_num = 2
WHERE
    curr.row_num = 1;
  
    SELECT   
        @brandID AS BrandID,  
        SG.S_School_Group_Name AS School_programme,  
        @SessionID AS Academic_Session,  
        SD.S_Student_ID AS StudentID,  
        SD.S_First_Name +     
            CASE     
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''       
                THEN ' ' + SD.S_Middle_Name       
                ELSE ''       
            END +       
            ' ' + SD.S_Last_Name AS StudentName,  
        TC.S_Class_Name AS Class,  
        TS.S_Section_Name AS SectionName,
		prb.S_Route_No as Previous_Route,
		prt.S_PickupPoint_Name as Previous_Pickup,
		crb.S_Route_No as Current_Route,
		crt.S_PickupPoint_Name as Current_Pickup
          
    FROM   
        T_Student_Class_Section SCS  
    INNER JOIN   
        T_Student_Detail SD ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID  
        AND SCS.I_Brand_ID = @brandID   
        AND SCS.I_School_Session_ID = @SessionID   
        AND SCS.I_Status = 1  
    INNER JOIN   
        T_School_Group_Class SGC ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID  
    INNER JOIN   
        T_School_Group SG ON SG.I_School_Group_ID = SGC.I_School_Group_ID   
        AND SG.I_Brand_Id = @brandID  
    INNER JOIN   
        T_Class TC ON TC.I_Class_ID = SGC.I_Class_ID   
        AND TC.I_Brand_ID = @brandID 
	INNER JOIN #Courses ct on ct.CourseID = TC.I_Class_ID	
    LEFT JOIN   
        T_Section TS ON TS.I_Section_ID = SCS.I_Section_ID   
    INNER JOIN   
        T_Student_Transport_History STH ON STH.I_Student_Detail_ID = SD.I_Student_Detail_ID  
    INNER JOIN   
        T_Transport_Master TRM ON TRM.I_PickupPoint_ID = STH.I_PickupPoint_ID  
        AND TRM.I_Brand_ID = @brandID  
    Left Join #Stud_RouteDiff_Info stt ON stt.I_Student_Detail_ID=SD.I_Student_Detail_ID
    Left JOIN   
        T_BusRoute_Master crb ON crb.I_Route_ID = stt.current_route_id  
        AND crb.I_Brand_ID = @brandID  
    Left Join T_Transport_Master crt ON crt.I_PickupPoint_ID=stt.current_pickup_id
	and crt.I_Brand_ID=@brandID
	Left Join T_BusRoute_Master prb on prb.I_Route_ID=stt.previous_route_id
	and prb.I_Brand_ID=@brandID
	Left Join T_Transport_Master prt on prt.I_PickupPoint_ID=stt.previous_pickup_id
	and prt.I_Brand_ID=@brandID
    WHERE   
        SG.I_School_Group_ID = @schoolGroupID   
        --AND TC.I_Class_ID = @ClassID;  
END;  