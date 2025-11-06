/*****************************************************************************************************************  
Created by:  Abhisek Bhattacharya  
Date:   08/06/2007  
Description: Saves the Feedback details for a particular Module given by a student  
******************************************************************************************************************/  
CREATE PROCEDURE [STUDENTFEATURES].[uspSaveStudentFeedback]
    (
      @iStudentDetailID INT ,
      @iCourseID INT ,
      @iTermID INT = NULL ,
      @iModuleID INT = NULL ,
      @iEmployeeID INT = NULL ,
      @iStatus INT ,
      @sFeedbackDetails XML ,
      @sUser VARCHAR(20) ,
      @dDate DATETIME ,
      @iUserID INT = NULL  
    )
AS 
    BEGIN TRY   
        DECLARE @AdjPosition SMALLINT ,
            @AdjCount SMALLINT  
        DECLARE @iFeedbackID INT ,
        @iFeedbackOptionID INT , @FeedbackMasterID INT
        DECLARE @FeedbackOptionXML XML  
        DECLARE @iStudentModuleID INT  
        DECLARE @Remarks NVARCHAR(100)
        IF @iModuleID IS NOT NULL
            AND @iTermID IS NOT NULL 
            BEGIN
 -- Select the Student Module Detail ID  
                SELECT  @iStudentModuleID = I_Student_Module_Detail_ID
                FROM    dbo.T_Student_Module_Detail
                WHERE   I_Student_Detail_ID = @iStudentDetailID
                        AND I_Course_ID = @iCourseID
                        AND I_Term_ID = @iTermID
                        AND I_Module_ID = @iModuleID  
                BEGIN TRAN T1  
 ---Inserting the Student Feedback Table  
                INSERT  INTO STUDENTFEATURES.T_Student_Feedback
                        ( I_Student_Module_Detail_ID ,
                          I_Employee_ID ,
                          I_User_ID ,
                          I_Status ,
                          S_Crtd_By ,
                          Dt_Crtd_On,
						 I_Student_ID
                        )
                VALUES  ( @iStudentModuleID ,
                          @iEmployeeID ,
                          @iUserID ,
                          @iStatus ,
                          @sUser ,
		                  @dDate,
						  @iStudentDetailID  
                        )  
            END
        ELSE 
            BEGIN
             BEGIN TRAN T1  
                INSERT  INTO STUDENTFEATURES.T_Student_Feedback
                        ( i_Course_ID ,
                          I_User_ID ,
                          I_Status ,
                          S_Crtd_By ,
                          Dt_Crtd_On,  
						   I_Student_ID
                        )
                VALUES  ( @iCourseID ,
                          @iUserID ,
                          @iStatus ,
                          @sUser ,
                          @dDate,  
						  @iStudentDetailID
                        )  
            END
        SET @iFeedbackID = SCOPE_IDENTITY()  
        COMMIT TRAN T1  
        SET @AdjPosition = 1  
        SET @AdjCount = @sFeedbackDetails.value('count((FeedbackType/FeedbackOption))',
                                                'int')  
        WHILE ( @AdjPosition <= @AdjCount ) 
            BEGIN  
                SET @FeedbackOptionXML = @sFeedbackDetails.query('FeedbackType/FeedbackOption[position()=sql:variable("@AdjPosition")]')  
          SELECT  @iFeedbackOptionID = T.a.value('@I_Feedback_Option_Master_ID',  'int'),
						 @FeedbackMasterID=T.a.value('@I_Feedback_Master_ID',  'int'),
						 @Remarks=T.a.value('@S_Remarks',  'NVARCHAR(100)')
                FROM    @FeedbackOptionXML.nodes('/FeedbackOption') T ( a )  
  ---Inserting into Training Feedback Option Deatails  
                INSERT  INTO STUDENTFEATURES.T_Student_Feedback_Details
      ( I_Student_Feedback_ID ,
                          I_Feedback_Option_Master_ID,
						  I_Feedback_Master_ID,
						  S_Remarks  
                        )
                VALUES  ( @iFeedbackID ,
                          CASE WHEN @iFeedbackOptionID='' THEN NULL ELSE @iFeedbackOptionID end,
						  CASE WHEN @FeedbackMasterID ='' THEN NULL ELSE @FeedbackMasterID end,
						  @Remarks  
                        )  

                SET @AdjPosition = @AdjPosition + 1  
            END   
    END TRY  
  BEGIN CATCH  
 --Error occurred:    
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
    END CATCH
