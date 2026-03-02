---
alwaysApply: false
description: This rule helps identify and extract ALL necessary parameters from API documentation to build a dlt REST API source
globs: '**/*.py'
---

# REST API Parameter Extraction Guide

This rule helps identify and extract ALL necessary parameters from API documentation to build a dlt REST API source. **Crucially, configuration parameters like pagination and incremental loading can vary significantly between different API endpoints. Do not assume a single global strategy applies to all resources.**

## 1. Base Configuration Parameters (Client Level)

These settings usually apply globally but *can* sometimes be overridden at the resource level.

### Client Settings
Look for these in the API documentation (often in "Overview", "Getting Started", "Authentication"):
- **Base URL**:
  - Aliases: "API endpoint", "root URL", "service URL"
  - Example Format: `https://api.example.com/v1/`
  - Find the main entry point for the API version you need.

- **Authentication**:
  - Keywords: "Authentication", "Authorization", "API Keys", "Security"
  - Common Types & dlt Mappings:
    - API Key: Look for "API Key", "Access Token", "Secret Token", "Subscription Key". Map API key value to `api_key`, name to `name`, location (`query` or `header`) to `location`.
    - Bearer Token: Look for "Bearer Token", "JWT". Map token value to `token`.
    - OAuth2: Look for "OAuth", "Client ID", "Client Secret", "Scopes", "Token URL". Map to `client_id`, `client_secret`, `scopes`, `token_url`.
    - Basic Auth: Look for "Basic Authentication". Map to `username` and `password`.
  - Note where credentials go (header, query parameter, request body).
  - **Secret Handling:**
    - **Pattern 1: Using `@dlt.source` or `@dlt.resource` Decorators (Recommended when applicable):**
      Define your source/resource function with arguments having defaults like `api_key: str = dlt.secrets.value` or `client_secret: str = dlt.secrets["specific_key"]`. `dlt` injects the resolved secret when calling the decorated function. You can then use the argument variable directly.
      ```python
      @dlt.source
      def my_api_source(api_key: str = dlt.secrets.value):
          config = {...
              "auth": {"type": "api_key", "api_key": api_key, ...}
              ...
          }
          yield rest_api_source(config)
      ```
    - **Pattern 2: Calling `rest_api_source` Directly (Requires Explicit Resolution):**
      If calling `rest_api_source` *without* a `@dlt.source/resource` decorator on the calling function, you **must resolve the secret explicitly *before* creating the configuration dictionary**. Using `dlt.secrets.value` directly in the dictionary or as a default function argument *will not work* in this context.
      ```python
      def my_api_source_direct():
          # Resolve secret explicitly first
          actual_key = dlt.secrets["my_api_key"]
          
          config = {
              "client": {
                  "auth": {
                      "type": "api_key",
                      "api_key": actual_key, # Use resolved value
                      ...
                  }
              }
          }
          return rest_api_source(config)
      
      # Pipeline call
      pipeline.run(my_api_source_direct())
      ```

- **Global Headers** (Optional):
  - Keywords: "Headers", "Request Headers", "Required Headers"
  - Common Headers: `Accept: application/json`, `Content-Type: application/json`, `User-Agent`.
  - Look for any custom headers required for *all* requests (e.g., `X-Api-Version`). Resource-specific headers go in the resource config.

## 2. Resource / Endpoint Parameters

**Crucially, examine the documentation for EACH resource/endpoint individually.**

### Endpoint Configuration
For each endpoint/resource (e.g., `/users`, `/orders/{order_id}`), find:
- **Path**:
  - Keywords: "Endpoints", "Resources", "API Methods", "Routes"
  - Format: `/resource`, `/v1/resource`. Note any path parameters like `{id}`.
  - This path is appended to the `base_url`.

- **Method**:
  - Usually explicit: `GET`, `POST`, `PUT`, `DELETE`.
  - Default is `GET` if not specified.

- **Resource-Specific Query Parameters**:
  - Keywords: "Parameters", "Query Parameters", "Optional Parameters", "Filtering", "Sorting"
  - Examples:
    - Filtering: `status=active`, `type=customer`, `created_after=...`
    - Sorting: `sort=created_at`, `order=desc`
    - Fields: `fields=id,name,email` (for selecting specific fields)
  - **Note:** Pagination and incremental parameters are covered separately below, but are often listed here too.

- **Request Body** (for `POST`, `PUT`, `PATCH`):
  - Keywords: "Request Body", "Payload", "Data"
  - Note the expected structure (usually JSON).

### Data Selection (Response Parsing)
- Keywords: "Response", "Response Body", "Example Response", "Schema"
- **Identify the JSON path** to the list/array of actual data items within the response.
- Common patterns & dlt `data_selector`:
  - `{"data": [...]}` -> `data`
  - `{"results": [...]}` -> `results`
  - `{"items": [...]}` -> `items`
  - `{"data": {"records": [...]}}` -> `data.records`
  - Sometimes the root is the list: `[{...}, {...}]` -> `.` or `[*] `(or no selector needed)

