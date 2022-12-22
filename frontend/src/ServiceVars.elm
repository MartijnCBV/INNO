module ServiceVars exposing (..)


baseUrl : String
baseUrl =
    "https://nld-pu-0-shu-data-catalog-00-func.azurewebsites.net/api/"

discoveryEP : String
discoveryEP =
    baseUrl ++ "search"


entityEP : String
entityEP =
    baseUrl ++ "get"

