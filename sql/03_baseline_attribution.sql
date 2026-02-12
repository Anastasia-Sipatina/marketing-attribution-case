-- Models:
-- 1) Last Click
-- 2) First Click
-- 3) Linear

----------------------------------------------------------------
-- 1) LAST CLICK (by channel)

CREATE OR REPLACE TABLE `final_dataset.attribution_last_click` AS
WITH conv_users AS (
  SELECT user_id
  FROM `final_dataset.touchpoints`
  GROUP BY user_id
  HAVING SUM(conversions) > 0
),
last_touch AS (
  SELECT
    t.user_id,
    ARRAY_AGG(t.channel ORDER BY t.event_dt DESC LIMIT 1)[OFFSET(0)] AS channel,
    SUM(t.conversions) AS conversions
  FROM `final_dataset.touchpoints` t
  JOIN conv_users u USING (user_id)
  GROUP BY t.user_id
)
SELECT
  channel,
  SUM(conversions) AS attributed_conversions
FROM last_touch
GROUP BY channel
ORDER BY attributed_conversions DESC
;


-- 2) FIRST CLICK (by channel)

CREATE OR REPLACE TABLE `final_dataset.attribution_first_click` AS
WITH conv_users AS (
  SELECT user_id
  FROM `final_dataset.touchpoints`
  GROUP BY user_id
  HAVING SUM(conversions) > 0
),
first_touch AS (
  SELECT
    t.user_id,
    ARRAY_AGG(t.channel ORDER BY t.event_dt ASC LIMIT 1)[OFFSET(0)] AS channel,
    SUM(t.conversions) AS conversions
  FROM `final_dataset.touchpoints` t
  JOIN conv_users u USING (user_id)
  GROUP BY t.user_id
)
SELECT
  channel,
  SUM(conversions) AS attributed_conversions
FROM first_touch
GROUP BY channel
ORDER BY attributed_conversions DESC
;

-- 3) LINEAR

CREATE OR REPLACE TABLE `final_dataset.attribution_linear` AS
WITH conv_paths AS (
  SELECT
    user_id,
    ARRAY_AGG(channel ORDER BY event_dt) AS path,
    SUM(conversions) AS conversions
  FROM `final_dataset.touchpoints`
  GROUP BY user_id
  HAVING SUM(conversions) > 0
),
exploded AS (
  SELECT
    user_id,
    channel,
    SAFE_DIVIDE(conversions, ARRAY_LENGTH(path)) AS fractional_conversion
  FROM conv_paths,
  UNNEST(path) AS channel
)
SELECT
  channel,
  SUM(fractional_conversion) AS attributed_conversions
FROM exploded
GROUP BY channel
ORDER BY attributed_conversions DESC
;