## 3. Pagination Parameters (Check Per Endpoint!)

**APIs often use different pagination methods for different endpoints. Check EACH endpoint's documentation for its specific pagination details.**

- **Identify the Strategy**: Look for sections titled "Pagination", "Paging", "Handling Large Responses", or examples showing how to get the next set of results.
- **Common Strategies & dlt Mapping**:
  - **Cursor-based**:
    - Keywords: `cursor`, `next_cursor`, `next_page_token`, `continuation_token`, `after`, `marker`
    - Identify: Where is the *next* cursor value found in the response? (e.g., `pagination.next_cursor`, `meta.next`, `links.next.href`). Map this to `cursor_path`.
    - Identify: What is the *query parameter name* to send the next cursor? (e.g., `cursor`, `page_token`, `after`). Map this to `cursor_param`.
    - Identify: What is the parameter for page size? Map to `limit_param` (set this in `endpoint.params`, not the paginator dict).
    - dlt `type`: `cursor`
  - **Offset-based**:
    - Keywords: `offset`, `skip`, `start`, `startIndex`
    - Identify: Parameter name for the starting index/offset. Map to `offset_param`.
    - Identify: Parameter for page size/limit. Map to `limit_param`.
    - Identify: Optional path to total items count in response (e.g., `summary.total`, `total_count`). Map to `total_path`.
    - dlt `type`: `offset`
  - **Page-based**:
    - Keywords: `page`, `page_number`, `pageNum`
    - Identify: Parameter name for the page number. Map to `page_param`.
    - Identify: Parameter for page size/limit. Map to `limit_param`.
    - Identify: Optional path to total pages or total items in response. Map to `total_path`.
    - dlt `type`: `page`
  - **Link Header-based**:
    - Check response headers for a `Link` header (e.g., `Link: <url>; rel="next"`).
    - dlt `type`: `link_header`, `next_url_path`: `next` (usually)
  - **No Pagination**: Some simple endpoints (e.g., fetching a single item by ID, small config lists) might not be paginated.

- **Configure at Resource Level**: If pagination differs between endpoints, define the `paginator` dictionary within the specific resource's `endpoint` configuration in `dlt`, overriding the client/default level.

## 4. Incremental Loading Parameters (Check Per Endpoint!)

Look for ways to fetch only new or updated data since the last run. This also often varies by endpoint. **The `incremental` configuration dictionary *always* requires the `cursor_path` field to be defined, even if `start_param` is also used.**

- **Identify Strategy & Parameters**:
  - **Timestamp-based**:
    - Keywords: `since`, `updated_since`, `modified_since`, `start_time`, `from_date`
    - Identify: The query parameter name used to filter by time (Optional). Map to `start_param`.
    - Identify: The field *in the response items* that contains the relevant timestamp (e.g., `updated_at`, `modified_ts`, `last_activity_date`). **Map this to `cursor_path` (Required)**. `dlt` uses this path to find the value for the next incremental run's state.
    - Note the required date format.
  - **ID-based / Event-based**:
    - Keywords: `since_id`, `min_id`, `last_event_id`, `sequence_number`, `offset` (if used like a cursor)
    - Identify: The query parameter name used to filter by ID/sequence (Optional). Map to `start_param`.
    - Identify: The field *in the response items* containing the ID/sequence. **Map this to `cursor_path` (Required)**.
  - **Cursor-based (using pagination cursor)**:
    - Sometimes the pagination cursor itself can be used for incremental loading if it's persistent and ordered (less common, often needs verification).
    - Map the response cursor path to `cursor_path` (**Required**) and the query parameter to `start_param` (Optional).

- **Initial Value**: Determine a safe starting point (e.g., a specific date `"2023-01-01T00:00:00Z"`, `0` for IDs). Map to `initial_value`.
- **Optional End Param**: If the API supports filtering up to a certain point (e.g., `end_date`, `max_id`), identify the parameter name (map to `end_param`) and potentially a value (map to `end_value`).
- **Optional Conversion**: If the `cursor_path` value needs transformation before being used in `start_param` or `end_param`, define a function and map it to `convert`.
- **Configure at Resource Level**: Define the `incremental` dictionary within the specific resource's `endpoint` configuration if the strategy or fields differ from others.

## 5. Common Documentation Patterns & Examples

(Keep existing examples, they are helpful)

### Authentication Section
```markdown
## Authentication
To authenticate, include your API key in the `Authorization: Bearer <your_token>` header.
```

### Endpoint Documentation Example (with variations)
```markdown
## List Orders
GET /v2/orders

Fetches a list of orders. This endpoint uses offset-based pagination.

Query Parameters:
- limit (integer, optional, default: 50): Max items per page.
- offset (integer, optional, default: 0): Number of items to skip.
- status (string, optional): Filter by status (e.g., 'completed', 'pending').
```

