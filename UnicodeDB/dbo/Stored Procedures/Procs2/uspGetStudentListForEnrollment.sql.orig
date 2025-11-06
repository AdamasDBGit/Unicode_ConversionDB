CREATE PROCEDURE [dbo].[uspGetStudentListForEnrollment]
    (
      @iHierarchyDetailID INT ,
      @sEnquiryNumber VARCHAR(500) ,
      @sFname VARCHAR(50) ,
      @sMname VARCHAR(50) ,
      @sLname VARCHAR(50) ,
      @sStatus INT = NULL ,
      @iStartRowNumber INT = NULL ,
      @iEndRowNumber INT = NULL ,
      @sFormNo VARCHAR(100) = NULL                
    )
AS 
    BEGIN                  
       
        IF ( @sFormNo IS NOT NULL ) 
            BEGIN
                SELECT  A.* ,
                        tcp1.S_Corporate_Plan_Name ,
                        Is_Referral = CASE WHEN ( SELECT    COUNT(*)
                                                  FROM      dbo.T_Student_Registration_Details SRD
                                                  WHERE     SRD.I_Origin_Center_Id <> SRD.I_Destination_Center_ID
                                                            AND SRD.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
                                                ) > 0 THEN 'true'
                                           ELSE 'false'
                                      END
                FROM    T_Enquiry_Regn_Detail A WITH ( NOLOCK )
                        LEFT OUTER JOIN dbo.T_Student_Detail AS tsd ON A.I_Enquiry_Regn_ID = tsd.I_Enquiry_Regn_ID
                        LEFT OUTER JOIN CORPORATE.T_Corporate_Plan AS tcp1 ON A.I_Corporate_Plan_ID = tcp1.I_Corporate_Plan_ID
                WHERE   tsd.I_Student_Detail_ID IS NULL
                        AND A.S_First_Name LIKE ISNULL(@sFname, A.S_First_Name)
                        + '%'
                        AND ISNULL(A.S_Middle_Name, '') LIKE ISNULL(NULL,
                                                              ISNULL(A.S_Middle_Name,
                                                              '')) + '%'
                        AND A.S_Last_Name LIKE ISNULL(@sLname, A.S_Last_Name)
                        + '%'
                        AND S_Enquiry_No LIKE ISNULL(@sEnquiryNumber,
                                                     S_Enquiry_No) + '%'
                        AND S_Form_No = @sFormNo
                        AND ( I_Centre_Id IN (
                              SELECT    I_Center_Id
                              FROM      T_Center_Hierarchy_Details D
                              WHERE     I_Hierarchy_Detail_ID = @iHierarchyDetailID
                                        AND I_Status <> 0 )
                              OR A.I_Enquiry_Regn_ID IN (
                              SELECT    I_Enquiry_Regn_ID
                              FROM      dbo.T_Student_Registration_Details
                              WHERE     I_Destination_Center_ID IN (
                                        SELECT  I_Center_Id
                                        FROM    T_Center_Hierarchy_Details D
                                        WHERE   I_Hierarchy_Detail_ID = @iHierarchyDetailID
                                                AND I_Status <> 0 )
                                        AND I_Status = 1 )
                            )
                        AND I_Enquiry_Status_Code = ISNULL(@sStatus,
                                                           I_Enquiry_Status_Code)
            END             
        ELSE 
            BEGIN
                SELECT  A.* ,
                        tcp1.S_Corporate_Plan_Name ,
                        Is_Referral = CASE WHEN ( SELECT    COUNT(*)
                                                  FROM      dbo.T_Student_Registration_Details SRD
                                                  WHERE     SRD.I_Origin_Center_Id <> SRD.I_Destination_Center_ID
                                                            AND SRD.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
                                                ) > 0 THEN 'true'
                                           ELSE 'false'
                                      END
                FROM    T_Enquiry_Regn_Detail A WITH ( NOLOCK )
                        LEFT OUTER JOIN dbo.T_Student_Detail AS tsd ON A.I_Enquiry_Regn_ID = tsd.I_Enquiry_Regn_ID
                        LEFT OUTER JOIN CORPORATE.T_Corporate_Plan AS tcp1 ON A.I_Corporate_Plan_ID = tcp1.I_Corporate_Plan_ID
                WHERE   tsd.I_Student_Detail_ID IS NULL
                        AND A.S_First_Name LIKE ISNULL(@sFname, A.S_First_Name)
                        + '%'
                        AND ISNULL(A.S_Middle_Name, '') LIKE ISNULL(NULL,
                                                              ISNULL(A.S_Middle_Name,
                                                              '')) + '%'
                        AND A.S_Last_Name LIKE ISNULL(@sLname, A.S_Last_Name)
                        + '%'
                        AND S_Enquiry_No LIKE ISNULL(@sEnquiryNumber,
                                                     S_Enquiry_No) + '%'
                        AND ( S_Form_No = ISNULL(@sFormNo, S_Form_No)
                              OR S_Form_No IS NULL
                            )
                        AND ( I_Centre_Id IN (
                              SELECT    I_Center_Id
                              FROM      T_Center_Hierarchy_Details D
                              WHERE     I_Hierarchy_Detail_ID = @iHierarchyDetailID
                                        AND I_Status <> 0 )
                              OR A.I_Enquiry_Regn_ID IN (
                              SELECT    I_Enquiry_Regn_ID
                              FROM      dbo.T_Student_Registration_Details
                              WHERE     I_Destination_Center_ID IN (
                                        SELECT  I_Center_Id
                                        FROM    T_Center_Hierarchy_Details D
                                        WHERE   I_Hierarchy_Detail_ID = @iHierarchyDetailID
                                                AND I_Status <> 0 )
                                        AND I_Status = 1 )
                            )
                        AND I_Enquiry_Status_Code = ISNULL(@sStatus,
                                                           I_Enquiry_Status_Code)
            END                                                 
                 
    END
