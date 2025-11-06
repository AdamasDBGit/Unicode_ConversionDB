--EXEC [USP_ERP_Dash_AdmissionStatus] 2,2        
CREATE Proc [dbo].[USP_ERP_Dash_AdmissionStatus](          
@sessionID int=Null,          
@brandID int          
)          
As           
Begin          
Declare @Sdate date, @EDate date ,@Centerid int     
--Declare @sessionID int,@brandID int    
--SET @sessionID=2          
--SET @brandID=2      
SET @Centerid=(select top 1 I_Centre_Id from T_Brand_Center_Details where I_Brand_ID=@brandID)    
Select @Sdate= Convert(date,Dt_Session_Start_Date),@EDate=convert(date,Dt_Session_End_Date)          
from T_School_Academic_Session_Master           
where I_School_Session_ID=@sessionID           
and I_Brand_ID=@brandID          
--Select @Sdate,@EDate          
-----For Pre Enquiry--------------          
SELECT          
    MONTH(Dt_Crtd_On) AS MonthNumber,          
    DATENAME(MONTH, Dt_Crtd_On) AS MonthName,          
    COUNT(I_Enquiry_Regn_ID) AS RecordCount          
 Into #Temp_Pre_Enq          
FROM          
    T_Enquiry_Regn_Detail where I_ERP_Entry=1          
 and I_Enquiry_Status_Code is null           
And           
    convert(date,Dt_Crtd_On) >= @Sdate          
    AND convert(date,Dt_Crtd_On) < @EDate      
 and I_Centre_Id=@Centerid    
GROUP BY          
    MONTH(Dt_Crtd_On), DATENAME(MONTH, Dt_Crtd_On)          
ORDER BY          
    MonthNumber;    
 --select * from #Temp_Pre_Enq  
 ------For Enquiry--------------          
 SELECT          
    MONTH(Dt_Crtd_On) AS MonthNumber,          
    DATENAME(MONTH, Dt_Crtd_On) AS MonthName,          
    COUNT(I_Enquiry_Regn_ID) AS RecordCount          
  Into #Temp_Enq          
FROM          
    T_Enquiry_Regn_Detail where I_ERP_Entry=1          
 and I_Enquiry_Status_Code =1          
And           
    convert(date,Dt_Crtd_On) >= @Sdate          
    AND convert(date,Dt_Crtd_On) < @EDate      
 and I_Centre_Id=@Centerid    
GROUP BY          
    MONTH(Dt_Crtd_On), DATENAME(MONTH, Dt_Crtd_On)          
ORDER BY          
    MonthNumber;      
 --select * from #Temp_Enq  
 -----For Admission -------          
-- SELECT          
--    MONTH(sd.Dt_Crtd_On) AS MonthNumber,          
--    DATENAME(MONTH, sd.Dt_Crtd_On) AS MonthName,          
--    COUNT(distinct(I_Student_Detail_ID)) AS RecordCount          
-- Into #Temp_Adm          
--FROM          
--    T_student_detail sd
--	Inner Join T_Enquiry_Regn_Detail rd on sd.I_Enquiry_Regn_ID=sd.I_Enquiry_Regn_ID
--	where          
--    convert(date,sd.Dt_Crtd_On) >= @Sdate          
--    AND convert(date,sd.Dt_Crtd_On) <= @EDate     
-- and rd.I_Centre_Id=@Centerid    
--GROUP BY          
--    MONTH(sd.Dt_Crtd_On), DATENAME(MONTH, sd.Dt_Crtd_On)          
--ORDER BY          
--    MonthNumber; 
select COUNT(I_Student_Detail_ID) as RecordCount 
,MONTH(sd.Dt_Crtd_On) AS MonthNumber
,DATENAME(MONTH, sd.Dt_Crtd_On) AS MonthName
Into #Temp_Adm    
from t_student_detail sd
inner Join T_Enquiry_Regn_Detail rd on rd.I_Enquiry_Regn_ID=sd.I_Enquiry_Regn_ID

where convert(date,sd.Dt_Crtd_On)>=@Sdate  
and convert(date,sd.Dt_Crtd_On)<=@EDate and rd.i_centre_id=@Centerid
GROUP BY          
    MONTH(sd.Dt_Crtd_On), DATENAME(MONTH, sd.Dt_Crtd_On)  
	ORDER BY          
    MonthNumber; 
 --select * from #Temp_Adm  
 ---------------------------          
 ;WITH Months AS (          
    SELECT DATEADD(MONTH, number, @Sdate) AS MonthStart          
    FROM master..spt_values          
    WHERE type = 'P'           
    AND number BETWEEN 0 AND 11 -- Months from April to March          
)          
select Convert(Varchar,(FORMAT(Months.MonthStart, 'MMMM'))) AS MonthName          
Into #AllMonth          
          
from Months     
--select * from #AllMonth  
          
 Select SUBSTRING(am.MonthName,1,3) as Month_Name,a.RecordCount as Pre_Enq_Count,          
 b.RecordCount As Enq_Count,c.RecordCount As Adm_Count          
           
 from #AllMonth am          
 Left Join #Temp_Pre_Enq a on a.MonthName=am.MonthName          
 Left Join #Temp_Enq b on am.MonthName=b.MonthName          
 Left Join #Temp_Adm c on c.MonthName=am.MonthName          
           
          
 drop Table #Temp_Pre_Enq          
 drop table #Temp_Adm          
 DROP TABLE #Temp_Enq          
 drop table #AllMonth          
 End  