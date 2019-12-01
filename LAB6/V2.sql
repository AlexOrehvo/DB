USE ALEX_OREHVO;
GO

CREATE PROCEDURE dbo.SubCategoriesByColor (
	@Colors NVARCHAR(500)
)
AS
BEGIN
	DECLARE @SQL AS NVARCHAR(MAX)

	SET @SQL = 'SELECT Name, ' + @Colors + '
	FROM
	(
		SELECT PSubcategory.Name AS Name, Weight, P.Color
		FROM Production.ProductSubcategory AS PSubcategory 
		JOIN Production.Product AS P ON PSubcategory.ProductSubcategoryID = P.ProductSubcategoryID
	) AS src
	PIVOT (MAX(Weight) FOR Color IN (' + @Colors + ')) AS piv'

	EXEC(@SQL)
END;

EXECUTE dbo.SubCategoriesByColor '[Black],[Silver],[Yellow]'