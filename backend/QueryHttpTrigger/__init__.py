import logging
import json

import azure.functions


def main(req: azure.functions.HttpRequest) -> azure.functions.HttpResponse:
    logging.info("query function was executed")

    query = req.params.get("query")
    if not query:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            query = req_body.get("query")

    if query:
        return azure.functions.HttpResponse(
            json.dumps({
                "query": query,
                "req": "recieved"
            }),
            status_code=200,
            mimetype="application/json"
        )
    else:
        return azure.functions.HttpResponse(
             json.dumps({
                "error": "no query"
             }),
             status_code=400,
             mimetype="application/json"
        )
