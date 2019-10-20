USE ALEX_OREHVO;
GO

-- a
ALTER TABLE dbo.PersonPhone
	ADD HireDate DATE;
GO

-- b
DECLARE @PersonPhoneVar TABLE (
	BusinessEntityID INT NOT NULL,
	PhoneNumber NVARCHAR(25) NULL,
	PhoneNumberTypeID INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	ID BIGINT NULL,
	HireDate DATE NULL
);

INSERT INTO @PersonPhoneVar  (
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate,
	HireDate
) SELECT
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate,
	(
		SELECT HireDate FROM HumanResources.Employee e
			WHERE e.BusinessEntityID = dbo.PersonPhone.BusinessEntityID
	)
FROM dbo.PersonPhone;

-- c
UPDATE dbo.PersonPhone
	SET dbo.PersonPhone.HireDate = DATEADD(dd, 1, PersonPhone.HireDate)
FROM @PersonPhoneVar AS PersonPhoneVar
	WHERE dbo.PersonPhone.BusinessEntityID = PersonPhoneVar.BusinessEntityID;
GO

-- e
ALTER TABLE dbo.PersonPhone DROP CONSTRAINT PhoneNumber;
ALTER TABLE dbo.PersonPhone DROP CONSTRAINT UI_ID;
ALTER TABLE dbo.PersonPhone DROP CONSTRAINT DF_PhoneNumberTypeID;
GO

-- f
DROP TABLE dbo.PersonPhone;