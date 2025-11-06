CREATE PROCEDURE [dbo].[uspFetchBridgeCourses] 
(              
@iCourseID INT,        
@iInvoiceHeaderID INT            
)              
AS              
BEGIN 
	IF NOT EXISTS(SELECT 'TRUE' FROM [T_Student_Upgrade_Detail] WHERE [I_Previous_Invoice_Header_ID]=@iInvoiceHeaderID)
	BEGIN
	                       
	SELECT CM.[I_Course_ID],              
		CM.[S_Course_Code],              
		CM.[S_Course_Name],      
		BM.[I_Bridge_ID],      
		BM.[S_Bridge_Code]              
	FROM [T_Bridge_Course_Mapping] BCM WITH(NOLOCK)       
	INNER JOIN [T_Bridge_Master] BM WITH (NOLOCK)  ON BCM.[I_Bridge_ID] = BM.[I_Bridge_ID]             
	INNER JOIN [T_Course_Master] CM WITH(NOLOCK)   ON BCM.[I_Next_Course_ID] = CM.[I_Course_ID]      
	WHERE BCM.[I_Prev_Course_ID]=@iCourseID                  
	AND BCM.[I_Status]=1              
	AND CM.[I_Status]=1

	END
 ELSE
	
	BEGIN
		SELECT CM.[I_Course_ID],              
		CM.[S_Course_Code],              
		CM.[S_Course_Name],      
		BM.[I_Bridge_ID],      
		BM.[S_Bridge_Code] 
		FROM [T_Student_Upgrade_Detail] SUD WITH(NOLOCK)       
		INNER JOIN [T_Bridge_Master] BM WITH(NOLOCK) ON SUD.[I_Bridge_ID]= BM.[I_Bridge_ID]
		INNER JOIN [T_Bridge_Course_Mapping] BCM WITH (NOLOCK) ON BM.[I_Bridge_ID] = BCM.[I_Bridge_ID]
		INNER JOIN [T_Course_Master] CM WITH(NOLOCK) ON BCM.[I_Next_Course_ID] = CM.[I_Course_ID]
		WHERE SUD.[I_Previous_Invoice_Header_ID]=@iInvoiceHeaderID
		AND BCM.[I_Prev_Course_ID]=@iCourseID
		AND BCM.[I_Status]=1              
		AND CM.[I_Status]=1
		
	END  
         
              
              
END       
      
-----------------------------------------------------------------------------------------------------------------------------------------------    

-------------------------------------------------------------------------------------------------------------------------------------------------
