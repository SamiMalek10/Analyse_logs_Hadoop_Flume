#!/bin/bash
# Script d'analyse Hive 100% fonctionnel

REPORT_DIR="rapports_finaux"
mkdir -p "$REPORT_DIR"

# Fonction pour formater en CSV
format_as_csv() {
    awk 'BEGIN {FS="\t"; OFS=","} {if(NR==1) $0="# " $0; print $0}'
}

generate_report() {
    local query="$1"
    local report_name="$2"
    local output_file="${REPORT_DIR}/${report_name}_$(date +%Y%m%d_%H%M%S).csv"
    
    echo "📊 Génération du rapport: $report_name"
    echo "🔍 Requête: $query"
    
    # Exécution avec gestion d'erreur
    hive -e "USE log_analysis; $query" 2>&1 | format_as_csv > "$output_file"
    
    # Vérification du succès
    if [ $? -eq 0 ] && [ -s "$output_file" ] && ! grep -q "FAILED" "$output_file"; then
        echo "✅ Rapport généré: $output_file"
        echo "--- Aperçu (5 lignes) ---"
        head -n 5 "$output_file" | column -t -s, | sed 's/^/  /'
        echo "-------------------------"
        return 0
    else
        echo "❌ Échec de génération du rapport: $report_name"
        echo "--- Dernière erreur ---"
        tail -n 5 "$output_file"
        echo "----------------------"
        rm -f "$output_file"
        return 1
    fi
}

echo "🔄 Début de l'analyse des logs..."

# 1. Top pages (sans sous-requête)
generate_report "
SELECT endpoint, count 
FROM endpoint_stats 
ORDER BY count DESC 
LIMIT 10;
" "top_pages"

# 2. Stats HTTP (version simplifiée)
generate_report "
SELECT status, count 
FROM status_stats 
ORDER BY count DESC;
" "http_status"

# 3. Top IPs (sans alias problématique)
generate_report "
SELECT ip, count 
FROM ip_stats 
ORDER BY count DESC 
LIMIT 10;
" "top_ips"

# 4. Codes erreur (sans alias dans ORDER BY)
generate_report "
SELECT status, count 
FROM status_stats 
WHERE status >= 400 
ORDER BY 2 DESC;
" "erreurs_http"

# 5. Calcul des pourcentages (méthode alternative)
generate_report "
SELECT endpoint, count,
       ROUND(count*100.0/SUM(count) OVER (), 2) AS percentage
FROM endpoint_stats
ORDER BY count DESC
LIMIT 10;
" "pages_avec_pourcentages"

echo "✅ Analyse terminée. Rapports disponibles dans: $REPORT_DIR"
