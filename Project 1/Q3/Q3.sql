CREATE EXTERNAL TABLE clickstream (
    refferer STRING,
    reffered STRING,
    type STRING,
    count INT)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t';
LOAD DATA INPATH '/user/issac/clickstream' INTO TABLE clickstream;

CREATE EXTERNAL TABLE trace_views(
    domain STRING,
    title STRING,
    views INT,
    responses INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';
LOAD DATA LOCAL INPATH '/mnt/c/Users/issac/Files/Files/Ravature/Other files/Project1/pageviews'INTO TABLE trace_views;


SELECT * 
    FROM clickstream
    WHERE type = "link" and referrer="Hotel_California"
    SORT BY count DESC 
    limit 100;

SELECT Title, Sum(Views) as Views
    FROM Total_Clicks
    WHERE Title="Hotel_California" 
    GROUP BY Title
    SORT BY Views DESC 
    limit 100;

SELECT  referrer, referred, (count/73701*100) as Percentage
    FROM clickstream
    WHERE type = "link" and referrer="Hotel_California"
    SORT BY Percentage DESC 
    limit 100;



SELECT Title, Sum(Views) as Views
    FROM Total_Clicks
    WHERE Title="Hotel_California_(Eagles_album)" 
    GROUP BY Title
    SORT BY Views DESC 
    limit 100;

SELECT  referrer, referred, (count/37517*100) as Percentage
    FROM clickstream
    WHERE type = "link" and referrer="Hotel_California_(Eagles_album)"
    SORT BY Percentage DESC 
    limit 100;


SELECT Title, Sum(Views) as Views
    FROM Total_Clicks
    WHERE Title="The_Long_Run_(album)" 
    GROUP BY Title
    SORT BY Views DESC 
    limit 100;

SELECT  referrer, referred, (count/11871*100) as Percentage
    FROM clickstream
    WHERE type = "link" and referrer="The_Long_Run_(album)"
    SORT BY Percentage DESC 
    limit 100;



SELECT Title, Sum(Views) as Views
    FROM Total_Clicks
    WHERE Title="Eagles_Live"
    GROUP BY Title
    SORT BY Views DESC 
    limit 100;


SELECT  referrer, referred, (count/4034*100) as Percentage
    FROM clickstream
    WHERE type = "link" and referrer="Eagles_Live"
    SORT BY Percentage DESC 
    limit 100;

SELECT * 
    FROM clickstream
    WHERE type = "link" and referrer="Eagles_Greatest_Hits,_Vol._2"
    SORT BY count DESC 
    limit 100;

SELECT * 
    FROM clickstream
    WHERE type = "link" and referrer="The_Very_Best_of_the_Eagles"
    SORT BY count DESC 
    limit 100;

SELECT * 
    FROM clickstream
    WHERE type = "link" and referrer="Hell_Freezes_Over"
    SORT BY count DESC 
    limit 100;


SELECT * 
    FROM clickstream
    WHERE type = "link" and referrer="Selected_Works:_1972–1999"
    SORT BY count DESC 
    limit 100;

SELECT * 
    FROM clickstream
    WHERE type = "link" and referrer="The_Very_Best_Of_(Eagles_album)"
    SORT BY count DESC 
    limit 100;

SELECT Title, Sum(Views) as Views
    FROM Total_Clicks
    WHERE Title="Eagles_(box_set)"
    GROUP BY Title
    SORT BY Views DESC 
    limit 100;

SELECT  referrer, referred, (count/1283*100) as Percentage
    FROM clickstream
    WHERE type = "link" and referrer="Eagles_Live"
    SORT BY Percentage DESC 
    limit 100;

SELECT Title, Sum(Views) as Views
    FROM Total_Clicks
    WHERE Title="Long_Road_Out_of_Eden"
    GROUP BY Title
    SORT BY Views DESC 
    limit 100;

SELECT  referrer, referred, (count/7160*100) as Percentage
    FROM clickstream
    WHERE type = "link" and referrer="Long_Road_Out_of_Eden"
    SORT BY Percentage DESC 
    limit 100;

SELECT * 
    FROM clickstream
    WHERE type = "link" and referrer="Eagles_(band)"
    SORT BY count DESC 
    limit 100;



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
WHERE Final_Total_Views.Title="Hotel_California"
ORDER BY Clickthrough_Percentage DESC
LIMIT 100;