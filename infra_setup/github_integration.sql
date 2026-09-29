USE tasty_bytes_dbt_db.integrations;

CREATE OR REPLACE SECRET tasty_bytes_dbt_db.integrations.dbt_github_secret_dev /*git-integration-secret*/
  TYPE = PASSWORD
  USERNAME = 'pvs-qb'
  PASSWORD = '<token>'
  COMMENT = 'GitHub username + PAT for dbt Git repository integration';

-- Requires ACCOUNTADMIN or a role with CREATE INTEGRATION
CREATE OR REPLACE API INTEGRATION dbt_github_api_integration /*QB DW Migration*/
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/pvs-qb/getting-started-with-dbt-on-snowflake', 'https://github.com/pvs-qb/getting-started-with-dbt-on-snowflake.git')
  ALLOWED_AUTHENTICATION_SECRETS = (tasty_bytes_dbt_db.integrations.dbt_github_secret_dev)
  ENABLED = TRUE;


CREATE OR REPLACE GIT REPOSITORY tasty_bytes_dbt_db.integrations.dbt_git_repo_dev
  API_INTEGRATION = dbt_github_api_integration
  GIT_CREDENTIALS = tasty_bytes_dbt_db.integrations.dbt_github_secret_dev
  ORIGIN = 'https://github.com/pvs-qb/getting-started-with-dbt-on-snowflake.git';


ALTER GIT REPOSITORY tasty_bytes_dbt_db.integrations.dbt_git_repo_dev FETCH;
SHOW GIT BRANCHES IN tasty_bytes_dbt_db.integrations.dbt_git_repo_dev;

CREATE SCHEMA IF NOT EXISTS tasty_bytes_dbt_db.project_dev;
CREATE OR REPLACE DBT PROJECT tasty_bytes_dbt_db.project_dev.DBT_PROJECT
  FROM '@tasty_bytes_dbt_db.integrations.dbt_git_repo_dev/branches/dev/tasty_bytes_dbt_demo'
  DEFAULT_TARGET = 'dev';





-- GRANT USAGE ON DBT PROJECT tasty_bytes_dbt_db.project_dev.DBT_PROJECT TO ROLE FR_SVC_DBT_CI_UAT;
-- GRANT MONITOR ON DBT PROJECT tasty_bytes_dbt_db.project_dev.DBT_PROJECT TO ROLE FR_SVC_DBT_CI_UAT;