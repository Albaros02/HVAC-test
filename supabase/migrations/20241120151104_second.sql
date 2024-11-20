-- Supabase AI is experimental and may produce incorrect answers
-- Always verify the output before executing

-- Activar Row-Level Security (RLS) en todas las tablas
alter table technicians enable row level security;

alter table work_orders enable row level security;

alter table materials_used enable row level security;

-- Crear políticas para la tabla `technicians`
-- Permitir que cada técnico vea y actualice solo su propio registro
create policy "Allow technician to view own data" on technicians for
select
  using (auth.uid () = id);

create policy "Allow technician to update own data" on technicians
for update
  using (auth.uid () = id);

-- Crear políticas para la tabla `work_orders`
-- Permitir a los técnicos ver y actualizar únicamente sus órdenes de trabajo
create policy "Allow technician to view their work orders" on work_orders for
select
  using (auth.uid () = technician_id);

create policy "Allow technician to update their work orders" on work_orders
for update
  using (auth.uid () = technician_id);

-- Crear políticas para la tabla `materials_used`
-- Permitir a los técnicos gestionar materiales únicamente para sus órdenes de trabajo
-- Política para INSERT en `materials_used`
create policy "Allow technician to insert materials for their work orders" on materials_used for insert
with
  check (
    exists (
      select
        1
      from
        work_orders
      where
        work_orders.id = work_order_id
        and work_orders.technician_id = auth.uid ()
    )
  );

-- Política para UPDATE en `materials_used`
create policy "Allow technician to update materials for their work orders" on materials_used
for update
  using (
    exists (
      select
        1
      from
        work_orders
      where
        work_orders.id = work_order_id
        and work_orders.technician_id = auth.uid ()
    )
  );

-- Política para SELECT en `materials_used`
create policy "Allow technician to view materials for their work orders" on materials_used for
select
  using (
    exists (
      select
        1
      from
        work_orders
      where
        work_orders.id = work_order_id
        and work_orders.technician_id = auth.uid ()
    )
  );