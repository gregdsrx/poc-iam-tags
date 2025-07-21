import csv
import os
import random
from datetime import datetime

# Configuration
output_root = "sales_data"
start_month = 1
end_month = 6
year = 2025
rows_per_file = 100

user_ids = list(range(1, rows_per_file + 1))  # IDs user matching marketing
campaigns = ["summer_sale", "webinar_june", "discount_email", "black_friday"]
products = ["laptop", "smartphone", "headphones", "smartwatch"]
statuses = ["completed", "pending", "cancelled"]

# Génération
for month in range(start_month, end_month + 1):
    folder_name = f"{year}-{month:02d}"
    folder_path = os.path.join(output_root, folder_name)
    os.makedirs(folder_path, exist_ok=True)

    file_path = os.path.join(folder_path, "sales_data.csv")

    with open(file_path, mode='w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["user_id", "campaign", "product", "amount", "status", "timestamp"])

        for i in range(rows_per_file):
            user_id = user_ids[i]
            campaign = random.choice(campaigns)
            product = random.choice(products)
            amount = round(random.uniform(50, 2000), 2)  # Montant en euros
            status = random.choice(statuses)
            day = random.randint(1, 28)
            hour = random.randint(0, 23)
            minute = random.randint(0, 59)
            ts = datetime(year, month, day, hour, minute).strftime("%Y-%m-%d %H:%M:%S")

            writer.writerow([user_id, campaign, product, amount, status, ts])

    print(f"✅ Fichier généré : {file_path}")
