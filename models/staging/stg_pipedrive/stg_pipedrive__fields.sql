-- stg_pipedrive__fields.sql

with

    source as (select * from {{ source('postgres_public', 'fields') }}),
    
    final as (
        select
        
            id as field_id,
            field_key,
            name as field_name,
            field_value_options

        from source
    )

select * 
from final