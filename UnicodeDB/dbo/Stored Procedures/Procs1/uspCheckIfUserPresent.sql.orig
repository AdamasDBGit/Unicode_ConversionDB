CREATE PROC [dbo].[uspCheckIfUserPresent] --'CON_CHandigarh',NULL  
(      
@sLoginID VARCHAR(500) ,     
@dtDOB DATETIME  = NULL   
)      
AS       
BEGIN      
     
 DECLARE @sUserType VARCHAR(50)    
     
 SET NOCOUNT ON      
     
 SELECT @sUserType=S_User_Type FROM dbo.T_User_Master AS tum WHERE tum.S_Login_ID=@sLoginID    
 PRINT   @sUserType    
IF @dtDOB is NULL
BEGIN     
 IF @sUserType='ST'    
         
  SELECT I_User_ID,ISNULL(tsd.S_Email_ID,'') AS S_Email_ID,ISNULL(tsd.S_First_Name,'') AS S_First_Name,    
  ISNULL(tsd.S_Last_Name,'') AS S_Last_Name,S_User_Type FROM dbo.T_User_Master     
  INNER JOIN dbo.T_Student_Detail AS tsd    
  ON tsd.S_Student_ID=dbo.T_User_Master.S_Login_ID    
  WHERE S_Login_ID = @sLoginID  
      
 ELSE IF @sUserType='CE'    
          
  SELECT I_User_ID,ISNULL(ted.S_Email_ID,'') AS S_Email_ID,ISNULL(ted.S_First_Name,'') AS S_First_Name,    
  ISNULL(ted.S_Last_Name,'') AS S_Last_Name,S_User_Type FROM dbo.T_User_Master     
  INNER JOIN dbo.T_Employee_Dtls AS ted    
  ON ted.I_Employee_ID=dbo.T_User_Master.I_Reference_ID    
  WHERE S_Login_ID = @sLoginID  
      
  ELSE    
      
   SELECT I_User_ID,ISNULL(S_Email_ID,'') AS S_Email_ID,ISNULL(S_First_Name,'') AS S_First_Name,    
   ISNULL(S_Last_Name,'') AS S_Last_Name     
   FROM dbo.T_User_Master WHERE S_Login_ID=@sLoginID 
END
ELSE
BEGIN
	IF @sUserType='ST'    
         
  SELECT I_User_ID,ISNULL(tsd.S_Email_ID,'') AS S_Email_ID,ISNULL(tsd.S_First_Name,'') AS S_First_Name,    
  ISNULL(tsd.S_Last_Name,'') AS S_Last_Name,S_User_Type FROM dbo.T_User_Master     
  INNER JOIN dbo.T_Student_Detail AS tsd    
  ON tsd.S_Student_ID=dbo.T_User_Master.S_Login_ID    
  WHERE S_Login_ID = @sLoginID AND tsd.Dt_Birth_Date = ISNULL(@dtDOB,tsd.Dt_Birth_Date)   
      
 ELSE IF @sUserType='CE'    
          
  SELECT I_User_ID,ISNULL(ted.S_Email_ID,'') AS S_Email_ID,ISNULL(ted.S_First_Name,'') AS S_First_Name,    
  ISNULL(ted.S_Last_Name,'') AS S_Last_Name,S_User_Type FROM dbo.T_User_Master     
  INNER JOIN dbo.T_Employee_Dtls AS ted    
  ON ted.I_Employee_ID=dbo.T_User_Master.I_Reference_ID    
  WHERE S_Login_ID = @sLoginID AND ted.Dt_DOB =ISNULL(@dtDOB,ted.Dt_DOB)  
      
  ELSE    
      
   SELECT I_User_ID,ISNULL(S_Email_ID,'') AS S_Email_ID,ISNULL(S_First_Name,'') AS S_First_Name,    
   ISNULL(S_Last_Name,'') AS S_Last_Name     
   FROM dbo.T_User_Master WHERE S_Login_ID=@sLoginID AND Dt_Date_Of_Birth = ISNULL(@dtDOB,Dt_Date_Of_Birth)	
END       
END
