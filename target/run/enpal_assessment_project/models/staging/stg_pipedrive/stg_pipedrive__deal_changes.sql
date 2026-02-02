
  create view "postgres"."public_pipedrive_analytics"."stg_pipedrive__deal_changes__dbt_tmp"
    
    
  as (
    -- stg_pipedrive__deal_changes.sql

with

    source as (select * from "postgres"."public"."deal_changes"),
    
    final as (
        select
            *
        from source
    )

select * 
from final
  );