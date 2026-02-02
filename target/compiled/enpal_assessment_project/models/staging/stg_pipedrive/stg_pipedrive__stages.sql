-- stg_pipedrive__stages.sql

with

    source as (select * from "postgres"."public"."stages"),
    
    final as (
        select
            *
        from source
    )

select * 
from final