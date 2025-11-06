/*******************************************************  
Author :     SUBHENDU CHATTERJEE  
Date :   05/12/2011  
Description : This SP retrieves the Invigilator Report Detail  
      
*********************************************************/  
  
  
CREATE PROCEDURE [REPORT].[uspGetStudentBatchCourse]
    (
      -- Add the parameters for the stored procedure here  
      @dtStartDate DATETIME = NULL ,
      @dtEndDate DATETIME = NULL ,
      @sCourseID VARCHAR(MAX) ,
      @iBatchID INT = NULL ,
      @iBrandID INT ,
      @sHierarchyList VARCHAR(MAX)
    )
AS 
    BEGIN TRY  
   
        DECLARE @InstanceChain NVARCHAR(4000)= NULL  
    
        IF ( @iBatchID IS NOT NULL ) 
            BEGIN  
                SELECT  @InstanceChain = @InstanceChain + '; Batch: '
                        + A.S_Batch_Code
                FROM    [dbo].[T_Student_Batch_Master] AS A
                WHERE   A.I_Batch_ID = @iBatchID  
            END  
        ELSE 
            BEGIN  
                SET @InstanceChain = @InstanceChain + '; Batch: ALL'  
            END   
    
        DECLARE @tblCourse TABLE ( CourseID INT )  
    
        IF ( @sCourseID IS NOT NULL ) 
            BEGIN  
                INSERT  INTO @tblCourse
                        SELECT  CAST([Val] AS INT)
                        FROM    [dbo].[fnString2Rows](@sCourseID, ',') AS FSR  
                SELECT  @InstanceChain = @InstanceChain + 'Course: '
                        + A.S_Course_Name
                FROM    [dbo].[T_Course_Master] AS A
                WHERE   A.I_Course_ID IN ( SELECT   CourseID
                                           FROM     @tblCourse )  
            END  
        ELSE 
            BEGIN  
                INSERT  INTO @tblCourse
                        SELECT  I_Course_ID
                        FROM    DBO.T_Course_Master  
                SET @InstanceChain = @InstanceChain + 'Course: ALL'  
            END  
     
        SELECT DISTINCT
                TBCD2.brandID ,
                tsd.I_Student_Detail_ID ,
                [tsd].[S_Student_ID] ,
                [tsd].[S_Title] ,
                [tsd].[S_First_Name] ,
                [tsd].[S_Middle_Name] ,
                [tsd].[S_Last_Name] ,
                TSBM.I_Batch_ID ,
                [TSBM].[S_Batch_Code] ,
                [TSBM].S_Batch_Name ,
                [TCM].[S_Course_Name] ,
                [TCFM].[S_CourseFamily_Name] ,
                tsd.S_Phone_No ,
                tsd.S_Mobile_No ,
                [TSD].S_Email_ID ,
				Tsd.S_Curr_Address1 +' ' + tsd.S_Curr_Address2 as S_Curr_Stud_Address,
				Tsd.S_Perm_Address1 +' ' + tsd.S_Perm_Address2 as S_Perm_Stud_Address,
				Tsd.S_Guardian_Name,
                TBCD2.centerName AS S_Center_Name ,
                @InstanceChain AS InstanceChain
        FROM    [dbo].[T_Student_Detail] AS TSD
                INNER JOIN [dbo].[T_Student_Batch_Details] AS TSBD ON [TSD].[I_Student_Detail_ID] = [TSBD].[I_Student_ID]
                INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM ON [TSBD].[I_Batch_ID] = [TSBM].[I_Batch_ID]
                INNER JOIN [dbo].[T_Course_Master] AS TCM ON [TSBM].[I_Course_ID] = [TCM].[I_Course_ID]
                INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]
                INNER JOIN [dbo].[T_Student_Center_Detail] AS TSCD ON [TSCD].[I_Student_Detail_ID] = [tsd].[I_Student_Detail_ID]
                INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                          @iBrandID) TBCD2 ON [TBCD2].centerID = [TSCD].[I_Centre_Id]
                INNER JOIN DBO.[T_Enquiry_Regn_Detail] AS TERD ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Invoice_Parent AS TIP ON TSD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                INNER JOIN dbo.T_Invoice_Child_Header AS tich ON TIP.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                INNER JOIN dbo.T_Invoice_Batch_Map AS tibm ON tibm.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID
                                                              AND TSBM.I_Batch_ID = tibm.I_Batch_ID
        WHERE   TSBD.I_Batch_ID = ISNULL(@iBatchID, TSBD.I_Batch_ID)
                AND TCM.I_Course_ID IN ( SELECT CourseID
                                         FROM   @tblCourse )
                AND DATEDIFF(dd, ISNULL(@dtStartDate, TIP.Dt_Invoice_Date),
                             TIP.Dt_Invoice_Date) >= 0
                AND DATEDIFF(dd, ISNULL(@dtEndDate, TIP.Dt_Invoice_Date),
                             TIP.Dt_Invoice_Date) <= 0                
        ORDER BY [TBCD2].[brandID] ,
                [tsd].[I_Student_Detail_ID]  
     
    END TRY  
  
    BEGIN CATCH  
   
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT  
  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
    END CATCH
