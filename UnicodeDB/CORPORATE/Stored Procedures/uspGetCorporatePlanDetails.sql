CREATE PROCEDURE [CORPORATE].[uspGetCorporatePlanDetails] --1,18      
(                            
 -- Add the parameters for the stored procedure here                            
  @iCorporateID int = NULL,                                  
  @iCorporatePlanID int = NULL                                
                      
)                            
AS                            
BEGIN   

SELECT tcp1.I_Corporate_Plan_ID ,
        S_Corporate_Plan_Name ,
        I_Corporate_ID ,
        Dt_Valid_From ,
        tcp1.Dt_Valid_To ,
        B_Is_Fund_Shared ,
        I_Corporate_Plan_Type_ID ,
        I_Minimum_Strength ,
        I_Maximum_Strength ,
        N_Percent_Student_Share ,
        tcp1.I_Status ,
        IsCertificate_Eligible,
        tcfp.I_Course_Fee_Plan_ID,
        tcfp.S_Fee_Plan_Name,
        tcm.I_Course_ID,
        tcm.S_Course_Name,
        tcfm.I_CourseFamily_ID,
        tcfm.S_CourseFamily_Name 
        
        INTO #temp
        
        FROM CORPORATE.T_Corporate_Plan tcp1
        INNER JOIN CORPORATE.T_CorporatePlan_FeePlan_Map AS tcpfpm
        ON tcp1.I_Corporate_Plan_ID = tcpfpm.I_Corporate_Plan_ID
        INNER JOIN dbo.T_Course_Fee_Plan AS tcfp
        ON tcpfpm.I_Course_Fee_Plan_ID = tcfp.I_Course_Fee_Plan_ID
        INNER JOIN dbo.T_Course_Master AS tcm
        ON tcfp.I_Course_ID = tcm.I_Course_ID
        INNER JOIN dbo.T_CourseFamily_Master AS tcfm
        ON tcm.I_CourseFamily_ID = tcfm.I_CourseFamily_ID
        WHERE tcp1.I_Corporate_ID = @iCorporateID
        AND tcp1.I_Corporate_Plan_ID = @iCorporatePlanID
        AND tcp1.I_Status = 1
        
        SELECT distinct I_Corporate_Plan_ID ,
                S_Corporate_Plan_Name ,
                I_Corporate_ID ,
                Dt_Valid_From ,
                Dt_Valid_To ,
                B_Is_Fund_Shared ,
                I_Corporate_Plan_Type_ID ,
                I_Minimum_Strength ,
                I_Maximum_Strength ,
                N_Percent_Student_Share ,
                I_Status ,
                IsCertificate_Eligible ,
                FeePlanIds = STUFF((SELECT ','+ +CAST(t2.I_Course_Fee_Plan_ID AS VARCHAR(8))            
                FROM #temp AS t2              
				WHERE t2.I_Corporate_Plan_ID = t3.I_Corporate_Plan_ID        
				ORDER BY t3.I_Corporate_Plan_ID              
				FOR XML PATH('')),1,1,'')  ,   
                FeePlanName = STUFF((SELECT ','+ t2.S_Fee_Plan_Name            
                FROM #temp AS t2              
				WHERE t2.I_Corporate_Plan_ID = t3.I_Corporate_Plan_ID        
				ORDER BY t3.I_Corporate_Plan_ID              
				FOR XML PATH('')),1,1,'')  ,   
				CourseIDs = STUFF((SELECT ','+ +CAST(t2.I_Course_ID AS VARCHAR(40))            
                FROM #temp AS t2              
				WHERE t2.I_Corporate_Plan_ID = t3.I_Corporate_Plan_ID        
				ORDER BY t3.I_Corporate_Plan_ID              
				FOR XML PATH('')),1,1,'')  ,   
				CourseNames = STUFF((SELECT ','+ t2.S_Course_Name             
                FROM #temp AS t2              
				WHERE t2.I_Corporate_Plan_ID = t3.I_Corporate_Plan_ID        
				ORDER BY t3.I_Corporate_Plan_ID              
				FOR XML PATH('')),1,1,'')  ,   
				CourseFamilyIDs = STUFF((SELECT ','+ +CAST(t2.I_CourseFamily_ID AS VARCHAR(40))            
                FROM #temp AS t2              
				WHERE t2.I_Corporate_Plan_ID = t3.I_Corporate_Plan_ID        
				ORDER BY t3.I_Corporate_Plan_ID              
				FOR XML PATH('')),1,1,'')  ,
				CourseFamilyNames = STUFF((SELECT ','+ t2.S_CourseFamily_Name             
                FROM #temp AS t2              
				WHERE t2.I_Corporate_Plan_ID = t3.I_Corporate_Plan_ID        
				ORDER BY t3.I_Corporate_Plan_ID              
				FOR XML PATH('')),1,1,'')  
				
                
                FROM #temp t3
        
     
   
    DROP TABLE #temp           

END
