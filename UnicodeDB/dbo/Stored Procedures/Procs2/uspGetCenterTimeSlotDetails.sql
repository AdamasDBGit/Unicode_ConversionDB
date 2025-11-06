CREATE PROCEDURE [dbo].[uspGetCenterTimeSlotDetails] --[dbo].[uspGetCenterTimeSlotDetails] 1,794,'12/6/2012 12:00:00 AM'    
    (  
      @IBrandID INT ,  
      @ICenterID INT ,  
      @DtSelected DATETIME = NULL    
    )  
AS   
    BEGIN      
        SET NOCOUNT ON   
          
        DECLARE @NoOfRooms INT  
        SELECT  @NoOfRooms = COUNT(*)  
        FROM    dbo.T_Room_Master AS TRM  
        WHERE   I_Centre_Id = @ICenterID and I_Status=1  
              
        SELECT  TCTM.I_TimeSlot_ID ,  
                TCTM.I_Brand_ID ,  
                TCTM.I_Center_ID ,  
                TCTM.Dt_Start_Time ,  
                TCTM.Dt_End_Time ,  
                CASE WHEN COUNT(I_TimeTable_ID) = @NoOfRooms THEN 2  
                     WHEN COUNT(I_TimeTable_ID) > 0 THEN 1  
                     ELSE 0   
                END AS IsTimeTableAdded  
        FROM    dbo.T_Center_Timeslot_Master TCTM  
                LEFT OUTER JOIN T_TimeTable_Master TTM ON TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID  
                                                          AND TTM.Dt_Schedule_Date = ISNULL(@DtSelected,TTM.Dt_Schedule_Date)
                                                          AND TTM.I_Center_ID = @ICenterID  
                                                          AND TTM.I_Status = 1 
                                                          AND TTM.I_Session_ID is not null  
        WHERE   TCTM.I_Status = 1  
                AND TCTM.I_Brand_ID = @IBrandID  
                AND TCTM.I_Center_ID = @ICenterID  
                AND TCTM.I_Status = 1                 
                  
        GROUP BY TCTM.I_TimeSlot_ID ,  
                TCTM.I_TimeSlot_ID ,  
                TCTM.I_Brand_ID ,  
                TCTM.I_Center_ID ,  
                TCTM.Dt_Start_Time ,  
                TCTM.Dt_End_Time  
                    
    END
