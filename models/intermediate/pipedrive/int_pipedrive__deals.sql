-- int_pipedrive__deals.sql
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
} -%}  -- also can be defined in as a seed table

with

    deals as (select * from {{ ref('stg_pipedrive__deal_changes') }}),

    stages as (select * from {{ ref('stg_pipedrive__stages') }}),

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
