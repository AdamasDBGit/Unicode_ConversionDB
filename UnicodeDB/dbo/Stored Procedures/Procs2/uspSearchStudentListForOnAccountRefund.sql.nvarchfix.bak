CREATE PROCEDURE [dbo].[uspSearchStudentListForOnAccountRefund]
    (
      @iCenterID INT ,
      @sStudentId Nnvarchar(max) = NULL ,
      @sStudentFirstName Nnvarchar(max) = NULL ,
      @sStudentSecondName Nnvarchar(max) = NULL ,
      @sStudentLastName Nnvarchar(max) = NULL ,
      @sEnquiryNo Nnvarchar(max) = NULL        
    )
AS 
    BEGIN        
        SET NOCOUNT ON ;           
		
        SELECT  TERD.I_Enquiry_Regn_ID ,
                TERD.S_Enquiry_No ,
                TERD.S_First_Name ,
                ISNULL(TERD.S_Middle_Name, '') AS S_Middle_Name,
                ISNULL(TERD.S_Last_Name, '') AS S_Last_Name ,
                TSD.I_Student_Detail_ID ,
                TSD.S_Student_ID
        FROM    dbo.T_Enquiry_Regn_Detail AS TERD
                LEFT OUTER JOIN dbo.T_Student_Detail AS TSD ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TERD.S_First_Name LIKE ISNULL(@sStudentFirstName,
                                              TERD.S_First_Name) + '%'
                AND ISNULL(TERD.S_Middle_Name, '') LIKE ISNULL(@sStudentSecondName,
                                                              ISNULL(TERD.S_Middle_Name,
                                                              '')) + '%'
                AND ISNULL(TERD.S_Last_Name, '') LIKE ISNULL(@sStudentLastName,
                                                             ISNULL(TERD.S_Last_Name,
                                                              '')) + '%'
                AND ( tsd.S_Student_ID = ISNULL(@sStudentId, tsd.S_Student_ID)
                      OR TSD.S_Student_ID IS NULL
                    )
                AND TERD.S_Enquiry_No = ISNULL(@sEnquiryNo, TERD.S_Enquiry_No)
                AND TERD.I_Centre_Id = @iCenterID
        ORDER BY S_Student_ID ,
                S_Enquiry_No   
    END

