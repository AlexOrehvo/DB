USE ALEX_OREHVO;
GO

-- a
CREATE TABLE dbo.PersonPhone
(
    BusinessEntityID INT,
    PhoneNumber Phone,
    PhoneNumberTypeID INT,
    ModifiedDate DATETIME
);
GO	

-- b
ALTER TABLE dbo.PersonPhone
	ADD ID BIGINT IDENTITY(2,2);
ALTER TABLE dbo.PersonPhone
	ADD CONSTRAINT UI_ID UNIQUE (ID);
GO

-- c
ALTER TABLE dbo.PersonPhone
	ADD CONSTRAINT PhoneNumber
	CHECK(
	    PhoneNumber LIKE '%[^a-zA-Z]%'
	);
GO

-- d
ALTER TABLE dbo.PersonPhone
	ADD CONSTRAINT DF_PhoneNumberTypeID
	DEFAULT 1 FOR PhoneNumberTypeID;
GO

-- e
INSERT INTO dbo.PersonPhone (
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate
)
	SELECT 
		pp.BusinessEntityID,
		pp.PhoneNumber,
		pp.PhoneNumberTypeID,
		pp.ModifiedDate
	FROM Person.PersonPhone pp
	INNER JOIN HumanResources.Employee e ON pp.BusinessEntityID = e.BusinessEntityID
	INNER JOIN HumanResources.EmployeeDepartmentHistory edh ON pp.BusinessEntityID = edh.BusinessEntityID
	WHERE 
		NOT (PhoneNumber LIKE '%(%)%')
		AND (edh.StartDate = e.HireDate);
GO

-- f
ALTER TABLE dbo.PersonPhone
	ALTER COLUMN PhoneNumber NVARCHAR(25) NULL;
GO