import json
import os

import azure.functions
from azure.purview.scanning import PurviewScanningClient
from azure.purview.catalog import PurviewCatalogClient
from azure.purview.administration.account import PurviewAccountClient
from azure.identity import ClientSecretCredential 


def get_credentials() -> ClientSecretCredential:
    return ClientSecretCredential(client_id=os.environ["CLIENT_ID"], client_secret=os.environ["CLIENT_SECRET"], tenant_id=os.environ["TENANT_ID"])


def get_scanning_client() -> PurviewScanningClient:
    return PurviewScanningClient(endpoint=f"https://{os.environ['REFERENCE_NAME_PURVIEW']}.scan.purview.azure.com", credential=get_credentials(), logging_enable=True)  


def get_catalog_client() -> PurviewCatalogClient:
    return PurviewCatalogClient(endpoint=f"https://{os.environ['REFERENCE_NAME_PURVIEW']}.purview.azure.com/", credential=get_credentials(), logging_enable=True)


def get_account_client() -> PurviewAccountClient:
    return PurviewAccountClient(endpoint=f"https://{os.environ['REFERENCE_NAME_PURVIEW']}.purview.azure.com/", credential=get_credentials(), logging_enable=True)


def negative_response(err: str) -> azure.functions.HttpResponse:
    return azure.functions.HttpResponse(
        json.dumps({
            "error": err
        }),
        status_code=400,
        mimetype="application/json"
    )