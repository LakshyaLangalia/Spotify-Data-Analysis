-- Simple Data Analysis:

-- More than 1 Billion Streams
select * from spotify_dataset where stream >= 1000000000

-- All Albums with Respective Artists
select DISTINCT album, artist from spotify_dataset order by 1

-- Total number of comments in licensed tracks
select sum(comments) as total_comments from spotify_dataset where licensed = 'true'

-- All singles
select * from spotify_dataset where album_type = 'single'

--Total number of tracks by each artist
select artist, count(*) as total_num_songs from spotify_dataset group by artist

-- Avg danceability of tracks in each album
select album, avg(danceability) as avg_danceability from spotify_dataset group by album order by 2 desc

--finding the top 5 highest energy tracks
select top (5) energy, track from spotify_dataset order by energy desc

-- all tracks with an official video along with the video's likes and comments. 
select top (85)
	track, 
	sum(likes) as sum_likes, 
	sum(comments) as sum_comments 
from spotify_dataset 
where official_video = 'true' 
group by track
order by 2 desc

-- cumulative views for each album
select album, sum(views) from spotify_dataset group by album order by 2 desc

-- tracks that have been streamed on Spotify more than YouTube
select * from 
(select 
	track,
	--coalesce replaces null values with desired values
	coalesce (sum (case when most_playedon = 'Youtube' then stream end), 0) as streamed_on_yt,
	coalesce (sum (case when most_playedon = 'Spotify' then stream end), 0) as streamed_on_spotify
from spotify_dataset group by track)

where streamed_on_spotify > streamed_on_yt and streamed_on_yt > 0



-- top 3 most viewed tracks for each artist

with ranking_artist 
as
(select
	artist,
	track,
	sum(views) as sum_views,
	dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify_dataset 
group by artist, track)
select * from ranking_artist 
where rank <= 3


-- finding the tracks where the liveness score is above average
select track from spotify_dataset where liveness > (select avg(liveness) from spotify_dataset)

-- find the difference between the highest and lowest energy values within every album

with cte as 
(select album, max(energy) as highest_energy, min(energy) as lowest_energy from spotify_dataset group by album)
select album, highest_energy - lowest_energy as energy_difference from cte
order by energy_difference desc

