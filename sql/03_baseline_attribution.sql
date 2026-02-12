
-- Last touch attribution (by channel)
CREATE OR REPLACE TABLE `final_dataset.last_touch_attribution` AS
WITH conv_users AS (
  SELECT user_id
  FROM `final_dataset.touchpoints`
  GROUP BY user_id
  HAVING SUM(conversions) > 0
),
last_touch AS (
  SELECT
    t.user_id,
    ARRAY_AGG(t.channel ORDER BY t.event_dt DESC LIMIT 1)[OFFSET(0)] AS last_channel,
    SUM(t.conversions) AS conversions
  FROM `final_dataset.touchpoints` t
  JOIN conv_users u USING (user_id)
  GROUP BY t.user_id
)
SELECT
  last_channel AS channel,
  SUM(conversions) AS attributed_conversions
FROM last_touch
GROUP BY channel
ORDER BY attributed_conversions DESC;
