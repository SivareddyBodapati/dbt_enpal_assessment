-- stg_pipedrive__deal_changes.sql

with

    source as (select * from {{ source('postgres_public', 'deal_changes') }}),
    
    final as (
        select

            deal_id,
            change_time as changed_at,
            changed_field_key,
            new_value
            
        from source
    )

select * 
from final