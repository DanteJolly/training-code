CREATE EXTERNAL TABLE US_pageviews(
    domain STRING,
    title STRING,
    views INT,
    responses INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';
LOAD DATA LOCAL INPATH '/mnt/c/Users/issac/Files/Files/Ravature/pageviews/US'INTO TABLE US_pageviews;

CREATE TABLE partioned_us_pageviews(
    title STRING,
    views INT
)
PARTITIONED BY (domain STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';

INSERT INTO TABLE partioned_us_pageviews PARTITION (domain='en')
SELECT title, views FROM US_pageviews WHERE domain='en';

INSERT INTO TABLE partioned_us_pageviews PARTITION (domain='en.m')
SELECT title, views FROM US_pageviews WHERE domain='en.m'

CREATE EXTERNAL TABLE UK_pageviews(
    domain STRING,
    title STRING,
    views INT,
    responses INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';

LOAD DATA LOCAL INPATH '/mnt/c/Users/issac/Files/Files/Ravature/pageviews/UK'INTO TABLE UK_pageviews; 

CREATE TABLE partioned_uk_pageviews(
    title STRING,
    views INT
)
PARTITIONED BY (domain STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';

INSERT INTO TABLE partioned_uk_pageviews PARTITION (domain='en')
SELECT title, views FROM UK_pageviews WHERE domain='en';

INSERT INTO TABLE partioned_uk_pageviews PARTITION (domain='en.m')
SELECT title, views FROM UK_pageviews WHERE domain='en.m'


SELECT partioned_us_pageviews.title, sum(partioned_us_pageviews.views) AS total_us_views, sum(partioned_uk_pageviews.views) AS total_uk_views
FROM partioned_us_pageviews
INNER JOIN partioned_uk_pageviews on partioned_us_pageviews.title=partioned_uk_pageviews.title
WHERE partioned_us_pageviews.views>5 AND partioned_uk_pageviews.views>5
GROUP By partioned_us_pageviews.title 
ORDER BY total_us_views DESC
LIMIT 100;


CREATE EXTERNAL TABLE AUS_pageviews(
    domain STRING,
    title STRING,
    views INT,
    responses INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';
LOAD DATA LOCAL INPATH '/mnt/c/Users/issac/Files/Files/Ravature/pageviews/AUS'INTO TABLE AUS_pageviews;

CREATE TABLE partioned_aus_pageviews(
    title STRING,
    views INT
)
PARTITIONED BY (domain STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' ';


INSERT INTO TABLE partioned_aus_pageviews PARTITION (domain='en')
SELECT title, views FROM AUS_pageviews WHERE domain='en';

INSERT INTO TABLE partioned_aus_pageviews PARTITION (domain='en.m')
SELECT title, views FROM AUS_pageviews WHERE domain='en.m' and views>5

SELECT partioned_us_pageviews.title, sum(partioned_us_pageviews.views) AS total_us_views, sum(partioned_aus_pageviews.views) AS total_aus_views
FROM partioned_us_pageviews
INNER JOIN partioned_aus_pageviews on partioned_us_pageviews.title=partioned_aus_pageviews.title
WHERE partioned_us_pageviews.views>10 AND partioned_aus_pageviews.views>10
GROUP By partioned_us_pageviews.title 
ORDER BY total_us_views DESC
LIMIT 100;