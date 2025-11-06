
CREATE  Proc [dbo].[USP_ERP_MenuBinding_UserWise](
@UserID int,
@PermissionType NVARCHAR(MAX)=Null
)
As Begin



CREATE TABLE #USerPermission (
    I_Permission_ID INT,
    S_Name NVARCHAR(255),
    Description NVARCHAR(MAX),
    I_Parent_Menu_ID INT,
    S_PageUrl NVARCHAR(255),
    S_Icon NVARCHAR(255),
    I_Is_Leaf_Node BIT,
    i_pageseq INT,
    S_User_GroupName NVARCHAR(255),
    S_Role_Desc NVARCHAR(255)

);

IF EXISTS (SELECT * FROM T_ERP_User WHERE I_User_ID = @UserID AND ISNULL(IsAllAllowedEligible, 'false') = 'true')
BEGIN
    -- If user has all permissions allowed
    INSERT INTO #USerPermission
    SELECT DISTINCT
        c.I_Permission_ID,
        c.S_Name,
        c.Description,
        c.I_Parent_Menu_ID,
        c.S_PageUrl,
        c.S_Icon,
        c.I_Is_Leaf_Node,
        c.i_pageseq,
        NULL AS S_User_GroupName,
        NULL as S_Role_Desc
		
    FROM T_erp_Permission c 
    WHERE  c.I_Status = 1 AND c.Permission_Type = @PermissionType;
END
ELSE
BEGIN
    -- If user does not have all permissions allowed
    INSERT INTO #USerPermission
    SELECT DISTINCT
        c.I_Permission_ID,
        c.S_Name,
        c.Description,
        c.I_Parent_Menu_ID,
        c.S_PageUrl,
        c.S_Icon,
        c.I_Is_Leaf_Node,
        c.i_pageseq,
        d.S_User_GroupName,
        b.S_Role_Desc
    FROM T_ERP_Users_Role_Permission_Map a
    INNER JOIN T_ERP_Role_Master b ON a.Role_Id = b.I_Role_ID
    INNER JOIN T_erp_Permission c ON c.I_Permission_ID = a.Permission_ID
    INNER JOIN T_ERP_User_Group_Master d ON d.I_User_Group_Master_ID = a.User_Group_ID
    WHERE a.Is_Active = 1 AND b.I_Status = 1 AND c.I_Status = 1 AND d.Is_Active = 1
    AND a.I_User_Id = @UserID AND c.Permission_Type = @PermissionType;
END

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
SELECT DISTINCT
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

