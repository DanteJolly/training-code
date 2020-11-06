create table history (WIKI_DB STRING, 
                EVENT_ENTITY STRING,
                EVENT_TYPE STRING,
                EVENT_TIMESTAMP STRING,
                EVENT_COMMENT STRING,
                EVENT_USER_ID BIGINT,
                EVENT_USER_TEXT_HISTORICAL STRING,
                EVENT_USER_TEXT STRING,
                EVENT_USER_BLOCKS_HISTORICAL STRING,
                EVENT_USER_BLOCKS ARRAY<STRING>,
                EVENT_USER_GROUPS_HISTORICAL ARRAY<STRING>,
                EVENT_USER_GROUPS ARRAY<STRING>,
                event_user_is_bot_by_historical ARRAY<STRING>,
                event_user_is_bot_by ARRAY<STRING>,
                event_user_is_created_by_self BOOLEAN,
                event_user_is_created_by_system BOOLEAN,
                event_user_is_created_by_peer BOOLEAN,
                event_user_is_anonymous BOOLEAN,
                event_user_registration_timestamp STRING,
                event_user_creation_timestamp STRING,
                event_user_first_edit_timestamp STRING,
                event_user_revision_count BIGINT,
                event_user_seconds_since_previous_revision BIGINT,
                page_id BIGINT,
                page_title_historical STRING,
                page_title STRING,
                page_namespace_historical INT,
                page_namespace_is_content_historical BOOLEAN,
                page_namespace INT,
                page_namespace_is_content BOOLEAN,
                page_is_redirect BOOLEAN,
                page_is_deleted BOOLEAN,
                page_creation_timestamp STRING,
                page_first_edit_timestamp STRING,
                page_revision_count BIGINT,
                page_seconds_since_previous_revision BIGINT,
                user_id BIGINT,
                user_text_historical STRING,
                user_text STRING,
                user_blocks_historical ARRAY<STRING>,
                user_blocks ARRAY<STRING>,
                user_groups_historical ARRAY<STRING>,
                user_groups ARRAY<String>,
                user_is_bot_by_historical ARRAY<STRING>,
                user_is_bot_by Array<STRING>,
                user_is_created_by_self BOOLEAN,
                user_is_created_by_system boolean,
                user_is_created_by_peer BOOLEAN,
                user_is_anonymous boolean,
                user_registration_timestamp String,
                user_creation_timestamp STRING,
                user_first_edit_timestamp STRING,
                revision_id bigint,
                revision_parent_id bigint,
                revision_minor_edit boolean,
                revision_deleted_parts Array<String>,
                revision_deleted_parts_are_suppressed boolean,
                revision_text_bytes bigint,
                revision_text_bytes_diff bigint,
                revision_text_sha1 string,
                revision_content_model string,
                revision_content_format string,
                revision_is_deleted_by_page_deletion boolean,
                revision_deleted_by_page_deletion_timestamp string,
                revision_is_identity_reverted boolean,
                revision_first_identity_reverting_revision_id bigint,
                revision_seconds_to_identity_revert bigint,
                revision_is_identity_revert boolean,
                revision_is_from_before_page_creation boolean,
                revision_tags Array<string>
                )
            ROW FORMAT DELIMITED 
            FIELDS TERMINATED BY '\t';


LOAD DATA LOCAL INPATH '/mnt/c/Users/issac/Files/Files/Ravature/Other files/Project1/history/september' INTO TABLE history


select revision_id 
from history
where revision_id IS NOT NULL 
limit 5; 



SELECT  page_title_historical,revision_seconds_to_identity_revert
FROM  history
SORT BY revision_seconds_to_identity_revert desc
LIMIT 100;


SELECT  page_title_historical,revision_seconds_to_identity_revert,revision_deleted_by_page_deletion_timestamp
FROM  history
SORT BY revision_seconds_to_identity_revert desc
LIMIT 100;

