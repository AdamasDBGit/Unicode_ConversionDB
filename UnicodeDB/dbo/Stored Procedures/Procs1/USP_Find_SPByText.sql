CREATE Proc [dbo].[USP_Find_SPByText](@SearchSyntax NVARCHAR(MAX))
as
Begin


SELECT 
    p.name AS ProcedureName
FROM 
    sys.procedures p
JOIN 
    sys.sql_modules m ON p.object_id = m.object_id
WHERE 
    m.definition LIKE '%' + @SearchSyntax + '%';
end
