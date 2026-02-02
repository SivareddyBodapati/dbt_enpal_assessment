
  create view "postgres"."public_pipedrive_analytics"."stg_pipedrive__stages__dbt_tmp"
    
    
  as (
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
  );