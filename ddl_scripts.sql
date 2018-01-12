
CREATE TABLE d_xf_channels (    
  xf_channel_dm_id NUMBER (5) NOT NULL, 
  xf_channel_name VARCHAR2 (50) NOT NULL,   
  is_self_assisted NUMBER (1) NOT NULL, 
  insert_load_id NUMBER (10) NOT NULL,  
  load_id NUMBER (10) NOT NULL  
);  
COMMENT ON TABLE d_xf_channels  
IS 'Dimension table for channels in Transformation monitor' 
;   
COMMENT ON COLUMN d_xf_channels.xf_channel_dm_id IS 
'PK'    
;   
COMMENT ON COLUMN d_xf_channels.xf_channel_name IS  
'Known values currently: "Branch", "Call Center", "Web" etc'    
;   
COMMENT ON COLUMN d_xf_channels.is_self_assisted IS 
'FK to D_FLAGS' 
;   
COMMENT ON COLUMN d_xf_channels.insert_load_id IS   
'tbd'   
;   
COMMENT ON COLUMN d_xf_channels.load_id IS  
'tbd'   
;   

CREATE TABLE d_xf_journeys (    
  journey_dm_id NUMBER (5) NOT NULL,    
  journey_name VARCHAR2 (100) NOT NULL, 
  journey_descr VARCHAR2 (200) ,    
  macro_journey VARCHAR2 (100) NOT NULL,    
  process VARCHAR2 (100) NOT NULL,  
  domain VARCHAR2 (100) NOT NULL,   
  insert_load_id NUMBER (10) NOT NULL,  
  load_id NUMBER (10) NOT NULL  
);  
COMMENT ON TABLE d_xf_journeys  
IS 'Dimension table for journey in Transformation KPI monitor'  
;   
COMMENT ON COLUMN d_xf_journeys.journey_dm_id IS    
'PK'    
;   
COMMENT ON COLUMN d_xf_journeys.journey_name IS 
'e.g. "Tariff Change", "Change account holder" '    
;   
COMMENT ON COLUMN d_xf_journeys.journey_descr IS    
'e.g. "Tariff Change Orders" for JOURNEY_SHORT_DESCRIPTION, "Tariff Change" '   
;   
COMMENT ON COLUMN d_xf_journeys.macro_journey IS    
'e.g. "Acount Management" for journey "Change account holder"'  
;   
COMMENT ON COLUMN d_xf_journeys.process IS  
'e.g. "Request to change" for journey "Change account holder"'  
;   
COMMENT ON COLUMN d_xf_journeys.domain IS   
'e.g. "Customer Care & Servicing"'  
;   
COMMENT ON COLUMN d_xf_journeys.insert_load_id IS   
'tbd'   
;   

COMMENT ON COLUMN d_xf_journeys.load_id IS  
'tbd'   
;   
CREATE TABLE f_xf_journeys_dd ( 
  date_id  NOT NULL,    
  journey_d_id NUMBER (5) NOT NULL, 
  xf_channel_dm_id NUMBER (5) NOT NULL, 
  system_stack_id NUMBER (5) NOT NULL,  
  f_interactions NUMBER (5) NOT NULL,   
  f_count NUMBER (5) NOT NULL,  
  version_id NUMBER (5) NOT NULL,   
  insert_load_id NUMBER (10) ,  
  load_id NUMBER (10) , 
  ta_example_src_id VARCHAR2 (100)  
);  
COMMENT ON TABLE f_xf_journeys_dd   
IS 'Aggregates of number of interactions'   
;   
COMMENT ON COLUMN f_xf_journeys_dd.date_id IS   
'FK to D_DATES' 
;   
COMMENT ON COLUMN f_xf_journeys_dd.ta_example_src_id IS 
'An example of a source event id which contributes to the measure F_INTERACTIONS. It is for faster validation when the m
easure is challenged. It might be computed e.g. as MAX( event_id ) FROM contact_events GROUP BY ??? An examplary value w
ould be contact_events:123456789'   
    
;   
COMMENT ON COLUMN f_xf_journeys_dd.journey_d_id IS  
'FK to D_XF_JOURNEYS'   
;   
COMMENT ON COLUMN f_xf_journeys_dd.xf_channel_dm_id IS  
'FK to D_XF_CHANNELS'   
;   
COMMENT ON COLUMN f_xf_journeys_dd.system_stack_id IS   
'FK to D_SYSTEM_STACKS' 
;   
COMMENT ON COLUMN f_xf_journeys_dd.f_interactions IS    
'Number of interactions'    
;   
COMMENT ON COLUMN f_xf_journeys_dd.f_count IS   
'Always 1 since mandatory for Abacus'   
;   
COMMENT ON COLUMN f_xf_journeys_dd.version_id IS    
'FK to D_VERSIONS'  
;   

