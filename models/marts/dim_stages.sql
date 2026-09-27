-- dim_stages.sql
-- Grain: stage_id

with

    stages as (select * from {{ ref('stg_pipedrive__stages') }}),
    
    final as (
        select
            stage_id,
            stage_name
        from stages
    )

select * 
from final