models:
  - name: fct_monthly_zone_revenue
    description: Monthly revenue aggregation by pickup zone and service type for business reporting
    data_tests:
      - dbt_utils.unique_combination_of_columns:
          arguments:
            combination_of_columns:
              - pickup_zone
              - revenue_month
              - service_type
    columns:
      - name: pickup_zone
        description: Pickup zone where revenue was generated
        data_tests:
          - not_null
      - name: revenue_month
        description: Month for revenue aggregation
        data_tests:
          - not_null
      - name: service_type
        description: Service type (Green or Yellow)
        data_tests:
          - not_null
          - accepted_values:
              arguments:
                values: ['Green', 'Yellow']
      - name: revenue_monthly_total_amount
        description: Monthly sum of total fares
        data_tests:
          - not_null
      - name: total_monthly_trips
        description: Count of trips in the month
        data_tests:
          - not_null
