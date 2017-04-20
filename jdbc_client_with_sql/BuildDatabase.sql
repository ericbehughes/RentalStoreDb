/*
DROP TABLE ACTORS CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEES CASCADE CONSTRAINTS;
DROP TABLE HOURS CASCADE CONSTRAINTS;
DROP TABLE INVENTORY CASCADE CONSTRAINTS;
DROP TABLE MOVIECUSTOMERS CASCADE CONSTRAINTS;
DROP TABLE MOVIES CASCADE CONSTRAINTS;
DROP TABLE RENTALS CASCADE CONSTRAINTS;
DROP TABLE SPECIALS CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEES CASCADE CONSTRAINTS;
DROP TABLE SCHEDULE CASCADE CONSTRAINTS;
DROP TABLE STORECUSTOMERS CASCADE CONSTRAINTS;
DROP TABLE SHIPMENTS CASCADE CONSTRAINTS;
DROP TABLE Movieactors cascade constraints;
DROP TABLE credentials cascade constraints;
DROP TABLE rentallog cascade constraints;
DROP sequence InventorySequence;
*/
CREATE TABLE Specials
(
SpecialID VARCHAR2(64),
Title VARCHAR2(64),
Discount NUMBER(4),
  CONSTRAINT Specials_SpecialID_pk PRIMARY KEY(SpecialID)
);

CREATE TABLE Movies 
(
MovieID VARCHAR2(64),
Title  VARCHAR2(64) NOT NULL,
Price NUMBER(6,2) NOT NULL,
Rating NUMBER(4),
TotalAvailable number(4),
TotalInStock number(4),
Release_Date DATE,
Genre VARCHAR2(64),
IsOnSpecial CHAR(1),
SpecialID VARCHAR2(64),
  CONSTRAINT Movies_MovieID_pk PRIMARY KEY(MovieID),
  CONSTRAINT Movies_SpecialID_fk FOREIGN KEY (SpecialID)
    REFERENCES Specials(SpecialID)
);

CREATE TABLE StoreCustomers  
(
CustomerID VARCHAR2(64),
First_Name VARCHAR2(64) NOT NULL,
Last_Name VARCHAR2(64) NOT NULL,
Phone_Number VARCHAR2(64) NOT NULL,
Address VARCHAR2(64) NOT NULL,
Late_Fees NUMBER(6,2),
ReferredBy VARCHAR2(64),
  CONSTRAINT StoreCustomers_CustomerID_pk PRIMARY KEY(CustomerID)
);
  
  
CREATE TABLE Actors 
(
ActorID VARCHAR2(64),
First_Name VARCHAR2(64) NOT NULL,
Last_Name VARCHAR2(64) NOT NULL,
  CONSTRAINT Actors_ActorID_pk PRIMARY KEY(ActorID)
);

CREATE TABLE MovieActors
(ActorID VARCHAR2(64), 
 MovieID VARCHAR2(64), 
  CONSTRAINT MovieActors_pk PRIMARY KEY (ActorID, MovieID),
  CONSTRAINT MovieActors_ActorID_fk FOREIGN KEY (ActorID)
             REFERENCES Actors (ActorID),
  CONSTRAINT MovieActors_MovieID_fk FOREIGN KEY (MovieID)
             REFERENCES Movies (MovieID));   
	
CREATE TABLE Employees
(
EmployeeID VARCHAR2(64),
ManagerID VARCHAR2(64) NOT NULL,
Address VARCHAR2(64) NOT NULL,
First_Name VARCHAR2(64) NOT NULL,
Last_Name VARCHAR2(64) NOT NULL,
Phone_Number VARCHAR2(64) NOT NULL,
Title VARCHAR2(64) NOT NULL,
Salary NUMBER(20,2) NOT NULL,
Hire_Date DATE NOT NULL,
	CONSTRAINT Employees_EmployeeID_pk PRIMARY KEY(EmployeeID)
);

CREATE TABLE Shipments
(
ShipmentID VARCHAR2(64),
MovieID VARCHAR2(64),
Ship_Date DATE NOT NULL,
Ship_Street VARCHAR2(64) NOT NULL,
Ship_Country VARCHAR2(64) NOT NULL,
EmployeeID VARCHAR2(64),
ShipmentQuantity NUMBER(4),
  CONSTRAINT Shipments_ShipmentID_pk PRIMARY KEY(ShipmentID),
  CONSTRAINT Shipments_MovieID_fk FOREIGN KEY(MovieID)
  REFERENCES Movies(MovieID),
  CONSTRAINT Shipments_EmployeeID_fk FOREIGN KEY(EmployeeID)
  REFERENCES Employees(EmployeeID)
);

