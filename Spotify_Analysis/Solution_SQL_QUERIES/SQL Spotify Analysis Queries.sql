------Creating Table--------------

Drop Table if exists Spotify_DB;
Create table Spotify_DB
(

Artist Varchar(300),
Track Varchar (300),
Album Varchar (300),
Album_type Varchar (300),
Danceability float,
Energy float,
Loudness float,
Speechiness float,
Acousticness float,
Instrumentalness float,
Liveness float,
Valence float,
Tempo float,
Duration_min float,
Title varchar(255),
Channel varchar (255),
View_count bigint,
Likes bigint,
Comment_Count bigint,
Licensed boolean,
official_video boolean,
Stream bigint,
EnergyLiveness float,
most_playedon varchar (255)

);


-------Queries----------------

--test query--
select * from spotify_db limit 100;

--Retrieve the names of all tracks that have more than 1 billion streams.--

select artist,track,album from spotify_db
where stream > 1000000000;

----List all albums along with their respective artists.----

select artist, album from spotify_db
group by artist,album
order by artist;

----Get the total number of comments for tracks where licensed = TRUE.----

select sum(Comment_Count) from spotify_db
where Licensed='TRUE';

---- Find all tracks that belong to the album type single. ----

select artist,track from spotify_db
where album_type='single';

---- Count the total number of tracks by each artist. ----

select artist, count(track)
from spotify_db
group by artist
order by 2 desc;


---- Find the top 5 tracks with the highest energy values. ----

select artist,track,energy from spotify_db
order by Energy desc
limit 5;

---- Calculate the average danceability of tracks in each album. ----

select album, avg(Danceability) from spotify_db
group by album
order by 2 desc;

---- For each album, calculate the total views of all associated tracks. ----

select sum(View_count), album 
from Spotify_db
group by album
order by 1 asc;

---- List all tracks along with their views and likes where official_video = TRUE. ----

select track, View_count, Likes
from spotify_db
where official_video= TRUE
order by likes desc;

---- Retrieve the track names that have been streamed on Spotify more than YouTube. ----

select artist,track,stream
from spotify_db
where most_playedon= 'Spotify'
order by 3 asc;

---- Find the top 3 most-viewed tracks for each artist using window functions. ----

select artist, track, view_count,top_3tracks from(
select artist, track, view_count,
rank()Over(partition by artist order by view_count desc) as top_3tracks
from spotify_db)
where top_3tracks<=3;

---- Write a query to find tracks where the liveness score is above the average. ----

select track,EnergyLiveness from spotify_db
where EnergyLiveness> ( select avg(EnergyLiveness) as Avg_liveness from spotify_db)
order by EnergyLiveness desc;


---- Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions. ----

select distinct track,likes,view_count,
sum(likes)over(order by view_count desc) as running_total_likes
from spotify_db order by track desc;

---- Find tracks where the energy-to-liveness ratio is greater than 1.2. ----

select track from spotify_db
where Energy/Energyliveness >1;


/*Use a WITH clause to calculate 
the difference between the highest and lowest energy values 
for tracks in each album.*/

with cte as
(select album, max(Energyliveness) as max_liveness, min(Energyliveness) as min_liveness
from spotify_db
group by album 
) 
select album, max_liveness-min_liveness as liveness_diff
from cte order by 2 desc;




