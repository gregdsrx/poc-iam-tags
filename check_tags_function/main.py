import os
from google.cloud import bigquery
import logging
import google.cloud.logging

def check_tags(request):
    project_id = os.environ.get("GCP_PROJECT")
    tag_key = os.environ.get("TAG_KEY")
    bq_client = bigquery.Client()
    logging_client = google.cloud.logging.Client()
    logging_client.setup_logging()

    untagged_datasets = []

    # List all datasets in the project
    datasets = bq_client.list_datasets(project=project_id)
    for dataset in datasets:
        dataset_ref = bq_client.dataset(dataset.dataset_id, project=project_id)
        dataset_obj = bq_client.get_dataset(dataset_ref)
        tags = dataset_obj.resource_tags or {}
        print(f"Checking dataset: {dataset.dataset_id}")
        print(f"Tags: {dataset_obj.resource_tags}")

        if tag_key not in tags:
            untagged_datasets.append(dataset.dataset_id)

    if not untagged_datasets:
        message = f"✅ Tous les datasets ont le tag requis : '{tag_key}'."
        logging.info(message)
    else:
        message = (
            f"[TAG_CHECK] ⚠️ {len(untagged_datasets)} datasets sans le tag '{tag_key}': "
            + ", ".join(untagged_datasets)
        )
        logging.error(message)

    return message