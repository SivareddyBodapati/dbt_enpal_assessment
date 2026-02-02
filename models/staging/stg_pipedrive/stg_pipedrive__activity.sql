-- stg_pipedrive__activity.sql

with

    source as (select * from {{ source('postgres_public', 'activity') }}),

    final as (
        select
            *
        from source
    )

select *
from final
