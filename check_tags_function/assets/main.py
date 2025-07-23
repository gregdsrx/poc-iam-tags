import os
import json
import logging
import google.cloud.logging
from google.cloud import asset_v1

def check_tags(request):
    project_id = os.environ.get("PROJECT_ID")
    asset_types = json.loads(os.environ.get("ASSET_TYPES","[]"))
    tag_key = os.environ.get("TAG_KEY")

    logging_client = google.cloud.logging.Client()
    logging_client.setup_logging()

    asset_client = asset_v1.AssetServiceClient()
    scope = f"projects/{project_id}"

    untagged_resources = []

    # Requête pour récupérer les ressources
    response = asset_client.list_assets(
        request ={
            "parent":scope,
            "asset_types": asset_types,
            "content_type": asset_v1.ContentType.RESOURCE
        }
    )
    
    for asset in response:
        print(asset)
        resource_fields = asset.resource.data
        resource_tags_struct = resource_fields["resourceTags"]

        if tag_key not in resource_tags_struct:
            untagged_resources.append(asset.name)
        else:
            print(f"✅ {asset.name} contient bien le tag {tag_key}")


    if not untagged_resources:
        message = f"✅ Toutes les ressources ont le tag requis : '{tag_key}'."
        logging.info(message)
    else:
        message = (
            f"[TAG_CHECK] ⚠️ {len(untagged_resources)} ressources sans le tag '{tag_key}':\n"
            + "\n".join(untagged_resources)
        )
        logging.error(message)

    return message
