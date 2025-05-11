CREATE TABLE revenue_data (
  region VARCHAR(100),
  revenue_2011 INT,
  revenue_2016 INT,
  grand_total INT
);

INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('Australia', 2529914, 3591983, 21302059);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('New South Wales', 1175012, 1575353, 9203495);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('Queensland', 622846, 813837, 5066267);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('Victoria', 521784, 918707, 5054839);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('Canada', 789798, 1663400, 7935738);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('British Columbia', 773245, 1655765, 7877890);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('France', 946624, 1803197, 8432872);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('Seine (Paris)', 164430, 344171, 1643279);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('Germany', 833603, 2223502, 8978596);
INSERT INTO revenue_data (region, revenue_2011, revenue_2016, grand_total) VALUES ('United States', 3041468, 5810494, 27975547);

-- evaluating top perfoming regtions by year
-- Rank each region within its country based on revenue in 2016:
SELECT
  region,
  revenue_2016,
  ROW_NUMBER() OVER (ORDER BY revenue_2016 DESC) AS row_num
FROM revenue_data;


-- Identify which regions tie in revenue and how they rank.
-- am using the RANK() which assigns the same rank to ties and skips numbers.
SELECT
  region,
  revenue_2016,
  RANK() OVER (ORDER BY revenue_2016 DESC) AS revenue_rank
FROM revenue_data;

-- Measuring revenue change between adjacent regions.
-- LAG() gets the value from a previous row.
-- LEAD() gets the value from the next row.
SELECT
  region,
  revenue_2016,
  LAG(revenue_2016) OVER (ORDER BY revenue_2016 DESC) AS prev_revenue,
  LEAD(revenue_2016) OVER (ORDER BY revenue_2016 DESC) AS next_revenue
FROM revenue_data;

--   Using It for Trend-Based Forecasting (Heuristic) 
--  estimating next year’s revenue based on the trend between 2011 and 2016:
-- This is a very simplistic forecast assuming linear growth.
SELECT
  region,
  revenue_2011,
  revenue_2016,
  (revenue_2016 - revenue_2011) / 5 AS avg_yearly_growth,
  revenue_2016 + ((revenue_2016 - revenue_2011) / 5) AS forecast_2017
FROM revenue_data;
-- Classifying regions into performance groups.
-- NTILE(n) – Divide rows into equal parts (quantiles)
-- Distributing rows into n roughly equal groups. Useful for quartiles, deciles, etc.

SELECT
  region,
  revenue_2016,
  NTILE(4) OVER (ORDER BY revenue_2016 DESC) AS revenue_quartile
FROM revenue_data;

-- Compare each region to the global or group average.
-- SUM() / AVG() OVER() – Aggregate over partitions
-- Perform cumulative or group-based aggregations without collapsing rows.

SELECT
  region,
  revenue_2016,
  SUM(revenue_2016) OVER () AS total_revenue_2016,
  AVG(revenue_2016) OVER () AS avg_revenue_2016
FROM revenue_data;


-- which region is too far ahead or behind as compared to others.
-- i will use PERCENT_RANK() / CUME_DIST() – Percentile calculations
-- PERCENT_RANK() shows the relative standing of a row within a group (0–1).

-- CUME_DIST() gives the cumulative distribution.
SELECT
  region,
  revenue_2016,
  PERCENT_RANK() OVER (ORDER BY revenue_2016) AS percent_rank,
  CUME_DIST() OVER (ORDER BY revenue_2016) AS cumulative_dist
FROM revenue_data;

