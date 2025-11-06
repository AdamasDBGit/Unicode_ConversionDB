CREATE PROCEDURE [dbo].[uspGetFeePlanDetails] ( @iFeePlanID INT )
AS 
    BEGIN      
        SET NOCOUNT ON      
       
 -- Fee Plan List      
 -- Table [0]      
        SELECT  I_Course_Fee_Plan_ID ,
                I_Course_ID ,
                I_Course_Delivery_ID ,
                I_Currency_ID ,
                S_Fee_Plan_Name ,
                C_Is_LumpSum ,
                N_TotalLumpSum ,
                N_TotalInstallment ,
                I_Status ,
                Dt_Valid_To
        FROM    dbo.T_Course_Fee_Plan
        WHERE   I_Course_Fee_Plan_ID = @iFeePlanID
                AND I_Status = 1      
       
 -- Fee Component List      
 -- Table [1]      
        SELECT  I_Course_Fee_Plan_Detail_ID ,
                I_Fee_Component_ID ,
                I_Course_Fee_Plan_ID ,
                I_Item_Value ,
                ISNULL(N_CompanyShare, 0) AS N_CompanyShare ,
                I_Installment_No ,
                I_Sequence ,
                C_Is_LumpSum ,
                I_Display_Fee_Component_ID
        FROM    dbo.T_Course_Fee_Plan_Detail
        WHERE   I_Course_Fee_Plan_ID = @iFeePlanID
                AND I_Status = 1
        ORDER BY I_Installment_No,I_Sequence      
      
    END
