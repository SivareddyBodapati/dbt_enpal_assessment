
  create view "postgres"."public_pipedrive_analytics"."stg_pipedrive__activity_types__dbt_tmp"
    
    
  as (
    -- stg_pipedrive__activity_types.sql

with

    source as (select * from "postgres"."public"."activity_types"),
    
    final as (
        select
            *
        from source
    )

select * 
from final
  );