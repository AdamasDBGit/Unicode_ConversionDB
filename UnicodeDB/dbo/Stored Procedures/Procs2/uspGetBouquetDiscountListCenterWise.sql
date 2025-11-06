CREATE PROCEDURE [dbo].[uspGetBouquetDiscountListCenterWise] --743  
(    
 @iCenterID INT    
)    
AS    
BEGIN    
      	
		/*	  
 SELECT DISTINCT TDSM.I_Discount_Scheme_ID ,
        S_Discount_Scheme_Name ,
        Dt_Valid_From,
        Dt_Valid_To,
        TDD.I_Discount_Detail_ID,
        tclcm.I_Course_ID
        INTO #temp
         FROM dbo.T_Discount_Scheme_Master AS TDSM
		INNER JOIN dbo.T_Discount_Details AS TDD
		ON TDSM.I_Discount_Scheme_ID = TDD.I_Discount_Scheme_ID
		INNER JOIN dbo.T_Discount_Center_Detail AS TDCD  
		ON TDSM.I_Discount_Scheme_ID = TDCD.I_Discount_Scheme_ID  
		INNER JOIN dbo.T_CourseList_Course_Map AS tclcm  
		ON tdd.I_CourseList_ID = tclcm.I_CourseList_ID  
 		WHERE TDSM.I_Status = 1
 		AND TDCD.I_Status = 1
 		AND TDCD.I_Centre_ID = @iCenterID
 		AND tclcm.I_Status = 1
 		AND Dt_Valid_To >=  CONVERT(date, GETDATE()) 
 		AND Dt_Valid_From <= CONVERT(date, GETDATE())
		
		*/


---Added by Akash 16.9.2021--

SELECT DISTINCT TDSM.I_Discount_Scheme_ID ,
        S_Discount_Scheme_Name ,
        Dt_Valid_From,
        Dt_Valid_To,
        TDD.I_Discount_Scheme_Detail_ID AS I_Discount_Detail_ID,
        tclcm.I_Course_ID
        INTO #temp
         FROM dbo.T_Discount_Scheme_Master AS TDSM
		INNER JOIN dbo.T_Discount_Scheme_Details AS TDD ON TDSM.I_Discount_Scheme_ID = TDD.I_Discount_Scheme_ID
		INNER JOIN dbo.T_Discount_Center_Detail AS TDCD  ON TDSM.I_Discount_Scheme_ID = TDCD.I_Discount_Scheme_ID  
		INNER JOIN dbo.T_Discount_Course_Detail AS tclcm  ON tdcd.I_Discount_Center_Detail_ID = tclcm.I_Discount_Course_Detail_ID  
 		WHERE TDSM.I_Status = 1
 		AND TDCD.I_Status = 1
 		AND TDCD.I_Centre_ID = @iCenterID
 		AND tclcm.I_Status = 1
 		AND Dt_Valid_To >=  CONVERT(date, GETDATE()) 
 		AND Dt_Valid_From <= CONVERT(date, GETDATE())

		select * from #temp

---Added by Akash 16.9.2021--
 		
 		SELECT DISTINCT t2.I_Discount_Scheme_ID,t2.S_Discount_Scheme_Name,Dt_Valid_From,Dt_Valid_To,  
 CourseIdList = STUFF((SELECT ','+CAST(t1.I_Course_ID AS VARCHAR(5)) FROM #temp AS t1 WHERE  t1.I_Discount_Detail_ID = t2.I_Discount_Detail_ID
 ORDER BY t1.I_Discount_Scheme_ID        
 FOR XML PATH('')),1,1,'')       
 FROM #temp t2
 
	SELECT * FROM dbo.T_Discount_Scheme_Details AS TDD WHERE I_Discount_Scheme_ID IN (
	SELECT I_Discount_Scheme_ID FROM #temp AS T 
	)
 
 DROP TABLE #temp
  
    
END
