USE ALEX_OREHVO;
GO

-- 1
CREATE FUNCTION dbo.getEmployeeAmountByDepartmentID
	(
	@DepartmentID INT
	)
RETURNS INT
AS
BEGIN
	DECLARE @result INT
	SET @result = 
	(
		SELECT COUNT(1)
		FROM HumanResources.EmployeeDepartmentHistory
		WHERE DepartmentID = @DepartmentID
			AND EndDate IS NULL
	)

	RETURN @result
END;

-- 2
CREATE FUNCTION dbo.getOldEmployeeByDepartmentID(@DepartmentID INT)
RETURNS TABLE
AS
RETURN
	SELECT BusinessEntityID,DepartmentID
	FROM HumanResources.EmployeeDepartmentHistory
	WHERE DepartmentID = @DepartmentID
		  AND DATEDIFF(year, StartDate, GETDATE()) > 11
		  AND EndDate IS NULL

-- 3
SELECT * FROM HumanResources.Department
	CROSS APPLY dbo.getOldEmployeeByDepartmentID(DepartmentID) AS d
	ORDER BY d.DepartmentID

-- 4
CREATE FUNCTION dbo.getOldEmployeeByDepartmentID2(@DeparmentID SMALLINT)
	RETURNS @employees TABLE 
		(
			BusinessEntityID INT NOT NULL,
			DepartmentID SMALLINT NOT NULL
		)
AS
BEGIN
	INSERT INTO @employees
	SELECT BusinessEntityID, DepartmentID
	FROM HumanResources.EmployeeDepartmentHistory
	WHERE 
DepartmentID = @DeparmentID
		AND DATEDIFF(year, StartDate, GETDATE()) > 11
		AND EndDate IS NULL
	RETURN
END;
