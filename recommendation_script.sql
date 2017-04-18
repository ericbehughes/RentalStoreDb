--if no previous rentals then show only movies with above a 90 rating
select movieid, title, avg(rating) from movies 
where rating >= 90
group by movieid, title, rating;

-- select every movie that has same genre as his previous rentals with rating > 90
select movieid, title, genre, rating from movies
where genre IN
    (select genre from rentals 
    join movies using(movieid)
    where customerid = 'C293180405-3'
    group by genre)
group by movieid, title,genre, rating
having rating > 90;

--select all rentals who have rented a certain movie genre
-- find those customers
-- find all movies th
select movieid, genre, rating from rentals
join -- customers with past rentals with certain genre from customer coming in
    (select customerid from rentals
    join movies using(title)
    where genre in  (select genre from rentals 
                    join movies using(title) 
                    where customerid = 'C293180405-3' group by genre))
using (customerid)
join movies using(title)
where rating > 90;


select first_name, last_name, movieid from actors
join movieactors using(actorid)
join movies using(movieid)
order by last_name;
