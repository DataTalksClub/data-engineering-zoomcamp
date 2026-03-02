---
alwaysApply: false
description: Crucial guidelines to build a dlt rest api source
globs: '**/*.py'
---

## Prerequisities to writing a source

1. VERY IMPORTANT. When writing a new source, you should have an example available in the rest_api_pipeline.py file. 
Use this example or the github rest api source example from dlt's documentation on rest api for the general structure of the code. If you do not see this file rest_api_pipeline.py, ask the user to add it
2. Recall OpenAPI spec. You will figure out the same information that the OpenAPI spec contains for each API.
3. In particular:
- API base url
- type of authentication
- list of endpoints with method GET (you can read data for those)
4. You will figure out additional information that is required for successful data extraction
- type of pagination
- if data from an endpoint can be loaded incrementally
- unwrapping end user data from a response
- write disposition of the endpoint: append, replace, merge
- in case of merge, you need to find primary key that can be compound
5. Some endpoints take data from other endpoints. For example, in the github rest api source example from dlt's documentation, the `comments` endpoint needs `post id` to get the list of comments per particular post. You'll need to figure out such connections
6. **ASK USER IF YOU MISS CRUCIAL INFORMATION** You will make sure the user has provided you with enough information to figure out the above. Below are the most common possibilities
- open api spec (file or link)
- any other api definition, for example Airbyte low code yaml
- a source code in Python, java or c# of such connector or API client
- a documentation of the api or endpoint
7. In case you find more than 10 endpoints and you do not get instructions which you should add to the source, ask user.
8. Make sure you use the right pagination and use exactly the arguments that are available in the pagination guide. do not try to guess anything. remember that we have many paginator types that are configured differently
9. When creating pipeline instance add progress="log" as parameter `pipeline = dlt.pipeline(..., progress="log")`
10. When fixing a bug report focus only on a single cause. ie. incremental, pagination or authentication or wrong dict fields
11. You should have references for paginator types, authenticator types and general reference for rest api in you context. **DO NOT GUESS. DO NOT INVENT CODE. YOU SHOULD HAVE DOCUMENTATION FOR EVERYTHING YOU NEED. IF NOT - ASK USER**


## Look for Required Client Settings
When scanning docs or legacy code, first extract the API-level configuration including:

Base URL:
• The API's base URL (e.g. "https://api.pipedrive.com/").

Authentication:
• The type of authentication used (commonly "api_key" or "bearer").
• The name/key (e.g. "api_token") and its placement (usually in the query).
• Use secrets (e.g. dlt.secrets["api_token"]) to keep credentials secure.

Headers (optional):
• Check if any custom headers are required.

## Authentication Methods
Configure the appropriate authentication method:

API Key Authentication:
```python
"auth": {
    "type": "api_key",
    "name": "api_key",
    "api_key": dlt.secrets["api_key"],
    "location": "query"  # or "header"
}
```

Bearer Token Authentication:
```python
"auth": {
    "type": "bearer",
    "token": dlt.secrets["bearer_token"]
}
```

Basic Authentication:
```python
"auth": {
    "type": "basic",
    "username": dlt.secrets["username"],
    "password": dlt.secrets["password"]
}
```

OAuth2 Authentication:
```python
"auth": {
    "type": "oauth2",
    "token_url": "https://auth.example.com/oauth/token",
    "client_id": dlt.secrets["client_id"],
    "client_secret": dlt.secrets["client_secret"],
    "scopes": ["read", "write"]
}
```

## Find right pagination type
These are the available paginator types to be used in `paginator` field of `endpoint`:

* `json_link`: The link to the next page is in the body (JSON) of the response
* `header_link`: The links to the next page are in the response headers
* `offset`: The pagination is based on an offset parameter, with the total items count either in the response body or explicitly provided
* `page_number`: The pagination is based on a page number parameter, with the total pages count either in the response body or explicitly provided
* `cursor`: The pagination is based on a cursor parameter, with the value of the cursor in the response body (JSON)
* `single_page`: The response will be interpreted as a single-page response, ignoring possible pagination metadata


## Different Paginations per Endpoint are possible
When analyzing the API documentation, carefully check for multiple pagination strategies:

• Different Endpoint Types:
  - Some endpoints might use cursor-based pagination
  - Others might use offset-based pagination
  - Some might use page-based pagination
  - Some might use link-based pagination

• Documentation Analysis:
  - Look for sections describing different pagination methods
  - Check if certain endpoints have special pagination requirements
  - Verify if pagination parameters differ between endpoints
  - Look for examples showing different pagination patterns

