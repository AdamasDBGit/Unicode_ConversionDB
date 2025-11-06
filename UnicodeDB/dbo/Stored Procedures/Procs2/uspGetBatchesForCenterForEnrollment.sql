-- =============================================        
-- Author:  Debarshi Basu        
-- Create date: Sept 9, 2010        
-- Description: Get the Batch for Admission at a center        
-- =============================================        
        
CREATE PROCEDURE [dbo].[uspGetBatchesForCenterForEnrollment]
    @iCenterID INT = NULL ,
    @iCourseID INT = NULL
AS 
    BEGIN            
            
        SELECT  I_Batch_ID ,
                I_Centre_Id ,
                0 AS [Count] ,
                0 AS [EnrolmentCount] ,
                Max_Strength
        INTO    #temptable
        FROM    dbo.T_Center_Batch_Details            
            
        UPDATE  T
        SET     T.[Count] = T.[Count] + A1
        FROM    ( SELECT    COUNT(DISTINCT SRD.I_Enquiry_Regn_ID) AS A1 ,
                            SRD.I_Batch_ID ,
                            SRD.I_Destination_Center_ID AS I_Centre_ID
                  FROM      dbo.T_Student_Registration_Details SRD
                  WHERE     SRD.I_Status = 1
                  GROUP BY  SRD.I_Batch_ID ,
                            SRD.I_Destination_Center_ID
                ) A
                INNER JOIN #temptable T ON A.I_Batch_ID = T.I_Batch_ID
                                           AND A.I_Centre_Id = T.I_Centre_Id            
            
            
        UPDATE  T
        SET     T.[Count] = T.[Count] + A1 ,
                T.[EnrolmentCount] = T.[EnrolmentCount] + A1
        FROM    ( SELECT    COUNT(DISTINCT I_Student_Detail_ID) AS A1 ,
                            SBD.I_Batch_ID ,
                            SCD.I_Centre_Id
                  FROM      dbo.T_Student_Batch_Details SBD
                            INNER JOIN dbo.T_Student_Center_Detail SCD ON SBD.I_Student_ID = SCD.I_Student_Detail_ID
                  WHERE     SBD.I_Status = 1
                  GROUP BY  SBD.I_Batch_ID ,
                            SCD.I_Centre_Id
                ) A
                INNER JOIN #temptable T ON A.I_Batch_ID = T.I_Batch_ID
                                           AND A.I_Centre_Id = T.I_Centre_Id            
            
        UPDATE  A
        SET     I_Status = 6
        FROM    dbo.T_Center_Batch_Details A
                INNER JOIN ( SELECT I_Batch_ID ,
                                    I_Centre_ID
                             FROM   #temptable
                             WHERE  [COUNT] >= Max_Strength
                           ) B ON A.I_Batch_ID = B.I_Batch_ID
                                  AND A.I_Centre_Id = B.I_Centre_Id            
            
        UPDATE  A
        SET     I_Status = 4
        FROM    dbo.T_Center_Batch_Details A
                INNER JOIN ( SELECT I_Batch_ID ,
                                    I_Centre_ID
                             FROM   #temptable
                             WHERE  [COUNT] < Max_Strength
                           ) B ON A.I_Batch_ID = B.I_Batch_ID
                                  AND A.I_Centre_Id = B.I_Centre_Id
                                  AND A.I_Status = 6            
            
        SELECT  T.[Count] ,
                T.[EnrolmentCount] ,
                C.I_Course_ID ,
                C.S_Course_Name ,
                C.I_CourseFamily_ID ,
                C.S_Course_Code ,
                C.S_Course_Desc ,             
--D.I_TimeSlot_ID,D.S_TimeSlot_Desc,D.S_TimeSlot_Code,            
                E.I_Delivery_Pattern_ID ,
                E.S_Pattern_Name ,
                E.S_DaysOfWeek ,
                F.I_Course_Fee_Plan_ID ,
                F.S_Fee_Plan_Name ,
                F.N_TotalInstallment ,
                F.N_TotalLumpSum ,
                F.N_No_Of_Installments,
                F.Dt_Valid_To ,
                A.I_Batch_ID ,
                A.S_Batch_Code ,
                A.S_Batch_Name ,
                A.Dt_BatchStartDate ,
                B.I_Status ,
                A.Dt_Course_Expected_End_Date ,
                A.Dt_Course_Actual_End_Date ,
                A.I_Admission_GraceDays ,
                B.I_Centre_Id ,
                B.Max_Strength ,
                B.I_Minimum_Regn_Amt ,
                A.b_IsHOBatch ,
                A.b_IsCorporateBatch
        FROM    T_Student_Batch_Master A
                INNER JOIN #temptable T ON T.I_Batch_ID = A.I_Batch_ID
                LEFT OUTER JOIN dbo.T_Center_Batch_Details B ON A.I_Batch_ID = B.I_Batch_ID
                                                              AND T.I_Centre_Id = B.I_Centre_ID
                                                              AND B.I_Status = 4
                INNER JOIN dbo.T_Course_Master C ON A.I_Course_ID = C.I_Course_ID            
--INNER JOIN T_Center_TimeSlot D            
--ON A.I_TimeSlot_ID = D.I_TimeSlot_ID            
                INNER JOIN dbo.T_Delivery_Pattern_Master E ON A.I_Delivery_Pattern_ID = E.I_Delivery_Pattern_ID
                LEFT OUTER JOIN dbo.T_Course_Fee_Plan F ON B.I_Course_Fee_Plan_ID = F.I_Course_Fee_Plan_ID
        WHERE   T.[Count] < ISNULL(T.Max_Strength, T.[Count] + 1)
                AND B.I_Centre_Id = ISNULL(@iCenterID, B.I_Centre_Id)
                AND C.I_Course_ID = ISNULL(@iCourseID, C.I_Course_ID)
                AND ISNULL(A.b_IsApproved, 1) = 1        
            
        DROP TABLE #temptable         
            
    END
