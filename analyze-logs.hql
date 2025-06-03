-- Script d'analyse fonctionnel
USE log_analysis;

-- 1. Statistiques globales
SELECT 'Statistiques Globales' AS title;
SELECT COUNT(DISTINCT endpoint) AS nb_endpoints FROM endpoint_stats;
SELECT COUNT(DISTINCT status) AS nb_status_codes FROM status_stats;
SELECT COUNT(DISTINCT ip) AS nb_ips FROM ip_stats;

-- 2. Top 5 des pages
SELECT 'Top 5 des Pages' AS title;
SELECT endpoint, count 
FROM endpoint_stats 
ORDER BY count DESC 
LIMIT 5;

-- 3. Distribution des codes HTTP
SELECT 'Distribution des Codes HTTP' AS title;
SELECT status, count,
       ROUND(count*100.0/(SELECT SUM(count) FROM status_stats), 2) AS percentage
FROM status_stats
ORDER BY count DESC;

-- 4. Adresses IP suspectes
SELECT 'IPs avec +10 requêtes' AS title;
SELECT ip, count 
FROM ip_stats 
WHERE count > 10
ORDER BY count DESC;
