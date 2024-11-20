import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { supabaseClient } from "../shared/supabase-client.ts"

serve(async (req) => {
  try {

    const supabase = supabaseClient; 

    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "Method Not Allowed" }), {
        status: 405,
        headers: { "Content-Type": "application/json" },
      });
    }

    const { email, password } = await req.json();

    if (!email || !password) {
      return new Response(
        JSON.stringify({ error: "Email and password are required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    console.log({
      email,
      password,
    })

    if (error) {
      console.error("Authentication failed:", error.message);
      return new Response(
        JSON.stringify({ error: "Invalid email or password" }),
        { status: 401, headers: { "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({ accessToken: data.session?.access_token }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (err) {
    console.error("Error processing login:", err);
    return new Response(
      JSON.stringify({ error: "Internal Server Error" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
