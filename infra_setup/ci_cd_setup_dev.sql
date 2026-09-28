-- =============================================================================
-- DEV
-- =============================================================================

USE ROLE SECURITYADMIN;

CREATE ROLE IF NOT EXISTS FR_DBT_DEV_ADMIN;
CREATE ROLE IF NOT EXISTS FR_CICD_DEV_SERVICE;
CREATE ROLE IF NOT EXISTS FR_DBT_DEV_MONITOR;
CREATE ROLE IF NOT EXISTS FR_DBT_DEVELOPER;


CREATE USER IF NOT EXISTS cicd_DEV_service_user
    TYPE = SERVICE
    WORKLOAD_IDENTITY = (
        TYPE = OIDC
        ISSUER = 'https://token.actions.githubusercontent.com',
        SUBJECT = 'repo:pvs-qb@321677010/getting-started-with-dbt-on-snowflake@1375780582:environment:dev'
    )
    DEFAULT_ROLE = FR_CICD_DEV_SERVICE
    COMMENT = 'CI/CD + Pipeline service user for the dbt project object';
  
GRANT ROLE FR_CICD_DEV_SERVICE TO USER cicd_DEV_service_user;
ALTER USER cicd_DEV_service_user SET DEFAULT_WAREHOUSE = 'tasty_bytes_dbt_wh';

USE ROLE SYSADMIN;
-- CI/CD (deploy) privileges
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE FR_CICD_DEV_SERVICE;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.PROJECT_DEV TO ROLE FR_CICD_DEV_SERVICE;
GRANT CREATE DBT PROJECT ON SCHEMA tasty_bytes_dbt_db.PROJECT_DEV TO ROLE FR_CICD_DEV_SERVICE;
GRANT USAGE ON WAREHOUSE tasty_bytes_dbt_wh TO ROLE FR_CICD_DEV_SERVICE;


GRANT CREATE SCHEMA ON DATABASE TASTY_BYTES_DBT_DB TO ROLE FR_CICD_DEV_SERVICE;
GRANT USAGE ON SCHEMA TASTY_BYTES_DBT_DB.RAW TO ROLE FR_CICD_DEV_SERVICE;
GRANT SELECT ON ALL TABLES IN SCHEMA TASTY_BYTES_DBT_DB.RAW TO ROLE FR_CICD_DEV_SERVICE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA TASTY_BYTES_DBT_DB.RAW TO ROLE FR_CICD_DEV_SERVICE;


USE ROLE ACCOUNTADMIN;

CREATE NETWORK POLICY cicd_service_users_policy_allow_all
  ALLOWED_IP_LIST = ('0.0.0.0/0');

ALTER USER cicd_prod_service_user SET NETWORK_POLICY = cicd_service_users_policy_allow_all;
ALTER USER cicd_TEST_service_user SET NETWORK_POLICY = cicd_service_users_policy_allow_all;
ALTER USER cicd_DEV_service_user SET NETWORK_POLICY = cicd_service_users_policy_allow_all;



-- Pipeline (execute + schedule) privileges
-- GRANT USAGE ON DBT PROJECT tasty_bytes_dbt_db.PROJECT_DEV.DBT_PROJECT TO ROLE FR_CICD_DEV_SERVICE;
-- GRANT CREATE TASK ON SCHEMA tasty_bytes_dbt_db.PROJECT_DEV TO ROLE FR_CICD_DEV_SERVICE;
-- GRANT EXECUTE TASK ON ACCOUNT TO ROLE FR_CICD_DEV_SERVICE;


-- CREATE NETWORK POLICY IF NOT EXISTS github_actions_policy
--   ALLOWED_NETWORK_RULE_LIST = ('SNOWFLAKE.NETWORK_SECURITY.GITHUBACTIONS_GLOBAL')
--   BLOCKED_NETWORK_RULE_LIST = ();

-- ALTER USER cicd_DEV_service_user
--   SET NETWORK_POLICY = github_actions_policy;
  

-- USE ROLE SECURITYADMIN;

-- ALTER USER github_actions_service_user SET WORKLOAD_IDENTITY = (
--   TYPE = OIDC
--   ISSUER = 'https://token.actions.githubusercontent.com'
--   SUBJECT = 'repo:pvs-qb@321677010/getting-started-with-dbt-on-snowflake@1375780582:environment:dev'
-- );


