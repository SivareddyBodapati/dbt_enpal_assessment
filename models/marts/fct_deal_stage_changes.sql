-- fct_deal_stage_changes.sql 
-- Grain: one row per deal stage entry, enriched with stage name and funnel step
-- A deal can enter the same stage multiple times, we keep every entry and let downstream models decide how to aggregate them
-- This model is a append only event log would be a natural incrremental model, but for simplicity at current size we are using a full refresh here

{% set funnel_map = {
  "Lead Generation": "Step 1",
  "Qualified lead": "Step 2",
  "Needs Assessment": "Step 3",
  "Proposal/Quote Preparation": "Step 4",
  "Negotiation": "Step 5",
  "Closing": "Step 6",
  "Implementation/Onboarding": "Step 7",
  "Follow-up/Customer Success": "Step 8",
  "Renewal/Expansion": "Step 9"
} -%}  -- also can be defined in as a seed table (funnel_map.csv) and can be referenced here with  ref('funnel_map') for easier maintenance

with

    deals as (select * from {{ ref('stg_pipedrive__deal_changes') }}),

    stages as (select * from {{ ref('dim_stages') }}),

    deals_and_stages_joined as (
        select
            deals.*,
            stages.stage_name as kpi_name,
            case 
            {% for stage, kpi in funnel_map.items() %}
                when stage_name = '{{ stage }}' then '{{ kpi }}'
            {% endfor %} 
                else null 
            end as funnel_step
        from deals
        left join stages on deals.new_value = cast(stages.stage_id as varchar) and deals.changed_field_key = 'stage_id'
    )

select *
from deals_and_stages_joined
