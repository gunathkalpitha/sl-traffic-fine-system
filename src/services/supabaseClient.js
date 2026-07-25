import { createClient } from '@supabase/supabase-js';

export const supabaseUrl = 'https://dejaomcdgfnqnkhucjfi.supabase.co';
export const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRlamFvbWNkZ2ZucW5raHVjamZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQwOTY0ODAsImV4cCI6MjA5OTY3MjQ4MH0.DCYRjscFoezYW1ZBVgNXnfQSKUQKrCaur2TD-3FNO6k';

export const supabase = createClient(supabaseUrl, supabaseKey);
