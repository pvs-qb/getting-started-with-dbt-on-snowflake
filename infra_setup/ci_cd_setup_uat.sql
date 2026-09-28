
-- =============================================================================
-- TEST
-- =============================================================================

USE ROLE SECURITYADMIN;

CREATE ROLE IF NOT EXISTS FR_DBT_TEST_ADMIN;
CREATE ROLE IF NOT EXISTS FR_CICD_TEST_SERVICE;
CREATE ROLE IF NOT EXISTS FR_DBT_TEST_MONITOR;


CREATE USER IF NOT EXISTS cicd_TEST_service_user
    TYPE = SERVICE
    WORKLOAD_IDENTITY = (
        TYPE = OIDC
        ISSUER = 'https://token.actions.githubusercontent.com',
        SUBJECT = 'repo:pvs-qb@321677010/getting-started-with-dbt-on-snowflake@1375780582:environment:test'
    )
    DEFAULT_ROLE = FR_CICD_TEST_SERVICE
    COMMENT = 'CI/CD + Pipeline service user for the dbt project object';
  
GRANT ROLE FR_CICD_TEST_SERVICE TO USER cicd_TEST_service_user;
ALTER USER cicd_TEST_service_user SET DEFAULT_WAREHOUSE = 'tasty_bytes_dbt_wh_TEST';

USE ROLE SYSADMIN;

-- CI/CD (deploy) privileges
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE FR_CICD_TEST_SERVICE;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.PROJECT_TEST TO ROLE FR_CICD_TEST_SERVICE;
GRANT CREATE DBT PROJECT ON SCHEMA tasty_bytes_dbt_db.PROJECT_TEST TO ROLE FR_CICD_TEST_SERVICE;
GRANT USAGE ON WAREHOUSE tasty_bytes_dbt_wh_TEST TO ROLE FR_CICD_TEST_SERVICE;

GRANT CREATE SCHEMA ON DATABASE TASTY_BYTES_DBT_DB TO ROLE FR_CICD_TEST_SERVICE;
-- same for TEST role, since it'll hit the identical wall
GRANT USAGE ON SCHEMA TASTY_BYTES_DBT_DB.RAW TO ROLE FR_CICD_TEST_SERVICE;
GRANT SELECT ON ALL TABLES IN SCHEMA TASTY_BYTES_DBT_DB.RAW TO ROLE FR_CICD_TEST_SERVICE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA TASTY_BYTES_DBT_DB.RAW TO ROLE FR_CICD_TEST_SERVICE;


