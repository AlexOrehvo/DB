--a
CREATE VIEW Production.ProductView
	WITH ENCRYPTION, SCHEMABINDING
	AS 
		SELECT PL.LocationID, PPI.ProductID, PP.Name as ProductName, PL.Name AS LocationName, PL.CostRate, PL.Availability,
			 PPI.Shelf, PPI.Bin, PPI.Quantity, PPI.rowguid, PPI.ModifiedDate
		FROM Production.Location AS PL 
		INNER JOIN Production.ProductInventory AS ppi ON PL.LocationID = ppi.LocationID 
		INNER JOIN Production.Product AS pp ON ppi.ProductID = pp.ProductID
GO

CREATE UNIQUE CLUSTERED INDEX ID_LocationID_ProductID ON Production.Product_View (LocationID, ProductID)
GO

--b
CREATE TRIGGER Production.TriggerProductViewInsteadInsert ON Production.Product_View
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO Production.Location (Name, CostRate, Availability, ModifiedDate)
	SELECT LocationName, CostRate, Availability, ModifiedDate 
	FROM inserted

	INSERT INTO Production.ProductInventory (LocationID, ProductID, Shelf, Bin, Quantity, rowguid, ModifiedDate)
	SELECT PL.LocationID, PP.ProductID, Shelf, Bin, Quantity, inserted.rowguid, PL.ModifiedDate
	FROM inserted 
	INNER JOIN Production.Location AS pl ON inserted.ModifiedDate  = pl.ModifiedDate
	INNER JOIN Production.Product AS pp ON inserted.ProductName = pp.Name
END;
GO

CREATE TRIGGER Production.TriggerProductViewInsteadUpdate ON Production.Product_View
INSTEAD OF UPDATE AS
BEGIN
	UPDATE Production.Location
	SET Name = inserted.LocationName,
		CostRate = inserted.CostRate,
		Availability = inserted.Availability,
		ModifiedDate = inserted.ModifiedDate
	FROM inserted
	WHERE Production.Location.LocationID = inserted.LocationID

	UPDATE Production.ProductInventory
	SET Shelf = inserted.Shelf,
		Bin = inserted.Bin,
		Quantity = inserted.Quantity,
		rowguid = inserted.rowguid,
		ModifiedDate = inserted.ModifiedDate
	FROM inserted
	WHERE Production.ProductInventory.ProductID = inserted.ProductID
END;
GO

--c
INSERT INTO Production.Product_View (
	ProductName,
	LocationName,
	CostRate,
	Availability,
	Shelf,
	Bin,
	Quantity,
	rowguid,
	ModifiedDate
) 
VALUES ('Some Product', 'Glubokoe', 19, 99, 'A', 1, 400, '47A24246-6C43-48EB-968F-025738A8A411', GETDATE());

UPDATE Production.Product_View
SET LocationName = 'Minsk'
WHERE LocationName = 'Glubokoe';

DELETE Production.Product_View
WHERE LocationName = 'Minsk';

SELECT * FROM Production.Product_View
WHERE LocationName = 'Minsk';
