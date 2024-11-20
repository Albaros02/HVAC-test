create type "public"."work_order_status" as enum ('Pending', 'InProgress', 'Completed');

create table "public"."materials_used" (
    "id" uuid not null default gen_random_uuid(),
    "work_order_id" uuid not null,
    "material_name" text not null,
    "quantity" integer not null,
    "created_at" timestamp without time zone default CURRENT_TIMESTAMP
);


create table "public"."technicians" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "email" text not null,
    "phone" text not null,
    "created_at" timestamp without time zone default CURRENT_TIMESTAMP
);


create table "public"."work_orders" (
    "id" uuid not null default gen_random_uuid(),
    "technician_id" uuid not null,
    "customer_name" text not null,
    "address" text not null,
    "issue_description" text not null,
    "status" work_order_status default 'Pending'::work_order_status,
    "created_at" timestamp without time zone default CURRENT_TIMESTAMP
);


CREATE UNIQUE INDEX materials_used_pkey ON public.materials_used USING btree (id);

CREATE UNIQUE INDEX technicians_email_key ON public.technicians USING btree (email);

CREATE UNIQUE INDEX technicians_pkey ON public.technicians USING btree (id);

CREATE UNIQUE INDEX work_orders_pkey ON public.work_orders USING btree (id);

alter table "public"."materials_used" add constraint "materials_used_pkey" PRIMARY KEY using index "materials_used_pkey";

alter table "public"."technicians" add constraint "technicians_pkey" PRIMARY KEY using index "technicians_pkey";

alter table "public"."work_orders" add constraint "work_orders_pkey" PRIMARY KEY using index "work_orders_pkey";

alter table "public"."materials_used" add constraint "materials_used_quantity_check" CHECK ((quantity > 0)) not valid;

alter table "public"."materials_used" validate constraint "materials_used_quantity_check";

alter table "public"."materials_used" add constraint "materials_used_work_order_id_fkey" FOREIGN KEY (work_order_id) REFERENCES work_orders(id) ON DELETE CASCADE not valid;

alter table "public"."materials_used" validate constraint "materials_used_work_order_id_fkey";

alter table "public"."technicians" add constraint "technicians_email_key" UNIQUE using index "technicians_email_key";

alter table "public"."work_orders" add constraint "work_orders_technician_id_fkey" FOREIGN KEY (technician_id) REFERENCES technicians(id) ON DELETE CASCADE not valid;

alter table "public"."work_orders" validate constraint "work_orders_technician_id_fkey";


