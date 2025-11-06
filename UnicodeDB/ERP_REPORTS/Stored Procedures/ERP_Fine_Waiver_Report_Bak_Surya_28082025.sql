CREATE PROCEDURE [ERP_REPORTS].[ERP_Fine_Waiver_Report_Bak_Surya_28082025]  
    @brandID INT,  
    @StrSchool_Group VARCHAR(50)=null,  
    @strclass VARCHAR(50) = NULL,  
    @startdt date=null,  
    @enddate date=null  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
  
    SELECT DISTINCT  
        SD.S_Student_ID AS StudenID,  
        SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' ' + SD.S_Last_Name AS StudentName,  
        SG.S_School_Group_Name AS School_Group,  
        Tc.S_Class_Name AS Class_Name,  
        St.S_Stream as StreamName,  
        tss.S_Section_Name as Section,  
        (Select TOP 1 S_Status_Desc from T_Status_Master where Status_Type=2 and I_Brand_ID=@brandID) AS Fee_Component,  
        wvw.Fine_waieve_off_Amt AS Waived_Amount,  
        Convert(Date,wvw.Dt_Installment_Date) AS For_Installment_Dt,  
        wvw.dt_Finewaiveroff AS Waiver_Applied_On,  
        --ivp.S_Invoice_No AS Invoice_Number,  
        wvw.S_Invoice_Number as Invoice_Number,  
        asm.S_Label AS Academic_Session ,
        wvw.s_finewaieveoff_remarks as Remarks,
        wvw.is_Partial_finewaiver as Fine_Waiver,
        wvw.Actual_FineAmount as Actual_FineAmount,
        wvw.FineDiscountAmount,
        wvw.FineDiscountPerc,
        wvw.Dt_Partialwaeve_off
    FROM  
        vw_Student_Fine_Waieve_OFF_Bak_Surya_28082025 wvw  
        INNER JOIN T_Student_Detail SD ON SD.I_Student_Detail_ID = wvw.I_Student_Detail_ID  
        INNER JOIN T_Student_Class_Section SCS ON SCS.I_Student_Detail_ID = wvw.I_Student_Detail_ID  
            AND SCS.I_Brand_ID = @brandID AND SCS.I_Status = 1  
        INNER JOIN T_School_Group_Class SGC ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID  
        INNER JOIN T_School_Group SG ON SG.I_School_Group_ID = SGC.I_School_Group_ID  
            AND SG.I_Brand_Id = @brandID  
        INNER JOIN T_Class Tc ON Tc.I_Class_ID = SGC.I_Class_ID  
            AND Tc.I_Brand_ID = @brandID  
        Inner JOIN T_Invoice_Parent ivp ON ivp.I_Invoice_Header_ID = wvw.I_Invoice_Header_ID  
        LEFT JOIN T_School_Academic_Session_Master asm ON asm.I_School_Session_ID = ivp.I_School_Session_ID  
        Left Join T_Stream St on St.I_Stream_ID=SCS.I_Stream_ID and St.I_brand_id=@brandID  
        Left Join T_Section tss on tss.I_Section_ID=SCS.I_Section_ID   
  
    WHERE  
        (SG.I_School_Group_ID IN (SELECT Value FROM dbo.ERP_SplitString(@StrSchool_Group, ','))   
        OR @StrSchool_Group IS NULL)  
        AND (Tc.I_Class_ID IN (SELECT Value FROM dbo.ERP_SplitString(@strclass, ',')) OR @strclass IS NULL)  
          
AND   
(  
    (@startdt IS NULL AND @enddate IS NULL) OR  
    (Convert(Date, wvw.dt_Finewaiveroff) BETWEEN ISNULL(@startdt, Convert(Date, wvw.dt_Finewaiveroff))  
    AND ISNULL(@enddate, Convert(Date, wvw.dt_Finewaiveroff)))  
)  
Order by wvw.dt_Finewaiveroff  
  
END  