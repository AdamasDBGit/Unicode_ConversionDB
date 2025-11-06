CREATE PROCEDURE [STUDENTFEATURES].[uspSurveyQuestions] ( @StudentId INT )
AS 
    BEGIN          
      
        SELECT  *
        FROM    ( SELECT    NULL AS [I_Survey_Question_ID],
                            NULL AS [I_SQ_SubGroups_ID],
                            TSQG.I_SQ_Groups_ID,
                            TSQG.S_GroupDesc AS Descr,
                            NULL AS [N_Weightage],
                            @StudentId AS [StudentID]
                  FROM      [STUDENTFEATURES].[T_Survey_Question_Groups] AS TSQG
                  WHERE     ISNULL(TSQG.I_Status, 0) = 1
                  UNION
                  SELECT    NULL AS [I_Survey_Question_ID],
                            TSQSG.I_SQ_SubGroups_ID AS [I_SQ_SubGroups_ID],
                            TSQSG.I_SQ_Groups_ID,
                            TSQSG.S_SubGroupDesc AS Descr,
                            NULL AS [N_Weightage],
                            @StudentId AS [StudentID]
                  FROM      [STUDENTFEATURES].[T_Survey_Question_SubGroups] AS TSQSG
                  WHERE     ISNULL(TSQSG.I_Status, 0) = 1
                  UNION
                  SELECT    TSQ.I_Survey_Question_ID AS [I_Survey_Question_ID],
                            TSQ.I_SQ_SubGroups_ID AS [I_SQ_SubGroups_ID],
                            TSQ.I_SQ_Groups_ID,
                            TSQ.S_Question AS Descr,
                            TSQD.I_Weightage AS [N_Weightage],
                            @StudentId AS [StudentID]
                  FROM      [STUDENTFEATURES].[T_Survey_Question] AS TSQ
                            LEFT JOIN [STUDENTFEATURES].[T_Student_Survey_Ratings]
                            AS TSQD ON TSQ.I_Survey_Question_ID = TSQD.I_Survey_Question_ID
                                       AND TSQD.I_Student_Survey_ID IN (
                                       SELECT   I_Student_Survey_ID
                                       FROM     [STUDENTFEATURES].[T_Student_Survey_Details]
                                       WHERE    I_Student_Detail_ID = @StudentId )
                  WHERE     ISNULL(TSQ.I_Status, 0) = 1
                ) RR
        ORDER BY 3,
                2,
                1          
        
        
        SELECT  TSBM.S_Batch_Code,
                TCM.S_Course_Name,
                TED.S_First_Name + ' ' + TED.S_Middle_Name + ' '
                + TED.S_Last_Name AS [Faculty],
                TCM2.S_City_Name
        FROM    dbo.T_Student_Batch_Details AS TSBD
                INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Course_Master AS TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TSBD.I_Batch_ID = TCBD.I_Batch_ID
                LEFT OUTER JOIN dbo.T_Employee_Dtls AS TED ON TCBD.I_Employee_ID = TED.I_Employee_ID
                INNER JOIN NETWORK.T_Center_Address AS TCA ON TCBD.I_Centre_Id = TCA.I_Centre_Id
                INNER JOIN dbo.T_City_Master AS TCM2 ON TCA.I_City_ID = TCM2.I_City_ID
        WHERE   I_Student_ID = @StudentId      
       
    END
