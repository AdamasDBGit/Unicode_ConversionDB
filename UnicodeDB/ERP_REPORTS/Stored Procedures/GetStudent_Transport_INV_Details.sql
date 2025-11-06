--EXEC [ERP_REPORTS].[GetStudent_Transport_INV_Details]  107,7,'1',null  
  
CREATE PROCEDURE [ERP_REPORTS].[GetStudent_Transport_INV_Details]      
    @brandID INT,      
    @SessionID INT,      
    @schoolGroupID varchar(100)=null,      
    --@ClassID INT,      
 @strclass varchar(100)=null      
AS      
BEGIN      
    SET NOCOUNT ON;      
      
-- --step1  IF OBJECT_ID('tempdb..#Courses') IS NULL  BEGIN     CREATE TABLE #Courses (         Id INT IDENTITY(1,1), CourseID INT     )  END    --step2 INSERT INTO #Courses (CourseID) -- Adjust ColumnName to match your table's column                     
  
      
--            SELECT Value                                   FROM dbo.ERP_SplitString(@strclass, ',');        
      
----Declare     @brandID INT,      
----    @SessionID INT,      
----    @schoolGroupID INT,      
----    @ClassID INT      
    SELECT   distinct     
        @brandID AS BrandID,      
          
        asm.S_Label AS Academic_Session,      
        SD.S_Student_ID AS StudentID,      
        SD.S_First_Name +         
            CASE         
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''           
                THEN ' ' + SD.S_Middle_Name           
                ELSE ''           
            END +           
            ' ' + SD.S_Last_Name AS StudentName,      
   --SG.S_School_Group_Name as School_Group,  
     SG.S_School_Group_Name AS School_Programme,  
        TC.S_Class_Name AS Class,      
        TS.S_Section_Name AS SectionName,      
        BUM.S_Route_No AS Route ,    
        TRM.S_PickupPoint_Name as Stoppage  ,  
  TRM.N_Fees as RouteFee  
      
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
 --INNER JOIN #Courses ct on ct.CourseID = TC.I_Class_ID      
    LEFT JOIN       
        T_Section TS ON TS.I_Section_ID = SCS.I_Section_ID       
        
    INNER JOIN       
        T_Transport_Master TRM ON TRM.I_PickupPoint_ID = SD.I_Transport_ID    
        AND TRM.I_Brand_ID = @brandID      
    INNER JOIN       
        T_BusRoute_Master BUM ON BUM.I_Route_ID = SD.I_Route_ID  
        AND BUM.I_Brand_ID = @brandID      
  Inner Join T_School_Academic_Session_Master asm on asm.I_School_Session_ID=@SessionID   
--  Inner Join       
--  (      
--  Select  TIP.I_Student_Detail_ID,TIP.I_Invoice_Header_ID,TIP.N_Invoice_Amount as FeeAmount      
--,Subt.Total_ReceiptAmount as ReceiptAmount,(TIP.N_Invoice_Amount-Subt.Total_ReceiptAmount) as DueAmount      
      
--from T_Invoice_Parent TIP      
--Inner Join       
--(      
--select  DISTINCT  I_Student_Detail_ID,I_Invoice_Header_ID,SUM(N_Receipt_Amount) as Total_ReceiptAmount      
--from T_Receipt_Header RH       
--Inner Join T_Brand_Center_Details BCD ON BCD.I_Centre_Id=RH.I_Centre_Id      
--Inner Join T_Brand_Master BM ON BM.I_Brand_ID=BCD.I_Brand_ID      
--where BM.I_Brand_ID=@brandID      
--Group BY I_Student_Detail_ID,I_Invoice_Header_ID      
--) Subt On Subt.I_Student_Detail_ID=TIP.I_Student_Detail_ID      
--and TIP.I_Invoice_Header_ID=Subt.I_Invoice_Header_ID      
--where TIP.I_Status=1 and TIP.I_Centre_Id=1      
--  ) tt1 ON tt1.I_Student_Detail_ID=SD.I_Student_Detail_ID      
    WHERE       
        (SG.I_School_Group_ID in (SELECT Value FROM dbo.ERP_SplitString(@schoolGroupID, ',')) or @schoolGroupID is null )    
        AND ( TC.I_Class_ID in (SELECT Value FROM dbo.ERP_SplitString(@strclass, ',')) or @strclass is null)      
END;