-module(socket_test).
-export([start_nano_server/0,nano_client/1]).

start_nano_server() ->
  {ok, Listen} = gen_tcp:listen(2346, [binary, {packet, 0}, {reuseaddr, true}, {active, true}]),
  %gen_tcp:close(Listen),
  seq_loop(Listen).

seq_loop(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  loop(Socket),
  seq_loop(Listen).

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
      io:format("Server socket closed ~n")

  end.

nano_client(Str) ->
  {ok, Socket} = gen_tcp:connect("localhost", 2346, [binary, {packet, 0}]),
  ok = gen_tcp:send(Socket, term_to_binary(Str)),
  receive
    {tcp, Socket, Bin} ->
      io:format("Client result ~p~n", [binary_to_term(Bin)]),
      gen_tcp:close(Socket)
  end.
