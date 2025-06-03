USE log_analysis;
SET hive.cli.print.header=true;
SELECT page, visits FROM page_trends LIMIT 10;
