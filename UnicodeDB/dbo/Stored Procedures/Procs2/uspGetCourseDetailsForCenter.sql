CREATE PROCEDURE [dbo].[uspGetCourseDetailsForCenter] --1847,18  
    (
      -- Add the parameters for the stored procedure here  
      @iCourseID INT ,
      @iCenterID INT  
    )
AS 
    BEGIN  
-- SET NOCOUNT ON added to prevent extra result sets from  
-- interfering with SELECT statements.  
        SET NOCOUNT OFF  
  
        DECLARE @iGradingPatternID INT  
  
        SELECT  @iGradingPatternID = CM.I_Grading_Pattern_ID
        FROM    dbo.T_COURSE_MASTER CM
        WHERE   CM.I_Course_ID = @iCourseID
                AND CM.I_Status = 1  
  
-- Course Basic Details  
-- Table[0]  
        SELECT  CM.I_Course_ID ,
                CM.I_CourseFamily_ID ,
                CM.I_Brand_ID ,
                CM.S_Course_Code ,
                CM.S_Course_Name ,
                CM.I_Grading_Pattern_ID ,
                CM.S_Course_Desc ,
                CM.I_Certificate_ID ,
                CM.S_Crtd_By ,
                BM.S_Brand_Code ,
                BM.S_Brand_Name ,
                ( SELECT    COUNT(B.I_Session_ID)
                  FROM      dbo.T_Session_Module_Map A
                            INNER JOIN dbo.T_Session_Master B ON A.I_Session_ID = B.I_Session_ID
                            INNER JOIN dbo.T_Module_Term_Map C ON A.I_Module_ID = C.I_Module_ID
                            INNER JOIN dbo.T_Term_Course_Map D ON C.I_Term_ID = D.I_Term_ID
                                                              AND D.I_Course_ID = CM.I_Course_ID
                                                              AND GETDATE() >= ISNULL(A.Dt_Valid_From,
                                                              GETDATE())
                                                              AND GETDATE() <= ISNULL(A.Dt_Valid_To,
                                                              GETDATE())
                                                              AND A.I_Status <> 0
                                                              AND B.I_Status <> 0
                                                              AND C.I_Status <> 0
                                                              AND D.I_Status <> 0
                ) AS I_No_Of_Session ,
                CM.S_Upd_By ,
                CM.C_AptitudeTestReqd ,
                CM.C_IsCareerCourse ,
                CM.C_IsShortTermCourse ,
                CM.C_IsPlacementApplicable ,
                CM.Dt_Crtd_On ,
                CM.Dt_Upd_On ,
                CM.I_Status ,
                CM.I_Is_Editable ,
                CR.S_Certificate_Name ,
                CF.S_CourseFamily_Name
        FROM    dbo.T_Course_Master CM
                LEFT OUTER JOIN dbo.T_Certificate_Master CR ON CM.I_Certificate_ID = CR.I_Certificate_ID
                LEFT OUTER JOIN dbo.T_CourseFamily_Master CF ON CM.I_CourseFamily_ID = CF.I_courseFamily_ID
                INNER JOIN dbo.T_Brand_Master BM ON CM.I_Brand_ID = BM.I_Brand_ID
        WHERE   CM.I_Course_ID = @iCourseID
                AND CM.I_Status = 1
                AND BM.I_Status <> 0  
  
  
-- Term List  
-- Table[1]  
        SELECT  A.I_Term_Course_ID ,
                A.I_Certificate_ID ,
                A.I_Term_ID ,
                A.I_Sequence ,
                A.C_Examinable ,
                A.I_Status ,
                A.I_Course_ID ,
                B.I_Term_ID ,
                B.I_Brand_ID ,
                B.S_Term_Code ,
                B.S_Term_Name ,
                B.I_Is_Editable ,
                B.I_Total_Session_Count ,
                CR.S_Certificate_Name
        FROM    dbo.T_Term_Course_Map A
                INNER JOIN dbo.T_Term_Master B ON A.I_Term_ID = B.I_Term_ID
                INNER JOIN dbo.T_Brand_Master BM ON B.I_Brand_ID = BM.I_Brand_ID
                LEFT OUTER JOIN dbo.T_Certificate_Master CR ON A.I_Certificate_ID = CR.I_Certificate_ID
        WHERE   A.I_Course_ID = @iCourseID
                AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
                AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
                AND A.I_Status <> 0
                AND BM.I_Status <> 0  
  
-- Grading Pattern  
-- Table [2]  
        SELECT  I_Grading_Pattern_ID ,
                S_Pattern_Name ,
                I_Status ,
                S_Crtd_By ,
                S_Upd_By ,
                Dt_Crtd_On ,
                Dt_Upd_On
        FROM    dbo.T_Grading_Pattern_Master
        WHERE   I_Grading_Pattern_ID = @iGradingPatternID
                AND I_Status = 1  
  
