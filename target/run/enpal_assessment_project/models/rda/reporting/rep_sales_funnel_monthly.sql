
  
    

  create  table "postgres"."public_pipedrive_analytics"."rep_sales_funnel_monthly__dbt_tmp"
  
  
    as
  
  (
    -- rep_sales_funnel_monthly.sql

with

    deals as (select * from "postgres"."public_pipedrive_analytics"."int_pipedrive__deals"),

    activities as (select * from "postgres"."public_pipedrive_analytics"."int_pipedrive__activities"),

    deals_report as (
        select 
            to_char(date_trunc('month', change_time), 'Month YYYY') as month,
            kpi_name,
            max(funnel_step) as funnel_step,
            count(distinct deal_id) as deals_count
        from deals
        where kpi_name is not null
        group by 1, 2
    ),

    activities_report as (
        select 
            to_char(date_trunc('month', due_to), 'Month YYYY') as month,
            kpi_name,
            max(funnel_step) as funnel_step,
            count(distinct deal_id) as deals_count
        from activities
        where funnel_step is not null and done = true
        group by 1, 2
    ),

    final_report as (
        select * from deals_report
        union all
        select * from activities_report
    )

select *
from final_report
order by to_date(month, 'Month YYYY'), funnel_step
  );
  