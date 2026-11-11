-- Activity Part 1: Structure of the Data
select *
from information_schema.views
where table_name ilike 'uspto%';

-- Only if needed....
select table_name,
    column_name,
    data_type
from information_schema.columns
where table_name ilike 'uspto%'
order by table_name, ordinal_position;

-- Get column descriptions with: Run the following Cortex Code prompt: Create a comment in this SQL file that describes all of the columns in the <<table name>> table (view)

-- =============================================================================
-- USPTO_PATENT_INDEX Column Descriptions
-- =============================================================================
-- PATENT_ID               VARCHAR    Unique ID for the patent (usable in USPTO PPUBS Basic search)
-- PATENT_EXTENDED_ID      VARCHAR    ID for the patent (usable in Google Patents)
-- INVENTION_TITLE         VARCHAR    Title of the invention
-- PATENT_STATUS           VARCHAR    Status: "Application" or "Grant"
-- PATENT_TYPE             VARCHAR    Type: "design", "utility", "sir", "reissue", or "plant"
-- APPLICATION_DATE        DATE       Date the patent office received the application
-- DOCUMENT_PUBLICATION_DATE DATE     Date the application was published and made public
-- NUMBER_OF_CLAIMS        NUMBER     Count of claims in the patent (defines matter for which protection is sought)
-- CPC_SECTION_DESCRIPTION VARCHAR    CPC top-level section designation
-- CPC_CLASS_DESCRIPTION   VARCHAR    CPC class description (child of section)
-- CPC_SUBCLASS_DESCRIPTION VARCHAR   CPC subclass description (child of class)
-- CPC_GROUP_DESCRIPTION   VARCHAR    CPC group description (child of subclass)
-- CPC_SUBGROUP_DESCRIPTION VARCHAR   CPC subgroup description (child of group)
-- PATENT_RAW_TEXT         VARCHAR    Raw patent text in XML format
-- PATENT_RAW_JSON         OBJECT     Raw patent text in JSON format
-- =============================================================================
select *
from uspto_patent_index
limit 5;

-- =============================================================================
-- USPTO_PATENT_TEXT_ATTRIBUTES Column Descriptions
-- =============================================================================
-- PATENT_ID               VARCHAR    Unique ID for the patent (usable in USPTO PPUBS Basic search)
-- PATENT_EXTENDED_ID      VARCHAR    ID for the patent (usable in Google Patents)
-- VARIABLE                VARCHAR    Description of the patent part and its format (e.g., abstract, claims, description)
-- VALUE                   VARCHAR    The text or JSON structure for that variable
-- =============================================================================
select *
from uspto_patent_text_attributes
limit 5;

-- =============================================================================
-- USPTO_PATENT_RELATIONSHIPS Column Descriptions
-- =============================================================================
-- PATENT_ID               VARCHAR    Unique ID of the patent (usable in USPTO PPUBS Basic search)
-- PATENT_EXTENDED_ID      VARCHAR    ID of the patent (usable in Google Patents)
-- RELATIONSHIP_TYPE       VARCHAR    Relationship between the two patents (e.g., "associated application")
-- RELATED_PATENT_ID       VARCHAR    Unique ID of the related patent (usable in USPTO PPUBS Basic search)
-- RELATED_PATENT_EXTENDED_ID VARCHAR ID of the related patent (usable in Google Patents)
-- =============================================================================
select *
from uspto_patent_relationships
limit 5;

-- =============================================================================
-- USPTO_CONTRIBUTOR_INDEX Column Descriptions
-- =============================================================================
-- CONTRIBUTOR_ID          VARCHAR    Unique ID for this contributor
-- CONTRIBUTOR_NAME        VARCHAR    Name of the contributor
-- CONTRIBUTOR_TYPE        VARCHAR    Type of contributor: "Organization" or "Individual"
-- COUNTRY                 VARCHAR    Two-letter country code of the contributor
-- GEO_ID_COUNTRY          VARCHAR    Unique identifier for the country (joinable to GEOGRAPHY_INDEX)
-- STATE                   VARCHAR    Two-letter US state code (when country is US)
-- GEO_ID_STATE            VARCHAR    Unique identifier for the state (joinable to GEOGRAPHY_INDEX)
-- CITY                    VARCHAR    City of the contributor
-- =============================================================================
select *
from uspto_contributor_index
limit 5;

-- =============================================================================
-- USPTO_PATENT_CONTRIBUTOR_RELATIONSHIPS Column Descriptions
-- =============================================================================
-- CONTRIBUTOR_ID          VARCHAR    Unique ID of the contributor
-- CONTRIBUTION_TYPE       VARCHAR    Relationship of contributor to patent: "Assignee", "Applicant", or "Inventor" (sometimes includes foreign/domestic designation)
-- PATENT_ID               VARCHAR    Unique ID of the patent
-- =============================================================================
select *
from uspto_patent_contributor_relationships
limit 5;


-- Activity Part 2: Dig into a single patent
select *
from uspto_patent_index
limit 1;

-- JSON for one patent (might want to copy to JSONEditorOnline.org to browse it)
select patent_id,
    invention_title,
    patent_raw_json
from uspto_patent_index
limit 1;

-- Title
select patent_id,
    invention_title,
    patent_raw_json:"us-bibliographic-data-application"."invention-title"."#text"::string
from uspto_patent_index
limit 1;

-- Abstract: One paragraph
select patent_id,
    invention_title,
    patent_raw_json,
    patent_raw_json:"abstract".p[0]."#text"
from uspto_patent_index
limit 1;

-- Abstract: Lateral Flatten
select patent_id,
    invention_title,
    patent_raw_json,
    f.*
from uspto_patent_index,
    lateral flatten (input => patent_raw_json:"abstract".p) f
limit 5;

-- Abstract: In the patent text attributes
select *
from uspto_patent_text_attributes
where variable = 'Abstract'
limit 5;


-- Claims
select *
from uspto_patent_text_attributes
where variable = 'Claims'
limit 5;

select patent_id,
    invention_title,
    number_of_claims,
    patent_raw_json
from uspto_patent_index
limit 1;

-- Claim: specific, try 0, 1, 2, etc.
select patent_id,
    invention_title,
    number_of_claims,
    patent_raw_json:claims.claim[2]."claim-text"."#text"::string
from uspto_patent_index
limit 1;


-- TEST OF UPDATED DATA
use database z_db_instructor1;
use schema module4;

select count(*)
from uspto_patents_g06;

select *
from uspto_patents_g06
limit 5;

with cte as (
    select distinct patent_id, invention_title
    from uspto_patents_g06,
        lateral flatten(input => contributors_json) f
    where f.value:name ilike 'openai%'
)
select *
from uspto_patents_g06 g06
inner join cte on cte.patent_id = g06.patent_id;



--- activity for Noc 11--
select *
from information_schema.views
where table_name ilike 'uspto%';


select *
from uspto_patent_index
limit 5;

--activity 2
select *
from uspto_patent_index
limit 5;


select patent_id,
invention_title,
patent_raw_json:"us-bibliographic-data-application"."invention-title"."text"
from uspto_patent_index
limit 1;
