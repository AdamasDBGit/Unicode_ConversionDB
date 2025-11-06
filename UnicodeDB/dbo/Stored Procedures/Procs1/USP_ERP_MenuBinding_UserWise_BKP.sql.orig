
CREATE Proc [dbo].[USP_ERP_MenuBinding_UserWise_BKP](
@UserID int,
@PermissionType Varchar(10)=Null
)
As Begin 
Select distinct c.I_Permission_ID,
c.S_Name,c.Description,c.I_Parent_Menu_ID,c.S_PageUrl,c.S_Icon,c.I_Is_Leaf_Node,c.i_pageseq,
d.S_User_GroupName,b.S_Role_Desc
Into #USerPermission

from T_ERP_Users_Role_Permission_Map a
Inner Join T_ERP_Role_Master b on a.Role_Id=b.I_Role_ID
Inner Join T_erp_Permission c on c.I_Permission_ID=a.Permission_ID
Inner Join T_ERP_User_Group_Master d on d.I_User_Group_Master_ID=a.User_Group_ID

where a.Is_Active=1 and b.I_Status=1 and c.I_Status=1 and d.Is_Active=1
aND a.I_User_Id=@UserID		and c.Permission_Type=@PermissionType
--select * from #USerPermission
;WITH RecursiveCTE AS (
    SELECT 
I_Permission_ID
,Description
,I_Parent_Menu_ID
,S_PageUrl
,S_Icon
,I_Is_Leaf_Node
,i_pageseq
,1 AS Level
--,ROW_NUMBER() OVER (ORDER BY I_Permission_ID) AS i_pageseq1
    FROM #USerPermission
    WHERE  
    I_Parent_Menu_ID is null
 
    UNION ALL
 
    SELECT 
 p.I_Permission_ID
,p.Description
,p.I_Parent_Menu_ID
,p.S_PageUrl
,p.S_Icon
,p.I_Is_Leaf_Node
,p.i_pageseq
,Level + 1
--,ROW_NUMBER() OVER (ORDER BY p.I_Permission_ID) AS i_pageseq1
    FROM #USerPermission p
    INNER JOIN RecursiveCTE cte ON p.I_Parent_Menu_ID = cte.I_Permission_ID
	--where cte.I_Parent_Menu_ID is not null
)
SELECT 
 a.I_Permission_ID as PermissionID
 ,b.Description as Parent_PermissionName
,a.Description as PermissionName
,a.I_Parent_Menu_ID as ParentPermissionID
,STUFF(a.S_PageUrl, 1, LEN('/SMS2'), '')as PageURL
,a.S_Icon
,a.I_Is_Leaf_Node as LeafNode_Seq
,a.i_pageseq as ManuPageSeq
,a.Level
,b.i_pageseq
--,a.i_pageseq1


 
FROM RecursiveCTE a
Left Join T_ERP_Permission b on a.I_Parent_Menu_ID=b.I_Permission_ID
ORDER BY  b.i_pageseq

Drop table #USerPermission
End 
