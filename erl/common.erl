-module(common).
-export([for/3]).

for(N, N, Fun) -> Fun();
for(N, M, Fun) when N < M -> Fun(), for(N+1, M, Fun);
for(N, M, _Fun) when N > M -> io:format("Maybe something wrong for N > M ~p ~p~n", [N, M]).
