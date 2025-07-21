import csv
import os
import random
from datetime import datetime, timedelta

# Configuration
output_root = "data"
start_month = 1
end_month = 6
year = 2025
rows_per_file = 100

emails = ["alice@gmail.com", "bob@outlook.com", "carol@yahoo.com", "daniel@example.com"]
sources = ["google_ads", "linkedin", "newsletter", "referral"]
campaigns = ["summer_sale", "webinar_june", "discount_email", "black_friday"]

# Génération
for month in range(start_month, end_month + 1):
    folder_name = f"{year}-{month:02d}"
    folder_path = os.path.join(output_root, folder_name)
    os.makedirs(folder_path, exist_ok=True)

    file_path = os.path.join(folder_path, "marketing_data.csv")

    with open(file_path, mode='w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["user_id", "email", "source", "campaign", "timestamp"])

        for i in range(1, rows_per_file + 1):
            email = random.choice(emails)
            source = random.choice(sources)
            campaign = random.choice(campaigns)
            # Date aléatoire dans le mois
            day = random.randint(1, 28)
            hour = random.randint(0, 23)
            minute = random.randint(0, 59)
            ts = datetime(year, month, day, hour, minute).strftime("%Y-%m-%d %H:%M:%S")
            writer.writerow([i, email, source, campaign, ts])

    print(f"✅ Fichier généré : {file_path}")
