USE ALEX_OREHVO;
GO

-- 1
SELECT e.BusinessEntityID, e.JobTitle, d.Name as DepartmentName, ed.StartDate, ed.EndDate 
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory ed ON ed.BusinessEntityID = e.BusinessEntityID
INNER JOIN HumanResources.Department d ON d.DepartmentID = ed.DepartmentID
WHERE e.JobTitle = 'Purchasing Manager';
GO

-- 2
SELECT e.BusinessEntityID, e.JobTitle, count(eph.Rate) as RateCount 
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeePayHistory eph ON eph.BusinessEntityID = e.BusinessEntityID 
GROUP BY e.BusinessEntityID, e.JobTitle
HAVING COUNT(eph.RateChangeDate) > 1;
GO

-- 3
SELECT d.DepartmentID, d.Name, MAX(eph.Rate) AS MaxRate
FROM HumanResources.Department d
INNER JOIN HumanResources.EmployeeDepartmentHistory edh ON d.DepartmentID = edh.DepartmentID
INNER JOIN HumanResources.EmployeePayHistory eph ON eph.BusinessEntityID = edh.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY d.DepartmentID, d.Name;
GO
