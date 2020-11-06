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


SELECT page_title_historical, page_revision_count, revision_seconds_to_identity_revert
FROM history
ORDER BY page_revision_count DESC
LIMIT 100;

CREATE EXTERNAL TABLE clickstream (
    REFERRER STRING,
    REFERRED STRING,
    TYPE STRING,
    COUNT INT)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t';

LOAD DATA INPATH '/mnt/c/Users/issac/Files/Files/Ravature/clickstream-enwiki-2020-09.tsv' INTO TABLE clickstream;


SELECT *
FROM clickstream
WHERE REFERRED= 'Administrator_intervention_against_vandalism'
ORDER BY COUNT
LIMIT 100;


SELECT page_title_historical, page_revision_count, revision_seconds_to_identity_revert
FROM history
WHERE page_title_historical  != 'Administrator_intervention_against_vandalism'
ORDER BY page_revision_count DESC
LIMIT 100;

SELECT *
FROM clickstream
WHERE REFERRED= "Administrators'_noticeboard/Incidents"
ORDER BY COUNT
LIMIT 100;

SELECT page_title_historical, page_revision_count, revision_seconds_to_identity_revert
FROM history
ORDER BY revision_seconds_to_identity_revert DESC
LIMIT 100;


SELECT *
FROM clickstream
WHERE REFERRED= "Tokyo_Ghoul"
ORDER BY COUNT DESC
LIMIT 100;

SELECT *
FROM clickstream
WHERE REFERRER= "Tokyo_Ghoul" and type='link'
ORDER BY COUNT DESC
LIMIT 100;

SELECT page_title_historical, page_revision_count, revision_seconds_to_identity_revert
FROM history
WHERE page_title_historical ='List_of_Tokyo_Ghoul_episodes'
ORDER BY page_revision_count DESC
LIMIT 100;

SELECT page_title_historical, sum(page_revision_count) as sum_count
FROM history
WHERE page_title_historical ='List_of_Tokyo_Ghoul_episodes'
GROUP BY page_title_historical
ORDER BY sum_count DESC
LIMIT 100;