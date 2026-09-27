-- int_pipedrive__field_options.sql
-- Grain: one row per option value defined for a Pipedrive field (e.g. one row per stage,
-- one row per lost_reason code). Generic unpivot of field_value_options so any field with
-- a fixed option list can be looked up without needing its own dedicated dimension table
-- (e.g. lost_reason has no source table of its own today, but is covered here).

with

    fields as (select * from {{ ref('stg_pipedrive__fields') }}),

    -- unpivot the JSON array of options for each field into one row per option using jsonb_array_elements postgres function
    options_unpivoted as (
        select
            fields.field_id,
            fields.field_key,
            fields.field_name,
            option ->> 'id' as option_id,
            option ->> 'label' as option_label
        from fields
        cross join lateral jsonb_array_elements(fields.field_value_options) as option
        where fields.field_value_options is not null
    )
    
select *
from options_unpivoted