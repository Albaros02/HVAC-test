
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { supabaseClient } from "../shared/supabase-client.ts";


serve(async (req) => {
  if (req.method !== "GET") {
    return new Response(
      JSON.stringify({ error: "Method Not Allowed" }),
      { status: 405, headers: { "Content-Type": "application/json" } }
    );
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return new Response(
      JSON.stringify({ error: "Unauthorized" }),
      { status: 401, headers: { "Content-Type": "application/json" } }
    );
  }

  const token = authHeader.split(" ")[1];
  const supabase = supabaseClient;

  const { data: session, error: sessionError } = await supabase.auth.getUser(token)
  if (sessionError || !session) {
    return new Response(
      JSON.stringify({ error: "Unauthorized - Invalid session" }),
      { status: 401, headers: { "Content-Type": "application/json" } }
    );
  }
  const technicianId = session?.user?.id;
  console.log(technicianId)

  if (!technicianId) {
    return new Response(
      JSON.stringify({ error: "Unauthorized - Technician ID not found" }),
      { status: 401, headers: { "Content-Type": "application/json" } }
    );
  }

  const { data, error } = await supabase
    .from("work_orders")
    .select("*")
    .eq("technician_id", technicianId); 
  console.log(data)


  if (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }

  return new Response(
    JSON.stringify({ workOrders: data }),
    { status: 200, headers: { "Content-Type": "application/json" } }
  );
});
