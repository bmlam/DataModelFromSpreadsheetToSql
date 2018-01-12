set scan off

begin     
        PKG_UTL_CSV.INSERT2TABLE(
                P_CSV_STRING => 
q'{TABLE_NAME;TABLE_SHORT_NAME;COLUMN_POSITION;COLUMN_NAME;DATA_TYPE;FIELD_LEN_STR;NULLABLE;COMMENTS
D_XF_JOURNEYS;T1;0;;;;;Dimension table for journey in Transformation KPI monitor
D_XF_JOURNEYS;T1;1;JOURNEY_DM_ID;Number;5;N;PK
D_XF_JOURNEYS;T1;2;JOURNEY_NAME;Varchar2;100;N;"e.g. ""Tariff Change"", ""Change account holder"" "
D_XF_JOURNEYS;T1;3;JOURNEY_DESCR;Varchar2;200;Y;"e.g. ""Tariff Change Orders"" for JOURNEY_SHORT_DESCRIPTION, ""Tariff Change"" "
D_XF_JOURNEYS;T1;4;MACRO_JOURNEY;Varchar2;100;N;"e.g. ""Acount Management"" for journey ""Change account holder"""
D_XF_JOURNEYS;T1;5;PROCESS;Varchar2;100;N;"e.g. ""Request to change"" for journey ""Change account holder"""
D_XF_JOURNEYS;T1;6;DOMAIN;Varchar2;100;N;"e.g. ""Customer Care & Servicing"""
D_XF_JOURNEYS;T1;7;INSERT_LOAD_ID;Number;10;N;tbd
D_XF_JOURNEYS;T1;8;LOAD_ID;Number;10;N;tbd
D_XF_CHANNELS;T2;0;;;;;Dimension table for channels in Transformation monitor
D_XF_CHANNELS;T2;1;XF_CHANNEL_DM_ID;Number;5;N;PK
D_XF_CHANNELS;T2;2;XF_CHANNEL_NAME;Varchar2;50;N;"Known values currently: ""Branch"", ""Call Center"", ""Web"" etc"
D_XF_CHANNELS;T2;3;IS_SELF_ASSISTED;Number;1;N;FK to D_FLAGS
D_XF_CHANNELS;T2;4;INSERT_LOAD_ID;Number;10;N;tbd
D_XF_CHANNELS;T2;5;LOAD_ID;Number;10;N;tbd
F_XF_JOURNEYS_DD;T3;0;;;;;"Aggregates of number of interactions"
F_XF_JOURNEYS_DD;T3;1;DATE_ID;;;N;FK to D_DATES
F_XF_JOURNEYS_DD;T3;2;JOURNEY_D_ID;Number;5;N;FK to D_XF_JOURNEYS
F_XF_JOURNEYS_DD;T3;3;XF_CHANNEL_DM_ID;Number;5;N;FK to D_XF_CHANNELS
F_XF_JOURNEYS_DD;T3;4;SYSTEM_STACK_ID;Number;5;N;FK to D_SYSTEM_STACKS
F_XF_JOURNEYS_DD;T3;5;F_INTERACTIONS;Number;5;N;Number of interactions
F_XF_JOURNEYS_DD;T3;6;F_COUNT;Number;5;N;Always 1 since mandatory for Abacus
F_XF_JOURNEYS_DD;T3;7;VERSION_ID;Number;5;N;FK to D_VERSIONS
F_XF_JOURNEYS_DD;T3;8;INSERT_LOAD_ID;Number;10;;
F_XF_JOURNEYS_DD;T3;9;LOAD_ID;Number;10;;
F_XF_JOURNEYS_DD;T3;10;TA_EXAMPLE_SRC_ID;Varchar2;100;Y;An example of a source event id which contributes to the measure F_INTERACTIONS. It is for faster validation when the measure is challenged. It might be computed e.g. as MAX( event_id ) FROM contact_events GROUP BY … An examplary value would be contact_events:123456789
}'                
                ,P_TARGET_OBJECT =>   upper('spreadsheet')
            --    ,P_TARGET_SCHEMA =>     ?P_TARGET_SCHEMA
                ,P_DELETE_BEFORE_INSERT2TABLE => true
                ,P_COL_SEP =>   ';'
           --     ,P_DECIMAL_POINT_CHAR =>        ?P_DECIMAL_POINT_CHAR
                ,P_DATE_FORMAT =>     'yyyy.mm.dd'
                ,P_CREATE_TABLE =>   false);
end;
/                

-- offset escaping by MS Excel export

update spreadsheet
set comments = replace( regexp_replace( comments, '^"|"$', '' ), '""', '"' )
where comments like '%"'
;

commit;

prompt run the next commands in batch mode!

exec p_make_create_table_ddl

set heading off echo off verify off feedback off

spool c:\temp\ddl_scripts.sql


    select text 
    from temp_script_lines 
order by object_name
    , CASE 
        when object_type like 'TABLE' then 0 
        when object_type like 'TABLE COMMENT' then 1
        when object_type like 'COLUMN%COMMENT' then 2
       END
     , object_type
    , line_no
;

spool off