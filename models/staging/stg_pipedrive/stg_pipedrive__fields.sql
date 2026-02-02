-- stg_pipedrive__fields.sql

with

    source as (select * from {{ source('postgres_public', 'fields') }}),
    
    final as (
        select
            *
        from source
    )

select * 
from final