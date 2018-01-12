create or replace procedure p_make_create_table_ddl
authid current_user
as
	c_procname constant varchar2(30) := 'P_MAKE_CREATE_TABLE_DLL';
	c_nl       constant char(1) := chr(10);
	v_cmd varchar2(4000);
	v_tmp varchar2(4000);
--
	procedure write_cmd_as_lines (
		a_object_name varchar2, 
		a_object_type varchar2, 
		a_cmd varchar2) as
		v_line temp_script_lines.text%type;
		v_line_no   pls_integer := 1;
		v_start_pos pls_integer := 1;
		v_found     pls_integer;
	begin
		loop
		--	pck_std_log.debug(c_procname, null, 
		--		'v_start_pos: ' || v_start_pos ||
		--		'v_found: ' || v_found
		--	);
			v_found := instr(v_cmd, c_nl, v_start_pos);
			exit when v_found = 0 or v_start_pos > length(v_cmd);
			v_line := substr(v_cmd, v_start_pos, v_found - v_start_pos);
			insert into temp_script_lines (	
				object_name,   object_type,   line_no,   text
			) values (
				a_object_name, a_object_type, v_line_no, v_line
			);
			v_line_no := v_line_no + 1;
			v_start_pos := v_found + 1;
		end loop;
	end;
--
begin
	v_cmd := 'truncate table temp_script_lines';
	dbms_output.put_line('Run DDL: ' || v_cmd);
	execute immediate v_cmd;
	for tab_rec in (
		select table_short_name, table_name, comments
		from spreadsheet
		where column_position = 0
		order by table_name
	) loop
		v_tmp := null;
		for col_rec in (
			select * 
			from spreadsheet
			where table_short_name = tab_rec.table_short_name
              and column_position != 0
			order by column_position
		) loop
			v_tmp := v_tmp ||
				'  '||lower(col_rec.column_name) || ' ' ||
				upper(col_rec.data_type) || ' '
			;
			if col_rec.field_len_str IS not null then
				v_tmp := v_tmp || '(' || col_rec.field_len_str || ') ' ;
			end if;
			if col_rec.nullable = 'N' then
				v_tmp := v_tmp || 'NOT NULL';
			end if;
			v_tmp := v_tmp || ',' || c_nl
			;
		end loop;
		--
		-- pck_std_log.debug(c_procname, null, 'v_tmp: ' || v_tmp);
		-- there was at least one column found for the table
		if v_tmp IS not null then
			-- chop off last 2 chars which must be comma and new line
			v_tmp := substr(v_tmp, 1, length(v_tmp)-2); 
			v_cmd := 
				'CREATE TABLE ' || lower(tab_rec.table_name) || ' (' || c_nl ||
				v_tmp || c_nl ||
				');' || c_nl
			;
			-- Write command to temp table one line per row
			write_cmd_as_lines(tab_rec.table_name, 'TABLE', v_cmd);
			-- Comment the table
			v_cmd := 'COMMENT ON TABLE ' || lower(tab_rec.table_name) || c_nl || 'IS ''' ||
				replace(tab_rec.comments, '''', '''''') || '''' || c_nl || ';' || c_nl
			;
			write_cmd_as_lines(tab_rec.table_name, 'TABLE COMMENT', v_cmd);
			-- Comment the columns
			for col_rec in (
				select * 
				from spreadsheet
				where table_short_name = tab_rec.table_short_name
	              and column_position != 0
				  and comments IS not null
				order by column_position
			) loop
				v_cmd := 
					'COMMENT ON COLUMN ' || 
					lower(tab_rec.table_name || '.' || col_rec.column_name) || ' IS ' || c_nl || '''' ||
					replace(col_rec.comments, '''', '''''') || '''' || c_nl || ';' || c_nl
				;
				write_cmd_as_lines(
					tab_rec.table_name, 
					'COLUMN ' || to_char(col_rec.column_position) || ' COMMENT',
					v_cmd);
			end loop;
		else
			dbms_output.put_line('No columns found for table: ' || tab_rec.table_name);
		end if; -- at least one column found in loop over columns
	end loop;
end;
/

show errors