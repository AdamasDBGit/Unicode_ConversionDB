CREATE PROCEDURE [dbo].[uspGetCenterFeePlans]
    (
      @iHierarchyDetailID INT ,
      @iBrandID INT ,
      @dCurrentDate DATETIME,
      @iCourseID INT = NULL  
    )
AS 
    BEGIN TRY  
        SET NOCOUNT ON  
   
        DECLARE @sSearchCriteria nvarchar(max)  
        DECLARE @iMax INT  
        DECLARE @iCount INT  
   
        SELECT  @sSearchCriteria = S_Hierarchy_Chain
        FROM    T_Hierarchy_Mapping_Details
        WHERE   I_Hierarchy_detail_id = @iHierarchyDetailID    
    
        CREATE TABLE #tempCenter
            (
              seq INT IDENTITY(1, 1) ,
              centerID INT ,
              centerCode nvarchar(max) ,
              centerName nvarchar(max)
            )  
  
        CREATE TABLE #tempFeePlan
            (
              courseCenterDeliveryID INT ,
              courseFeePlanID INT ,
              centerID INT ,
              courseID INT ,
              courseCode nvarchar(max) ,
              courseName nvarchar(max) ,
              courseFeePlanName nvarchar(max) ,
              feePlanLumpsumTotal NUMERIC(18, 0) ,
              feePlanInstallmentTotal NUMERIC(18, 0) ,
              deliveryPatternID INT ,
              deliveryPatternName nvarchar(max)
            )   
   
        SET @iMax = 0  
        SET @iCount = 1  
   
        IF @iBrandID = 0 
            BEGIN  
                INSERT  INTO #tempCenter
                        ( centerID ,
                          centerCode ,
                          centerName
                        )
                        SELECT  TCHD.I_Center_Id ,
                                CM.S_Center_Code ,
                                CM.S_Center_Name
                        FROM    T_CENTER_HIERARCHY_DETAILS TCHD WITH ( NOLOCK )
                                INNER JOIN dbo.T_Centre_Master CM ON CM.I_Centre_Id = TCHD.I_Center_Id
                        WHERE   TCHD.I_Hierarchy_Detail_ID IN (
                                SELECT  I_HIERARCHY_DETAIL_ID
                                FROM    T_Hierarchy_Mapping_Details
                                WHERE   S_Hierarchy_Chain LIKE @sSearchCriteria
                                        + '%'
                                        AND I_Status = 1
                                        AND @dCurrentDate >= ISNULL(Dt_Valid_From,
                                                              @dCurrentDate)
                                        AND @dCurrentDate <= ISNULL(Dt_Valid_To,
                                                              @dCurrentDate) )
                                AND TCHD.I_Status = 1
                                AND CM.I_Status <> 0
                                AND @dCurrentDate >= ISNULL(TCHD.Dt_Valid_From,
                                                            @dCurrentDate)
                                AND @dCurrentDate <= ISNULL(TCHD.Dt_Valid_To,
                                                            @dCurrentDate)  
            END  
        ELSE 
            BEGIN  
                INSERT  INTO #tempCenter
                        ( centerID ,
                          centerCode ,
                          centerName
                        )
                        SELECT  TCHD.I_Center_Id ,
                                CM.S_Center_Code ,
                                CM.S_Center_Name
                        FROM    T_CENTER_HIERARCHY_DETAILS TCHD WITH ( NOLOCK )
                                INNER JOIN T_BRAND_CENTER_DETAILS TBCD ON TBCD.I_Centre_Id = TCHD.I_Center_Id
                                INNER JOIN dbo.T_Centre_Master CM ON CM.I_Centre_Id = TCHD.I_Center_Id
                        WHERE   TCHD.I_Hierarchy_Detail_ID IN (
                                SELECT  I_HIERARCHY_DETAIL_ID
                                FROM    T_Hierarchy_Mapping_Details
                                WHERE   S_Hierarchy_Chain LIKE @sSearchCriteria
                                        + '%'
                                        AND I_Status = 1
                                        AND @dCurrentDate >= ISNULL(Dt_Valid_From,
                                                              @dCurrentDate)
                                        AND @dCurrentDate <= ISNULL(Dt_Valid_To,
                                                              @dCurrentDate) )
                                AND TBCD.I_Status = 1
                                AND TCHD.I_Status = 1
                                AND CM.I_Status <> 0
                                AND TBCD.I_Brand_ID = @iBrandID
                                AND @dCurrentDate >= ISNULL(TCHD.Dt_Valid_From,
                                                            @dCurrentDate)
                                AND @dCurrentDate <= ISNULL(TCHD.Dt_Valid_To,
                                                            @dCurrentDate)
                                AND @dCurrentDate >= ISNULL(TBCD.Dt_Valid_From,
                                                            @dCurrentDate)
                                AND @dCurrentDate <= ISNULL(TBCD.Dt_Valid_To,
                                                            @dCurrentDate)  
            END  
     
        SELECT  @iMax = MAX(seq)
        FROM    #tempCenter  
  
        SELECT  centerID ,
                centerCode ,
                centerName
        FROM    #tempCenter  
    
        WHILE ( @iCount <= @iMax ) 
            BEGIN  
                INSERT  INTO #tempFeePlan
                        SELECT  CCDF.I_Course_Center_Delivery_ID ,
                                CCDF.I_Course_Fee_Plan_ID ,
                                CCD.I_Centre_Id ,
                                CCD.I_Course_ID ,
                                CM.S_Course_Code ,
                                CM.S_Course_Name ,
                                CFP.S_Fee_Plan_Name ,
                                CFP.N_TotalLumpSum ,
                                CFP.N_TotalInstallment ,
                                DP.I_Delivery_Pattern_ID ,
                                DP.S_Pattern_Name
                        FROM    dbo.T_Course_Center_Delivery_FeePlan CCDF WITH ( NOLOCK )
                                INNER JOIN dbo.T_Course_Center_Detail CCD ON CCDF.I_Course_Center_ID = CCD.I_Course_Center_ID
                                INNER JOIN dbo.T_Course_Master CM ON CM.I_Course_ID = CCD.I_Course_ID
                                INNER JOIN dbo.T_Course_Fee_Plan CFP ON CFP.I_Course_Fee_Plan_ID = CCDF.I_Course_Fee_Plan_ID
                                INNER JOIN dbo.T_Course_Delivery_Map CDM ON CCDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
                                INNER JOIN dbo.T_Delivery_Pattern_Master DP ON DP.I_Delivery_Pattern_ID = CDM.I_Delivery_Pattern_ID
                                INNER JOIN #tempCenter TEMP ON CCD.I_Centre_Id = TEMP.centerID
                        WHERE   CCDF.I_Status = 1
                                AND CCD.I_Status = 1
                                AND CM.I_Status <> 0
                                AND CFP.I_Status = 1
                                AND CDM.I_Status = 1
                                AND DP.I_Status = 1
                                AND CM.I_Course_ID = ISNULL(@iCourseID,CM.I_Course_ID)
                                AND @dCurrentDate >= ISNULL(CCDF.Dt_Valid_From,
                                                            @dCurrentDate)
                                AND @dCurrentDate <= ISNULL(CCDF.Dt_Valid_To,
                                                            @dCurrentDate)
                                AND @dCurrentDate >= ISNULL(CCD.Dt_Valid_From,
                                                            @dCurrentDate)
                                AND @dCurrentDate <= ISNULL(CCD.Dt_Valid_To,
                                                            @dCurrentDate)
                                AND TEMP.seq = @iCount  
  
                SET @iCount = @iCount + 1  
            END  
  
        SELECT  courseCenterDeliveryID ,
                courseFeePlanID ,
                centerID ,
                courseID ,
                courseCode ,
                courseName ,
                courseFeePlanName ,
                feePlanLumpsumTotal ,
                feePlanInstallmentTotal ,
                deliveryPatternID ,
                deliveryPatternName
        FROM    #tempFeePlan  
  
        DROP TABLE #tempCenter  
        DROP TABLE #tempFeePlan  
   
    END TRY  
    BEGIN CATCH  
 --Error occurred:    
  
        DECLARE @ErrMsg Nnvarchar(max) ,
            @ErrSeverity INT  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
    END CATCH
