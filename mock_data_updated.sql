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
SerialNum VARCHAR2(64) NOT NULL,
Title  VARCHAR2(64) NOT NULL,
Price NUMBER(6,2) NOT NULL,
Rating NUMBER(4),
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
(ShipmentID VARCHAR2(64), 
 MovieID VARCHAR2(64),
 TotalInStock NUMBER(4),
 TotalAvailable NUMBER(4),
  CONSTRAINT Inventory_pk PRIMARY KEY (ShipmentID, MovieID),
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
MovieID VARCHAR2(64),
SerialNumber VARCHAR2(64),
Date_Rented DATE NOT NULL,
Return_Date DATE NOT NULL,
Price Number(6,2),
SpecialID VARCHAR2(64),
Paid Number(6,2),
Returned CHAR(1),
  CONSTRAINT Rentals_RentalID_pk Primary KEY(RentalID),
  CONSTRAINT Rentals_MovieID_fk FOREIGN KEY(MovieID)
  REFERENCES Movies(MovieID),
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
Hash VARCHAR2(64) NOT NULL,
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

-- triggers to be compiled before inserts
--trigger for updating inventory if new shipment comes in
CREATE OR REPLACE TRIGGER AFTER_SHIPMENTS_INSERTORUPDATE
 AFTER INSERT OR UPDATE
 ON SHIPMENTS
 FOR EACH ROW
BEGIN

	INSERT INTO Inventory VALUES (:new.shipmentID, :new.MovieID, :new.shipmentQuantity, :new.ShipmentQuantity);
 dbms_output.put_line(:new.shipmentID || ' ' || :new.MovieID || ' ' || :new.Shipmentquantity);

END;


--2. Quantity Update � Create a trigger that automatically updates the quantity of movies in 
--stock when a film is rented or returned. 
 CREATE OR REPLACE TRIGGER AFTER_RENTALS_INSERTORUPDATE
 AFTER INSERT OR UPDATE
 ON RENTALS
 FOR EACH ROW
BEGIN
if :NEW.Returned = 0 THEN
	UPDATE Inventory SET TotalAvailable = (TotalAvailable - 1) 
	WHERE MovieID = :NEW.MovieID;
ELSIF :NEW.Returned = 1 THEN
	UPDATE Inventory SET TotalAvailable = (TotalAvailable + 1) 
	WHERE MovieID = :NEW.MovieID;
END IF;
END;


insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C522237612-5', 'Howard', 'Romero', '62-(570)630-1047', '6 Kensington Alley', 70, '269714963-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C361848077-6', 'Nicholas', 'Gibson', '7-(596)759-2953', '491 Little Fleur Street', 24, '517318433-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C211746369-X', 'Randy', 'Rose', '216-(109)965-0995', '6447 Fairview Street', 57, '582748715-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C423856923-7', 'Catherine', 'Henderson', '254-(258)710-0602', '9177 Fulton Drive', 72, '399359605-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C135888585-0', 'Walter', 'Nguyen', '86-(217)104-5286', '138 Glacier Hill Crossing', 16, '723703116-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C273893274-6', 'Karen', 'Wood', '62-(714)452-4609', '89 Almo Crossing', 97, '057019501-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C189555678-3', 'Michael', 'Chavez', '234-(262)717-1220', '5552 Hanover Pass', 79, '941007785-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C672522060-6', 'Annie', 'Hart', '381-(387)305-3209', '936 Sutteridge Plaza', 95, '746370568-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C234228970-7', 'Howard', 'Richardson', '976-(141)797-0901', '0418 Anderson Park', 66, '041991871-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C713894266-4', 'Jennifer', 'Hall', '46-(960)693-7810', '24 Almo Circle', 72, '166611740-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C119331350-3', 'Terry', 'Rodriguez', '351-(902)865-7394', '9137 Gateway Terrace', 38, '216395460-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C782706472-8', 'Jack', 'Mccoy', '93-(340)693-9992', '1 Harbort Terrace', 85, '833865611-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C252142194-4', 'Craig', 'Chavez', '86-(366)731-1613', '0 Shoshone Terrace', 84, '142455411-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C873740252-8', 'Betty', 'Marshall', '33-(390)596-3179', '749 Eagle Crest Alley', 50, '582841616-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C615839406-8', 'Eugene', 'Snyder', '57-(176)649-0262', '71 Mcbride Court', 84, '236325747-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C518065103-4', 'Marie', 'Cruz', '55-(924)994-5246', '8816 Doe Crossing Trail', 62, '464506395-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C364192265-8', 'Norma', 'Lane', '62-(385)630-6195', '46734 Golf View Terrace', 7, '457367134-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C870025721-4', 'Ralph', 'Elliott', '60-(359)262-0188', '7316 Montana Place', 65, '632169286-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C948987149-4', 'Lori', 'Burns', '86-(407)930-3257', '991 Kedzie Junction', 74, '010846495-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C159876996-0', 'Carol', 'Knight', '1-(402)278-3558', '09 Everett Place', 79, '000643294-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C054203940-0', 'Alice', 'Ross', '62-(860)420-5652', '84 Melby Center', 68, '072273004-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C296194050-8', 'Kimberly', 'Carr', '46-(441)945-7254', '7 Waubesa Drive', 86, '591144248-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C873563428-6', 'Virginia', 'Lewis', '33-(743)330-0814', '686 Bluejay Court', 77, '053441996-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C531805316-5', 'Pamela', 'Boyd', '62-(446)572-3290', '8 Harper Crossing', 29, '657087244-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C269554882-6', 'William', 'Franklin', '46-(464)241-9832', '2 Dennis Point', 69, '766852632-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C771111747-7', 'Andrea', 'Watkins', '57-(750)317-5308', '89577 Golf View Plaza', 22, '525924648-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C671005600-7', 'Evelyn', 'Armstrong', '86-(811)552-0011', '3417 Dakota Alley', 19, '090331616-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C804164352-3', 'Eric', 'Dixon', '62-(745)446-9085', '4504 Nobel Drive', 36, '101580816-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C191444733-6', 'Jane', 'Kelly', '7-(638)742-8617', '78 Cottonwood Way', 14, '574836685-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C977731203-2', 'Antonio', 'Wells', '46-(130)141-1328', '93148 3rd Trail', 86, '965508347-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C327389221-8', 'Stephen', 'Ray', '51-(233)259-3330', '15530 Fisk Avenue', 59, '238944843-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C952947635-3', 'Phillip', 'Dean', '98-(870)179-8900', '3 Thierer Hill', 4, '482258880-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C317344684-4', 'Diana', 'Watson', '7-(826)541-6988', '57298 Forest Crossing', 47, '792842867-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C803100162-6', 'Ann', 'Hamilton', '46-(612)571-2982', '337 Eliot Avenue', 25, '188515258-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C513695161-3', 'Theresa', 'Lee', '47-(855)160-6387', '678 Vahlen Trail', 16, '588939447-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C640008233-6', 'Judy', 'Hughes', '55-(508)649-7484', '5037 Bartillon Pass', 30, '392586609-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C687142059-2', 'Mildred', 'Hughes', '64-(440)959-4696', '1392 Luster Hill', 44, '417577760-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C660961331-1', 'Margaret', 'Richardson', '352-(581)991-7495', '652 Porter Avenue', 82, '519842728-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C278557631-4', 'Todd', 'Flores', '373-(739)928-0095', '938 Sunbrook Point', 89, '592062080-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C932097833-6', 'Paul', 'Snyder', '963-(934)439-8328', '146 Brentwood Junction', 88, '083867223-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C281066785-3', 'Joyce', 'Chavez', '39-(575)903-3475', '8 Utah Road', 46, '696418813-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C434513515-X', 'Jerry', 'Griffin', '86-(619)907-7995', '97109 Forster Trail', 55, '641541822-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C410820643-6', 'Clarence', 'Grant', '46-(895)113-7143', '9170 Huxley Crossing', 24, '517313991-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C499794257-X', 'Deborah', 'Sullivan', '227-(399)707-6208', '7 Del Mar Court', 68, '484188727-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C861131634-7', 'Margaret', 'Torres', '386-(322)505-6811', '11112 Rockefeller Trail', 89, '814290076-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C746167095-6', 'Daniel', 'Dunn', '48-(536)758-4284', '0 Bowman Lane', 79, '825715426-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C286651098-4', 'Michael', 'Edwards', '7-(686)221-0255', '21298 Debra Crossing', 41, '695260632-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C504204665-8', 'Harry', 'Rogers', '86-(226)799-5053', '546 Arizona Way', 29, '955148205-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C983961868-7', 'Rachel', 'Freeman', '62-(655)660-0598', '6406 Springs Drive', 21, '626096477-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C606515310-9', 'Chris', 'Robinson', '33-(566)352-1889', '73 Warner Crossing', 26, '325894191-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C615751172-9', 'Jean', 'Ryan', '81-(198)151-8053', '01 Raven Road', 56, '689156667-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C482421986-8', 'Catherine', 'Ryan', '46-(710)184-8850', '2 Shopko Hill', 18, '934801875-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C357406802-6', 'Julia', 'Henderson', '86-(575)419-3296', '09769 Texas Court', 82, '494246284-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C906581148-6', 'Gloria', 'Wells', '62-(562)748-3141', '48 Logan Road', 12, '532174937-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C140814263-5', 'Thomas', 'Howard', '86-(757)947-0966', '415 Delladonna Crossing', 6, '175403101-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C795293506-2', 'Norma', 'Lawrence', '62-(838)261-7820', '87429 Canary Way', 80, '950458813-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C349744178-3', 'Nicholas', 'Peterson', '62-(414)676-3713', '484 Monterey Pass', 74, '577494813-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C470548288-3', 'Kathryn', 'Sanchez', '62-(648)358-4802', '663 Pepper Wood Park', 63, '242677471-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C301041577-X', 'Annie', 'Burns', '62-(815)185-9811', '6148 Lighthouse Bay Terrace', 38, '730871870-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C581704571-0', 'Alice', 'Fuller', '86-(250)769-1008', '13 Manley Street', 56, '767468273-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C599952158-0', 'Antonio', 'Tucker', '48-(338)653-6944', '273 Anzinger Place', 69, '110963834-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C358747568-7', 'Paula', 'Hall', '86-(828)800-8874', '074 Marcy Road', 81, '498490285-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C495115399-8', 'Carol', 'Harvey', '389-(889)168-2004', '024 Helena Alley', 71, '087548889-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C269423160-8', 'John', 'Taylor', '63-(713)696-3123', '85429 Becker Pass', 49, '262367066-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C843967718-9', 'William', 'Garcia', '1-(808)737-0156', '70588 Stephen Junction', 36, '334032178-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C549888495-8', 'Joe', 'Carr', '30-(585)190-2155', '06424 Anthes Hill', 2, '586366747-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C443983224-5', 'Amy', 'Ford', '86-(231)276-7207', '70 Waxwing Parkway', 42, '755657870-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C308370348-1', 'Sandra', 'Little', '255-(106)813-4183', '3 Arkansas Pass', 87, '638086384-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C877614175-6', 'Nicholas', 'Bishop', '92-(994)329-0034', '28157 Green Court', 8, '422363851-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C599672040-X', 'Sarah', 'Gordon', '7-(377)723-8965', '89597 7th Park', 10, '047855144-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C791862923-X', 'Carlos', 'Harris', '86-(521)873-2278', '309 Veith Plaza', 61, '781482674-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C592711443-1', 'Roy', 'Davis', '92-(591)195-7532', '624 Chive Junction', 11, '932083415-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C701059223-3', 'Billy', 'Reid', '358-(827)432-0813', '6551 Dexter Park', 28, '270589192-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C913229046-2', 'Paul', 'Romero', '880-(484)287-5915', '6233 Merchant Park', 65, '055522977-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C536477622-0', 'Tina', 'Coleman', '961-(288)567-5190', '2 Gale Parkway', 19, '511262522-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C168512298-1', 'Walter', 'Hawkins', '44-(484)747-3785', '24 Mayer Parkway', 62, '420771836-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C777329948-X', 'Tammy', 'Medina', '591-(251)999-3537', '2201 Farragut Terrace', 20, '175503063-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C864270237-0', 'Paula', 'Gordon', '27-(620)238-8024', '29 Kim Court', 98, '924169651-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C188720714-7', 'Justin', 'Phillips', '86-(250)493-8269', '33571 Carberry Trail', 41, '168217803-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C224872788-7', 'John', 'Medina', '383-(435)939-6129', '429 Northport Center', 14, '643776829-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C268493236-0', 'Cheryl', 'Morgan', '7-(844)635-1626', '88 Village Green Street', 64, '393624540-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C848231972-8', 'Eugene', 'Jackson', '7-(550)126-5867', '6 East Way', 74, '351669639-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C803415644-2', 'Earl', 'Carter', '66-(302)213-9406', '475 Division Trail', 3, '202453967-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C558876904-X', 'Dennis', 'Scott', '52-(418)799-7306', '84328 Meadow Ridge Plaza', 38, '828591707-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C683893557-0', 'Cheryl', 'Simpson', '242-(934)515-2565', '879 Carpenter Way', 93, '487013549-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C360497664-2', 'Cheryl', 'Rose', '374-(848)883-3457', '8287 Killdeer Park', 94, '851647443-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C664001803-9', 'Edward', 'Robertson', '7-(171)918-0687', '86 Pawling Street', 47, '552554559-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C126346524-2', 'Amy', 'Fowler', '251-(887)504-4606', '96 Sundown Drive', 23, '049912720-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C449581623-3', 'Billy', 'Morris', '63-(179)211-7993', '4707 Spenser Street', 63, '050897950-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C447267850-0', 'Julia', 'Green', '86-(237)308-3460', '9235 Onsgard Crossing', 3, '485879901-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C890716743-5', 'Shirley', 'Cooper', '86-(522)789-4235', '0798 Chive Junction', 66, '906763832-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C248065013-8', 'Albert', 'Nguyen', '1-(538)586-1908', '61440 Monterey Way', 30, '907044956-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C780207949-7', 'Chris', 'Hayes', '62-(369)952-4056', '26 Farwell Hill', 60, '358491703-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C154620175-0', 'Eric', 'Andrews', '55-(306)318-9391', '5 Sheridan Trail', 52, '367680205-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C666947613-2', 'Roy', 'Morales', '86-(519)720-7752', '03158 Havey Plaza', 89, '336684526-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C059547233-8', 'Harry', 'Price', '86-(998)537-7811', '0 Donald Hill', 77, '879222329-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C549050937-6', 'Janice', 'Porter', '63-(667)315-7275', '46 Clemons Junction', 14, '931843648-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C594043164-X', 'Brenda', 'Ramos', '62-(641)370-8932', '2 Killdeer Pass', 51, '902687967-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C426867651-1', 'Harry', 'Moreno', '7-(326)480-2700', '90266 Stone Corner Trail', 84, '626483753-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C394147458-8', 'Jessica', 'Kennedy', '351-(972)538-3523', '3054 Knutson Alley', 39, '322213861-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C438927095-8', 'Sarah', 'Banks', '355-(409)251-4093', '64841 Esch Avenue', 35, '210288067-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C160611637-1', 'Andrea', 'Payne', '256-(768)999-9508', '5924 Eastlawn Park', 85, '753761697-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C518750529-7', 'Deborah', 'Simpson', '86-(648)783-9280', '58435 Manley Road', 83, '276466773-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C418493767-5', 'Louis', 'Tucker', '86-(434)907-8147', '53 Lunder Terrace', 95, '780639552-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C306098715-7', 'Amy', 'Ford', '54-(402)792-5416', '823 Hazelcrest Center', 77, '556221017-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C912528111-9', 'Earl', 'Warren', '86-(278)362-7101', '3639 Nobel Parkway', 17, '876030603-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C929809562-7', 'Christine', 'Boyd', '386-(128)191-2983', '8628 Washington Road', 99, '073215344-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C502074574-X', 'Beverly', 'Long', '30-(264)510-5338', '56630 Dryden Parkway', 39, '984755264-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C076106423-0', 'Walter', 'Diaz', '84-(578)468-2250', '705 Oriole Court', 25, '374121254-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C511660640-6', 'Donald', 'Grant', '62-(978)670-0336', '8 Sycamore Point', 6, '083112887-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C961255007-7', 'Dorothy', 'Simmons', '355-(940)420-2813', '015 Hayes Street', 83, '253172885-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C768954622-6', 'Catherine', 'Rogers', '62-(294)452-1368', '89 Mallory Street', 77, '161998791-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C525301901-4', 'Lisa', 'Morales', '54-(885)778-3375', '954 Hoard Point', 16, '283612494-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C970333223-4', 'Gary', 'Vasquez', '86-(258)693-1018', '51498 Gina Alley', 44, '803656785-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C166055920-0', 'Diana', 'Turner', '7-(597)197-2234', '39 Melody Avenue', 15, '551494029-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C543576592-7', 'Larry', 'Nichols', '963-(360)426-8361', '3884 Kim Hill', 66, '975842639-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C986107168-7', 'Mildred', 'Russell', '353-(712)701-1362', '1592 Sullivan Trail', 24, '785003668-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C942674614-5', 'Jonathan', 'Perry', '374-(161)679-8046', '1 Leroy Crossing', 49, '030354396-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C499030525-6', 'Christina', 'Hamilton', '62-(768)708-3199', '2834 Westerfield Street', 10, '474309229-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C982557837-8', 'Kelly', 'Banks', '967-(445)556-5610', '434 Vera Hill', 95, '866480163-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C513350671-6', 'Emily', 'Stephens', '47-(849)182-6840', '484 Ridgeway Junction', 33, '183546621-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C675333498-X', 'Robin', 'Diaz', '1-(422)201-0502', '19 Sachtjen Road', 85, '852010988-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C834830420-7', 'Karen', 'Parker', '963-(480)803-0177', '739 Grasskamp Place', 47, '020655132-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C339389051-4', 'Gloria', 'Allen', '86-(347)391-8961', '8 Erie Trail', 8, '926851165-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C061513347-9', 'Louise', 'Montgomery', '55-(612)818-6678', '345 Ruskin Avenue', 35, '861643174-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C365112411-8', 'Sarah', 'Powell', '976-(774)184-6633', '4 Dakota Crossing', 10, '981293616-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C911710484-X', 'Ruby', 'Campbell', '352-(942)208-1103', '42725 Independence Terrace', 63, '458219546-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C598000707-5', 'Edward', 'Bennett', '98-(361)146-7904', '0851 Scofield Pass', 21, '562476235-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C156116719-3', 'Margaret', 'Adams', '389-(826)715-1900', '37929 Cody Trail', 94, '803424249-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C107332795-7', 'Samuel', 'Wallace', '234-(635)690-7549', '27 Myrtle Crossing', 90, '308399524-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C396174556-0', 'Juan', 'Gray', '850-(577)397-6737', '91 Monument Plaza', 15, '572173177-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C714091576-8', 'Kenneth', 'Daniels', '55-(320)725-7858', '62368 Weeping Birch Lane', 76, '842471723-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C146182182-7', 'Ruth', 'Knight', '62-(275)998-3740', '91043 1st Drive', 85, '915793362-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C804560063-2', 'Jonathan', 'Hicks', '972-(440)834-6162', '7 Northwestern Place', 19, '446991544-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C532804591-2', 'Rebecca', 'Stevens', '63-(512)934-2380', '1746 Grover Hill', 25, '738420274-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C482564899-1', 'Ryan', 'Robinson', '52-(365)286-2220', '1267 Darwin Parkway', 53, '226339886-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C675475892-9', 'Kathryn', 'Bowman', '351-(451)409-1174', '7 Green Terrace', 25, '908199955-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C463594491-3', 'Phyllis', 'Lawson', '963-(424)897-4606', '85752 Derek Drive', 37, '697962813-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C291096080-3', 'Sandra', 'Jacobs', '998-(801)456-3313', '0918 Melvin Street', 42, '172189343-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C805363639-X', 'Janice', 'Ramirez', '57-(452)163-7784', '9225 Hazelcrest Alley', 10, '330261076-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C654323015-0', 'Katherine', 'Reid', '358-(239)891-0587', '6 Harper Park', 81, '949972075-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C536020622-5', 'Ryan', 'Foster', '84-(486)541-8879', '99 Arrowood Point', 90, '951836559-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C724083550-2', 'Doris', 'Ward', '86-(710)516-2834', '0395 Hanson Crossing', 68, '190203348-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C138228788-7', 'David', 'Lynch', '351-(423)884-0407', '0244 Bonner Place', 75, '358584762-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C953474883-8', 'Brenda', 'Hughes', '7-(823)263-4577', '251 Stang Lane', 65, '658181980-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C050742787-4', 'George', 'Jenkins', '55-(672)280-6219', '583 Kennedy Park', 21, '864574660-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C540602232-6', 'Craig', 'Kim', '48-(105)854-2323', '8409 Kipling Court', 13, '515390559-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C576899802-0', 'Paula', 'Phillips', '46-(389)144-8299', '34 Chinook Way', 88, '170834441-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C298187680-5', 'Cynthia', 'Bryant', '86-(173)646-9216', '1 Gerald Pass', 68, '358702494-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C362404019-7', 'Katherine', 'Wright', '963-(681)114-8078', '08 Esch Drive', 57, '861050475-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C553044041-X', 'Nancy', 'Nichols', '48-(563)176-4297', '12 Bay Crossing', 72, '763843130-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C589130718-9', 'Mark', 'Porter', '7-(767)612-5963', '9 Hudson Crossing', 22, '122945322-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C136594850-1', 'Nancy', 'Ferguson', '7-(643)980-3608', '197 Havey Road', 16, '867148003-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C397201820-7', 'Shawn', 'Mendoza', '86-(482)825-5192', '6881 Sauthoff Circle', 28, '751435351-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C644216238-9', 'Heather', 'Cooper', '86-(762)464-0418', '3 Cherokee Way', 6, '797718104-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C684939908-X', 'Richard', 'Perry', '86-(768)318-8971', '68 Chive Court', 92, '736889227-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C473498538-3', 'Nancy', 'Hart', '98-(483)940-8304', '5 Fallview Point', 85, '859508469-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C629296773-5', 'Randy', 'Morrison', '86-(887)117-6326', '70 Maple Park', 68, '454511807-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C208927738-6', 'Stephen', 'Reid', '380-(278)467-4974', '5 Delaware Circle', 74, '391223734-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C570695682-0', 'Anna', 'Kim', '62-(817)741-8142', '6522 Pine View Drive', 94, '360891265-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C235216186-X', 'Jane', 'Bailey', '7-(465)159-6784', '08601 Pleasure Way', 45, '772613888-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C478891835-8', 'Kelly', 'Lee', '55-(766)953-8003', '01382 Anhalt Street', 15, '797446543-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C372787239-X', 'Craig', 'Wilson', '351-(891)306-9072', '84 Grasskamp Center', 7, '022870899-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C177104028-9', 'Frank', 'Green', '351-(803)568-5476', '1392 Hansons Place', 76, '953890135-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C459160279-6', 'Ann', 'Evans', '63-(172)343-2616', '2903 Anzinger Pass', 23, '816616998-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C641404686-8', 'Ronald', 'Jenkins', '63-(942)649-0240', '16167 Novick Parkway', 20, '138892271-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C232406616-5', 'Raymond', 'Ferguson', '504-(987)587-6942', '4 Crownhardt Pass', 44, '077978145-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C148213293-1', 'Christopher', 'Elliott', '86-(929)729-7421', '7 Surrey Street', 57, '024743734-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C691283941-X', 'Keith', 'Diaz', '55-(857)396-5988', '85037 Clarendon Crossing', 88, '942344445-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C114669799-6', 'Roy', 'Jacobs', '387-(934)937-1025', '15958 Main Crossing', 12, '476086270-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C402315200-5', 'George', 'Boyd', '380-(536)259-5158', '14059 Debra Way', 48, '380749325-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C029393940-3', 'Michelle', 'Fuller', '86-(213)491-4026', '86 Mcguire Crossing', 58, '580068779-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C313850254-7', 'Virginia', 'Harrison', '86-(302)987-5177', '99857 Monterey Crossing', 72, '121584959-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C256536146-7', 'Tina', 'White', '1-(213)189-6188', '52 Graedel Crossing', 82, '364712994-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C133845368-8', 'Kathy', 'Reid', '66-(887)986-9682', '9160 Bluestem Junction', 19, '276750909-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C308677873-3', 'Donald', 'Hernandez', '62-(168)640-2131', '43 Atwood Street', 17, '704281899-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C099500072-7', 'Douglas', 'Graham', '86-(614)691-7253', '3 Sauthoff Junction', 52, '630361997-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C249738070-8', 'Douglas', 'Miller', '86-(658)122-3829', '8800 Colorado Parkway', 55, '461870177-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C507440314-6', 'Todd', 'Bradley', '51-(522)776-0892', '75 Blaine Street', 78, '904156462-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C150102559-7', 'Martin', 'Rose', '86-(902)989-3072', '29077 La Follette Center', 96, '629386510-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C070202692-1', 'Terry', 'Tucker', '1-(334)468-8246', '21 Banding Parkway', 17, '140861833-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C590388366-4', 'Judy', 'Wood', '242-(923)360-2888', '33 Prairieview Hill', 19, '766382379-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C719296075-6', 'Julia', 'Jackson', '7-(428)283-8105', '97044 Trailsway Court', 91, '990054274-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C208603811-9', 'Stephen', 'Jordan', '86-(306)527-5860', '6 Artisan Terrace', 100, '987053164-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C445676974-2', 'Louis', 'Miller', '505-(354)767-8017', '0 Summer Ridge Alley', 62, '769300984-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C126655659-1', 'Marie', 'Alexander', '386-(109)359-1514', '82813 Bluestem Road', 20, '729744916-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C615028275-9', 'Marilyn', 'Walker', '86-(977)228-2516', '01 Texas Point', 66, '362547339-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C258344148-5', 'Janice', 'Duncan', '86-(688)602-7418', '7 Bunker Hill Trail', 24, '470559798-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C676167311-9', 'Rose', 'Holmes', '86-(747)621-3777', '06921 Judy Pass', 86, '773473720-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C932960227-4', 'Willie', 'Stanley', '30-(615)620-9570', '0714 Truax Drive', 55, '405405290-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C090848343-0', 'Cynthia', 'Crawford', '48-(327)872-0209', '701 Mcguire Junction', 15, '020087012-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C191516309-9', 'Peter', 'Banks', '242-(352)224-8085', '0 Shoshone Junction', 41, '445241368-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C159131096-2', 'Helen', 'Robinson', '1-(232)597-9619', '4 Prentice Center', 10, '211106656-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C481664125-4', 'Gerald', 'Jordan', '234-(486)278-7349', '7 Annamark Circle', 13, '920269365-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C253524842-5', 'Dorothy', 'Bryant', '1-(473)599-5932', '62 Pawling Court', 74, '571415678-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C166937999-X', 'Nicole', 'Kim', '224-(800)641-6058', '7 Starling Avenue', 97, '619905236-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C884507170-7', 'Julie', 'Cruz', '33-(672)638-9518', '778 Lyons Plaza', 49, '144541683-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C770731586-3', 'Catherine', 'Mccoy', '81-(297)111-5320', '614 Commercial Parkway', 59, '519566486-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C901529312-0', 'Joseph', 'Graham', '62-(503)525-6795', '39 Sycamore Way', 5, '078402082-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C778770431-4', 'Deborah', 'Dean', '234-(726)931-3390', '58 Mandrake Park', 28, '091079087-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C383976538-2', 'Joseph', 'Williamson', '62-(517)489-2840', '8044 Kipling Street', 82, '768222015-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C672997395-1', 'Jerry', 'Howard', '237-(993)256-5300', '395 Bowman Alley', 12, '494835166-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C580137516-3', 'Michael', 'Cunningham', '1-(304)578-5395', '46 Oneill Park', 24, '047572177-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C705951002-8', 'David', 'Tucker', '386-(711)655-3990', '931 Porter Crossing', 59, '077039300-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C335797230-1', 'Daniel', 'Morrison', '86-(802)383-6026', '806 Caliangt Terrace', 26, '239350975-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C141248213-5', 'Roger', 'Jones', '86-(154)476-8048', '21551 Raven Park', 70, '441375424-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C918933049-8', 'Antonio', 'Willis', '48-(191)314-8076', '28874 Anthes Hill', 23, '081190566-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C798193405-2', 'Willie', 'Lynch', '420-(530)536-2760', '5 Mifflin Hill', 37, '096200443-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C474779462-X', 'Heather', 'Owens', '86-(972)642-8843', '332 Straubel Court', 8, '242852098-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C576645890-8', 'Samuel', 'Peterson', '7-(629)564-6898', '2675 Kensington Road', 41, '330328684-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C283451317-1', 'Denise', 'Wilson', '63-(194)679-5066', '9323 Jenifer Lane', 8, '302702423-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C153475750-3', 'Jennifer', 'Green', '351-(827)555-3865', '7107 Hovde Place', 75, '304473918-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C914466886-4', 'Victor', 'Wright', '62-(850)708-9674', '3 Buena Vista Terrace', 62, '167505097-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C830748827-3', 'Ruby', 'Simpson', '86-(531)377-6663', '010 Kim Lane', 86, '668497898-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C375090215-1', 'Tammy', 'Stone', '86-(433)249-4477', '80069 Swallow Way', 79, '090626912-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C762088236-7', 'Joe', 'Howard', '46-(659)881-6361', '2972 Jay Terrace', 2, '826264488-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C832582004-7', 'Billy', 'Edwards', '62-(337)919-3837', '941 John Wall Circle', 98, '925057588-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C706389741-1', 'Theresa', 'Fields', '55-(964)473-8334', '52 Butternut Pass', 93, '150239845-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C249751734-7', 'Ruth', 'Taylor', '55-(779)301-5621', '4133 Pierstorff Drive', 5, '616742916-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C516631533-2', 'Bobby', 'Wheeler', '86-(167)185-7020', '9278 Luster Lane', 7, '952383293-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C281598331-1', 'Doris', 'Cruz', '389-(536)570-2599', '085 Pleasure Road', 81, '518345410-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C459022662-6', 'Julie', 'Bishop', '48-(958)808-8349', '595 Jana Drive', 67, '962482146-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C229131481-5', 'Phillip', 'Perez', '970-(777)767-6726', '48 Randy Street', 92, '044077389-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C637715128-4', 'Clarence', 'Powell', '225-(484)511-7048', '3669 Bonner Place', 17, '197216306-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C134235124-X', 'Howard', 'Ross', '66-(660)209-0048', '46 Cardinal Court', 21, '500552844-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C601877773-8', 'Juan', 'Mccoy', '51-(333)895-1100', '9 Stone Corner Road', 92, '987302832-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C964745589-5', 'Scott', 'Gibson', '55-(807)277-0795', '03 Summer Ridge Terrace', 31, '347651905-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C911043998-6', 'Thomas', 'Kennedy', '86-(573)533-1150', '7 Rieder Center', 69, '170117473-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C797067049-0', 'Edward', 'Anderson', '976-(348)620-3928', '75094 Saint Paul Way', 28, '318932533-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C418225520-8', 'Karen', 'Russell', '62-(813)363-4978', '84320 Cottonwood Place', 61, '391966899-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C276218913-6', 'Rebecca', 'Ward', '7-(736)840-0919', '5 Sloan Plaza', 66, '004273213-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C357798904-1', 'Daniel', 'Adams', '86-(543)802-3256', '4652 Birchwood Avenue', 62, '253004055-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C920461178-2', 'Carol', 'Edwards', '51-(402)281-8512', '2579 Merry Hill', 24, '407219750-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C290858366-6', 'Fred', 'Carr', '62-(140)811-6499', '05799 Comanche Road', 49, '837619438-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C760340406-1', 'Antonio', 'Ryan', '86-(141)607-0638', '88735 Summit Crossing', 9, '750302406-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C499138087-1', 'Patricia', 'Hill', '971-(596)778-1727', '3 Crescent Oaks Junction', 80, '146950287-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C197167861-9', 'Benjamin', 'Price', '686-(399)490-2946', '12 Red Cloud Crossing', 55, '178773058-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C571053131-6', 'Wanda', 'Gray', '234-(593)484-2166', '6160 Goodland Park', 6, '269979724-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C052803759-5', 'Robin', 'Dixon', '63-(176)142-1937', '58 Mallard Plaza', 22, '996981423-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C907053107-0', 'Keith', 'Dunn', '86-(390)277-7736', '46 Graedel Center', 40, '314973333-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C506826273-0', 'Diana', 'Scott', '62-(859)232-9217', '8229 Northport Junction', 66, '490547887-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C600617417-0', 'Janet', 'Robinson', '880-(341)685-4571', '255 Farmco Street', 91, '602419381-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C536016090-X', 'Adam', 'Cooper', '62-(113)199-0897', '777 Laurel Avenue', 24, '528373895-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C320239655-2', 'Joshua', 'Harris', '55-(526)539-1778', '7 Kipling Trail', 56, '674543558-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C386178406-8', 'Juan', 'Ray', '1-(315)749-6798', '165 Hintze Circle', 7, '473265151-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C945901802-5', 'Phillip', 'Weaver', '62-(257)301-9736', '020 Killdeer Crossing', 83, '584253764-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C193294549-0', 'Phyllis', 'Harvey', '62-(978)913-1227', '217 Johnson Parkway', 53, '634864615-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C162035036-X', 'Harry', 'Day', '51-(181)346-1805', '4874 Becker Junction', 70, '124487390-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C427124953-X', 'Joshua', 'Hicks', '86-(233)477-2970', '2 Dahle Parkway', 66, '039821812-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C767497858-3', 'Laura', 'Dixon', '62-(751)620-6896', '07 Fordem Alley', 97, '675316932-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C393411915-8', 'Janice', 'Bailey', '86-(485)102-0407', '58 Elgar Pass', 53, '324113940-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C743191622-1', 'Debra', 'Burton', '81-(496)936-4726', '7041 Fordem Drive', 99, '716552352-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C601868099-8', 'Douglas', 'Cunningham', '66-(814)443-5690', '74 Meadow Valley Lane', 82, '803691808-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C106390859-0', 'Diane', 'Jones', '62-(623)553-2195', '11 Parkside Circle', 18, '569095688-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C928614366-4', 'Joshua', 'Fisher', '420-(645)701-5979', '44589 Forest Road', 69, '623231474-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C122456471-5', 'Christopher', 'Simmons', '86-(488)939-9249', '1455 Rigney Drive', 62, '832995956-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C457313960-5', 'Heather', 'Evans', '380-(459)915-7863', '56 Reindahl Drive', 96, '616347088-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C207453261-X', 'Harold', 'Fernandez', '82-(532)421-4280', '3 Anniversary Point', 99, '440408294-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C498339465-6', 'Denise', 'Weaver', '252-(248)119-2967', '2 Ilene Way', 38, '902474561-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C159109577-8', 'Bonnie', 'Meyer', '54-(471)268-3941', '1354 Ruskin Hill', 95, '498427180-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C189536142-7', 'Rebecca', 'Graham', '7-(874)144-0812', '07511 Charing Cross Way', 68, '747906596-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C773499219-6', 'Elizabeth', 'Stewart', '62-(228)630-8708', '63455 Oak Terrace', 29, '900314879-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C991093246-6', 'Raymond', 'Patterson', '380-(652)815-9340', '1791 Hazelcrest Avenue', 8, '965603788-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C003498282-5', 'Lawrence', 'Spencer', '81-(171)589-7168', '0 Prentice Pass', 33, '348491390-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C733136225-9', 'Evelyn', 'Burke', '223-(879)463-0541', '403 Lillian Crossing', 51, '726086430-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C884740611-0', 'Susan', 'Hunter', '380-(843)457-4889', '4448 Loeprich Point', 1, '384357030-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C726259005-7', 'Bruce', 'Cox', '86-(631)490-1634', '8026 Orin Court', 17, '800938996-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C870169513-4', 'Jeremy', 'Hernandez', '63-(266)545-6391', '71025 Chive Place', 47, '652504778-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C615704991-X', 'Aaron', 'Scott', '351-(445)230-5915', '429 Granby Junction', 92, '657939808-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C642058229-6', 'Jennifer', 'Moore', '86-(294)866-7161', '937 Service Point', 33, '619484488-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C257939284-X', 'Anne', 'Jones', '358-(754)924-5224', '43025 Arizona Point', 72, '155339479-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C046081390-0', 'Diana', 'Hill', '62-(380)319-5921', '7 Shasta Plaza', 88, '027542386-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C155061473-8', 'Joan', 'Hayes', '55-(393)121-0259', '93 Longview Junction', 74, '302721236-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C582021683-0', 'Philip', 'Moore', '355-(587)282-6276', '961 Nevada Park', 32, '463563800-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C293039350-5', 'Walter', 'Watson', '30-(501)433-5121', '518 Straubel Junction', 89, '959602015-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C484860938-0', 'Lisa', 'Peters', '994-(733)108-5251', '41481 Corry Plaza', 2, '827883706-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C269726622-4', 'Deborah', 'Rivera', '976-(399)821-8185', '4 Talmadge Terrace', 80, '626384138-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C262224689-7', 'Carol', 'Stanley', '62-(404)532-3516', '083 Dayton Hill', 56, '017610611-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C098445281-8', 'Rachel', 'Richards', '86-(641)719-9136', '6364 Del Mar Terrace', 41, '231315700-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C947374643-1', 'Brenda', 'Hill', '86-(870)706-4065', '57325 Lighthouse Bay Parkway', 51, '711989718-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C457271229-8', 'Bobby', 'Brown', '86-(482)347-2670', '08980 Sugar Parkway', 23, '565048516-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C050594040-X', 'Chris', 'Frazier', '961-(428)641-1083', '8581 Rieder Plaza', 97, '119915653-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C487418170-8', 'Emily', 'Howard', '1-(760)898-2612', '446 Russell Circle', 51, '907946267-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C286538643-0', 'Todd', 'Smith', '351-(176)614-8730', '51552 Ridge Oak Junction', 90, '226308074-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C222409212-1', 'Phillip', 'Evans', '504-(502)873-1935', '31 Shopko Terrace', 62, '013943952-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C245029550-X', 'Donna', 'Garcia', '55-(523)917-9203', '5 Orin Road', 13, '626041547-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C614055106-4', 'Jeremy', 'Jenkins', '505-(647)950-0507', '8463 Rockefeller Avenue', 83, '001199538-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C584416139-4', 'Daniel', 'Lewis', '66-(996)711-3314', '35 Kropf Avenue', 34, '339853629-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C347917756-5', 'Dennis', 'Evans', '62-(676)133-2635', '7751 Express Center', 9, '092879821-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C989527746-6', 'Bonnie', 'Holmes', '52-(916)160-9360', '96283 Southridge Crossing', 60, '101943505-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C789610663-9', 'Evelyn', 'Franklin', '1-(573)562-6714', '33528 Cody Alley', 2, '698589754-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C842709380-2', 'Jessica', 'Scott', '62-(401)958-5868', '1851 Kenwood Avenue', 81, '569970276-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C450756592-8', 'Jesse', 'Thompson', '62-(903)170-1756', '470 Blackbird Avenue', 68, '956529409-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C731471040-6', 'Joyce', 'Phillips', '7-(148)205-9765', '332 Brown Junction', 23, '543682747-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C450027082-5', 'George', 'Gilbert', '81-(492)269-9744', '008 Onsgard Point', 9, '657755766-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C907510818-4', 'Stephen', 'Armstrong', '46-(958)689-4663', '6850 Kensington Drive', 23, '590302172-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C818508692-3', 'Maria', 'Price', '86-(208)127-3017', '7 Graedel Avenue', 7, '899327384-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C317312854-0', 'Deborah', 'Fox', '357-(510)352-5812', '02 Maryland Crossing', 4, '966941664-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C762528717-3', 'Juan', 'Hunt', '62-(449)729-8719', '802 Hallows Pass', 37, '458686160-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C219142403-1', 'Rachel', 'Brown', '7-(983)764-3600', '1697 Menomonie Point', 74, '843136639-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C586129810-6', 'Susan', 'Stephens', '98-(644)751-7639', '585 Sutherland Way', 33, '634033001-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C802247287-5', 'Ralph', 'Perkins', '63-(377)347-2200', '8 Eggendart Place', 35, '407921132-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C909116449-2', 'Christina', 'Morgan', '234-(127)509-7932', '996 Thierer Junction', 37, '784718494-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C671761310-6', 'Martha', 'Scott', '55-(871)471-0028', '9 Elgar Center', 56, '576841836-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C272470586-6', 'Justin', 'Hill', '1-(325)770-4525', '7 Lunder Trail', 32, '622995696-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C734002980-X', 'Timothy', 'Carpenter', '86-(631)493-9060', '9279 Clemons Junction', 77, '313711532-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C307961945-5', 'Paul', 'Meyer', '46-(140)990-1718', '91 Stephen Place', 50, '263197238-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C037818015-0', 'Timothy', 'Willis', '7-(845)908-3388', '6740 Melrose Circle', 97, '024450472-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C401883632-5', 'Jonathan', 'Young', '62-(946)283-8729', '3057 Bunting Trail', 62, '721642100-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C643754883-5', 'Mary', 'Hunter', '855-(122)368-6711', '27 Karstens Terrace', 67, '913286617-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C037210367-7', 'Jennifer', 'Garrett', '86-(404)538-9065', '88 Emmet Way', 53, '110100912-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C845290303-0', 'Julia', 'Patterson', '66-(488)549-0294', '1071 Becker Plaza', 82, '935859813-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C132082981-3', 'Adam', 'Riley', '7-(671)939-2060', '77310 Reindahl Plaza', 75, '986759212-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C371848248-7', 'Mary', 'Pierce', '1-(806)730-2069', '2 Carpenter Crossing', 69, '466764086-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C537611489-9', 'Carol', 'Williamson', '48-(996)697-8972', '6786 Duke Lane', 35, '618994938-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C577721198-4', 'Elizabeth', 'Fisher', '86-(699)227-2113', '71561 Cambridge Alley', 50, '073757450-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C631410870-5', 'Timothy', 'Gordon', '86-(912)360-0260', '241 Jana Pass', 30, '713164695-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C645230759-2', 'Beverly', 'Black', '86-(364)904-5522', '29 Johnson Terrace', 18, '684236292-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C256594097-1', 'Peter', 'Kim', '46-(928)585-7806', '33417 Clarendon Avenue', 62, '455041242-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C335592218-8', 'Linda', 'Ramirez', '420-(126)190-3375', '4342 Monterey Road', 73, '344999780-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C584430835-2', 'Pamela', 'Tucker', '420-(917)859-4976', '408 Kenwood Way', 64, '353276441-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C592808087-5', 'Timothy', 'West', '66-(469)742-1866', '9 Florence Pass', 48, '415151795-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C629107030-8', 'Keith', 'Stanley', '380-(759)629-6440', '4 Dayton Pass', 27, '684677721-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C873929130-8', 'Alan', 'Nichols', '269-(470)286-7193', '080 Basil Park', 8, '330325505-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C107266201-9', 'Ashley', 'Powell', '53-(876)659-2544', '18325 Dayton Alley', 29, '283362480-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C179703094-9', 'Samuel', 'Robertson', '371-(864)290-8701', '47802 Roth Center', 99, '752920044-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C614638647-2', 'Catherine', 'Armstrong', '86-(236)179-0156', '331 Drewry Place', 35, '944810052-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C587799636-3', 'Lillian', 'Nelson', '86-(717)964-7765', '90919 Granby Plaza', 12, '777670925-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C651262824-1', 'Sean', 'Ruiz', '380-(466)823-1436', '9 Utah Junction', 21, '295893724-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C650005514-4', 'Stephen', 'Watkins', '46-(488)791-0634', '4188 Mccormick Place', 15, '706411409-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C455987663-0', 'Martha', 'Garcia', '63-(963)249-1449', '37523 6th Avenue', 31, '119634305-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C839454446-0', 'Phyllis', 'Riley', '86-(546)339-3231', '5 Northland Trail', 84, '446263755-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C480184712-9', 'Mark', 'Harvey', '33-(631)608-6547', '6903 Havey Junction', 83, '763177469-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C026927131-7', 'Kelly', 'Wagner', '386-(377)392-2845', '912 Prentice Drive', 80, '865408403-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C132726255-X', 'Jeremy', 'Pierce', '54-(631)466-9096', '489 Eastwood Crossing', 13, '280963549-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C366803420-6', 'Diane', 'Franklin', '86-(352)255-0906', '45 Rutledge Crossing', 3, '656709972-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C826190841-0', 'Marilyn', 'Fuller', '62-(488)865-9245', '06 Cascade Court', 4, '389147739-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C439543135-6', 'Christine', 'Tucker', '57-(474)598-1329', '3 Hoffman Lane', 31, '167144476-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C125272371-7', 'Barbara', 'Fields', '505-(520)687-4161', '923 Buena Vista Pass', 20, '979174640-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C338242426-6', 'Margaret', 'Romero', '1-(260)600-3058', '6 Bunker Hill Trail', 99, '365380680-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C311288263-6', 'Robin', 'Burns', '63-(771)449-4411', '672 Rutledge Parkway', 41, '242507846-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C858356500-7', 'Ralph', 'White', '7-(302)839-0453', '603 Fairfield Avenue', 67, '318569160-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C439319951-0', 'Roger', 'Hawkins', '81-(717)422-0516', '5718 Alpine Way', 64, '939543732-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C767507872-1', 'Margaret', 'Hanson', '55-(340)130-0638', '09 Loeprich Parkway', 16, '663360323-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C908059804-6', 'Willie', 'Fernandez', '86-(902)862-6025', '2926 Haas Park', 41, '804902127-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C347643579-2', 'Paul', 'Fuller', '30-(305)484-5793', '94 Melody Court', 27, '622276502-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C044166064-9', 'Bruce', 'Gonzales', '420-(160)272-7081', '8253 Almo Street', 29, '079651006-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C241965074-3', 'Heather', 'Adams', '7-(397)151-3827', '853 Parkside Park', 33, '565896823-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C996787291-8', 'Edward', 'Baker', '351-(421)770-6116', '9370 Emmet Place', 83, '226663059-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C019550007-5', 'Robin', 'Wilson', '46-(578)516-8270', '228 Warrior Parkway', 2, '891294848-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C747897752-9', 'Keith', 'Ruiz', '7-(867)338-3237', '0 Rowland Parkway', 7, '401106944-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C592765407-X', 'Marilyn', 'Wallace', '255-(830)403-2091', '6 Center Avenue', 17, '584076366-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C648937620-2', 'Nancy', 'Gomez', '972-(272)761-9342', '23 Lighthouse Bay Park', 9, '629463424-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C859366595-0', 'Juan', 'Ortiz', '86-(526)369-5556', '7 Nova Crossing', 60, '706927448-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C976700849-7', 'Brandon', 'Wilson', '63-(600)517-2476', '4324 Westend Avenue', 79, '281294695-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C094122131-8', 'Phillip', 'King', '63-(504)275-2786', '2 Village Crossing', 5, '676470625-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C921229127-9', 'Jonathan', 'Gutierrez', '7-(660)756-9435', '3 Nancy Terrace', 92, '629911848-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C366469859-2', 'Pamela', 'Bailey', '502-(444)440-3895', '5 Londonderry Plaza', 90, '318607767-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C364295527-4', 'Theresa', 'Carr', '7-(616)909-8722', '294 Fuller Park', 2, '834843146-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C257843186-8', 'Gerald', 'Kelley', '63-(827)487-4528', '50493 Riverside Terrace', 25, '761650257-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C722628403-0', 'Tina', 'Morrison', '62-(756)771-3908', '528 Reindahl Pass', 14, '512004859-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C709744370-7', 'Roger', 'Collins', '62-(447)465-0919', '1 Melby Park', 88, '492584789-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C478271970-1', 'Beverly', 'Mccoy', '62-(139)902-7704', '39546 Golden Leaf Circle', 1, '048169671-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C236761301-X', 'Rose', 'Alexander', '86-(956)764-1293', '7187 Stone Corner Way', 66, '033938162-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C046472749-9', 'Gary', 'Sanders', '63-(538)919-0292', '73 Sommers Street', 2, '836701410-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C994508300-7', 'Ralph', 'Gonzales', '84-(945)722-7817', '6 Doe Crossing Trail', 85, '192345582-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C572555535-6', 'Norma', 'Burke', '1-(312)101-9079', '1168 Dunning Court', 100, '049700398-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C920606856-3', 'Theresa', 'Shaw', '81-(602)471-1498', '797 Aberg Court', 27, '211066619-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C394382743-7', 'Pamela', 'Evans', '974-(590)250-5876', '9592 Emmet Trail', 86, '803728956-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C418030514-3', 'Ruth', 'Watkins', '93-(799)479-5056', '71275 Schmedeman Trail', 18, '172250031-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C237924138-4', 'Sara', 'Jackson', '216-(393)284-4527', '239 Kingsford Center', 83, '940498902-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C968979272-5', 'Nicholas', 'Perry', '63-(733)760-9840', '5 Sunbrook Court', 73, '934304264-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C917884229-8', 'Carl', 'Adams', '66-(558)410-5505', '2375 Utah Pass', 56, '888478131-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C010675083-6', 'Anna', 'Hamilton', '260-(802)571-5888', '13218 Thompson Center', 77, '928736656-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C902499792-5', 'Susan', 'Crawford', '994-(717)587-9075', '74 Ilene Alley', 48, '622502045-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C445724090-7', 'Andrea', 'Simmons', '86-(738)630-3350', '58 Di Loreto Hill', 67, '154956296-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C321986033-8', 'Judy', 'Hart', '351-(838)529-4158', '47273 Darwin Crossing', 50, '832808774-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C659518217-3', 'Debra', 'Cunningham', '506-(343)880-1591', '31 Dryden Place', 92, '989569389-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C998455409-0', 'Edward', 'Lawson', '86-(376)745-3888', '29 Mcguire Hill', 13, '210110961-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C846981172-X', 'Albert', 'Schmidt', '63-(182)953-3354', '357 Cambridge Lane', 91, '201846469-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C119316045-6', 'Carol', 'Wood', '62-(506)205-4834', '3 Oxford Avenue', 20, '347450340-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C378238272-2', 'Earl', 'Burns', '224-(102)859-0367', '76 Michigan Alley', 95, '655845209-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C005375694-0', 'Kathleen', 'Wheeler', '961-(270)711-4862', '76 Grayhawk Alley', 98, '800654934-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C394903154-5', 'Mildred', 'Cooper', '48-(281)346-5980', '1699 Badeau Drive', 83, '752275848-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C087332030-1', 'Anthony', 'Morrison', '55-(850)731-0223', '36 Arkansas Crossing', 97, '124603706-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C210154023-1', 'Diana', 'Gomez', '7-(143)361-8464', '540 Paget Lane', 94, '730030350-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C816748274-X', 'Bonnie', 'Bennett', '507-(606)192-7068', '03792 Maple Wood Way', 38, '798946285-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C628648487-6', 'Theresa', 'Cooper', '62-(121)660-8012', '967 Fair Oaks Trail', 70, '300396292-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C058213504-4', 'Wayne', 'Johnston', '976-(824)870-6133', '78377 5th Parkway', 69, '791401915-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C964927689-0', 'Philip', 'Sanders', '230-(234)594-7203', '606 Anzinger Parkway', 52, '483213820-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C799267986-5', 'Paul', 'Carpenter', '351-(198)739-7540', '0705 Dottie Lane', 27, '487136845-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C481115216-6', 'Billy', 'Long', '86-(770)633-2146', '6 Reindahl Court', 26, '170732822-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C658101866-X', 'Eric', 'Henderson', '86-(494)398-3353', '55 Ridgeview Center', 48, '955090318-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C781170917-1', 'Walter', 'Snyder', '84-(837)292-8394', '1255 Mayer Place', 85, '613791493-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C113172807-6', 'Kimberly', 'Scott', '54-(817)951-0636', '6 Starling Place', 96, '585794825-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C383925561-9', 'Louis', 'Banks', '52-(795)505-9845', '6 Killdeer Junction', 6, '290429007-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C352006591-6', 'Charles', 'Carr', '62-(208)467-6137', '93 Meadow Valley Avenue', 41, '636722319-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C396845111-2', 'Kathy', 'Gibson', '86-(776)827-1215', '63 Sheridan Court', 6, '292735584-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C468693292-0', 'Paul', 'Griffin', '86-(759)888-5784', '96 Bartelt Way', 34, '334834702-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C762065211-6', 'Eric', 'Knight', '33-(192)231-4493', '4 Crescent Oaks Terrace', 28, '370684329-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C895424180-8', 'Catherine', 'Martin', '55-(546)567-4966', '95 Warrior Avenue', 96, '370804247-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C684455938-0', 'Bruce', 'Reid', '351-(374)911-0908', '488 Emmet Avenue', 61, '892992873-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C722571918-1', 'Alan', 'Sanders', '1-(511)544-1629', '870 Carioca Plaza', 71, '882978829-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C564114968-3', 'Willie', 'Sanchez', '55-(843)609-5913', '3 Dapin Drive', 80, '420727615-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C115623396-8', 'Kenneth', 'Ward', '233-(690)991-6768', '6 Hallows Park', 8, '863814925-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C260289075-8', 'Peter', 'Barnes', '56-(879)868-8257', '19 Menomonie Center', 2, '148056614-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C649729581-X', 'Matthew', 'Cunningham', '62-(700)268-1705', '15791 Bowman Place', 6, '644962585-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C600527981-5', 'Ashley', 'Howard', '63-(370)434-5302', '416 Forster Way', 53, '980173469-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C711403882-8', 'Juan', 'Simmons', '62-(671)886-7182', '98 Commercial Trail', 2, '430587044-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C206319570-6', 'Joseph', 'Lewis', '86-(259)136-9881', '78813 Little Fleur Lane', 87, '401998011-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C906795387-3', 'Alan', 'Wallace', '86-(738)288-2016', '56693 Kinsman Place', 72, '348190316-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C851983952-5', 'Phillip', 'Harvey', '86-(175)138-4918', '5133 Merchant Trail', 36, '189174340-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C862236997-8', 'Steven', 'Nelson', '62-(681)786-1554', '743 Riverside Court', 52, '894959061-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C045815286-2', 'Bobby', 'Harvey', '63-(554)573-0789', '05 Mccormick Drive', 64, '095956743-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C767817792-5', 'Rose', 'Richards', '54-(732)473-2828', '248 Esker Parkway', 97, '411387051-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C994885091-2', 'Joan', 'Simmons', '86-(649)401-9620', '2129 Harper Parkway', 12, '771219393-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C926189084-9', 'Michael', 'Owens', '1-(915)554-5177', '6 Bultman Road', 39, '646029051-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C425010933-X', 'Joan', 'Ross', '62-(334)156-0776', '894 Butterfield Drive', 69, '619152242-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C687212428-8', 'Jason', 'Matthews', '51-(168)326-4044', '3 Fulton Circle', 89, '169342186-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C465212727-8', 'Roger', 'Daniels', '48-(649)462-4054', '5 Leroy Avenue', 74, '596892947-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C238615894-2', 'Jacqueline', 'Carter', '86-(136)173-7944', '49511 Cottonwood Parkway', 33, '997725065-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C052087893-0', 'Alan', 'Weaver', '504-(956)945-2931', '3940 Graceland Crossing', 10, '880059866-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C732510109-0', 'Judith', 'Hernandez', '1-(768)737-6695', '7 Pankratz Place', 45, '757967871-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C506056976-4', 'George', 'Lewis', '86-(234)815-0076', '4 Fuller Hill', 97, '031159456-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C625241504-9', 'Lori', 'Fields', '355-(705)792-9874', '6 Daystar Street', 25, '572948940-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C158114470-9', 'Rose', 'Shaw', '355-(260)524-0808', '6538 Lighthouse Bay Plaza', 21, '216019307-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C099701617-5', 'Kathryn', 'Owens', '63-(329)833-3350', '39 Hanson Alley', 22, '178514254-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C450905054-2', 'Kevin', 'Fields', '503-(426)545-4623', '3452 Di Loreto Terrace', 16, '981796352-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C976665713-0', 'Joan', 'Sullivan', '81-(665)752-1234', '25 Merchant Junction', 45, '723365897-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C251938073-X', 'Gary', 'Robertson', '62-(320)454-0725', '842 Corben Parkway', 59, '488918925-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C293180405-3', 'Randy', 'Burns', '55-(975)306-9375', '22149 Veith Place', 15, '213142418-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C626339413-7', 'Sandra', 'Cruz', '355-(481)158-9969', '39 Magdeline Crossing', 55, '884365529-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C979965680-X', 'Brian', 'Wood', '62-(672)129-2025', '7 Gulseth Point', 27, '112061944-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C827859022-2', 'Nicholas', 'Harris', '84-(251)153-8174', '480 Lerdahl Plaza', 65, '501514397-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C312728582-5', 'Carlos', 'Campbell', '351-(403)538-8856', '360 Buhler Place', 92, '062416996-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C088583519-0', 'Lawrence', 'Burton', '48-(840)560-1480', '0 Oneill Pass', 33, '879605901-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C121838369-0', 'Robin', 'Dixon', '355-(613)423-6306', '2846 Gulseth Crossing', 81, '922309698-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C336658615-X', 'Brian', 'Thompson', '1-(772)423-3559', '9275 Main Park', 22, '143593312-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C632421525-3', 'Thomas', 'Burke', '46-(113)542-8954', '1389 Kensington Way', 1, '693063929-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C836476915-4', 'Betty', 'Cunningham', '41-(455)912-0288', '64200 Atwood Junction', 58, '699924173-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C306567971-X', 'Charles', 'Wood', '351-(236)394-5176', '366 Namekagon Junction', 70, '759253777-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C653793167-3', 'Marilyn', 'Collins', '55-(308)178-6925', '8088 Rutledge Road', 43, '107234846-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C313946026-0', 'Sandra', 'West', '420-(367)503-5991', '24 Redwing Way', 27, '675174006-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C779447312-8', 'Jeffrey', 'Robertson', '62-(696)845-5048', '82179 Park Meadow Way', 4, '898872364-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C110415962-7', 'Susan', 'Hanson', '86-(454)224-3284', '5 Sherman Alley', 89, '284569203-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C459314167-2', 'Lois', 'Watson', '86-(941)505-9335', '7 Myrtle Pass', 85, '263017515-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C128430689-5', 'Eugene', 'Ward', '98-(635)593-1803', '22412 American Ash Street', 59, '594892091-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C529442118-6', 'Ann', 'James', '55-(512)794-4108', '847 Shelley Parkway', 47, '845496373-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C332606411-X', 'Catherine', 'Hansen', '86-(183)291-0383', '477 Mendota Alley', 76, '215697759-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C280903986-0', 'Lillian', 'Hawkins', '355-(128)757-4959', '6 Waywood Junction', 34, '658268612-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C311271154-8', 'Jacqueline', 'Shaw', '7-(216)973-9205', '5117 Golf View Junction', 92, '080920295-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C871052554-8', 'Sean', 'Armstrong', '48-(286)893-0768', '83868 Dahle Circle', 55, '984784314-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C361118161-7', 'Mark', 'Henry', '62-(771)595-2975', '417 Dixon Alley', 99, '924682487-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C677790715-7', 'Albert', 'Jenkins', '880-(848)190-2649', '27224 Lakewood Gardens Circle', 91, '555948411-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C146670207-9', 'Angela', 'Welch', '63-(543)855-2084', '4 Jana Circle', 98, '740037368-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C881532885-8', 'Joseph', 'Collins', '31-(981)824-6211', '7274 Lakewood Gardens Lane', 51, '168644481-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C191023338-2', 'Jennifer', 'Henry', '1-(505)515-1715', '3 Straubel Circle', 45, '556585011-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C481361569-4', 'Patrick', 'Castillo', '86-(773)601-2534', '8 Florence Park', 80, '366523952-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C394957852-8', 'Katherine', 'Weaver', '86-(691)150-4932', '2769 Sage Center', 21, '603164267-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C698563173-8', 'Bruce', 'Williams', '86-(175)235-4916', '34025 Paget Pass', 19, '044651091-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C410527117-2', 'Anna', 'White', '46-(704)609-2900', '962 Jana Terrace', 31, '048201426-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C200540044-0', 'Sara', 'Ellis', '86-(191)114-7357', '522 Saint Paul Alley', 5, '824627459-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C317181391-2', 'Elizabeth', 'Ruiz', '380-(453)934-8915', '1 Lukken Parkway', 82, '507639992-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C991503028-2', 'Billy', 'Porter', '86-(472)630-2854', '469 Wayridge Point', 80, '167090773-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C385448095-4', 'Jose', 'Palmer', '850-(459)631-7104', '5005 6th Junction', 6, '548502685-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C182497010-2', 'Timothy', 'Williams', '970-(912)629-1873', '074 Morrow Street', 21, '112222572-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C788996407-2', 'Tina', 'Fernandez', '81-(304)514-6831', '821 Mayfield Point', 69, '673972413-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C847137878-7', 'Judith', 'Green', '62-(101)844-4347', '6 Bluestem Pass', 11, '805093023-8');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C934986316-2', 'Jose', 'Wheeler', '7-(368)966-2701', '562 Goodland Drive', 3, '535347948-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C849647013-X', 'Tina', 'Edwards', '55-(993)330-2518', '6 New Castle Junction', 18, '576714765-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C864257172-1', 'Judith', 'Hart', '86-(419)449-5665', '4 Farwell Lane', 66, '425972438-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C316551794-0', 'Debra', 'Fisher', '62-(130)737-0707', '14 Ludington Hill', 13, '121167115-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C628325859-X', 'Elizabeth', 'Black', '86-(696)891-2975', '91654 Valley Edge Pass', 57, '632980768-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C939586603-9', 'Brandon', 'Stanley', '48-(304)737-1491', '2846 Waubesa Court', 4, '762342401-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C419770104-7', 'Steve', 'Moreno', '380-(168)901-4932', '822 Artisan Hill', 22, '261859471-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C772115884-2', 'Aaron', 'Lawrence', '95-(196)729-9657', '4 Basil Hill', 18, '631602978-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C070455050-4', 'Marilyn', 'Gibson', '62-(729)296-7292', '6081 Moulton Pass', 98, '265742450-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C428704897-0', 'Norma', 'Pierce', '977-(803)292-4514', '47550 Forest Run Way', 43, '828095060-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C972101404-4', 'Adam', 'King', '212-(452)735-6976', '3 Main Way', 6, '882882289-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C752841442-5', 'Emily', 'Warren', '55-(664)873-5011', '5112 Pleasure Center', 2, '924392537-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C337739806-6', 'Wayne', 'Lopez', '55-(530)117-3090', '235 Barnett Drive', 97, '626628638-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C381831307-5', 'Harold', 'Mills', '63-(586)701-4777', '17479 Roxbury Way', 7, '594575857-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C173802613-2', 'Melissa', 'Sims', '234-(937)829-1906', '2 Dryden Alley', 100, '613885130-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C446024280-X', 'Raymond', 'Bailey', '374-(681)137-9062', '7 Grim Parkway', 60, '005316507-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C862835209-0', 'Sara', 'Lynch', '52-(550)142-0128', '2 Colorado Terrace', 93, '661385701-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C896218106-1', 'Harold', 'Vasquez', '850-(273)180-0020', '596 Londonderry Point', 36, '013935033-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C552891455-8', 'Jimmy', 'Sims', '86-(111)903-5886', '376 Darwin Parkway', 44, '293888964-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C317735101-5', 'Mark', 'Castillo', '33-(753)424-1128', '64770 Clarendon Lane', 66, '619940623-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C854393679-9', 'John', 'Alvarez', '86-(927)322-9898', '9857 Fuller Point', 43, '733906580-6');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C202981862-3', 'Elizabeth', 'Lynch', '55-(201)793-0141', '5873 Carberry Hill', 10, '822765686-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C008605374-4', 'Robert', 'Clark', '86-(830)507-6850', '1 Briar Crest Way', 95, '253361480-7');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C311127505-1', 'Rose', 'Rodriguez', '380-(345)759-9047', '07248 Annamark Court', 14, '282324128-0');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C897066847-0', 'Kevin', 'Ferguson', '94-(742)611-0485', '6472 West Place', 45, '891022047-3');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C318493836-0', 'Bobby', 'Sanders', '86-(693)399-5101', '5729 Sheridan Drive', 58, '874685939-X');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C123081895-2', 'Ann', 'Jackson', '48-(228)785-1599', '92741 Corry Parkway', 91, '471384241-9');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C474196428-0', 'Amy', 'Oliver', '86-(241)182-4686', '652 Homewood Terrace', 76, '306640738-1');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C029263738-1', 'Patricia', 'Brooks', '86-(587)789-1831', '2215 Commercial Terrace', 6, '675793914-2');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C796420264-2', 'Annie', 'Harris', '62-(774)631-6829', '769 Mitchell Court', 67, '573584973-5');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C750924736-5', 'Theresa', 'Warren', '86-(382)967-1105', '4270 Colorado Trail', 66, '408347747-4');
insert into STORECUSTOMERS (customerid, first_name, last_name, phone_number, address, late_fees, referredby) values ('C207300516-0', 'Bonnie', 'Fox', '86-(331)278-6577', '4 Birchwood Hill', 78, '185516931-2');

