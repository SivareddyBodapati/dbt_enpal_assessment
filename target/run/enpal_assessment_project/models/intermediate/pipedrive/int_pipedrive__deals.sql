
  create view "postgres"."public_pipedrive_analytics"."int_pipedrive__deals__dbt_tmp"
    
    
  as (
    -- int_pipedrive__deals.sql
-- also can be defined in as a seed table

with

    deals as (select * from "postgres"."public_pipedrive_analytics"."stg_pipedrive__deal_changes"),

    stages as (select * from "postgres"."public_pipedrive_analytics"."stg_pipedrive__stages"),

    deals_and_stages_joined as (
        select
            deals.*,
            stages.stage_name as kpi_name,
            case 
            
                when stage_name = 'Lead Generation' then 'Step 1'
            
                when stage_name = 'Qualified lead' then 'Step 2'
            
                when stage_name = 'Needs Assessment' then 'Step 3'
            
                when stage_name = 'Proposal/Quote Preparation' then 'Step 4'
            
                when stage_name = 'Negotiation' then 'Step 5'
            
                when stage_name = 'Closing' then 'Step 6'
            
                when stage_name = 'Implementation/Onboarding' then 'Step 7'
            
                when stage_name = 'Follow-up/Customer Success' then 'Step 8'
            
                when stage_name = 'Renewal/Expansion' then 'Step 9'
             
                else null 
            end as funnel_step
        from deals
        left join stages on deals.new_value = cast(stages.stage_id as varchar) and deals.changed_field_key = 'stage_id'
    )

select *
from deals_and_stages_joined
  );