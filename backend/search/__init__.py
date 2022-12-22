import json

import azure.functions
from azure.core.exceptions import HttpResponseError
from shared_code import *


def main(req: azure.functions.HttpRequest) -> azure.functions.HttpResponse:
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
            body = {
                "keywords": query
            }
            try:
                resp = catalog_client.discovery.query(search_request=body)
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