• Implementation Strategy:
  - Configure pagination at the endpoint level rather than globally
  - Use the appropriate paginator type for each endpoint
  - Document which endpoints use which pagination strategy
  - Test pagination separately for each endpoint type

## Select the right data from the response
In each endpoint the interesting data (typically an array of objects) may be wrapped
differently. You can unwrap this data by using `data_selector`

Data Selection Patterns:
```python
"endpoint": {
    "data_selector": "data.items.*",  # Basic array selection
    "data_selector": "data.*.items",  # Nested array selection
    "data_selector": "data.{id,name,created_at}",  # Field selection
}
```

## Resource Defaults & Endpoint Details
Ensure that the default settings applied across all resources are clearly delineated:

Defaults:
• Specify the default primary key (e.g., "id").
• Define the write disposition (e.g., "merge").
• Include common endpoint parameters (for example, a default limit value like 50).

Resource-Specific Configurations:
• For each resource, extract the endpoint path, method, and any additional query parameters.
• If incremental loading is supported, include the minimal incremental configuration (using fields like "start_param", "cursor_path", and "initial_value"), but try to keep it within the REST API config portion.

## Incremental Loading Configuration
Configure incremental loading for efficient data extraction. Your task is to get only new data from
the endpoint.

Typically you will identify query parameter that allows to get items that are newer than certain date:

```py
{
    "path": "posts",
    "data_selector": "results",
    "params": {
        "created_since": "{incremental.start_value}",  # Uses cursor value in query parameter
    },
    "incremental": {
        "cursor_path": "created_at",
        "initial_value": "2024-01-25T00:00:00Z",
    },
}
```


## End to end example
Below is an annotated template that illustrates how your output should look. Use it as a reference to guide your extraction:

```python
import dlt
from dlt.sources.rest_api import rest_api_source

# Build the REST API config with cursor-based pagination
source = rest_api_source({
    "client": {
        "base_url": "https://api.pipedrive.com/",  # Extract this from the docs/legacy code
        "auth": {
            "type": "api_key",                    # Use the documented auth type
            "name": "api_token",
            "api_key": dlt.secrets["api_token"],    # Replace with secure token reference
            "location": "query"                     # Typically a query parameter for API keys
        }
    },
    "resource_defaults": {
        "primary_key": "id",                        # Default primary key for resources
        "write_disposition": "merge",               # Default write mode
        "endpoint": {
            "params": {
                "limit": 50                         # Default query parameter for pagination size
            }
        }
    },
    "resources": [
        {
            "name": "deals",                        # Example resource name extracted from code or docs
            "endpoint": {
                "path": "v1/recents",               # Endpoint path to be appended to base_url
                "method": "GET",                    # HTTP method (default is GET)
                "params": {
                    "items": "deal"
                    "since_timestamp": "{incremental.start_value}"
                },
                "data_selector": "data.*",          # JSONPath to extract the actual data
                "paginator": {                      # Endpoint-specific paginator
                    "type": "offset",
                    "offset": 0,
                    "limit": 100
                },
                "incremental": {                    # Optional incremental configuration
                    "cursor_path": "update_time",
                    "initial_value": "2023-01-01 00:00:00"
                }
            }
        }
    ]
})

if __name__ == "__main__":
    pipeline = dlt.pipeline(
        pipeline_name="pipedrive_rest",
        destination="duckdb",
        dataset_name="pipedrive_data"
    )
    pipeline.run(source)
```

## How to Apply This Rule
Extraction:
• Search both the REST API docs and any legacy pipeline code for all mentions of "cursor" or "pagination".
• Identify the exact keys and JSONPath expressions needed for the cursor field.
• Look for authentication requirements and rate limiting information.
• Identify any dependent resources and their relationships.
• Check for multiple pagination strategies across different endpoints.

Configuration Building:
• Assemble the configuration in a dictionary that mirrors the structure in the example.
• Ensure that each section (client, resource defaults, resources) is as declarative as possible.
• Implement proper state management and incremental loading where applicable.
• Configure rate limiting based on API requirements.
• Configure pagination at the endpoint level when multiple strategies exist.

Verification:
• Double-check that the configuration uses the REST API config keys correctly.
• Verify that no extraneous Python code is introduced.
• Test the configuration with mock responses.
• Verify rate limiting and error handling.
• Test pagination separately for each endpoint type.

Customization:
• Allow for adjustments (like modifying the "initial_value") where incremental loading is desired.
• Customize rate limiting parameters based on API requirements.
• Adjust batch sizes and pagination parameters as needed.
• Implement custom error handling and retry logic where necessary.
• Handle different pagination strategies appropriately.