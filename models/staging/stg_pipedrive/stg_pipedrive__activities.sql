-- stg_pipedrive__activities.sql

with

    source as (select * from {{ source('postgres_public', 'activity') }}),

    final as (
        select

            activity_id,
            type as activity_type,
            assigned_to_user as assigned_to_user_id,
            deal_id,
            done as is_done,
            due_to as due_date
            
        from source
    )

select *
from final
