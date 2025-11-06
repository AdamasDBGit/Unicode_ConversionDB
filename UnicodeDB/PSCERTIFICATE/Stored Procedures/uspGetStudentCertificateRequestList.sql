/*
-- =================================================================
-- Author:Chandan Dey
-- Modified By : 
-- Create date:06/18/2007 
-- Description:Select List StudentCertificateRequestList record in T_Student_Certificate_Request table 
-- =================================================================
*/

CREATE PROCEDURE [PSCERTIFICATE].[uspGetStudentCertificateRequestList]
(
    
	@iCenterID		INT = null,
	@iHierarchyDetailID INT = null,
	@iCourseID		INT = null,
	@iTermID		INT = null,
	@iPSCert		INT = null,
	@iStatusID		INT,
	@iBrandID INT = null,
	@iFlag INT = NULL
)
AS 
    BEGIN

-- For Get the center using hierarchy id 

        DECLARE @sSearchCriteria varchar(20)
        CREATE TABLE #TempCenter ( I_Center_ID int )

        IF @iHierarchyDetailID IS NOT NULL 
            BEGIN

                SELECT  @sSearchCriteria = S_Hierarchy_Chain
                from    T_Hierarchy_Mapping_Details
                where   I_Hierarchy_detail_id = @iHierarchyDetailID  
		
                IF @iBrandId = 0 
                    BEGIN
                        INSERT  INTO #TempCenter
                                SELECT  TCHD.I_Center_Id
                                FROM    T_CENTER_HIERARCHY_DETAILS TCHD
                                WHERE   TCHD.I_Hierarchy_Detail_ID IN (
                                        SELECT  I_HIERARCHY_DETAIL_ID
                                        FROM    T_Hierarchy_Mapping_Details
                                        WHERE   I_Status = 1
                                                AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
                                                AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
                                                AND S_Hierarchy_Chain LIKE @sSearchCriteria
                                                + '%' ) 
                    END
                ELSE 
                    BEGIN
                        INSERT  INTO #TempCenter
                                SELECT  TCHD.I_Center_Id
                                FROM    T_CENTER_HIERARCHY_DETAILS TCHD,
                                        T_BRAND_CENTER_DETAILS TBCD
                                WHERE   TCHD.I_Hierarchy_Detail_ID IN (
                                        SELECT  I_HIERARCHY_DETAIL_ID
                                        FROM    T_Hierarchy_Mapping_Details
                                        WHERE   I_Status = 1
                                                AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
                                                AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
                                                AND S_Hierarchy_Chain LIKE @sSearchCriteria
                                                + '%' )
                                        AND TBCD.I_Brand_ID = @iBrandId
                                        AND TBCD.I_Centre_Id = TCHD.I_Center_Id 			 
                    END
            END
        ELSE 
            BEGIN
                INSERT  INTO #TempCenter
                        SELECT  I_Centre_ID
                        FROM    T_Centre_Master
                        WHERE   I_Status = 1
                                AND I_Centre_ID = @iCenterID  
            END


        IF ( @iPSCert = 0
             AND @iTermID IS NULL
             AND @iFlag IS NULL
           ) 
            BEGIN
                SELECT DISTINCT ISNULL(A.I_Student_Cert_Request_ID, 0) AS I_Student_Cert_Request_ID,
                        ISNULL(A.I_Student_Certificate_ID, 0) AS I_Student_Certificate_ID,
                        ( ISNULL(A.S_Student_FName, ' ')
                          + ISNULL(A.S_Student_MName, ' ')
                          + ISNULL(A.S_Student_LName, ' ') ) AS S_Student_Name,
                        ISNULL(A.S_Reiss_Reason, ' ') AS S_Reiss_Reason,
                        ISNULL(A.I_Status, 0) AS I_Status,
                        ISNULL(A.S_Crtd_By, ' ') AS S_Crtd_By,
                        ISNULL(A.S_Upd_By, ' ') AS S_Upd_By,
                        ISNULL(A.Dt_Crtd_On, ' ') AS Dt_Crtd_On,
                        ISNULL(A.Dt_Upd_On, ' ') AS Dt_Upd_On,
                        ISNULL(B.I_Student_Detail_ID, 0) AS I_Student_Detail_ID,
                        ISNULL(C.S_First_Name, '') AS S_First_Name,
                        ISNULL(C.S_Middle_Name, '') AS S_Middle_Name,
                        ISNULL(C.S_Last_Name, '') AS S_Last_Name,
                        ISNULL(B.S_Certificate_Serial_No, '') AS S_Certificate_Serial_No,
                        ISNULL(CM.S_Center_Name, '') AS S_Center_Name,
                        CM.I_Centre_ID AS I_Center_ID,
                        ISNULL(COM.S_Course_Name, '') AS S_Course_Name,
                        ISNULL(TM.S_Term_Name, '') AS S_Term_Name,
                        SCD.I_Batch_ID
                FROM    [PSCERTIFICATE].T_Student_Certificate_Request A
                        INNER JOIN [PSCERTIFICATE].T_Student_PS_Certificate B ON A.I_Student_Certificate_ID = B.I_Student_Certificate_ID
                        INNER JOIN [dbo].T_Student_Detail C ON B.I_Student_Detail_ID = C.I_Student_Detail_ID
                        INNER JOIN [dbo].T_Student_Center_Detail F ON C.I_Student_Detail_ID = F.I_Student_Detail_ID
                        INNER JOIN dbo.T_Centre_Master CM ON CM.I_Centre_Id = F.I_Centre_Id
                        INNER JOIN dbo.T_Student_Course_Detail SCD ON SCD.I_Student_Detail_ID = B.I_Student_Detail_ID
                        AND [SCD].[I_Course_ID] = [B].[I_Course_ID]
                        INNER JOIN dbo.T_Course_Master COM ON COM.I_Course_ID = SCD.I_Course_ID
                        LEFT OUTER JOIN [dbo].T_Term_Master TM ON TM.I_Term_ID = B.I_Term_ID
                WHERE   
                        F.I_Centre_ID IN ( SELECT   I_Center_ID
                                           FROM     #TempCenter )
                        AND B.I_Course_ID = COALESCE(@iCourseID, B.I_Course_ID)
                        AND B.I_Term_ID IS NULL 
                        AND A.I_Status = COALESCE(@iStatusID, A.I_Status)
                        AND B.B_PS_Flag = 0
		
            END
        ELSE 
            IF ( @iPSCert = 1 ) 
                BEGIN
                    SELECT DISTINCT ISNULL(A.I_Student_Cert_Request_ID, 0) AS I_Student_Cert_Request_ID,
                            ISNULL(A.I_Student_Certificate_ID, 0) AS I_Student_Certificate_ID,
                            ( ISNULL(A.S_Student_FName, ' ')
                              + ISNULL(A.S_Student_MName, ' ')
                              + ISNULL(A.S_Student_LName, ' ') ) AS S_Student_Name,
                            ISNULL(A.S_Reiss_Reason, ' ') AS S_Reiss_Reason,
                            ISNULL(A.I_Status, 0) AS I_Status,
                            ISNULL(A.S_Crtd_By, ' ') AS S_Crtd_By,
                            ISNULL(A.S_Upd_By, ' ') AS S_Upd_By,
                            ISNULL(A.Dt_Crtd_On, ' ') AS Dt_Crtd_On,
                            ISNULL(A.Dt_Upd_On, ' ') AS Dt_Upd_On,
                            ISNULL(B.I_Student_Detail_ID, 0) AS I_Student_Detail_ID,
                            ISNULL(C.S_First_Name, '') AS S_First_Name,
                            ISNULL(C.S_Middle_Name, '') AS S_Middle_Name,
                            ISNULL(C.S_Last_Name, '') AS S_Last_Name,
                            ISNULL(B.S_Certificate_Serial_No, '') AS S_Certificate_Serial_No,
                            ISNULL(CM.S_Center_Name, '') AS S_Center_Name,
                            CM.I_Centre_ID AS I_Center_ID,
                            ISNULL(COM.S_Course_Name, '') AS S_Course_Name,
                            ISNULL(TM.S_Term_Name, '') AS S_Term_Name,
                            SCD.I_Batch_ID
                    FROM    [PSCERTIFICATE].T_Student_Certificate_Request A
                            INNER JOIN [PSCERTIFICATE].T_Student_PS_Certificate B ON A.I_Student_Certificate_ID = B.I_Student_Certificate_ID
                            INNER JOIN [dbo].T_Student_Detail C ON B.I_Student_Detail_ID = C.I_Student_Detail_ID
                            INNER JOIN [dbo].T_Student_Center_Detail F ON C.I_Student_Detail_ID = F.I_Student_Detail_ID
                            INNER JOIN dbo.T_Centre_Master CM ON CM.I_Centre_Id = F.I_Centre_Id
                            INNER JOIN dbo.T_Student_Course_Detail SCD ON SCD.I_Student_Detail_ID = B.I_Student_Detail_ID
                            AND [SCD].[I_Course_ID] = [B].[I_Course_ID]
                            INNER JOIN dbo.T_Course_Master COM ON COM.I_Course_ID = SCD.I_Course_ID
                            LEFT OUTER JOIN [dbo].T_Term_Master TM ON TM.I_Term_ID = B.I_Term_ID
                    WHERE  
                            F.I_Centre_ID IN ( SELECT   I_Center_ID
                                               FROM     #TempCenter )
                            AND B.I_Course_ID = COALESCE(@iCourseID,
                                                         B.I_Course_ID)
                            AND B.I_Term_ID = COALESCE(@iTermID, B.I_Term_ID)
                            AND A.I_Status = COALESCE(@iStatusID, A.I_Status)
                            AND B.B_PS_Flag = 1
		
                END
            ELSE 
                BEGIN
                    SELECT DISTINCT ISNULL(A.I_Student_Cert_Request_ID, 0) AS I_Student_Cert_Request_ID,
                            ISNULL(A.I_Student_Certificate_ID, 0) AS I_Student_Certificate_ID,
                            ( ISNULL(A.S_Student_FName, ' ')
                              + ISNULL(A.S_Student_MName, ' ')
                              + ISNULL(A.S_Student_LName, ' ') ) AS S_Student_Name,
                            ISNULL(A.S_Reiss_Reason, ' ') AS S_Reiss_Reason,
                            ISNULL(A.I_Status, 0) AS I_Status,
                            ISNULL(A.S_Crtd_By, ' ') AS S_Crtd_By,
                            ISNULL(A.S_Upd_By, ' ') AS S_Upd_By,
                            ISNULL(A.Dt_Crtd_On, ' ') AS Dt_Crtd_On,
                            ISNULL(A.Dt_Upd_On, ' ') AS Dt_Upd_On,
                            ISNULL(B.I_Student_Detail_ID, 0) AS I_Student_Detail_ID,
                            ISNULL(C.S_First_Name, '') AS S_First_Name,
                            ISNULL(C.S_Middle_Name, '') AS S_Middle_Name,
                            ISNULL(C.S_Last_Name, '') AS S_Last_Name,
                            ISNULL(B.S_Certificate_Serial_No, '') AS S_Certificate_Serial_No,
                            ISNULL(CM.S_Center_Name, '') AS S_Center_Name,
                            CM.I_Centre_ID AS I_Center_ID,
                            ISNULL(COM.S_Course_Name, '') AS S_Course_Name,
                            ISNULL(TM.S_Term_Name, '') AS S_Term_Name,
                            SCD.I_Batch_ID
                    FROM    [PSCERTIFICATE].T_Student_Certificate_Request A
                            INNER JOIN [PSCERTIFICATE].T_Student_PS_Certificate B ON A.I_Student_Certificate_ID = B.I_Student_Certificate_ID
                            INNER JOIN [dbo].T_Student_Detail C ON B.I_Student_Detail_ID = C.I_Student_Detail_ID
                            INNER JOIN [dbo].T_Student_Center_Detail F ON C.I_Student_Detail_ID = F.I_Student_Detail_ID
                            INNER JOIN dbo.T_Centre_Master CM ON CM.I_Centre_Id = F.I_Centre_Id
                            INNER JOIN dbo.T_Student_Course_Detail SCD ON SCD.I_Student_Detail_ID = B.I_Student_Detail_ID
                            AND [SCD].[I_Course_ID] = [B].[I_Course_ID]
                            INNER JOIN dbo.T_Course_Master COM ON COM.I_Course_ID = SCD.I_Course_ID
                            LEFT OUTER JOIN [dbo].T_Term_Master TM ON TM.I_Term_ID = B.I_Term_ID
                    WHERE   
                            F.I_Centre_ID IN ( SELECT   I_Center_ID
                                               FROM     #TempCenter )
	                        AND B.I_Term_ID IS NOT NULL
                            AND A.I_Status = COALESCE(@iStatusID, A.I_Status)
                            AND B.B_PS_Flag = 0
                END		
    END
