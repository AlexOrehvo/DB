USE ALEX_OREHVO;
GO

--a
CREATE TABLE Production.LocationHst (
	ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Action CHAR(6) NOT NULL CHECK (Action IN ('insert', 'update', 'delete')),
	ModifiedDate DATETIME NOT NULL,
	SourceID INT NOT NULL,
	UserName NVARCHAR(50) NOT NULL
);

--b
CREATE TRIGGER Production.LocationAfterTrigger
ON Production.Location
AFTER INSERT, UPDATE, DELETE AS
	INSERT INTO Production.LocationHst (Action, ModifiedDate, SourceID, UserName)
	SELECT
		CASE WHEN inserted.LocationID  IS NULL THEN 'delete'
			 WHEN deleted.LocationID  IS NULL THEN 'insert'
			 ELSE 'update'
		END,
		GETDATE(),
		COALESCE(inserted.LocationID, deleted.LocationID),
		USER_NAME()
	FROM inserted FULL 
	OUTER JOIN deleted ON inserted.LocationID = deleted.LocationID;
GO

--c
CREATE VIEW Production.LocationView AS
	SELECT * FROM Production.Location

--d
INSERT INTO Production.LocationView (Name, CostRate, Availability, ModifiedDate)
VALUES ('Alex Orehvo', 19, 99, GETDATE());

UPDATE Production.LocationView
SET CostRate = 25
WHERE Name = 'Alex Orehvo';

DELETE Production.LocationView
WHERE Name = 'Alex Orehvo';