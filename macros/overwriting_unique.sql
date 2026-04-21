{% test unique( model, column_name ) %}

select *
from (

    select
        {{ column_name }}

    from {{ model }}
    where {{ column_name }} is not null 
      and {{ column_name }} != '00000'
      and {{ column_name }} != '11111'  -- Adding the second exclusion here
    group by {{ column_name }}
    having count(*) > 1

) validation_errors

{% endtest %}