SELECT  page_title_historical,revision_seconds_to_identity_revert,revision_deleted_by_page_deletion_timestamp
FROM  history
WHERE revision_seconds_to_identity_revert IS NOT NULL
SORT BY revision_deleted_by_page_deletion_timestamp desc
LIMIT 100;

SELECT  page_title_historical,avg(revision_seconds_to_identity_revert) ,revision_deleted_by_page_deletion_timestamp
FROM  history
WHERE revision_seconds_to_identity_revert IS NOT NULL
GROUP BY page_title_historical, revision_deleted_by_page_deletion_timestamp
SORT BY revision_deleted_by_page_deletion_timestamp desc
LIMIT 100;

SELECT  page_title_historical,avg(revision_seconds_to_identity_revert) as AVG ,revision_deleted_by_page_deletion_timestamp
FROM  history
WHERE revision_seconds_to_identity_revert IS NOT NULL AND revision_deleted_by_page_deletion_timestamp IS NOT NULL
GROUP BY page_title_historical, revision_deleted_by_page_deletion_timestamp
SORT BY AVG desc
LIMIT 100;

CREATE TABLE convert_avg_time(
    seconds BIGINT,
    minutes BIGINT,
    hours INT, 
    days INT
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';

select avg(revision_seconds_to_identity_revert),
avg(revision_seconds_to_identity_revert/60),
avg(revision_seconds_to_identity_revert/3600)
FROM history
WHERE revision_seconds_to_identity_revert>0;

select 
ROUND(avg(revision_seconds_to_identity_revert)),
ROUND(avg(revision_seconds_to_identity_revert/60)),
ROUND(avg(revision_seconds_to_identity_revert/3600)),
ROUND(avg(revision_seconds_to_identity_revert/86400))

FROM history
WHERE revision_seconds_to_identity_revert>0 and revision_is_identity_reverted=true;

INSERT INTO TABLE convert_avg_time
SELECT 
ROUND(avg(revision_seconds_to_identity_revert)),
ROUND(avg(revision_seconds_to_identity_revert/60)),
ROUND(avg(revision_seconds_to_identity_revert/3600)),
ROUND(avg(revision_seconds_to_identity_revert/86400))
FROM history
WHERE revision_seconds_to_identity_revert>0;

CREATE TABLE pagecount(
    wiki_code STRING,
    article_title STRING,
    monthly_total BIGINT,
    Hourly_counts STRING
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ' ';

LOAD DATA LOCAL INPATH '/mnt/c/Users/issac/Files/Files/Ravature/Other files/Project1/pagecount/2020-09' INTO TABLE pagecount


SELECT article_title, monthly_total, Hourly_counts
FROM pagecount
WHERE wiki_code = 'en.m'
ORDER BY monthly_total desc
LIMIT 100;

SELECT article_title, sum(monthly_total) as total
FROM pagecount
WHERE wiki_code = 'en.m' OR  wiki_code='en.us'
GROUP BY article_title 
SORT BY total desc
LIMIT 100;


SELECT article_title, avg(monthly_total) as total
FROM pagecount
WHERE monthly_total>0
GROUP BY article_title 
SORT BY total desc
LIMIT 100;

CREATE TABLE revision (
    page_title STRING,
    average_views INT 
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';


CREATE TABLE sum_pagecount (
Title STRING,
Total BIGINT
)
CLUSTERED BY (Total) into 4 buckets 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';

INSERT INTO TABLE sum_pagecount
SELECT article_title, sum(monthly_total)
FROM pagecount
WHERE wiki_code='en.m' OR wiki_code='en.us'
GROUP BY article_title;

CREATE TABLE sum_history as 
SELECT  page_title_historical,sum(revision_seconds_to_identity_revert)as seconds
FROM  history
WHERE revision_seconds_to_identity_revert IS NOT NULL And revision_seconds_to_identity_revert>0
GROUP BY page_title_historical


INSERT INTO TABLE revision
SELECT sum_pagecount.Title, round(sum_history.seconds*sum_pagecount.Total/86400)
FROM sum_pagecount
INNER JOIN sum_history ON sum_pagecount.Title=sum_history.page_title_historical;



