
/* 1. Rental Log – Create a trigger which logs movie rentals and returns,
indicating who has rented movies and when */
CREATE OR REPLACE TRIGGER AFTER_RENTALS_INSERTORUPDATE
after INSERT OR UPDATE
ON Rentals
FOR EACH ROW
DECLARE
	inStock CHAR(1) := :NEW.Returned;
BEGIN
	dbms_output.put_line('Rental ID..: ' || :new.rentalid);
	dbms_output.put_line('Customer ID: ' || :new.CustomerID);
	dbms_output.put_line('Movie ID...: ' || :new.MovieID);
	dbms_output.put_line('Date rented: ' || :new.Date_Rented);
	dbms_output.put_line('Return date: ' || :new.Return_Date);
	IF (inStock = '1') THEN
		dbms_output.put_line('Returned?..: Yes' );
	ELSE
		dbms_output.put_line('Returned?..: No'  );
	END IF;
END;


--INSERT INTO rentals VALUES('0010', '0001', 'DM1234', '0002', 'A931KFMD8' ,TO_DATE('2017-03- 10','YYYY-MM-DD'), 
--TO_DATE('2017-04- 04','YYYY-MM-DD'), 5.99, null, 5.99,'0');

--  alter trigger BEFORE_RENTALS_CanRent disable;
/* 2. Quantity Update – Create a trigger that automatically updates the quantity of movies in 
stock when a film is rented or returned. */
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


-- INSTRUCTIONS
-- check if movie has been rented last 30 days in table from input from INSERT
-- and quantity isnt 1
CREATE OR REPLACE TRIGGER BEFORE_RENTALS_CanRent
BEFORE INSERT OR UPDATE
ON RENTALS
 FOR EACH ROW
DECLARE 
no_records number(4);
ex_custom       EXCEPTION;
PRAGMA EXCEPTION_INIT( ex_custom, -20001 );
BEGIN
  -- select if customer has rented movie from input 
  -- and has been in last 30 days
  SELECT count(movieid) INTO no_records FROM RENTALS 
  JOIN inventory using(movieid)
  where customerID = :new.customerid
  and TO_DATE(:new.date_rented,'YYYY-MM-DD') -
  TO_DATE(date_rented,'YYYY-MM-DD')
   < 30 and TotalAvailable = 1;
   
  if no_records != 0 then
    RAISE_APPLICATION_ERROR(-20101, 'You cannot rent out the last movie');
    ROLLBACK;
  end if;    
end;  

/* 2. Quantity Update – Create a trigger that automatically updates the quantity of movies in 
stock when a film is rented or returned. */
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

-- INSTRUCTIONS
-- check if movie has been rented last 30 days in table from input from INSERT
-- and quantity isnt 1
CREATE OR REPLACE TRIGGER BEFORE_RENTALS_CanRent
BEFORE INSERT OR UPDATE
ON RENTALS
 FOR EACH ROW
DECLARE 
no_records number(4);
ex_custom       EXCEPTION;
PRAGMA EXCEPTION_INIT( ex_custom, -20001 );
BEGIN
  -- select if customer has rented movie from input 
  -- and has been in last 30 days
  SELECT count(movieid) INTO no_records FROM RENTALS 
  JOIN inventory using(movieid)
  where customerID = :new.customerid
  and TO_DATE(:new.date_rented,'YYYY-MM-DD') -
  TO_DATE(date_rented,'YYYY-MM-DD')
   < 30 and TotalAvailable = 1;
   
  if no_records != 0 then
    RAISE_APPLICATION_ERROR(-20101, 'You cannot rent out the last movie');
    ROLLBACK;
  end if;    
end;