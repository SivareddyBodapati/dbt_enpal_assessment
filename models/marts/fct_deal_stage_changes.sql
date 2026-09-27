-- fct_deal_stage_changes.sql 
-- Grain: one row per deal stage entry, enriched with stage name and funnel step
-- A deal can enter the same stage multiple times, we keep every entry and let downstream models decide how to aggregate them
-- This model is a append only event log would be a natural incrremental model, but for simplicity at current size we are using a full refresh here

with

    deals as (select * from {{ ref('stg_pipedrive__deal_changes') }}),

    stages as (select * from {{ ref('dim_stages') }}),

    deals_and_stages_joined as (
        select
            deals.*,
            stages.stage_name as kpi_name
        from deals
        left join stages on deals.new_value = cast(stages.stage_id as varchar) and deals.changed_field_key = 'stage_id'
    )

select *
from deals_and_stages_joined
