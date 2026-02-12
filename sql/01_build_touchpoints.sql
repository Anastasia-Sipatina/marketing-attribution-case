-- Build a touchpoints table for attribution models (BigQuery SQL)

CREATE OR REPLACE TABLE `final_dataset.touchpoints` AS
SELECT
  clientID AS user_id,
  DATETIME(datetime) AS event_dt,

  IFNULL(Channel,   'None') AS channel,
  IFNULL(Publisher, 'None') AS publisher,
  IFNULL(Campaign,  'None') AS campaign,
  IFNULL(Creative,  'None') AS creative,

  SAFE_CAST(impressions AS INT64) AS impressions,
  SAFE_CAST(visits AS INT64) AS clicks,
  SAFE_CAST(conversions AS INT64) AS conversions,
  IFNULL(Path_type, 'Primary') AS path_type

FROM `raw_dataset.df_metrics_and_attr`
WHERE clientID IS NOT NULL
ORDER BY user_id, event_dt;
