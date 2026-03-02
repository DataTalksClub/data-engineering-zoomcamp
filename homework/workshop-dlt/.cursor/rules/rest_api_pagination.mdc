---
alwaysApply: false
description: Use this rule when writing REST API Source to configure right pagination type for an Endpoint
globs: '**/*.py'
---

# dlt REST API Pagination Configuration Guide
Use this rule when writing REST API Source to configure right pagination type for an Endpoint

This rule explains how to configure different pagination strategies for the `dlt` `rest_api` source. Understanding the API's specific pagination method is crucial for correct configuration.

If you are unsure what type of pagination to use due to lack of information from the api, consider curl-ing for responses (you can probably find credentials in secrets if needed)

We will use class based paginators and not declartive so if you search online in dlthub docs, make sure you do the right type

**Key Principle: Endpoint-Specific Pagination**

While you can set a default paginator at the `client` level, many APIs use *different* pagination methods for different endpoints. Always check the documentation for *each specific endpoint* you intend to load.

If an endpoint uses a different pagination method than the default, define its `paginator` configuration within that specific resource's `endpoint` section to override the client-level setting.

## DLT RESTClient Paginators Guide

To specify the pagination configuration, use the `paginator` field in the `client` or `endpoint` configurations. You should use a dictionary with a string alias in the `type` field along with the required parameters

#### Example

Suppose the API response for `https://api.example.com/posts` contains a `next` field with the URL to the next page:

```json
{
    "data": [
        {"id": 1, "title": "Post 1"},
        {"id": 2, "title": "Post 2"},
        {"id": 3, "title": "Post 3"}
    ],
    "pagination": {
        "next": "https://api.example.com/posts?page=2"
    }
}
```

You can configure the pagination for the `posts` resource like this:

```py
{
    "path": "posts",
    "paginator": {
        "type": "json_link",
        "next_url_path": "pagination.next",
    }
}
```

Currently, pagination is supported only for GET requests. To handle POST requests with pagination, you need to implement a custom paginator

These are the available paginator types to be used in `paginator` field:

* `json_link`: The link to the next page is in the body (JSON) of the response
* `header_link`: The links to the next page are in the response headers
* `offset`: The pagination is based on an offset parameter, with the total items count either in the response body or explicitly provided
* `page_number`: The pagination is based on a page number parameter, with the total pages count either in the response body or explicitly provided
* `cursor`: The pagination is based on a cursor parameter, with the value of the cursor in the response body (JSON)
* `single_page`: The response will be interpreted as a single-page response, ignoring possible pagination metadata


### Paginator arguments

#### json_link
Description: Paginator for APIs where the next page’s URL is included in the response JSON body (e.g. in a field like "next" or within a "pagination" object)​
dlthub.com

Parameters:
`next_url_path` (str, optional): JSONPath to the key in the response JSON that contains the next page URL​

When to Use
Use `json_link` when the API’s JSON response includes a direct link (URL) to the next page of results​

A common pattern is a field such as "next" or a nested key that holds the full URL for the next page. For example, an API might return a JSON structure like:
```json
{
  "data": [ ... ],
  "pagination": {
    "next": "https://api.example.com/posts?page=2"
  }
}
```

In the above, the "pagination.next" field provides the URL for the next page​

By specifying next_url_path="pagination.next", the `json_link` will extract that URL and request the next page automatically. This paginator is appropriate whenever the response body itself contains the next page URL, often indicated by keys like "next", "next_url", or a pagination object with a next link.

#### header_link

Description: Paginator for APIs where the next page’s URL is provided in an HTTP header (commonly the Link header with rel="next")​

Parameters
`links_next_key` (str, optional): The relation key in the Link response header that identifies the next page’s URL​. Default is "next". Example: If the header is Link: <https://api.example.com/items?page=2>; rel="next", the default links_next_key="next" will capture the URL for the next page.

When to Use
Use `header_link` when the API provides pagination links via HTTP headers rather than in the JSON body. This is common in APIs (like GitHub’s) that return a Link header containing URLs for next/prev pages. For example, an HTTP response might include:
```
Link: <https://api.example.com/items?page=2>; rel="next"
Link: <https://api.example.com/items?page=5>; rel="last"
```
In such cases, the `header_link` will parse the Link header, find the URL tagged with rel="next", and follow it​

You should use this paginator if the API documentation or responses indicate that pagination is controlled by header links. (Typically, look for a header named “Link” or similar, with URIs and relation types.) Note: By default, links_next_key="next" works for standard cases. If an API uses a different relation name in the Link header, you can specify that (e.g. HeaderLinkPaginator(links_next_key="pagination-next")).


#### offset
Description: Paginator for APIs that use numeric offset/limit parameters in query strings to paginate results​.
Each request fetches a set number of items (limit), and subsequent requests use an increasing offset.

Parameters
`limit` (int, required): The maximum number of items to retrieve per request (page size)​.
`offset` (int, optional): The starting offset for the first request​. Defaults to 0 (beginning of dataset).
`offset_param` (str, optional): Query parameter name for the offset value​. Default is "offset".
`limit_param` (str, optional): Query parameter name for the page size limit​. Default is "limit".
`total_path` (str or None, optional): JSONPath to the total number of items in the response. If provided, it helps determine when to stop pagination based on total count​. By default this is "total", assuming the response JSON has a field "total" for total item count. Use None if the API doesn’t return a total.
`maximum_offset` (int, optional): A cap on the maximum offset to reach​. If set, pagination stops when offset >= maximum_offset + limit.
`stop_after_empty_page` (bool, optional): Whether to stop when an empty page (no results) is encountered​. Defaults to True. If True, the paginator will halt as soon as a request returns zero items (useful for APIs that don’t provide a total count).
​
. To illustrate, if the first response looks like:
```json
{
  "items": [ ... ],
  "total": 1000
}
```
the paginator knows there are 1000 total items​
 and will continue until the offset reaches 1000 (or the final partial page). If the API does not provide a total count, OffsetPaginator will rely on getting an empty result page to stop by default​. You can also set maximum_offset to limit the number of items fetched (e.g., for testing, or if the API has an implicit max).

