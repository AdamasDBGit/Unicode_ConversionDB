



CREATE PROCEDURE [dbo].[usp_ERP_GetSearchInvoiceListForCancel] -- 11,'','','sa','',''  
    (      
      @iBrandId INT = NULL ,
	  @iCenterId INT = NULL ,
      @sInvoiceId Nnvarchar(max) = NULL ,      
      @sStudentId Nnvarchar(max) = NULL ,      
      @sStudentFirstName Nnvarchar(max) = NULL ,      
      @sStudentSecondName Nnvarchar(max) = NULL ,      
      @sStudentLastName Nnvarchar(max) = NULL          
    )      
AS       
    BEGIN          
        SET NOCOUNT ON ;          
        DECLARE @sStudentName nvarchar(max)          
        DECLARE @sStudentDetailId INT  
		
		select @iCenterId=I_Centre_Id from T_Brand_Center_Details where I_Brand_ID=@iBrandId

          
       SELECT  
			TIP.I_Student_Detail_ID as StudentDetailID,
			TIP.I_Invoice_Header_ID as invoiceHeaderID,
			CONCAT(
				ISNULL(TSD.S_First_Name, ''),
				' ',
				ISNULL(TSD.S_Middle_Name, ''),
				' ',
				ISNULL(TSD.S_Last_Name, '')
			) AS Full_Name,    
                TSD.S_STUDENT_ID as StudentID,      
                TIP.S_Invoice_No as InvoiceNo ,      
                TIP.Dt_Invoice_Date as InvoiceDate,
				TCFP.S_Fee_Plan_Name as FeePlanName,
				TIP.N_Invoice_Amount as TotalInvoiceAmount,
				TIP.N_Tax_Amount as TotalTaxAmount,
				CASE when ISNULL(ICH.C_Is_LumpSum, '') <> 'Y' THEN 'LumpSum Payment'
				ELSE 'Installment Payment' END FeeScheduleType
				,SG.S_School_Group_Name as SchoolGroupName
				,TC.S_Class_Name as ClassName
				,SASM.S_Label as AcademicSession
        FROM    T_INVOICE_PARENT TIP 
				inner join
                T_STUDENT_DETAIL TSD on TSD.I_Student_Detail_ID=TIP.I_Student_Detail_ID      
                inner join
				T_STUDENT_CENTER_DETAIL TSCD on 
				TSCD.I_Student_Detail_ID=TIP.I_Student_Detail_ID and TSCD.I_Centre_Id=TIP.I_Centre_Id
				inner join
				T_Invoice_Child_Header as ICH on ICH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID
				inner join
				T_Course_Fee_Plan as TCFP on ICH.I_Course_FeePlan_ID=TCFP.I_Course_Fee_Plan_ID
				left join
				T_ERP_Fee_Structure as EFS on EFS.I_Fee_Structure_ID=TCFP.I_New_I_Fee_Structure_ID
				left join
				T_School_Group as SG on EFS.I_School_Group_ID=SG.I_School_Group_ID
				left join
				T_Class as TC on EFS.I_Class_ID=TC.I_Class_ID
				left join
				T_ERP_Fee_Structure_AcademicSession_Map as EFSA on 
				EFS.I_Fee_Structure_ID=EFSA.I_Fee_Structure_ID and EFSA.Is_Active=1
				left join
				T_School_Academic_Session_Master as SASM 
				on EFSA.I_School_Session_ID=SASM.I_School_Session_ID and SASM.I_Status=1
				
        WHERE   TSCD.I_Centre_Id = @iCenterId  
				AND TIP.I_Centre_ID = @iCenterId    
                AND TIP.S_Invoice_No LIKE ISNULL(@sInvoiceId, TIP.S_Invoice_No)+'%'      
                AND TSD.S_Student_ID LIKE ISNULL(@sStudentId, TSD.S_Student_ID)+'%'     
                AND TSD.S_First_Name LIKE ISNULL(@sStudentFirstName,      
                                                 TSD.S_First_Name) + '%'      
                 AND ISNULL(TSD.S_Middle_Name,'') LIKE ISNULL(@sStudentSecondName,      
                                                  ISNULL(TSD.S_Middle_Name,'')) + '%'    
                AND TSD.S_Last_Name LIKE ISNULL(@sStudentLastName,      
                                                TSD.S_Last_Name) + '%'      
                AND TIP.I_STATUS in (1,3)      
                AND TSD.I_Status = 1      
                AND ISNULL([TSD].[S_Is_Corporate], 'N') = 'N'  
				
        ORDER BY TSD.S_Student_ID          
          
    END 


