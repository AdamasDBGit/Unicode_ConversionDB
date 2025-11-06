CREATE PROCEDURE [dbo].[uspSearchEnquiryList]
    (
      @iCenterId INT ,
      @sFname Nnvarchar(max) ,
      @sMname Nnvarchar(max) ,
      @sLName Nnvarchar(max) ,
      @sEnquiryNo Nnvarchar(max)
    )
AS 
    BEGIN            
        SELECT  I_Enquiry_Regn_ID ,
                ISNULL(S_Enquiry_No, '') ,
                ISNULL(S_First_Name, '') ,
                ISNULL(S_Middle_Name, '') ,
                ISNULL(S_Last_Name, '') ,
                ISNULL(Dt_Crtd_On, '') ,
                ISNULL(S_CURR_ADDRESS1, '') ,
                ISNULL(S_CURR_ADDRESS2, '') ,
                ISNULL(S_CURR_AREA, '') ,
                ISNULL(S_CURR_PINCODE, '')
        FROM    T_ENQUIRY_REGN_DETAIL TERD
        WHERE   TERD.S_Enquiry_No LIKE @sEnquiryNo + '%'
                AND TERD.S_FIRST_NAME LIKE @sFname + '%'
                AND ISNULL(TERD.S_MIDDLE_NAME, '') LIKE ISNULL(@sMname,
                                                              ISNULL(TERD.S_MIDDLE_NAME,
                                                              '')) + '%'
                AND TERD.S_LAST_NAME LIKE @slname + '%'
                AND (I_Enquiry_Status_Code <> 3 OR I_Enquiry_Status_Code IS NULL)
                AND I_Centre_Id = @iCenterId  
          
      
  -- Table[1] Enquiry Course Details            
        SELECT  A.I_Course_ID ,
                C.S_Course_Name ,
                TCFM.I_CourseFamily_ID ,
                TCFM.S_CourseFamily_Name ,
                B.I_Enquiry_Regn_ID
        FROM    dbo.T_Enquiry_Course A ,
                dbo.T_Enquiry_Regn_Detail B ,
                dbo.T_Course_Master C ,
                dbo.T_CourseFamily_Master AS TCFM
        WHERE   B.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
                AND A.I_Course_ID = C.I_Course_ID
                AND C.I_CourseFamily_ID = TCFM.I_CourseFamily_ID
                AND A.I_Enquiry_Regn_ID IN (
                SELECT  I_Enquiry_Regn_ID
                FROM    T_ENQUIRY_REGN_DETAIL TERD
                WHERE   TERD.S_Enquiry_No LIKE @sEnquiryNo + '%'
                        AND TERD.S_FIRST_NAME LIKE @sFname + '%'
                        AND ISNULL(TERD.S_MIDDLE_NAME, '') LIKE ISNULL(@sMname,
                                                              ISNULL(TERD.S_MIDDLE_NAME,
                                                              '')) + '%'
                        AND TERD.S_LAST_NAME LIKE @slname + '%'
                        AND (I_Enquiry_Status_Code <> 3 OR I_Enquiry_Status_Code IS NULL)
                        AND I_Centre_Id = @iCenterId )          
    END