CREATE TABLE Inventory
( 
InventoryID varchar2(64), 
ShipmentID VARCHAR2(64),
MovieID varchar2(64),

  CONSTRAINT Inventory_InvId_fk PRIMARY KEY (InventoryID),
  CONSTRAINT Inventory_ShipID_fk FOREIGN KEY (ShipmentID)
             REFERENCES Shipments (ShipmentID),
  CONSTRAINT Inventory_MovieID_fk FOREIGN KEY (MovieID)
             REFERENCES Movies (MovieID)
        
);

CREATE TABLE Rentals
(
RentalID VARCHAR2(64),
CustomerID VARCHAR2(64),
EmployeeID VARCHAR2(64),
InventoryID VARCHAR2(64),
Date_Rented DATE NOT NULL,
Return_Date DATE NOT NULL,
Price Number(6,2),
SpecialID VARCHAR2(64),
Paid Number(6,2),
Returned CHAR(1),
  CONSTRAINT Rentals_RentalID_pk Primary KEY(RentalID),
  CONSTRAINT Rentals_InventoryID_fk FOREIGN KEY(InventoryID)
  REFERENCES Inventory(InventoryID),
  CONSTRAINT Rentals_CustomerID_fk FOREIGN KEY(CustomerID)
  REFERENCES StoreCustomers(CustomerID),
  CONSTRAINT Rentals_SpecialID_fk FOREIGN KEY(SpecialID)
  REFERENCES Specials(SpecialID),
  CONSTRAINT Rentals_EmployeeID_fk FOREIGN KEY(EmployeeID)
  REFERENCES Employees(EmployeeID)
);
  
  
CREATE TABLE Schedule
  (
EmployeeID VARCHAR2(64),
CheckInTime VARCHAR2(64) NOT NULL,
CheckOutTime VARCHAR2(64) NOT NULL,
WorkDate DATE NOT NULL,
WeeklyHours NUMBER(4) NOT NULL,
    CONSTRAINT Hours_EmployeeId_fk FOREIGN KEY(EmployeeID)
    REFERENCES Employees(EmployeeID)
);

CREATE TABLE Credentials
(
UserID VARCHAR2(64),
Hash RAW(64) NOT NULL,
Salt VARCHAR2(64) NOT NULL,
  CONSTRAINT Credentials_UserID_pk PRIMARY KEY(Userid)
);

  CREATE TABLE RentalLog
(
LogID VARCHAR2(64),
RentalID VARCHAR2(64),
Log_Date DATE NOT NULL,
RentedOrReturned VARCHAR2(64) NOT NULL CHECK(RentedOrReturned IN('Rented', 'Returned')),
  CONSTRAINT RentalLog_LogID_Pk PRIMARY KEY (LogID),
  
  CONSTRAINT RentalLog_RentalID_fk FOREIGN KEY (RentalID)
  REFERENCES Rentals(RentalID)
);

--sequence for inventory table
CREATE SEQUENCE InventorySequence
 MINVALUE 1
  MAXVALUE 999999999999999999999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

-- trigger for when shipment is received to update inventory
 CREATE OR REPLACE TRIGGER AFTER_SHIPMENTS_INSERTORUPDATE
  AFTER INSERT OR UPDATE
  ON SHIPMENTS
  FOR EACH ROW
 DECLARE
         counter NUMBER(4) := 0;
 BEGIN
 for i in 1..:new.shipmentquantity looP
         INSERT INTO Inventory VALUES (counter || '_' ||:new.MovieID||'_'||:new.shipmentID || '_' || InventorySequence.NEXTVAL, :new.shipmentID, :new.MovieID);
         dbms_output.put_line(:new.shipmentID || ' ' || :new.MovieID || ' ' || :new.Shipmentquantity);
         counter := counter + 1;
  end loop;

  UPDATE Movies SET totalinstock = totalinstock + :new.ShipmentQuantity, totalavailable = totalavailable + :new.ShipmentQuantity WHERE MovieID = :new.MovieID;
 END;