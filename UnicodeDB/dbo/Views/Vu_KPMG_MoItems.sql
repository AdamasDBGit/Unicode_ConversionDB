


Create VIEW [dbo].[Vu_KPMG_MoItems]
AS
SELECT  DISTINCT   P.I_Student_Detail_ID, P.I_Centre_Id, CH.I_Course_ID, CD.I_Installment_No, Slist.Fld_KPMG_ItemCode
FROM          dbo.T_Invoice_Parent AS P INNER JOIN
              dbo.T_Invoice_Child_Header AS CH ON P.I_Invoice_Header_ID = CH.I_Invoice_Header_ID INNER JOIN
              dbo.T_Invoice_Child_Detail AS CD ON CH.I_Invoice_Child_Header_ID = CD.I_Invoice_Child_Header_ID INNER JOIN              
              -- CD.I_Installment_No <> StMp.Fld_KPMG_I_Installment_No INNER JOIN
              dbo.Tbl_KPMG_SM_List AS Slist ON CH.I_Course_ID = Slist.Fld_KPMG_CourseId 
              LEFT OUTER JOIN dbo.Tbl_KPMG_MoStudentMap AS StMp ON StMp.Fld_KPMG_I_Student_Detail_ID = P.I_Student_Detail_ID
              AND StMp.Fld_KPMG_MoStudentMapId IS NULL
              AND CD.I_Installment_No = Slist.Fld_KPMG_I_Installment_No
			  AND     (CD.I_Installment_No > '1') 
			  AND (CD.I_Installment_No < '9') AND (CH.I_Course_ID IS NOT NULL) -- AND (StMp.Fld_KPMG_Status = '0')