--exec [EXAMINATION].[uspSaveStudentTermAttendance]'<Students><Attendance StudentID="4923" Attendance="2" Conduct="1" CenterID="1" /></Students>',5,3  
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspSaveStudentTermAttendance]  
@studentAttendance  xml, 
--@IStudentID int, 
@ITermID int,--
@ICourse int
--@DAttendance decimal(18,0),
--@SCouduct varchar(20)
AS
BEGIN


-- Create Temporary Table To store values from XML    

 CREATE TABLE #tempTable    

 (          
       
  I_Student_Detail_ID int,      

  D_Attendance decimal(18,0) ,    

  I_Conduct_Id int ,    

  I_Center_ID int    

 )    

    

-- INsert Values into Temporary Table    

 INSERT INTO #tempTable    

 SELECT T.c.value('@StudentID','int'),       

   CASE WHEN T.c.value('@Attendance', 'varchar(100)') = '' THEN NULL ELSE T.c.value('@Attendance','decimal(18,0)') END,      

   T.c.value('@Conduct', 'int'),

   T.c.value('@CenterID','int')    

 FROM   @studentAttendance.nodes('/Students/Attendance') T(c)    

 --//select * from #tempTable

   
    UPDATE T_Student_Term_Detail 
	SET D_Attendance = #tempTable.D_Attendance,
		I_Conduct_Id = #tempTable.I_Conduct_Id
	FROM #tempTable
    WHERE I_Course_ID = @ICourse AND I_Term_ID = @ITermID AND T_Student_Term_Detail.I_Student_Detail_ID = #tempTable.I_Student_Detail_ID
    
END
