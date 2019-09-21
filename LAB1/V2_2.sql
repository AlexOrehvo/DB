USE ALEX_OREHVO;

-- 1
GO
SELECT DepartmentID, Name
FROM HumanResources.Department
ORDER BY Name DESC
	OFFSET 2 ROWS
	FETCH NEXT 5 ROWS ONLY;
GO

-- 2
SELECT DISTINCT JobTitle FROM HumanResources.Employee
WHERE OrganizationLevel = 1;

-- 3
SELECT BusinessEntityID, JobTitle, Gender, BirthDate, HireDate 
FROM HumanResources.Employee
WHERE DATEDIFF(year, BirthDate, HireDate) = 18
