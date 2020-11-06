CREATE EXTERNAL TABLE clickstream (
    REFERRER STRING,
    REFERRED STRING,
    TYPE STRING,
    COUNT INT)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t';

LOAD DATA INPATH '/mnt/c/Users/issac/Files/Files/Ravature/clickstream-enwiki-2020-09.tsv' INTO TABLE clickstream;


CREATE EXTERNAL TABLE trace_views(
    domain STRING,
    title STRING,
    views INT,
    responses INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';
LOAD DATA LOCAL INPATH '/mnt/c/Users/issac/Files/Files/Ravature/Other files/Project1/pageviews'INTO TABLE trace_views;

SELECT REFERRER, TYPE, COUNT 
    FROM clickstream
    WHERE Type ='link'
    LIMIT 100;



SELECT referrer, type, count 
    FROM clickstream 
    WHERE type ='link'
    ORDER BY count DESC
    LIMIT 100;


SELECT *
    FROM clickstream 
    WHERE type ='link' and referrer='Deaths_in_2020'
    ORDER BY count DESC
    LIMIT 100;

SELECT *
    FROM clickstream 
    WHERE type ='other' 
    ORDER BY count DESC
    LIMIT 100;


SELECT *
    FROM clickstream 
    WHERE type ='link' OR type='other' AND referrer='Main_Page'
    ORDER BY count DESC
    LIMIT 100;


SELECT referrer, referred, type, count 
    FROM clickstream 
    WHERE type ='external' AND NOT (referrer='other-search' or referrer='other-internal' or 
    referrer='other-empty' or referrer='other-external')
    ORDER BY count DESC
    LIMIT 100;



CREATE TABLE Total_Clicks( Title STRING, Views INT)
PARTITIONED BY (domain STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

INSERT INTO TABLE Total_Clicks PARTITION(domain='en.m')
SELECT title, sum(views)
FROM trace_views
WHERE domain='en.m'
GROUP by title;

CREATE TABLE Total_Clickstream( Title STRING, Clicks INT)
PARTITIONED BY (type STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

INSERT INTO TABLE Total_Clickstream PARTITION(type='link')
SELECT referrer, sum(count)
FROM clickstream
WHERE type='link'
GROUP by referrer;

CREATE TABLE Final_Total_Views(Title STRING, Views INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

INSERT INTO TABLE Final_Total_Views 
SELECT Title, sum(Views)
FROM Total_Clicks
GROUP by title;


SELECT Final_Total_Views.Title AS Article,
Final_Total_Views.Views AS Total_Views,
Total_Clickstream.Clicks AS Links_Followed,
ROUND(Total_Clickstream.Clicks/Final_Total_Views.Views*100, 2) AS Clickthrough_Percentage
FROM Final_Total_Views
INNER JOIN Total_Clickstream ON Final_Total_Views.Title = Total_Clickstream.Title
WHERE Final_Total_Views.views> 1000000
ORDER BY Clickthrough_Percentage DESC
LIMIT 100;

