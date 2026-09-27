-- rep_sales_funnel_monthly.sql
-- 

with

    deals as (select * from {{ ref('fct_deal_stage_changes') }}),

    activities as (select * from {{ ref('fct_activities') }}),

    deals_report as (
        select 
            date_trunc('month', changed_at) as due_month_date,
            kpi_name,
            max(funnel_step) as funnel_step,
            count(distinct deal_id) as deals_count
        from deals
        where kpi_name is not null
        group by 1, 2
    ),

    activities_report as (
        select 
            date_trunc('month', due_date) as due_month_date,
            kpi_name,
            max(funnel_step) as funnel_step,
            count(distinct deal_id) as deals_count
        from activities
        where funnel_step is not null and is_done = true
        group by 1, 2
    ),

    final_report as (
        select * from deals_report
        union all
        select * from activities_report
    )

select 
    to_char(due_month_date, 'Month YYYY') as month, 
    kpi_name,
    funnel_step,
    deals_count
from final_report
order by due_month_date, funnel_step