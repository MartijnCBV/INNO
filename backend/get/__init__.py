import json

import azure.functions as func
from azure.core.exceptions import HttpResponseError
from shared_code import *


def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        catalog_client = get_catalog_client()
        query = req.params.get("query")
        if not query:
            try:
                req_body = req.get_json()
            except ValueError:
                pass
            else:
                query = req_body.get("query")

        if query:
            try:
                resp = catalog_client.entity.get_by_guid(query)
                catalog_client.close()
            except HttpResponseError as ae:
                catalog_client.close()
                return negative_response(ae)

            return azure.functions.HttpResponse(
                json.dumps(resp),
                status_code=200,
                mimetype="application/json"
            )
        else:
            return negative_response("no query")
    except ValueError as e:
        catalog_client.close()
        return negative_response(e)