--specials
insert into Specials (specialid, title, discount) values ('03-1059950', 'Konklux', 2.69);
insert into Specials (specialid, title, discount) values ('43-8426902', 'Sub-Ex', 1.54);
insert into Specials (specialid, title, discount) values ('70-5831373', 'Ventosanzap', 1.48);
insert into Specials (specialid, title, discount) values ('84-1469852', 'Zontrax', 1.15);
insert into Specials (specialid, title, discount) values ('50-4392985', 'Voyatouch', 7.18);


-- movies
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M73-8265338', '255556316-4', 'Pannier', 13.26, 10, to_date('1991-06-20', 'yyyy-mm-dd'), 'adventure', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M46-1421504', '720329589-3', 'Biodex', 9.5, 20, to_date('2009-04-30', 'yyyy-mm-dd'), 'adventure', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M97-5362702', '810417522-X', 'Tres-Zap', 6.03, 30, to_date('1999-01-25', 'yyyy-mm-dd'), 'adventure', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M76-6555137', '905235489-8', 'Alpha', 28.04, 40,to_date('2007-04-01', 'yyyy-mm-dd'), 'adventure', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M08-3281675', '557738168-1', 'Tres-Zap', 18.31, 50, to_date('2001-11-08', 'yyyy-mm-dd'), 'adventure', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M65-1698400', '621374550-5', 'Regrant', 7.96, 60, to_date('1998-04-10', 'yyyy-mm-dd'), 'adventure', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M39-9922479', '610371485-0', 'Ventosanzre', 21.19, 70, to_date('1993-07-12', 'yyyy-mm-dd'), 'adventuree', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M90-7436212', '093303497-0', 'Bitchip', 2.67, 80, to_date('2010-07-05', 'yyyy-mm-dd'), 'adventure', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M89-8454499', '632364756-7', 'Cardguardre', 10.33, 90, to_date('1996-08-01', 'yyyy-mm-dd'), 'adventure', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M51-0760472', '608230575-2', 'Konklab', 12, 100, to_date('2005-01-07', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M57-2611019', '800016413-2', 'Voyatouch', 17,33, to_date('2000-05-22', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M71-8961183', '322371254-2', 'Job', 7.3, 70, to_date('2003-01-21', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M82-5969295', '606398665-0', 'Veribet', 15.47, 13, to_date('2012-06-14', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M56-1438689', '705149134-2', 'Tresom', 10.36, 41, to_date('2002-10-08', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M01-5371873', '422056498-5', 'Kanlam', 18.11, 51, to_date('2005-02-25', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M09-5356081', '269719717-6', 'Bamity', 11.24, 61, to_date('1998-08-23', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M69-4680867', '356831810-5', 'Zoolab', 21.44, 71, to_date('2006-02-15', 'yyyy-mm-dd'), 'action', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M18-4023754', '557909751-4', 'Tampflex', 7.62, 91, to_date('1990-06-16', 'yyyy-mm-dd'), 'secondary', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M48-2852655', '370055606-3', 'Zathin', 12.78, 91, to_date('1991-01-22', 'yyyy-mm-dd'), 'science-fiction', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M78-7659141', '448774166-1', 'Tresom', 9.81, 20, to_date('2009-04-25', 'yyyy-mm-dd'), 'science-fiction', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M20-1683353', '995910234-3', 'Rank', 27.53, 21, to_date('2000-04-17', 'yyyy-mm-dd'), 'science-fiction', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M60-3604497', '300341959-5', 'Cardify', 24.26, 22, to_date('2000-05-03', 'yyyy-mm-dd'), 'science-fiction', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M02-2806400', '234643340-3', 'Wrapsafe', 21.16, 23, to_date('2010-05-11', 'yyyy-mm-dd'), 'science-fiction', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M23-8182019', '297105755-0', 'Zathin', 23.31, 24, to_date('1990-12-13', 'yyyy-mm-dd'), 'science-fiction', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M48-0086984', '864824803-5', 'Temp', 18.24, 25, to_date('1990-12-19', 'yyyy-mm-dd'), 'science-fiction', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M33-2481165', '381481336-7', 'Zaam-Dox', 15.58, 26, to_date('1992-04-29', 'yyyy-mm-dd'), 'drama', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M34-4869842', '424586565-2', 'Cardify', 2.14, 27, to_date('2006-10-31', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M93-9646714', '363960030-4', 'Lotlux',  20.05, 28, to_date('1990-07-18', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M36-2571856', '319391434-7', 'Bamity',  3.82, 29, to_date('2006-09-18', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M31-7497843', '589241912-6', 'Tres-Zap', 14.28, 30, to_date('2007-03-16', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M46-5793201', '887123919-9', 'Bigtax',  15.82, 31, to_date('1994-05-10', 'yyyy-mm-dd'), 'drama', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M14-0985497', '663191551-1', 'Keylex',  29.88, 32, to_date('2002-02-01', 'yyyy-mm-dd'), 'drama', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M92-2988013', '966514095-7', 'Mat Lam', 5.21, 33, to_date('1997-06-22', 'yyyy-mm-dd'), 'drama', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M39-3358245', '485438860-9', 'Matsoft', 20.91, 34, to_date('1994-06-26', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M48-7669569', '101767690-9', 'It', 7.22, 35, to_date('2011-12-26', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M67-4391442', '113895041-6', 'Otcom', 8, 36, to_date('2005-10-20', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M81-6585139', '353963437-1', 'Konklab', 29.57, 37, to_date('2013-02-10', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M36-9793769', '362221644-1', 'Mat Lam', 3.62, 38, to_date('2007-04-03', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M78-7359446', '759585748-1', 'Bamity', 18.19, 39, to_date('1989-06-30', 'yyyy-mm-dd'), 'drama', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M45-7004821', '317622199-1', 'Andalax', 5.44, 40, to_date('2007-06-01', 'yyyy-mm-dd'), 'children', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M78-0937512', '377197422-4', 'Bitchip', 10.96, 41, to_date('2004-12-25', 'yyyy-mm-dd'), 'children', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M09-0642772', '188664515-9', 'Bitchip', 2.89, 42, to_date('2012-02-19', 'yyyy-mm-dd'), 'children', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M70-3276364', '892092501-1', 'Lotstringn', 29.91, 43, to_date('2013-04-01', 'yyyy-mm-dd'), 'children', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M31-8300561', '984870970-3', 'Holdlamisn', 18.35, 44, to_date('1995-01-29', 'yyyy-mm-dd'), 'children', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M28-2773053', '490025101-1', 'Prodder', 2.06, 45, to_date('2007-06-25', 'yyyy-mm-dd'), 'children', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M53-1117582', '781734687-9', 'Zathin', 29.51, 46, to_date('1999-02-06', 'yyyy-mm-dd'), 'children', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M65-7026091', '001156979-4', 'Quo Lux', 25.46, 47, to_date('1993-07-10', 'yyyy-mm-dd'), 'children', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M81-7770678', '873254713-7', 'Fintone', 24.46, 48, to_date('2014-02-19', 'yyyy-mm-dd'), 'children', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M23-0420959', '164340820-8', 'Fix San', 10.74, 49, to_date('2016-03-13', 'yyyy-mm-dd'), 'children', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M74-6178630', '122044568-1', 'Stronghol', 20.46, 50, to_date('2005-06-13', 'yyyy-mm-dd'), 'children', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M43-9800753', '538832647-0', 'Flexidy', 27.37, 51, to_date('2013-06-29', 'yyyy-mm-dd'), 'horror', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M12-4992827', '661028343-5', 'Sonsing', 26.12, 52, to_date('1990-01-31', 'yyyy-mm-dd'), 'horror', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M94-2441609', '271531545-7', 'Solarbree', 10.35, 53, to_date('1997-06-28', 'yyyy-mm-dd'), 'horror', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M99-4865641', '882052650-6', 'Cardguard', 8.04, 54, to_date('1997-06-15', 'yyyy-mm-dd'), 'horror', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M45-9065957', '485311448-3', 'Bytecard', 6.58, 55, to_date('2002-09-08', 'yyyy-mm-dd'), 'horror', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M34-8816328', '868337706-7', 'Konklab', 13.45, 56, to_date('1994-01-03', 'yyyy-mm-dd'), 'horror', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M40-8458604', '905302149-3', 'Fix San', 26.31, 57, to_date('1988-12-13', 'yyyy-mm-dd'), 'horror', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M88-5711898', '769243414-X', 'Regrant', 5.91, 58, to_date('1994-08-17', 'yyyy-mm-dd'), 'horror', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M41-3233780', '350197304-7', 'Tin', 8.07, 59, to_date('2014-07-04', 'yyyy-mm-dd'), 'horror', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M48-1513905', '381841511-0', 'Mat Lam', 14.9, 60, to_date('1997-10-27', 'yyyy-mm-dd'), 'romance', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M69-8004737', '624282647-X', 'Fintone', 15.03, 61, to_date('1995-05-21', 'yyyy-mm-dd'), 'romance', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M00-6730628', '963090730-5', 'Home Ing', 2.17, 62, to_date('1998-02-05', 'yyyy-mm-dd'), 'romance', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M32-4710691', '321836774-3', 'Tempsoft', 23.49, 63, to_date('1994-07-07', 'yyyy-mm-dd'), 'romance', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M19-7302803', '766374698-8', 'Y-find', 2.79, 64, to_date('1996-10-28', 'yyyy-mm-dd'), 'heuristic', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M30-5951474', '642961555-3', 'Matsoft', 17.92, 65, to_date('2008-04-28', 'yyyy-mm-dd'), 'romance', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M46-9440896', '226270990-4', 'Zoolab', 21.11, 66, to_date('2003-03-20', 'yyyy-mm-dd'), 'romance', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M49-1881582', '163270995-3', 'Overhold', 3.77, 67, to_date('1998-11-07', 'yyyy-mm-dd'), 'romance', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M58-4543126', '145043037-6', 'Temp', 24.31, 68, to_date('2014-11-04', 'yyyy-mm-dd'), 'romance', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M23-0293506', '397294268-0', 'Daltfreshr', 29.86, 69, to_date('2016-09-03', 'yyyy-mm-dd'), 'romance', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M14-4885567', '850127849-1', 'Tampflex', 21.65, 70, to_date('1993-07-13', 'yyyy-mm-dd'), 'thriller', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M77-1195753', '144865270-7', 'Hatity', 19.44, 71, to_date('1998-08-31', 'yyyy-mm-dd'), 'thriller', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M52-2565396', '179704708-6', 'Tampflex', 6.82, 72, to_date('1999-10-15', 'yyyy-mm-dd'), 'thriller', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M98-1394640', '720776691-2', 'Sonair', 24.36, 73, to_date('1988-10-30', 'yyyy-mm-dd'), 'thriller', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M20-2559365', '647512139-8', 'Alpha', 3.83, 74, to_date('1999-05-03', 'yyyy-mm-dd'), 'thriller', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M46-4644709', '045324850-0', 'Andalax',16.38, 75, to_date('1988-06-11', 'yyyy-mm-dd'), 'thriller', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M09-1412594', '850280528-2', 'Job', 23.45, 76, to_date('2012-04-15', 'yyyy-mm-dd'), 'thriller', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M17-6192947', '150430630-9', 'Ronstringr', 8.67, 77, to_date('1993-07-31', 'yyyy-mm-dd'), 'thriller', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M76-3440021', '915407661-7', 'Y-Solowarr', 7.36, 78, to_date('2002-06-03', 'yyyy-mm-dd'), 'thriller', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M99-3455230', '569560655-1', 'Kanlam', 28.98, 79, to_date('2013-08-20', 'yyyy-mm-dd'), 'thriller', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M65-6556289', '393110165-7', 'Cardguardr', 10.61, 80, to_date('2003-08-29', 'yyyy-mm-dd'), 'thriller', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M25-3195313', '823778037-X', 'Bamity', 9.19, 81, to_date('1990-12-07', 'yyyy-mm-dd'), 'thriller', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M76-1660238', '693795651-7', 'Latlux', 15.51, 82, to_date('2000-04-23', 'yyyy-mm-dd'), 'thriller', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M55-1298958', '062443627-6', 'Namfix', 4.0, 83, to_date('2005-09-10', 'yyyy-mm-dd'), 'thriller', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M16-9570895', '169750716-6', 'Stim', 17.39, 84, to_date('1989-09-06', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M16-5249908', '591011844-7', 'Greenlam', 22.83, 85, to_date('2006-06-05', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M44-3260728', '244841053-4', 'Redhold', 11.07, 86, to_date('1995-03-12', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M22-8474368', '813407537-1', 'Flowdesk', 2.62, 87, to_date('2015-06-21', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M79-0455326', '472085166-5', 'Stronghol', 5.36, 88, to_date('1993-10-01', 'yyyy-mm-dd'), 'documentary', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M59-6630546', '002287424-0', 'Opela', 21.45, 89, to_date('1991-03-02', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M78-1672860', '907291914-9', 'Kanlam', 17.58, 90, to_date('2016-08-02', 'yyyy-mm-dd'), 'documentary', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M81-4747135', '807506521-2', 'Stringtout', 16.57, 91, to_date('2012-02-25', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M25-4938632', '592254959-6', 'Ronstring', 6.7, 92, to_date('1989-07-15', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M85-6193743', '903966496-X', 'Alpha', 14.99, 93, to_date('2008-07-26', 'yyyy-mm-dd'), 'documentary', 0, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M96-5316551', '959692755-8', 'Home Ing', 27.29, 94, to_date('2014-03-18', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M36-5985588', '926127084-0', 'Stringtoutary', 6.66, 95, to_date('2010-07-12', 'yyyy-mm-dd'), 'documentary', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M54-3696177', '219002684-9', 'Viva', 10, 96, to_date('2009-01-02', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M67-5690009', '803715034-8', 'Konklab', 29.36, 97, to_date('2001-02-20', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M81-0480350', '146585097-X', 'Daltfresh', 15.95, 98, to_date('2012-06-22', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M84-0569091', '344461435-7', 'Home Ing', 29.9, 99, to_date('2015-08-20', 'yyyy-mm-dd'), 'action', 1, '03-1059950');
insert into Movies (movieid, serialnum, title, price, rating, release_date, genre, isonspecial, specialid) values ('M87-1179985', '735578602-4', 'Quo Lux', 25.22, 100, to_date('1998-09-09', 'yyyy-mm-dd'), 'action', 0, '03-1059950');


--shipments
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S1',       'M73-8265338',to_date('2017-03-14', 'yyyy-mm-dd'), '2 Dakota Way', 'Cameroon', 'E94-9771106', 16);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S2',       'M46-1421504',to_date('2016-10-01', 'yyyy-mm-dd'), '2 Eggendart Trail', 'Japan', 'E94-9771106', 21);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S3',       'M97-5362702',to_date('2016-05-07', 'yyyy-mm-dd'), '4 Continental Terrace', 'Venezuela', 'E94-9771106', 32);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S4',       'M76-6555137',to_date('2016-07-21', 'yyyy-mm-dd'), '78 Straubel Avenue', 'China', 'E94-9771106', 23);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S5',       'M08-3281675',to_date('2016-12-10', 'yyyy-mm-dd'),'1 International Road', 'Russia', 'E94-9771106', 19);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S6',       'M65-1698400',to_date('2017-01-26', 'yyyy-mm-dd'), '00 Shopko Road', 'Colombia', 'E94-9771106', 20);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S7',       'M39-9922479',to_date('2016-08-20', 'yyyy-mm-dd'), '98048 Swallow Plaza', 'Indonesia', 'E94-9771106', 41);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S8',       'M90-7436212',to_date('2017-02-28', 'yyyy-mm-dd'), '31751 New Castle Way', 'Argentina', 'E94-9771106', 34);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S9',       'M89-8454499',to_date('2016-12-10', 'yyyy-mm-dd'), '6052 Bellgrove Hill', 'Brazil', 'E94-9771106', 42);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S10',      'M51-0760472',to_date('2017-03-27', 'yyyy-mm-dd'), '67 Caliangt Plaza', 'Indonesia', 'E94-9771106', 21);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S11',      'M57-2611019',to_date('2017-01-28', 'yyyy-mm-dd'), '011 American Circle', 'Egypt', 'E94-9771106', 48);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S12',      'M71-8961183',to_date('2016-08-10', 'yyyy-mm-dd'), '75996 Corscot Hill', 'Argentina', 'E94-9771106', 39);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S13',      'M82-5969295',to_date('2016-12-04', 'yyyy-mm-dd'), '27648 Del Mar Hill', 'France', 'E94-9771106', 49);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S14',      'M56-1438689',to_date('2016-06-18', 'yyyy-mm-dd'), '8800 Stoughton Parkway', 'China', 'E94-9771106', 27);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S15',      'M01-5371873',to_date('2016-09-17', 'yyyy-mm-dd'), '0 Tony Way', 'China', 'E94-9771106', 50);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S16',      'M09-5356081',to_date('2016-05-24', 'yyyy-mm-dd'), '070 Doe Crossing Park', 'Ukraine', 'E94-9771106', 42);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S17',      'M69-4680867',to_date('2017-03-17', 'yyyy-mm-dd'), '5116 Larry Center', 'China', 'E94-9771106', 21);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S18',      'M18-4023754',to_date('2016-07-20', 'yyyy-mm-dd'), '5210 Waywood Alley', 'Philippines', 'E94-9771106', 15);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S19',      'M48-2852655',to_date('2017-02-22', 'yyyy-mm-dd'), '7 Barby Avenue', 'China', 'E94-9771106', 16);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S20',      'M78-7659141',to_date('2016-06-30', 'yyyy-mm-dd'), '1 Crownhardt Road', 'Nigeria', 'E94-9771106', 12);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S21',      'M20-1683353',to_date('2016-07-20', 'yyyy-mm-dd'), '064 Loeprich Road', 'Philippines', 'E94-9771106', 37);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S22',      'M60-3604497',to_date('2016-09-18', 'yyyy-mm-dd'),'75 Warrior Court', 'Czech Republic', 'E94-9771106', 44);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S23',      'M02-2806400',to_date('2017-03-23', 'yyyy-mm-dd'), '00852 Brentwood Road', 'Tunisia', 'E94-9771106', 46);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S24',      'M23-8182019',to_date('2016-07-22', 'yyyy-mm-dd'), '94 Parkside Plaza', 'China', 'E94-9771106', 24);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S25',      'M48-0086984',to_date('2017-01-03', 'yyyy-mm-dd'), '393 Riverside Avenue', 'United States', 'E94-9771106', 31);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S26',      'M33-2481165',to_date('2017-04-10', 'yyyy-mm-dd'), '69754 Raven Road', 'United States', 'E94-9771106', 20);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S27',      'M34-4869842',to_date('2016-09-22', 'yyyy-mm-dd'), '969 Lighthouse Bay Junction', 'China', 'E94-9771106', 48);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S28',      'M93-9646714',to_date('2016-08-30', 'yyyy-mm-dd'), '185 Kipling Circle', 'Indonesia', 'E94-9771106', 35);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S29',      'M36-2571856',to_date('2016-08-31', 'yyyy-mm-dd'), '70686 Garrison Pass', 'Albania', 'E94-9771106', 18);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S30',      'M31-7497843',to_date('2016-06-14', 'yyyy-mm-dd'), '9437 Schmedeman Plaza', 'China', 'E94-9771106', 50);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S31',      'M46-5793201',to_date('2017-03-18', 'yyyy-mm-dd'), '61793 Saint Paul Road', 'Poland', 'E94-9771106', 16);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S32',      'M14-0985497',to_date('2016-07-23', 'yyyy-mm-dd'), '97 School Park', 'Mexico', 'E94-9771106', 36);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S33',      'M92-2988013',to_date('2016-11-02', 'yyyy-mm-dd'), '7842 Swallow Street', 'Pakistan', 'E94-9771106', 24);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S34',      'M39-3358245',to_date('2016-04-27', 'yyyy-mm-dd'), '4206 Jay Center', 'Philippines', 'E94-9771106', 50);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S35',      'M48-7669569',to_date('2016-05-23', 'yyyy-mm-dd'), '96565 Anzinger Plaza', 'Vietnam', 'E94-9771106', 17);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S36',      'M67-4391442',to_date('2017-03-25', 'yyyy-mm-dd'), '969 Superior Crossing', 'Luxembourg', 'E94-9771106', 28);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S37',      'M81-6585139',to_date('2016-06-11', 'yyyy-mm-dd'), '89301 Kedzie Drive', 'Indonesia', 'E94-9771106', 31);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S38',      'M36-9793769',to_date('2016-11-02', 'yyyy-mm-dd'), '4 Rockefeller Place', 'Honduras', 'E94-9771106', 37);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S39',      'M78-7359446',to_date('2016-12-16', 'yyyy-mm-dd'), '1234 Melrose Point', 'Portugal', 'E94-9771106', 14);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S40',      'M45-7004821',to_date('2017-01-22', 'yyyy-mm-dd'), '0 Morning Alley', 'Turkmenistan', 'E94-9771106', 23);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S41',      'M78-0937512',to_date('2017-03-11', 'yyyy-mm-dd'), '73581 Miller Place', 'French Polynesia', 'E94-9771106', 28);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S42',      'M09-0642772',to_date('2017-04-01', 'yyyy-mm-dd'), '83333 Annamark Parkway', 'Russia', 'E94-9771106', 41);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S43',      'M70-3276364',to_date('2016-06-19', 'yyyy-mm-dd'), '3838 Arizona Parkway', 'Indonesia', 'E94-9771106', 48);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S44',      'M31-8300561',to_date('2017-01-17', 'yyyy-mm-dd'), '71 Westridge Crossing', 'Japan', 'E94-9771106', 41);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S45',      'M28-2773053',to_date('2017-01-12', 'yyyy-mm-dd'), '9 Dennis Plaza', 'Indonesia', 'E94-9771106', 32);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S46',      'M53-1117582',to_date('2016-07-21', 'yyyy-mm-dd'), '66645 Killdeer Drive', 'China', 'E94-9771106', 42);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S47',      'M65-7026091',to_date('2016-05-29', 'yyyy-mm-dd'), '7 Meadow Vale Street', 'Norway', 'E94-9771106', 31);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S48',      'M81-7770678',to_date('2016-11-10', 'yyyy-mm-dd'), '59407 Warner Hill', 'China', 'E94-9771106', 25);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S49',      'M23-0420959',to_date('2017-01-10', 'yyyy-mm-dd'), '21 Park Meadow Junction', 'Indonesia', 'E94-9771106', 42);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S50',      'M74-6178630',to_date('2017-01-09', 'yyyy-mm-dd'), '36 Ridgeview Parkway', 'Indonesia', 'E94-9771106', 37);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S51',      'M43-9800753',to_date('2017-02-20', 'yyyy-mm-dd'), '728 Jana Hill', 'China', 'E94-9771106', 48);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S52',      'M12-4992827',to_date('2016-11-21', 'yyyy-mm-dd'), '92049 Northfield Way', 'Greece', 'E94-9771106', 25);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S53',      'M94-2441609',to_date('2016-07-02', 'yyyy-mm-dd'),'2004 Londonderry Circle', 'Philippines', 'E94-9771106', 23);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S54',      'M99-4865641',to_date('2016-04-26', 'yyyy-mm-dd'),'66 Superior Circle', 'Greece', 'E94-9771106', 37);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S55',      'M45-9065957',to_date('2016-10-18', 'yyyy-mm-dd'),'35593 Stang Plaza', 'Nigeria', 'E94-9771106', 26);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S56',      'M34-8816328',to_date('2016-11-01', 'yyyy-mm-dd'), '0014 Waubesa Crossing', 'Serbia', 'E94-9771106', 11);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S57',      'M40-8458604',to_date('2016-12-01', 'yyyy-mm-dd'), '71768 Crescent Oaks Park', 'Netherlands', 'E94-9771106', 13);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S58',      'M88-5711898',to_date('2016-12-15', 'yyyy-mm-dd'), '4167 Maywood Center', 'Croatia', 'E94-9771106', 29);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S59',      'M41-3233780',to_date('2017-03-31', 'yyyy-mm-dd'), '1135 Crescent Oaks Parkway', 'Brazil', 'E94-9771106', 40);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S60',      'M48-1513905',to_date('2017-03-28', 'yyyy-mm-dd'),'20 Autumn Leaf Avenue', 'Indonesia', 'E94-9771106', 44);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S61',      'M69-8004737',to_date('2017-02-01', 'yyyy-mm-dd'), '4405 Bashford Avenue', 'Sweden', 'E94-9771106', 32);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S62',      'M00-6730628',to_date('2016-12-28', 'yyyy-mm-dd'), '5 Shelley Hill', 'Poland', 'E94-9771106', 16);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S63',      'M32-4710691',to_date('2016-09-20', 'yyyy-mm-dd'), '49 Susan Center', 'Indonesia', 'E94-9771106', 16);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S64',      'M19-7302803',to_date('2016-09-22', 'yyyy-mm-dd'), '56726 Londonderry Alley', 'Philippines', 'E94-9771106', 12);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S65',      'M30-5951474',to_date('2016-04-28', 'yyyy-mm-dd'), '70 Prairieview Terrace', 'China', 'E94-9771106', 27);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S66',      'M46-9440896',to_date('2017-02-01', 'yyyy-mm-dd'), '86776 Reinke Terrace', 'Indonesia', 'E94-9771106', 43);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S67',      'M49-1881582',to_date('2016-05-29', 'yyyy-mm-dd'), '414 Dryden Way', 'France', 'E94-9771106', 13);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S68',      'M58-4543126',to_date('2017-03-16', 'yyyy-mm-dd'), '5443 Rigney Hill', 'China', 'E94-9771106', 22);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S69',      'M23-0293506',to_date('2016-11-02', 'yyyy-mm-dd'), '0419 Bay Trail', 'Philippines', 'E94-9771106', 21);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S70',      'M14-4885567',to_date('2016-11-16', 'yyyy-mm-dd'),'82359 Quincy Court', 'Ukraine', 'E94-9771106', 33);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S71',      'M77-1195753',to_date('2016-09-04', 'yyyy-mm-dd'), '8 Brickson Park Lane', 'China', 'E94-9771106', 40);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S72',      'M52-2565396',to_date('2016-05-26', 'yyyy-mm-dd'), '5 Fairview Avenue', 'Germany', 'E94-9771106', 11);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S73',      'M98-1394640',to_date('2016-11-06', 'yyyy-mm-dd'), '69218 Lawn Lane', 'China', 'E94-9771106', 10);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S74',      'M20-2559365',to_date('2017-03-03', 'yyyy-mm-dd'), '339 Sundown Street', 'Indonesia', 'E94-9771106', 24);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S75',      'M46-4644709',to_date('2016-06-13', 'yyyy-mm-dd'), '04 Thackeray Point', 'United States', 'E94-9771106', 13);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S76',      'M09-1412594',to_date('2017-01-04', 'yyyy-mm-dd'), '54 Kenwood Point', 'China', 'E94-9771106', 39);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S77',      'M17-6192947',to_date('2016-09-21', 'yyyy-mm-dd'), '6860 Florence Terrace', 'Russia', 'E94-9771106', 27);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S78',      'M76-3440021',to_date('2017-02-19', 'yyyy-mm-dd'), '77 Corben Road', 'Ukraine', 'E94-9771106', 39);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S79',      'M99-3455230',to_date('2017-01-29', 'yyyy-mm-dd'), '96764 Roth Road', 'Italy', 'E94-9771106', 50);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S80',      'M65-6556289',to_date('2016-10-28', 'yyyy-mm-dd'), '361 Stoughton Plaza', 'Portugal', 'E94-9771106', 29);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S81',      'M25-3195313',to_date('2016-05-04', 'yyyy-mm-dd'), '9517 Michigan Hill', 'Brazil', 'E94-9771106', 47);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S82',      'M76-1660238',to_date('2016-11-25', 'yyyy-mm-dd'), '57828 Express Avenue', 'Indonesia', 'E94-9771106', 49);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S83',      'M55-1298958',to_date('2016-06-21', 'yyyy-mm-dd'), '36 Waywood Hill', 'Italy', 'E94-9771106', 45);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S84',      'M16-9570895',to_date('2016-12-05', 'yyyy-mm-dd'),'1883 Mifflin Circle', 'Indonesia', 'E94-9771106', 40);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S85',      'M16-5249908',to_date('2016-09-11', 'yyyy-mm-dd'), '989 Marquette Junction', 'China', 'E94-9771106', 45);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S86',      'M44-3260728',to_date('2017-03-30', 'yyyy-mm-dd'), '00 Hoffman Park', 'Finland', 'E94-9771106', 44);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S87',      'M22-8474368',to_date('2016-12-30', 'yyyy-mm-dd'),'2 Oak Junction', 'United States', 'E94-9771106', 45);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S88',      'M79-0455326',to_date('2017-03-11', 'yyyy-mm-dd'), '37 Brickson Park Court', 'Kazakhstan', 'E94-9771106', 22);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S89',      'M59-6630546',to_date('2016-11-11', 'yyyy-mm-dd'), '0985 Springview Trail', 'Poland', 'E94-9771106', 29);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S90',      'M78-1672860',to_date('2016-12-24', 'yyyy-mm-dd'), '366 Cambridge Trail', 'Greece', 'E94-9771106', 17);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S91',      'M81-4747135',to_date('2017-03-07', 'yyyy-mm-dd'),'619 Straubel Alley', 'Portugal', 'E94-9771106', 30);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S92',      'M25-4938632',to_date('2016-11-13', 'yyyy-mm-dd'),'11 Rockefeller Road', 'Ukraine', 'E94-9771106', 41);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S93',      'M85-6193743',to_date('2016-10-21', 'yyyy-mm-dd'), '4196 Kim Hill', 'Russia', 'E94-9771106', 31);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S94',      'M96-5316551',to_date('2016-04-29', 'yyyy-mm-dd'), '1691 Mockingbird Alley', 'Indonesia', 'E94-9771106', 17);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S95',      'M36-5985588',to_date('2017-01-07', 'yyyy-mm-dd'), '2 Evergreen Plaza', 'Tunisia', 'E94-9771106', 18);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S96',      'M54-3696177',to_date('2016-06-19', 'yyyy-mm-dd'), '23772 American Ash Center', 'Croatia', 'E94-9771106', 40);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S97',      'M67-5690009',to_date('2016-09-26', 'yyyy-mm-dd'), '44596 Browning Place', 'Sweden', 'E94-9771106', 39);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S98',      'M81-0480350',to_date('2017-03-29', 'yyyy-mm-dd'),'43234 Milwaukee Parkway', 'Poland', 'E94-9771106', 39);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S99',      'M84-0569091',to_date('2016-09-15', 'yyyy-mm-dd'), '2 Warrior Center', 'Indonesia', 'E94-9771106', 20);
insert into shipments (shipmentid, movieid, ship_date, ship_street, ship_country, employeeid, shipmentquantity) values ('S100',     'M87-1179985',to_date('2016-11-12', 'yyyy-mm-dd'), '74948 Manley Plaza', 'Chile', 'E94-9771106', 16);


