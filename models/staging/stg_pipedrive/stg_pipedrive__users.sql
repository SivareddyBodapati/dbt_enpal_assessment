-- stg_pipedrive__users.sql

with

    source as (select * from {{ source('postgres_public', 'users') }}),
    
    final as (
        select
            *
        from source
    )

select * 
from final