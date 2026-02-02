-- int_pipedrive__activities.sql

with

    activities as (select * from {{ ref('stg_pipedrive__activity') }}),

    activity_types as (select * from {{ ref('stg_pipedrive__activity_types') }}),

    activities_and_types_joined as (
        select
            activities.*,
            activity_types.name as  kpi_name,
            case 
                when activity_types.name = 'Sales Call 1' then 'Step 2.1'
                when activity_types.name = 'Sales Call 2' then 'Step 3.1'
                else null
            end as funnel_step
        from activities
        left join activity_types using (type)
    )

select *
from activities_and_types_joined
