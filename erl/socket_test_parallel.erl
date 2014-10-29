-module(socket_test_parallel).
-export([start_parallel_server/0,nano_client/1]).

start_parallel_server() ->
  {ok, Listen} = gen_tcp:listen(2347, [binary, {packet, 0}, {reuseaddr, true}, {active, true}]),
  %gen_tcp:close(Listen),
  common:for(1, 10, fun() -> Pid = spawn(fun() -> par_connect(Listen) end),io:format("start server ~p~n", [Pid]) end).

par_connect(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  {ok, {IP_Address, Port}} = inet:peername(Socket),
  io:format("source from ~p~n", [IP_Address]),

  %spawn(fun() -> par_connect(Listen) end),
  loop(Socket).


loop(Socket) ->
  receive 
    {tcp, Socket, Bin} ->
      io:format("Server received binary =~p~n", [Bin]),
      Str = binary_to_term(Bin),
      io:format("Server (unpacked) ~p~n", [Str]),
      Reply = lists:reverse(Str),
      gen_tcp:send(Socket, term_to_binary(Reply)),
      loop(Socket);
    {tcp_closed, Socket} ->
      io:format("Server socket closed ~p~n",[self()])

  end.

nano_client(Str) ->
  {ok, Socket} = gen_tcp:connect("localhost", 2347, [binary, {packet, 0}]),
  ok = gen_tcp:send(Socket, term_to_binary(Str)),
  receive
    {tcp, Socket, Bin} ->
      io:format("Client result ~p~n", [binary_to_term(Bin)]),
      gen_tcp:close(Socket)
  end.
  
