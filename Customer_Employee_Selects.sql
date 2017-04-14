select distinct isbn, title, retail from books join bookauthor using(isbn) 
join author using(authorid);

-- browse all movies
select distinct title, price, genre, totalavailable
from movies join inventory using(movieid);
-- rented or not
select distinct title, price, genre
from movies JOIN inventory using(movieid)
where totalavailable > 0;

-- title
select distinct title, cost, category
from movies where title = 'HOW TO GET FASTER PIZZA';

-- using genre
select distinct title, price, genre
from movies where genre = userGenre;
--using title
select distinct title, rating, price
from movies where title = usertitle
group by title;

-- actors present in film
select distinct title, rating, price from movies 
join movieactors using(movieid)
join actors using(actorid);

--
Select rentalid, movieid, title, price, date_rented, returned
FROM rentals join movies using(movieid)
where customerID = custID;
	dbms_output.put_line('Total number of movies rented: ' || total);
  

-- employee selects
-- browser all movies just like customers so same select

-- overdue movies for all customers
SELECT rentalid, customerid, first_name, last_name, TO_NUMBER(TO_DATE(current_date) - TO_DATE(return_date)) as days_late
FROM rentals 
JOIN storecustomers using(customerid)
WHERE TO_DATE(current_date) - TO_DATE(return_date) > 0 
AND returned = '1'
group by rentalid,customerid,
first_name, last_name,
TO_NUMBER(TO_DATE(current_date) - TO_DATE(return_date))
order by days_late;

--rent movie
CREATE OR REPLACE PROCEDURE RentMovie(custID IN VARCHAR2, movID IN VARCHAR2)
AS
  SerialNumber VARCHAR2(64);
  MovPrice NUMBER(4);
BEGIN
	  Select SerialNum, Price INTO SerialNumber, MovPrice FROM Movies where movies.MovieID = movID;
	  INSERT INTO rentals
	  VALUES('R'||custID||movID, custID, 'DM1234', movID, SerialNumber,TO_DATE(CURRENT_DATE,'YYYY-MM-DD'), TO_DATE('2017-06- 29','YYYY-MM-DD'), MovPrice, null, MovPrice);
END;

execute RentMovie('0001', '0003');

--Film in stock – Create a subprogram that determines if a film is currently available for rent.
/*
create or replace function userRequest(userInput in varchar2) RETURN varCHAR AS
--variables
begin 
-- can maybe be simplified

IF userInput = 'title' then
dbms_output.put_line('user input is title');
return 'title';

elsif userINput = 'genre' then
dbms_output.put_line('user input is genre');
return 'genre';

-- need todo exceptions or in java
end if;

end;
-- run function 
DECLARE
		userInput varchar(64);
BEGIN
		userInput := userRequest('genre');
		dbms_output.put_line(userInput);
END;

*/