CREATE PROCEDURE [dbo].[uspSearchStudentListByTCstatus]   --794,NULL,NULL,NULL,NULL,0           
    (  
      @iCenterId INT ,  
      @sStudentId VARCHAR(500) = NULL ,  
      @sStudentFirstName VARCHAR(50) = NULL ,  
      @sStudentSecondName VARCHAR(50) = NULL ,  
      @sStudentLastName VARCHAR(50) = NULL ,  
      @sTCStatus INT = NULL             
    )  
AS   
    BEGIN              
        SELECT  ISNULL(tsd.S_First_Name, '') AS S_First_Name ,  
                ISNULL(tsd.S_Middle_Name, '') AS S_Middle_Name ,  
                ISNULL(tsd.S_Last_Name, '') AS S_Last_Name ,  
                tsd.S_Student_ID AS STUDENT_CODE ,  
                tsd.I_Student_Detail_ID AS STUDENT_ID ,  
                ISNULL(TTC.I_Transfer_Req_Status, 0) AS I_Transfer_Req_Status , 
                TTC.S_Remarks AS S_Remarks
        FROM    dbo.T_Student_Detail AS TSD  
                INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON tsd.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID  
                LEFT OUTER JOIN dbo.T_Transfer_Certificates AS TTC ON tsd.I_Student_Detail_ID = TTC.I_Student_Detail_ID  
        WHERE   tsd.S_First_Name LIKE ISNULL(@sStudentFirstName,  
                                             tsd.S_First_Name) + '%'  
                AND ISNULL(tsd.S_Middle_Name, '') LIKE ISNULL(@sStudentSecondName,  
                                                              ISNULL(tsd.S_Middle_Name,  
                                                              '')) + '%'  
                AND tsd.S_Last_Name LIKE ISNULL(@sStudentLastName,  
                                                tsd.S_Last_Name) + '%'  
                AND tsd.S_Student_ID LIKE ISNULL(@sStudentId, tsd.S_Student_ID)  
                AND TERD.I_Centre_Id = ISNULL(@iCenterId, @iCenterId)  
                AND ISNULL(TTC.Is_Released,0) = 0  
                AND ISNULL(TTC.I_Transfer_Req_Status, 0) = @sTCStatus  
    END
