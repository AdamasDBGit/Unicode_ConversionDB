CREATE PROCEDURE [dbo].[uspGetStudentForDemotionForParticularBatch ]  --707,'04-0070',NULL,NULL,NULL,1  
    (
      @iBatchID INT ,
      @sStudentCode NVARCHAR(MAX) = NULL ,
      @sFname NVARCHAR(MAX) = NULL ,
      @sMname NVARCHAR(MAX) = NULL ,
      @sLname NVARCHAR(MAX) = NULL ,
      @iCenterID INT = NULL          
            
    )
AS 
    BEGIN              
           
        SELECT DISTINCT
                STD.I_Student_Detail_ID ,
                ERD.I_Enquiry_Regn_ID ,
                STD.S_Student_ID ,
                STD.S_First_Name ,
                ISNULL(STD.S_Middle_Name, '') AS S_Middle_Name ,
                STD.S_Last_Name ,
                TSEV.I_Extra_View_Count
        FROM    T_Student_Batch_Details STBD
                INNER JOIN T_Student_Detail STD ON STD.I_Student_Detail_ID = STBD.I_Student_ID
                INNER JOIN T_Enquiry_Regn_Detail ERD ON STD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                LEFT OUTER JOIN T_Student_Extra_View TSEV ON TSEV.I_Student_Detail_ID = STD.I_Student_Detail_ID
                                                             AND TSEV.I_Batch_ID = @iBatchID
        WHERE   STBD.I_Batch_ID = @iBatchID
                AND STBD.I_Status = 3
                AND STD.S_First_Name LIKE ISNULL(@sFname, STD.S_First_Name)
                + '%'
                AND ( STD.S_Middle_Name IS NULL
                      OR STD.S_Middle_Name LIKE ISNULL(@sMname,
                                                       STD.S_Middle_Name)
                      + '%'
                    )
                AND STD.S_Last_Name LIKE ISNULL(@sLname, STD.S_Last_Name)
                + '%'
                AND STD.S_Student_ID LIKE ISNULL(@sStudentCode, S_Student_ID)  
  
--Akash 20.9.14            
--and ERD.I_Centre_Id =  ISNULL(@iCenterID,ERD.I_Centre_Id)                  
--Akash 20.9.14   
          
              
              
    END