```markdown
## Get Activity Stream
GET /activities/stream

Fetches recent activities. Uses cursor-based pagination.

Query Parameters:
- page_size (integer, optional, default: 100): Number of activities.
- next_page_cursor (string, optional): Cursor from the previous response's `meta.next_page` field.

Response:
{
  "activities": [...],
  "meta": {
    "next_page": "aabbccddeeff"
  }
}
```

## 6. Enhanced Parameter Mapping (API Terminology -> dlt Config)

Map diverse API documentation terms to consistent `dlt` parameters. Identify the API's term first, then find the corresponding `dlt` key.

```yaml
client:
  base_url:
    common_api_terms: ["Base URL", "API Endpoint", "Root URL", "Service URL"]
    dlt_parameter: "client.base_url"
    notes: "Include version path (e.g., /v1/)"
  
  auth:
    api_key_value:
      common_api_terms: ["API Key", "Access Token", "Secret", "Token", "Key"]
      dlt_parameter: "client.auth.api_key"
      notes: "Handled via Secret Handling patterns"
    
    api_key_param_name:
      common_api_terms: ["api_key", "token", "key", "access_token"]
      dlt_parameter: "client.auth.name"
      notes: "Query param name or Header name"
    
    api_key_location:
      common_api_terms: ["Query parameter", "Header"]
      dlt_parameter: "client.auth.location"
      notes: "query or header"
    
    bearer_token:
      common_api_terms: ["Bearer Token", "JWT"]
      dlt_parameter: "client.auth.token"
      notes: "Handled via Secret Handling patterns"

pagination:
  note: "Define per-resource if strategies differ!"
  
  next_cursor_source:
    common_api_terms: ["next_cursor", "next_page", "nextToken", "marker"]
    dlt_parameter: "paginator.cursor_path"
    notes: "JSON path in response"
  
  next_cursor_param:
    common_api_terms: ["cursor", "page_token", "after", "next", "marker"]
    dlt_parameter: "paginator.cursor_param"
    notes: "Query param name to send cursor"
  
  offset_param:
    common_api_terms: ["offset", "skip", "start", "startIndex"]
    dlt_parameter: "paginator.offset_param"
    notes: "Query param name"
  
  page_number_param:
    common_api_terms: ["page", "page_number", "pageNum"]
    dlt_parameter: "paginator.page_param"
    notes: "Query param name"
  
  page_size_param:
    common_api_terms: ["limit", "per_page", "page_size", "count", "maxItems"]
    dlt_parameter: "paginator.limit_param"
    notes: "Query param name"
  
  total_items_source:
    common_api_terms: ["total", "total_count", "total_results", "count"]
    dlt_parameter: "paginator.total_path"
    notes: "Optional JSON path in response"
  
  link_header_relation:
    common_api_terms: ["next", "last"]
    dlt_parameter: "paginator.next_url_path"
    notes: "rel value in Link header"

incremental:
  note: "Define per-resource if strategies differ!"
  
  timestamp_param:
    common_api_terms: ["since", "updated_since", "modified_since", "from"]
    dlt_parameter: "incremental.start_param"
    notes: "Query param name"
  
  timestamp_source:
    common_api_terms: ["updated_at", "modified", "last_updated", "ts"]
    dlt_parameter: "incremental.cursor_path"
    notes: "JSON path in response item"
  
  id_sequence_param:
    common_api_terms: ["since_id", "min_id", "after_id", "sequence"]
    dlt_parameter: "incremental.start_param"
    notes: "Query param name"
  
  id_sequence_source:
    common_api_terms: ["id", "event_id", "sequence_id", "_id"]
    dlt_parameter: "incremental.cursor_path"
    notes: "JSON path in response item"
  
  initial_value:
    common_api_terms: ["N/A"]
    dlt_parameter: "incremental.initial_value"
    notes: "Start value for first run"

data:
  data_array_path:
    common_api_terms: ["data", "results", "items", "records", "entries"]
    dlt_parameter: "endpoint.data_selector"
    notes: "JSON path to the list of items"
```

## 7. Verification Checklist

Before finalizing the configuration:
1.  Verify Base URL format and version.
2.  Confirm Authentication method and *all* required parameters/headers.
3.  Verify Secret Handling pattern matches how the source is called.
4.  **For EACH resource:** Identify its specific pagination strategy (cursor, offset, page, link, none).
5.  **For EACH resource:** Extract the correct pagination parameters (`cursor_path`, `cursor_param`, `offset_param`, `page_param`, `limit_param` etc.) based on its strategy.
6.  **For EACH resource:** Determine if incremental loading is possible and identify its strategy (timestamp, ID, etc.).
7.  **For EACH resource:** Extract the correct incremental parameters (`cursor_path`, `initial_value`, `start_param`, etc.) based on its strategy.
8.  Validate the `data_selector` path for each resource by checking example responses.
9.  Check for any required Global Headers AND Resource-Specific Headers.