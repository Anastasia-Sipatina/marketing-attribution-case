CREATE OR REPLACE TABLE `final_dataset.channel_paths_grouped` AS
WITH base AS (
  SELECT
    user_id,
    event_dt,
    channel,
    conversions
  FROM `final_dataset.touchpoints`
  WHERE channel IS NOT NULL
),

per_user AS (
  SELECT
    user_id,
    STRING_AGG(channel, ' > ' ORDER BY event_dt) AS conversion_path,
    SUM(conversions) AS conversions,
    DATETIME_DIFF(MAX(event_dt), MIN(event_dt), DAY) AS days_in_journey
  FROM base
  GROUP BY user_id
),

grouped AS (
  SELECT
    conversion_path,
    SUM(conversions) AS conversions,
    SUM(CASE WHEN conversions = 0 THEN 1 ELSE 0 END) AS zeropath,
    AVG(days_in_journey) AS avg_days_in_journey,
    COUNT(*) AS users
  FROM per_user
  GROUP BY conversion_path
)

SELECT *
FROM grouped
ORDER BY conversions DESC;