-- Grading Pattern Details  
-- Table [3]  
        SELECT  I_Grading_Pattern_Detail_ID ,
                I_Grading_Pattern_Detail_ID ,
                S_Grade_Type ,
                I_MinMarks ,
                I_MaxMarks
        FROM    dbo.T_Grading_Pattern_Detail
        WHERE   I_Grading_Pattern_ID = @iGradingPatternID  
  
-- Delivery Pattern List  
-- Table [4]  
        SELECT  DPM.I_Delivery_Pattern_ID ,
                DPM.S_Pattern_Name ,
                DPM.I_Status ,
                DPM.I_No_Of_Session ,
                DPM.N_Session_Day_Gap ,
                DPM.S_DaysOfWeek,
                DPM.S_Crtd_By ,
                DPM.S_Upd_By ,
                DPM.Dt_Crtd_On ,
                DPM.Dt_Upd_On
        FROM    dbo.T_Delivery_Pattern_Master DPM
                INNER JOIN dbo.T_Course_Delivery_Map CDM ON DPM.I_Delivery_Pattern_ID = CDM.I_Delivery_Pattern_ID
                                                            AND CDM.I_Course_ID = @iCourseID
                                                            AND DPM.I_Status = 1
                                                            AND CDM.I_Status = 1  
  
-- Fee Plan List  
-- Table [5]  
        SELECT  CF.I_Course_Fee_Plan_ID ,
                CF.S_Fee_Plan_Name ,
                CF.I_Course_Delivery_ID ,
                CF.I_Course_ID ,
                CF.I_Currency_ID ,
                CF.S_Crtd_By ,
                CF.C_Is_LumpSum ,
                CF.N_TotalLumpSum ,
                CF.S_Upd_By ,
                CF.Dt_Crtd_On ,
                CF.N_TotalInstallment ,
                CF.Dt_Upd_On ,
                DM.I_Delivery_Pattern_ID ,
                CF.I_Status ,
                CF.Dt_Valid_To,
                CF.N_No_Of_Installments
        FROM    dbo.T_Course_Fee_Plan CF
                INNER JOIN dbo.T_Course_Delivery_Map CD ON CF.I_Course_Delivery_ID = CD.I_Course_Delivery_ID
                INNER JOIN dbo.T_Delivery_Pattern_Master DM ON CD.I_Delivery_Pattern_ID = DM.I_Delivery_Pattern_ID
                                                              AND CF.I_Status = 1
                INNER JOIN t_course_center_detail TCD ON TCD.i_course_id = CF.I_Course_ID
                                                         AND TCD.i_centre_id = @iCenterID
                INNER JOIN T_Course_Center_Delivery_FeePlan TCCDF ON TCCDF.I_Course_Center_ID = TCD.I_Course_Center_ID
                                                              AND TCCDF.I_Course_Fee_Plan_ID = CF.I_Course_Fee_Plan_ID
                                                              AND TCCDF.i_status <> 0
        WHERE   CF.I_Course_ID = @iCourseID  
  
  
-- Fee Component List  
-- Table [6]  
        SELECT  FD.I_Course_Fee_Plan_Detail_ID ,
                FD.I_Fee_Component_ID ,
                FD.I_Course_Fee_Plan_ID ,
                FD.I_Item_Value ,
                FD.N_CompanyShare ,
                FD.I_Installment_No ,
                FD.I_Sequence ,
                FD.C_Is_LumpSum ,
                FD.I_Display_Fee_Component_ID ,
                FD.S_Crtd_By ,
                FD.Dt_Crtd_On ,
                FD.S_Upd_By ,
                FD.Dt_Upd_On
        FROM    dbo.T_Course_Fee_Plan_Detail FD
                INNER JOIN dbo.T_Course_Fee_Plan FP ON FD.I_Course_Fee_Plan_ID = FP.I_Course_Fee_Plan_ID
                                                       AND FP.I_Course_ID = @iCourseID
                                                       AND FP.I_Status = 1
                                                       AND FD.I_Status = 1
                INNER JOIN t_course_center_detail TCD ON TCD.i_course_id = FP.I_Course_ID
                                                         AND TCD.i_centre_id = @iCenterID
                INNER JOIN T_Course_Center_Delivery_FeePlan TCCDF ON TCCDF.I_Course_Center_ID = TCD.I_Course_Center_ID
                                                              AND TCCDF.I_Course_Fee_Plan_ID = FD.I_Course_Fee_Plan_ID
                                                              AND TCCDF.i_status <> 0  
  
    END
