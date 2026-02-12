CREATE OR REPLACE TABLE `final_dataset.touchpoints` AS
WITH unified AS (
  SELECT
    user_id,
    event_dt,
    channel,
    campaign,
    interaction_type,
    SAFE_CAST(conversions AS INT64) AS conversions,
    SAFE_CAST(revenue AS FLOAT64) AS revenue
  FROM `raw_dataset.source_events`
)
SELECT *
FROM unified
WHERE user_id IS NOT NULL
ORDER BY user_id, event_dt;
