-- stg_pipedrive__stages.sql

with

    source as (select * from {{ source('postgres_public', 'stages') }}),
    
    final as (
        select
        
            stage_id,
            stage_name

        from source
    )

select * 
from final