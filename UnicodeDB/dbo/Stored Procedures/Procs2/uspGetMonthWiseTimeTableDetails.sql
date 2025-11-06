CREATE PROCEDURE [dbo].[uspGetMonthWiseTimeTableDetails] --[dbo].[uspGetMonthWiseTimeTableDetails] 17,'3/11/2013'   
    (    
      @ICenterID INT ,  
      @DtSelected DATETIME  
    )  
AS   
    BEGIN      
        SET NOCOUNT ON
        SELECT	I_TimeTable_ID, 
				I_TimeSlot_ID ,  
                I_Batch_ID ,               
                I_Room_ID ,  
                I_Session_ID ,
                S_Remarks ,
                S_Session_Name ,
                S_Session_Topic ,
                I_Term_ID ,
                I_Module_ID ,
                Dt_Actual_Date ,
                I_Is_Complete 
                
        FROM    dbo.T_TimeTable_Master  
        WHERE I_Center_ID=@ICenterID 
        AND I_Status=1 
        AND Dt_Schedule_Date=@DtSelected
    END
