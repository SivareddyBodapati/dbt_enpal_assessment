-- stg_pipedrive__stages.sql

with

    source as (select * from {{ source('postgres_public', 'stages') }}),
    
    final as (
        select
            *
        from source
    )

select * 
from final