{% macro slugify(string) %}

{#- Lower case the string -#}
{% set string = string | lower %}
{#- Replace spaces and dashes with underscores -#}
{% set string = modules.re.sub('[ -]+', '_', string) %}
{#- Only take letters, numbers, and underscores -#}
{% set string = modules.re.sub('[^a-z0-9_]+', '', string) %}

{{ return(string) }}

{% endmacro %}