--employees
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E02-7757423', 'E02-7757423', '1588 Scofield Avenue', 'Lawrence', 'Kennedy', '03-1059950', 'Graphical User Interface', 21815, to_date('2016-02-02', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E94-9771106', 'E02-7757423', '76 Riverside Circle', 'Fred', 'Burns', '03-1059950', 'multi-state', 7284, to_date('2005-11-28', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E57-3195113', 'E02-7757423', '5 Tony Parkway', 'Roy', 'Wood', '03-1059950', 'encryption', 3768, to_date('2005-07-25', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E83-8700712', 'E02-7757423', '3 Northport Hill', 'Ruby', 'Murray', '03-1059950', 'homogeneous', 14671, to_date('2008-04-24', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E58-4706821', 'E02-7757423', '17201 Marcy Court', 'Lillian', 'Owens', '03-1059950', 'scalable', 2313, to_date('2014-04-23', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E90-3171346', 'E02-7757423', '464 Caliangt Point', 'Harry', 'Flores', '03-1059950', 'open architecture', 18157, to_date('2007-10-18', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E04-6432716', 'E02-7757423', '8 Laurel Crossing', 'Rebecca', 'Bowman', '03-1059950', 'Reduced', 14129, to_date('2013-02-22', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E05-8597812', 'E02-7757423', '4 Magdeline Parkway', 'Joyce', 'George', '03-1059950', 'application', 12439, to_date('2012-08-18', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E04-8228666', 'E02-7757423', '176 Kings Court', 'Juan', 'Coleman', '03-1059950', 'fault-tolerant', 13032, to_date('2015-08-31', 'yyyy-mm-dd'));
insert into employees (employeeid, managerid, address, first_name, last_name, phone_number, title, salary, hire_date) values ('E78-4412455', 'E02-7757423', '2942 Northland Court', 'Randy', 'Long', '03-1059950', 'migration', 1806, to_date('2013-12-07', 'yyyy-mm-dd'));


--rentals
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R126856643-8', 'C625241504-9', 'E94-9771106','M79-0455326', '472085166-5', to_date('2007-09-20', 'yyyy-mm-dd'), to_date('2013-01-29', 'yyyy-mm-dd'), 36, '03-1059950', 0, 0);
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R701339923-X', 'C158114470-9', 'E94-9771106','M59-6630546', '002287424-0', to_date('2007-01-27', 'yyyy-mm-dd'), to_date('2010-11-02', 'yyyy-mm-dd'), 20, '03-1059950', 0, 0);
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R263131225-2', 'C099701617-5', 'E94-9771106','M78-1672860', '907291914-9', to_date('2014-02-02', 'yyyy-mm-dd'), to_date('2015-06-14', 'yyyy-mm-dd'), 19, '03-1059950', 0, 0);
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R115115634-5', 'C450905054-2', 'E94-9771106','M81-4747135', '807506521-2',  to_date('2013-07-17', 'yyyy-mm-dd'), to_date('2005-04-19', 'yyyy-mm-dd'), 34, '03-1059950', 0, 0);
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R035945460-7', 'C976665713-0', 'E94-9771106','M25-4938632', '592254959-6',  to_date('2014-10-13', 'yyyy-mm-dd'), to_date('2012-12-22', 'yyyy-mm-dd'), 11, '03-1059950', 1, 0);
                                                                                                                                                                              
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R081519397-1', 'C293180405-3',  'E05-8597812','M96-5316551', '959692755-8',  to_date('2016-05-05', 'yyyy-mm-dd'), to_date('2008-08-27', 'yyyy-mm-dd'), 31, '03-1059950', 1, 0);
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R413215315-0', 'C626339413-7',  'E05-8597812','M36-5985588', '926127084-0',  to_date('2015-06-16', 'yyyy-mm-dd'), to_date('2005-06-03', 'yyyy-mm-dd'), 26, '03-1059950', 0, 0);
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R025430356-0', 'C979965680-X',  'E05-8597812','M54-3696177', '219002684-9',  to_date('2014-10-07', 'yyyy-mm-dd'), to_date('2009-12-22', 'yyyy-mm-dd'), 28, '03-1059950', 1, 0);
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R772699742-7', 'C827859022-2',  'E05-8597812','M67-5690009', '803715034-8', to_date('2009-10-27', 'yyyy-mm-dd'), to_date('2010-01-15', 'yyyy-mm-dd'), 7, '03-1059950', 0, 0);
insert into rentals (rentalid, customerid, employeeid, movieid, serialnumber, date_rented, return_date, price, specialid, paid, returned) values ('R335867002-3', 'C312728582-5',  'E05-8597812','M81-0480350', '146585097-X', to_date('2009-11-14', 'yyyy-mm-dd'), to_date('2015-06-03', 'yyyy-mm-dd'), 35, '03-1059950', 0, 0);
                                               


--actors
insert into actors (actorid, first_name, last_name) values ('A88-5697278', 'Adam', 'Burke');
insert into actors (actorid, first_name, last_name) values ('A60-1955047', 'George', 'Frazier');
insert into actors (actorid, first_name, last_name) values ('A06-9357192', 'Martin', 'Turner');
insert into actors (actorid, first_name, last_name) values ('A39-9651342', 'Adam', 'Martinez');
insert into actors (actorid, first_name, last_name) values ('A63-2846037', 'Anna', 'Richards');
insert into actors (actorid, first_name, last_name) values ('A53-4283011', 'Sharon', 'Sullivan');
insert into actors (actorid, first_name, last_name) values ('A76-8127180', 'Emily', 'Walker');
insert into actors (actorid, first_name, last_name) values ('A65-4070520', 'Lawrence', 'Johnson');
insert into actors (actorid, first_name, last_name) values ('A85-9687546', 'Patricia', 'Jenkins');
insert into actors (actorid, first_name, last_name) values ('A34-9304923', 'Nancy', 'Morris');
insert into actors (actorid, first_name, last_name) values ('A90-7777042', 'Anna', 'Sullivan');
insert into actors (actorid, first_name, last_name) values ('A39-1850089', 'Howard', 'Perry');
insert into actors (actorid, first_name, last_name) values ('A53-7454892', 'Phyllis', 'Kennedy');
insert into actors (actorid, first_name, last_name) values ('A36-3921693', 'Mary', 'Gibson');
insert into actors (actorid, first_name, last_name) values ('A03-3030021', 'Jane', 'Meyer');
insert into actors (actorid, first_name, last_name) values ('A99-6803668', 'Jeremy', 'Gilbert');
insert into actors (actorid, first_name, last_name) values ('A81-2673545', 'Harry', 'Russell');
insert into actors (actorid, first_name, last_name) values ('A07-7978407', 'Bruce', 'Rodriguez');
insert into actors (actorid, first_name, last_name) values ('A63-9738818', 'Lawrence', 'Fisher');
insert into actors (actorid, first_name, last_name) values ('A16-0680939', 'Dennis', 'Lewis');
insert into actors (actorid, first_name, last_name) values ('A48-4018681', 'Edward', 'Hamilton');
insert into actors (actorid, first_name, last_name) values ('A55-3993946', 'Aaron', 'Fuller');
insert into actors (actorid, first_name, last_name) values ('A37-0827296', 'Joyce', 'Willis');
insert into actors (actorid, first_name, last_name) values ('A60-0300796', 'Richard', 'Warren');
insert into actors (actorid, first_name, last_name) values ('A49-5936395', 'Jonathan', 'Gray');
insert into actors (actorid, first_name, last_name) values ('A85-5102149', 'Melissa', 'Pierce');
insert into actors (actorid, first_name, last_name) values ('A19-7469409', 'Harry', 'Little');
insert into actors (actorid, first_name, last_name) values ('A03-2059515', 'Virginia', 'Carroll');
insert into actors (actorid, first_name, last_name) values ('A17-2840227', 'Ashley', 'Simpson');
insert into actors (actorid, first_name, last_name) values ('A17-1106101', 'Alice', 'Nichols');
insert into actors (actorid, first_name, last_name) values ('A14-3106568', 'Shawn', 'Brown');
insert into actors (actorid, first_name, last_name) values ('A48-9002954', 'Henry', 'Henderson');
insert into actors (actorid, first_name, last_name) values ('A65-1773695', 'Donna', 'Spencer');
insert into actors (actorid, first_name, last_name) values ('A40-1161197', 'James', 'Shaw');
insert into actors (actorid, first_name, last_name) values ('A27-2160889', 'Jeffrey', 'Thomas');
insert into actors (actorid, first_name, last_name) values ('A31-9784973', 'Martin', 'Welch');
insert into actors (actorid, first_name, last_name) values ('A33-7040519', 'Justin', 'Vasquez');
insert into actors (actorid, first_name, last_name) values ('A62-8454644', 'Elizabeth', 'Daniels');
insert into actors (actorid, first_name, last_name) values ('A07-2483388', 'Randy', 'Lawson');
insert into actors (actorid, first_name, last_name) values ('A30-2447763', 'Ruby', 'Sanchez');

--movie actors
insert into movieactors (actorid, movieid) values ('A60-1955047', 'M73-8265338');
insert into movieactors (actorid, movieid) values ('A06-9357192', 'M46-1421504');
insert into movieactors (actorid, movieid) values ('A39-9651342', 'M97-5362702');
insert into movieactors (actorid, movieid) values ('A63-2846037', 'M76-6555137');
insert into movieactors (actorid, movieid) values ('A53-4283011', 'M08-3281675');
insert into movieactors (actorid, movieid) values ('A76-8127180', 'M65-1698400');
insert into movieactors (actorid, movieid) values ('A65-4070520', 'M39-9922479');
insert into movieactors (actorid, movieid) values ('A85-9687546', 'M90-7436212');
insert into movieactors (actorid, movieid) values ('A34-9304923', 'M89-8454499');
insert into movieactors (actorid, movieid) values ('A90-7777042', 'M51-0760472');
insert into movieactors (actorid, movieid) values ('A39-1850089', 'M57-2611019');
insert into movieactors (actorid, movieid) values ('A53-7454892', 'M71-8961183');
insert into movieactors (actorid, movieid) values ('A36-3921693', 'M82-5969295');
insert into movieactors (actorid, movieid) values ('A03-3030021', 'M56-1438689');
insert into movieactors (actorid, movieid) values ('A99-6803668', 'M01-5371873');
insert into movieactors (actorid, movieid) values ('A81-2673545', 'M09-5356081');
insert into movieactors (actorid, movieid) values ('A07-7978407', 'M69-4680867');
insert into movieactors (actorid, movieid) values ('A63-9738818', 'M18-4023754');
insert into movieactors (actorid, movieid) values ('A16-0680939', 'M48-2852655');
insert into movieactors (actorid, movieid) values ('A48-4018681', 'M78-7659141');
insert into movieactors (actorid, movieid) values ('A55-3993946', 'M20-1683353');
insert into movieactors (actorid, movieid) values ('A37-0827296', 'M60-3604497');
insert into movieactors (actorid, movieid) values ('A60-0300796', 'M02-2806400');
insert into movieactors (actorid, movieid) values ('A49-5936395', 'M23-8182019');
insert into movieactors (actorid, movieid) values ('A85-5102149', 'M48-0086984');
insert into movieactors (actorid, movieid) values ('A19-7469409', 'M33-2481165');
insert into movieactors (actorid, movieid) values ('A03-2059515', 'M34-4869842');
insert into movieactors (actorid, movieid) values ('A17-2840227', 'M93-9646714');
insert into movieactors (actorid, movieid) values ('A17-1106101', 'M36-2571856');
insert into movieactors (actorid, movieid) values ('A14-3106568', 'M31-7497843');
insert into movieactors (actorid, movieid) values ('A48-9002954', 'M46-5793201');
insert into movieactors (actorid, movieid) values ('A65-1773695', 'M14-0985497');
insert into movieactors (actorid, movieid) values ('A40-1161197', 'M92-2988013');
insert into movieactors (actorid, movieid) values ('A27-2160889', 'M39-3358245');
insert into movieactors (actorid, movieid) values ('A31-9784973', 'M48-7669569');
insert into movieactors (actorid, movieid) values ('A33-7040519', 'M67-4391442');
insert into movieactors (actorid, movieid) values ('A62-8454644', 'M81-6585139');
insert into movieactors (actorid, movieid) values ('A07-2483388', 'M36-9793769');
insert into movieactors (actorid, movieid) values ('A30-2447763', 'M78-7359446');
insert into movieactors (actorid, movieid) values ('A60-1955047', 'M45-7004821');
insert into movieactors (actorid, movieid) values ('A06-9357192', 'M78-0937512');
insert into movieactors (actorid, movieid) values ('A39-9651342', 'M09-0642772');
insert into movieactors (actorid, movieid) values ('A63-2846037', 'M70-3276364');
insert into movieactors (actorid, movieid) values ('A53-4283011', 'M31-8300561');
insert into movieactors (actorid, movieid) values ('A76-8127180', 'M28-2773053');
insert into movieactors (actorid, movieid) values ('A65-4070520', 'M53-1117582');
insert into movieactors (actorid, movieid) values ('A85-9687546', 'M65-7026091');
insert into movieactors (actorid, movieid) values ('A34-9304923', 'M81-7770678');
insert into movieactors (actorid, movieid) values ('A90-7777042', 'M23-0420959');
insert into movieactors (actorid, movieid) values ('A39-1850089', 'M74-6178630');
insert into movieactors (actorid, movieid) values ('A53-7454892', 'M43-9800753');
insert into movieactors (actorid, movieid) values ('A36-3921693', 'M12-4992827');
insert into movieactors (actorid, movieid) values ('A03-3030021', 'M94-2441609');
insert into movieactors (actorid, movieid) values ('A99-6803668', 'M99-4865641');
insert into movieactors (actorid, movieid) values ('A81-2673545', 'M45-9065957');
insert into movieactors (actorid, movieid) values ('A07-7978407', 'M34-8816328');
insert into movieactors (actorid, movieid) values ('A63-9738818', 'M40-8458604');
insert into movieactors (actorid, movieid) values ('A16-0680939', 'M88-5711898');
insert into movieactors (actorid, movieid) values ('A48-4018681', 'M41-3233780');
insert into movieactors (actorid, movieid) values ('A55-3993946', 'M48-1513905');
insert into movieactors (actorid, movieid) values ('A37-0827296', 'M69-8004737');
insert into movieactors (actorid, movieid) values ('A60-0300796', 'M00-6730628');
insert into movieactors (actorid, movieid) values ('A49-5936395', 'M32-4710691');
insert into movieactors (actorid, movieid) values ('A85-5102149', 'M19-7302803');
insert into movieactors (actorid, movieid) values ('A19-7469409', 'M30-5951474');
insert into movieactors (actorid, movieid) values ('A03-2059515', 'M46-9440896');
insert into movieactors (actorid, movieid) values ('A17-2840227', 'M49-1881582');
insert into movieactors (actorid, movieid) values ('A17-1106101', 'M58-4543126');
insert into movieactors (actorid, movieid) values ('A14-3106568', 'M23-0293506');
insert into movieactors (actorid, movieid) values ('A48-9002954', 'M14-4885567');
insert into movieactors (actorid, movieid) values ('A65-1773695', 'M77-1195753');
insert into movieactors (actorid, movieid) values ('A40-1161197', 'M52-2565396');
insert into movieactors (actorid, movieid) values ('A27-2160889', 'M98-1394640');
insert into movieactors (actorid, movieid) values ('A31-9784973', 'M20-2559365');
insert into movieactors (actorid, movieid) values ('A33-7040519', 'M46-4644709');
insert into movieactors (actorid, movieid) values ('A62-8454644', 'M09-1412594');
insert into movieactors (actorid, movieid) values ('A07-2483388', 'M17-6192947');
insert into movieactors (actorid, movieid) values ('A30-2447763', 'M76-3440021');
insert into movieactors (actorid, movieid) values ('A60-1955047', 'M99-3455230');
insert into movieactors (actorid, movieid) values ('A06-9357192', 'M65-6556289');
insert into movieactors (actorid, movieid) values ('A39-9651342', 'M25-3195313');
insert into movieactors (actorid, movieid) values ('A63-2846037', 'M76-1660238');
insert into movieactors (actorid, movieid) values ('A53-4283011', 'M55-1298958');
insert into movieactors (actorid, movieid) values ('A76-8127180', 'M16-9570895');
insert into movieactors (actorid, movieid) values ('A65-4070520', 'M16-5249908');
insert into movieactors (actorid, movieid) values ('A85-9687546', 'M44-3260728');
insert into movieactors (actorid, movieid) values ('A34-9304923', 'M22-8474368');
insert into movieactors (actorid, movieid) values ('A90-7777042', 'M79-0455326');
insert into movieactors (actorid, movieid) values ('A39-1850089', 'M59-6630546');
insert into movieactors (actorid, movieid) values ('A53-7454892', 'M78-1672860');
insert into movieactors (actorid, movieid) values ('A36-3921693', 'M81-4747135');
insert into movieactors (actorid, movieid) values ('A03-3030021', 'M25-4938632');
insert into movieactors (actorid, movieid) values ('A99-6803668', 'M85-6193743');
insert into movieactors (actorid, movieid) values ('A81-2673545', 'M96-5316551');
insert into movieactors (actorid, movieid) values ('A07-7978407', 'M36-5985588');
insert into movieactors (actorid, movieid) values ('A63-9738818', 'M54-3696177');
insert into movieactors (actorid, movieid) values ('A16-0680939', 'M67-5690009');
insert into movieactors (actorid, movieid) values ('A48-4018681', 'M81-0480350');
insert into movieactors (actorid, movieid) values ('A55-3993946', 'M84-0569091');
insert into movieactors (actorid, movieid) values ('A37-0827296', 'M87-1179985');


				

