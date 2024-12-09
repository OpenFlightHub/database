CREATE TABLE "users" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "email_hash" text NOT NULL,
  "password" text,
  "login_token" text,
  "session_token" text,
  "reset_code" text,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "state" integer NOT NULL DEFAULT 0,
  "locale" text NOT NULL DEFAULT 'en-US'
);

COMMENT ON COLUMN "users"."state" IS '0 = invited, 1 = live, 2 = locked, 3 = deleted';
