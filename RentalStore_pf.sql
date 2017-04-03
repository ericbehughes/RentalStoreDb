create or replace function filmInStock(movieTitle in varchar2) RETURN CHAR AS
  numOfFreeMovies number(4) := 0;
begin 
  SELECT COUNT(movieid) INTO numOfFreeMovies FROM inventory 
  JOIN MOVIES using(movieid)
  WHERE movieTitle = title AND totalavailable > 0
  GROUP BY movieid;
  IF numOfFreeMovies > 0 then
    dbms_output.put_line('yes the movie is in stock');
  return '1';
else 
  dbms_output.put_line('no the movie is not in stock');
  return '0';
end if;
end;
/*
-- run function 
DECLARE
		movie char(1) := 0;
BEGIN
		movie := filmInStock('Nothing Lasts Forever');
		dbms_output.put_line(movie);
END;
*/
--Calculate Late Fees – Calculates a customer’s late fees.
create or replace procedure calculateLateFees(custId in varchar2) as
--variables
latefees number(6,2) := 0;
type dlate is varray(10) of number(4);
days_late dlate ;
BEGIN
SELECT  TO_NUMBER(TO_DATE(current_date) - TO_DATE(return_date))BULK COLLECT INTO days_late FROM rentals
  WHERE TO_DATE(current_date) - TO_DATE(return_date) > 0 AND returned = '1'
  group by rentalid, serialnumber, TO_NUMBER(TO_DATE(current_date) - TO_DATE(return_date));
  
  FOR i IN 1..days_late.last LOOP
    dbms_output.put_line(days_late(i));
    latefees := 50 * days_late(i);
  end LOOP;
  dbms_output.put_line(latefees);
END;
--execute calculateLateFees('0001' );

-- rent movie
CREATE OR REPLACE PROCEDURE RentMovie(custID IN VARCHAR2, movID IN VARCHAR2)
AS
  SerialNumber VARCHAR2(64);
  MovPrice NUMBER(4);
BEGIN
	  Select SerialNum, Price INTO SerialNumber, MovPrice FROM Movies where movies.MovieID = movID;
	  INSERT INTO rentals
	  VALUES('R'||custID||movID, custID, 'DM1234', movID, SerialNumber,TO_DATE('2017-06- 25','YYYY-MM-DD'), TO_DATE('2017-06- 29','YYYY-MM-DD'), MovPrice, null, MovPrice, 0);
END;

--execute RentMovie('0001', '0003');

/*Get Total Rented – Create a subprogram that counts the total number of films a customer has rented*/
CREATE OR REPLACE PROCEDURE GetRented(custID IN VARCHAR2)
AS
  total NUMBER(4);
BEGIN
	Select count(customerID) INTO total FROM rentals where customerID = custID;
	dbms_output.put_line('Total number of movies rented: ' || total);
END;

--execute GetRented('0002');

/*Customer Report – Create a subprogram that lists each customer along with the total number of movies they currently have out, and total amount of movies they have rented in the past month.*/
/*Customer Report – Create a subprogram that lists each customer along with the total number of movies they currently have out, and total amount of movies they have rented in the past month.*/
CREATE OR REPLACE PROCEDURE CustomerReport
AS
	TYPE CustomersVarray IS VARRAY(10) of VARCHAR2(64);
	Customers CustomersVarray;
	total NUMBER(4);
	MonthlyTotal NUMBER(4);
BEGIN
	SELECT CustomerID BULK COLLECT INTO Customers
	FROM StoreCustomers;
	FOR i IN 1..Customers.COUNT LOOP
		SELECT count(CustomerID) INTO total FROM rentals WHERE customerID = Customers(i);
		SELECT count(customerID) INTO MonthlyTOtal FROM rentals WHERE customerID = Customers(i)
		AND Date_Rented BETWEEN TO_DATE('2017-03-01','YYYY-MM-DD') AND TO_DATE('2017-03-30','YYYY-MM-DD');
		dbms_output.put_line('Total movies rented for customer ' || Customers(i)|| ': ' || total);
		dbms_output.put_line('Monthly movies rented for customer ' || Customers(i)|| ': ' || MOnthlyTotal);
	END LOOP;
END;

--EXECUTE CustomerReport;
