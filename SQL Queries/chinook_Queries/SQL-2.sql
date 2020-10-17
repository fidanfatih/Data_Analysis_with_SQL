  		----SQLITE QUERIES

--1-How many tracks does each album have? 
--Your solution should include Album id and its number of tracks sorted from highest to lowest.

SELECT AlbumId, count(TrackId) as number_of_tracks
FROM tracks
GROUP BY AlbumId
ORDER BY number_of_tracks DESC;

--2-Find the album title of the tracks.
--Your solution should include track name and its album title.

SELECT t.name as track_name, a.Title as album_title
FROM albums a
JOIN tracks t ON t.AlbumId=a.AlbumId ;

--3-Find the minimum duration of the track in an album. 
--Your solution should include track name, album id, album title and 
--duration of the track sorted from highest to lowest.

SELECT t.name as track_name, a.AlbumId, a.Title as album_title, min(t.Milliseconds) as duration_of_track
FROM albums a
JOIN tracks t ON t.AlbumId=a.AlbumId 
GROUP BY a.AlbumId
ORDER BY duration_of_track DESC;

--4-Find the total duration of each album. Your solution should include track name, album id, album title 
--and its total duration sorted from highest to lowest.

SELECT t.name as track_name, a.AlbumId, a.Title as album_title, sum(t.Milliseconds) as total_duration_of_album
FROM albums a
JOIN tracks t ON t.AlbumId=a.AlbumId 
GROUP BY a.AlbumId
ORDER BY total_duration_of_album DESC;

--5-Based on the previous question, find the albums whose total duration is higher than 70 minutes. 
--Your solution should include album title and total duration.

SELECT a.Title as album_title, sum(t.Milliseconds)/60000 as "total_duration(mn)"
FROM albums a
JOIN tracks t ON t.AlbumId=a.AlbumId
GROUP BY a.AlbumId
HAVING "total_duration(mn)" >70;