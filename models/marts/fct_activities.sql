-- fct_activities.sql 
-- Grain: one row per activity, enriched with activity type name and funnel step

with

    activities as (select * from {{ ref('stg_pipedrive__activities') }}),

    activity_types as (select * from {{ ref('stg_pipedrive__activity_types') }}),

    activities_and_types_joined as (
        select
            activities.*,
            activity_types.activity_type_name as  kpi_name
        from activities
        left join activity_types using (activity_type)
    )

select *
from activities_and_types_joined
