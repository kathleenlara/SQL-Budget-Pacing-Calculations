SELECT
  r.publisher,
  r.industry,
  r.mediaclient,
  MIN(r.rundate) AS start_date,
  MAX(r.rundate) AS end_date,
  r.planned_days,
  1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)) AS days_recorded,
  ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) AS days_paused,
  (1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day))) - (ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) ) AS days_inmarket,
  r.planned_days - ((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day))) - (ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) ) ) AS days_remaining,
  r.objective,
  r.budget,
  ROUND(safe_divide(r.budget, r.planned_days),2) AS daily_budget,
  ROUND(SUM(r.mediacost),2) AS mediacost,
  ROUND(safe_divide(SUM(r.mediacost), ((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day))) - (ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) ))),2) AS avg_daily_spend,
  ROUND(r.planned_days*(safe_divide(SUM(r.mediacost), ((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day))) - (ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) ))) ),2) AS projected_spend,
  ROUND((r.budget) - (r.planned_days*(safe_divide(SUM(r.mediacost), ((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day))) - (ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) ))))),2) AS overunder,
  ROUND(safe_divide(((ROUND(safe_divide(SUM(r.mediacost), ((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day))) - (ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) ))),2))-r.budget),r.budget),2) AS pacing,
 safe_divide((r.budget -  (ROUND(r.planned_days*(safe_divide(SUM(r.mediacost), ((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day))) - (ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) ))) ),2))),(  r.planned_days - ((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day))) - (ABS((1+ ABS(DATE_DIFF(MIN(r.rundate), MAX(r.rundate), day)))-  r.planned_days) ) ))) AS adjust_daily_spend,
FROM

  `analyticsdata-293414.gdsreporting.plandelivery` r
  
GROUP BY
 r.publisher,
  r.industry,
  r.mediaclient,
  r.planned_days,
  r.budget,
  r.objective