-- stg_pipedrive__activity_types.sql

with

    source as (select * from {{ source('postgres_public', 'activity_types') }}),
    
    final as (
        select
            *
        from source
    )

select * 
from final