When to Use
Use `offset` for APIs that use offset-based pagination. Indicators include endpoint documentation or query parameters like offset (or skip/start) and limit(orpage_size`), and often a field in the response that gives the total count of items. For example, an API endpoint might be called as:
```
GET https://api.example.com/items?offset=0&limit=100
```
and return data with a structure like:
```json
{
  "items": [ ... ],
  "total": 1000
}
```
Here, the presence of offset/limit parameters and a "total" count in the JSON indicates offset-based pagination​. Choose `offset` when you see this pattern. This paginator will automatically increase the offset by the given limit each time, until it either reaches the total count (if known) or encounters an empty result set (if stop_after_empty_page=True). If the API lacks a total count and can continuously scroll, ensure you provide a stopping condition (like maximum_offset) or rely on an empty page to avoid infinite pagination.

#### page_number
Description: Paginator for APIs that use page number indexing in their queries (e.g. page=1, page=2, ... in the URL)​. It increments the page number on each request.

Parameters
`base_page` (int, optional): The starting page index as expected by the API​. This defines what number represents the first page (commonly 0 or 1). Default is 0.
`page` (int, optional): The page number for the first request. If not provided, it defaults to the value of base_page​. (Typically you either use base_page to set the start, or directly give an initial page number.)
`page_param` (str, optional): The query parameter name used for the page number​. Default is "page".
`total_path` (str or None, optional): JSONPath to the total number of pages (or total items) in the response​. If the API provides a total page count or total item count, you can specify its JSON field (e.g. "total_pages"). Defaults to "total" (common key for total count)​. If set to None or not present, the paginator will rely on other stopping criteria.
`maximum_page` (int, optional): The maximum page number to request​. If provided, pagination will stop once this page is reached (useful to limit page count during testing or to avoid excessive requests).
`stop_after_empty_page` (bool, optional): Whether to stop when an empty page is encountered (no results)​. Default is True. If False, you should ensure there is another stop condition (like total_path or maximum_page) to prevent infinite loops.

For example, if a response is:
```json
{
  "items": [ ... ],
  "total_pages": 10
}
```
the paginator knows there are 10 pages in total​ and will not go beyond that. If the API does not provide a total count of pages, PageNumberPaginator will paginate until an empty result page is returned by default​. You can also manually limit pages by maximum_page if needed (e.g., stop after page 5). Setting stop_after_empty_page=False can force it to continue even through empty pages, but then you must have a total_path or maximum_page to avoid infinite loops​


When to Use
Use `page_number` for APIs that indicate pagination through a page number parameter. Clues include endpoints documented like /resource?page=1, /resource?page=2, etc., or the presence of terms like "page" or "page_number" in the API docs. Often, the response will include something like a "total_pages" field or a "page" field in the payload to help manage pagination. For example:
```
GET https://api.example.com/items?page=1
```
Response:
```json
{
  "items": [ ... ],
  "total_pages": 10,
  "page": 1
}
```

In this scenario, the presence of "page" in the request and a total count of pages in the response suggests using a page-number-based paginator​. Choose `page_number` when the API paginates by page index. It will increment the page number on each call. Be mindful of whether the first page is indexed as 0 or 1 in that API (set base_page accordingly). If a total page count is given (e.g., "total_pages" or "last_page"), pass the appropriate JSON path via total_path so the paginator knows when to stop. If no total count is given, the paginator will stop when no more data is returned (or when you hit a maximum_page if you set one).

`cursor`
Description: Paginator for APIs that use a cursor or token in the JSON response to indicate the next page. The next cursor value is extracted from the response body and passed as a query parameter in the subsequent request​

Parameters
`cursor_path` (str, optional): JSONPath to the cursor/token in the response JSON​. Defaults to "cursors.next", which corresponds to a common pattern where the JSON has a "cursors" object with a "next" field.
`cursor_param` (str, optional): The name of the query parameter to send the cursor in for the next request​. Defaults to "after". This is the parameter that the API expects on the URL (or body) to fetch the next page (for example, many APIs use ?after=<token> or ?cursor=<token> in the query string).

When to Use
Use `cursor` when the API provides a continuation token or cursor in the JSON response rather than a direct URL. This is common in APIs where responses include a field like "next_cursor", "next_page_token", or a nested structure for cursors. For example, a response might look like:
```json
{
  "records": [ ... ],
  "cursors": {
    "next": "cursor_string_for_next_page"
  }
}
```

In this case, the value "cursor_string_for_next_page" is a token that the client must send in the next request to get the following page of results. The documentation might say something like “use the next cursor from the response for the next page, via a cursor query parameter.” Indicators for this paginator:
The presence of a field in the JSON that looks like a cryptic token (often base64 or long string) for pagination.
API docs using terminology like “cursor”, “continuation token”, “next token”, or showing request examples with parameters such as after, nextToken, cursor, etc.
Choose JSONResponseCursorPaginator if the API’s pagination is driven by such tokens in the response body. You will configure cursor_path to point at the JSON field containing the token (e.g. "cursors.next" as default, or "next_cursor", etc.), and cursor_param to the name of the query parameter the API expects (commonly "cursor" or "after"). The paginator will then automatically extract the token and append it as ?cursor=<token> (or your specified param name) on subsequent calls​