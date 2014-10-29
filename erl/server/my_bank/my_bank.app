{
  application, my_bank,
  [
    {description, "my bank test supervisor"},
    {vsn, "1.0"},
    {modules, [my_bank_app, my_bank, my_bank_supervisor]},
    {registered, [my_bank, my_bank_supervisor]},
    {applications, [kernel, stdlib]},
    {mod, {my_bank_app, []}},
    {start_phases, []}
  ]
}.
