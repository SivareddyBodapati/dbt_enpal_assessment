
  create view "postgres"."public_pipedrive_analytics"."stg_pipedrive__activity__dbt_tmp"
    
    
  as (
    -- stg_pipedrive__activity.sql

with

    source as (select * from "postgres"."public"."activity"),

    final as (
        select
            *
        from source
    )

select *
from final
  );