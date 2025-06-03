#!/usr/bin/env python3
"""
Script pour générer des logs web simulés au format Apache Common Log
"""

import random
import time
import os
from datetime import datetime

# Constantes
LOG_FILE = "/tmp/weblogs/access.log"
USERS = ["user1", "user2", "user3", "user4", "user5"]
IPS = ["192.168.1." + str(i) for i in range(1, 21)]
PAGES = ["/", "/home", "/about", "/contact", "/products", "/services", "/blog", "/login", "/register", "/dashboard"]
STATUS_CODES = [200, 200, 200, 200, 200, 301, 302, 404, 404, 500]
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1 Safari/605.1.15",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36"
]

# Assurer que le répertoire de logs existe
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)

def generate_log_entry():
    """Génère une entrée de log au format Apache Common Log"""
    ip = random.choice(IPS)
    user = random.choice(USERS)
    timestamp = datetime.now().strftime("%d/%b/%Y:%H:%M:%S +0000")
    method = random.choice(["GET", "POST", "PUT", "DELETE"])
    page = random.choice(PAGES)
    protocol = "HTTP/1.1"
    status = random.choice(STATUS_CODES)
    size = random.randint(1024, 10240)
    user_agent = random.choice(USER_AGENTS)
    
    log_entry = f'{ip} - {user} [{timestamp}] "{method} {page} {protocol}" {status} {size} "{user_agent}"'
    return log_entry

def main():
    """Fonction principale qui génère des logs en continu"""
    print(f"Génération de logs dans {LOG_FILE}...")
    
    try:
        with open(LOG_FILE, "a") as f:
            while True:
                log_entry = generate_log_entry()
                f.write(log_entry + "\n")
                f.flush()
                # Attendre entre 0.5 et 2 secondes avant de générer une nouvelle entrée
                time.sleep(random.uniform(0.5, 2))
    except KeyboardInterrupt:
        print("\nArrêt de la génération de logs")

if __name__ == "__main__":
    main()
