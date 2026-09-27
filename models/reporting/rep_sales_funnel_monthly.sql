-- rep_sales_funnel_monthly.sql

with

    deals as (select * from {{ ref('fct_deal_stage_changes') }}),

    activities as (select * from {{ ref('fct_activities') }}),

    funnel_step_map as (select * from {{ ref('funnel_step_map') }}),

    deals_report as (
        select 
            date(date_trunc('month', changed_at)) as due_month_date,
            kpi_name,
            count(distinct deal_id) as deals_count
        from deals
        where kpi_name is not null and changed_field_key = 'stage_id'
        group by 1, 2
    ),

    activities_report as (
        select 
            date(date_trunc('month', due_date)) as due_month_date,
            kpi_name,
            count(distinct deal_id) as deals_count
        from activities
        where is_done = true
        group by 1, 2
    ),

    combined_report as (
        select * from deals_report
        union all
        select * from activities_report
    ),

    final_report as (
        select 
            due_month_date,
            kpi_name,
            funnel_step_map.funnel_step,
            combined_report.deals_count
        from combined_report
        inner join funnel_step_map using (kpi_name)
    )   

select 
    to_char(due_month_date, 'FMMonth YYYY') as month, 
    kpi_name,
    funnel_step,
    deals_count
from final_report
order by due_month_date, funnel_step