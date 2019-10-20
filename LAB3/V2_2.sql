USE ALEX_OREHVO;
GO

-- a
ALTER TABLE dbo.PersonPhone
	ADD JobTitle NVARCHAR(50),
		BirthDate DATE,
		HireDate DATE,
		HireAge AS DATEDIFF(year, BirthDate,HireDate);
GO

-- b
CREATE TABLE dbo.#PersonPhone(
	BusinessEntityID INT NOT NULL PRIMARY KEY,
	PhoneNumber NVARCHAR(25) NULL,
	PhoneNumberTypeID INT DEFAULT(1),
	ModifiedDate DATETIME NOT NULL,
	ID BIGINT NOT NULL,
	JobTitle NVARCHAR(50) NULL,
	BirthDate DATE NULL,
	HireDate DATE NULL
);

-- c
WITH Employee_CTE
AS 
(SELECT
	PPhone.BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	PPhone.ModifiedDate,
	ID,
	Employee.JobTitle,
	Employee.BirthDate,
	Employee.HireDate
FROM dbo.PersonPhone AS PPhone 
	INNER JOIN HumanResources.Employee ON PPhone.BusinessEntityID = Employee.BusinessEntityID
WHERE Employee.JobTitle = 'Sales Representative')

INSERT INTO dbo.#PersonPhone (
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate,
	ID,
	JobTitle,
	BirthDate,
	HireDate
) SELECT
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate,
	ID,
	JobTitle,
	BirthDate,
	HireDate
FROM Employee_CTE;

-- d
DELETE FROM dbo.PersonPhone WHERE BusinessEntityID = 275;

-- e
MERGE dbo.PersonPhone AS target
USING dbo.#PersonPhone as source
ON target.BusinessEntityID = source.BusinessEntityID
WHEN MATCHED 
	THEN UPDATE SET
		JobTitle = source.JobTitle,
		BirthDate = source.BirthDate
WHEN NOT MATCHED BY TARGET
	THEN INSERT(
			BusinessEntityID,
			PhoneNumber,
			PhoneNumberTypeID,
			ModifiedDate,
			JobTitle,
			BirthDate,
			HireDate
		)
		VALUES(
			source.BusinessEntityID,
			source.PhoneNumber,
			source.PhoneNumberTypeID,
			source.ModifiedDate,
			source.JobTitle,
			source.BirthDate,
			source.HireDate
		)
WHEN NOT MATCHED BY SOURCE
	THEN DELETE;