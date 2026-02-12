CREATE OR REPLACE TABLE `final_dataset.channel_paths_grouped` AS
WITH ordered AS (
  SELECT
    user_id,
    event_dt,
    IFNULL(channel, 'None') AS channel,
    conversions
  FROM `final_dataset.touchpoints`
  ORDER BY user_id, event_dt
),
user_paths AS (
  SELECT
    user_id,
    STRING_AGG(channel, ' > ' ORDER BY event_dt) AS conversion_path,
    SUM(conversions) AS conversions,
    CASE WHEN SUM(conversions) = 0 THEN NULL
         ELSE DATE_DIFF(DATE(MAX(event_dt)), DATE(MIN(event_dt)), DAY)
    END AS days_before_conv
  FROM ordered
  GROUP BY user_id
)
SELECT
  conversion_path,
  SUM(conversions) AS conversions,
  AVG(days_before_conv) AS avg_days_before_conv,
  SUM(CASE WHEN conversions = 0 THEN 1 ELSE 0 END) AS zeropath
FROM user_paths
GROUP BY conversion_path
ORDER BY conversions DESC;
