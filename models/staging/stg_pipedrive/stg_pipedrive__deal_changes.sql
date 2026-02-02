-- stg_pipedrive__deal_changes.sql

with

    source as (select * from {{ source('postgres_public', 'deal_changes') }}),
    
    final as (
        select
            *
        from source
    )

select * 
from final