-- see https://medium.com/launchpad-lab/postgres-triggers-with-listen-notify-565b44ccd782 and https://www.postgresql.org/docs/17/sql-notify.html and https://www.postgresql.org/docs/current/functions-json.html


-- notify when change happens on some specific tables

CREATE OR REPLACE FUNCTION notify_change() RETURNS trigger AS $notify_change$
    BEGIN
		PERFORM pg_notify(
			'notify_change',
			json_build_object(
			  'id', NEW.id::text,
			  'table', TG_TABLE_NAME
			)::text
		  );

        RETURN NULL;
    END;
$notify_change$ LANGUAGE plpgsql;

-- notify when insert happens on some specific tables

CREATE OR REPLACE FUNCTION notify_insert() RETURNS trigger AS $notify_insert$
    BEGIN
		PERFORM pg_notify(
			'notify_insert',
			json_build_object(
			  'id', NEW.id::text,
			  'table', TG_TABLE_NAME,
        'data', NEW
			)::text
		  );

        RETURN NULL;
    END;
$notify_insert$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER notify_insert_drone_data AFTER INSERT ON drone_data FOR EACH ROW EXECUTE FUNCTION notify_insert();
CREATE OR REPLACE TRIGGER notify_insert_remote_controller_data AFTER INSERT ON remote_controller_data FOR EACH ROW EXECUTE FUNCTION notify_insert();

CREATE OR REPLACE TRIGGER notify_insert_drone_media AFTER INSERT ON drone_media FOR EACH ROW EXECUTE FUNCTION notify_insert();
